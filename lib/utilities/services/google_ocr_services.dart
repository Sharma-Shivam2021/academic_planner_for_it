import 'dart:io';

import 'package:academic_planner_for_it/features/ocr_screen/model/ocr_model.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_list_notifier.dart';
import 'package:academic_planner_for_it/features/settings_screen/view_model/setting_notifier.dart';
import 'package:academic_planner_for_it/utilities/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class GoogleOCRServices {
  Future<void> performTextRecognition(File? imageFile, WidgetRef ref) async {
    List<OCRData> extractedEvents = [];
    String? eventName;
    String? startDateString;
    String? endDateString;
    final kConfigTimeForSubtract =
        ref.read(settingsProvider).configTimeForSubtract;

    try {
      final inputImage = InputImage.fromFile(imageFile!);
      final TextRecognizer textRecognizer = TextRecognizer();
      RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      final sizeOfList = recognizedText.blocks.length;

      if (sizeOfList % 3 != 0) {
        throw const FormatException(
            'The image structure is invalid. Each event should have 3 fields.');
      }

      final recognizedBlocks = recognizedText.blocks;
      final startDateIncrementer = sizeOfList ~/ 3;
      final endDateIncrementer = startDateIncrementer + startDateIncrementer;
      final noOfEvents = sizeOfList ~/ 3;

      for (int i = 0; i < noOfEvents; i++) {
        eventName = cleanText(recognizedBlocks[i].text);
        startDateString =
            cleanText(recognizedBlocks[i + startDateIncrementer].text);
        endDateString =
            cleanText(recognizedBlocks[i + endDateIncrementer].text);

        // Parse the dates in DD-MM-YYYY format
        var startDate = parseDate(startDateString);
        if (startDate != null) {
          startDate = startDate.subtract(kConfigTimeForSubtract);
          final newOcrData = createOcrData(eventName, startDate);
          extractedEvents.add(newOcrData);
        } else {
          debugPrint("Error: Invalid Start Date");
        }

        var endDate = parseDate(endDateString);
        if (endDate != null && endDate.isAfter(startDate!)) {
          endDate = endDate.subtract(kConfigTimeForSubtract);
          final newOcrData = createOcrData(eventName, endDate);
          extractedEvents.add(newOcrData);
        } else {
          debugPrint("Error: Invalid End Date or End Date equals Start Date");
        }
      }

      for (final event in extractedEvents) {
        ref.read(ocrListProvider.notifier).addOcrData(event);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      // Close the recognizer to release resources
      final TextRecognizer textRecognizer = TextRecognizer();
      textRecognizer.close();
    }
  }

  OCRData createOcrData(String eventName, DateTime dateTime) {
    return OCRData(eventName: eventName, dateTime: dateTime);
  }

  // Function to parse DD-MM-YYYY date format
  DateTime? parseDate(String dateString) {
    try {
      List<String> parts = dateString.split("-");
      if (parts.length == 3) {
        String formattedDate =
            "${parts[2]}-${parts[1]}-${parts[0]}"; // Convert to YYYY-MM-DD
        return DateTime.tryParse(formattedDate);
      }
    } catch (e) {
      debugPrint("Date parsing error: $e");
    }
    return null;
  }

  // Clean the event name and dates from unwanted pipe characters
  String cleanText(String text) {
    return text.replaceAll('|', '').trim();
  }
}
