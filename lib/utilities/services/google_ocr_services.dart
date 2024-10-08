import 'dart:io';

import 'package:academic_planner_for_it/features/ocr_screen/model/ocr_model.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_list_notifier.dart';
import 'package:academic_planner_for_it/features/settings_screen/view_model/setting_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class GoogleOCRServices {
  Future<void> performTextRecognition(File? imageFile, WidgetRef ref) async {
    List<OCRData> extractedEvents = [];
    String? eventName;
    String? startDateString;
    String? endDateString;
    final TextRecognizer textRecognizer = TextRecognizer();
    try {
      final kConfigTimeForSubtract =
          ref.watch(settingsProvider).configTimeForSubtract;
      final inputImage = InputImage.fromFile(imageFile!);

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
        var endDate = parseDate(endDateString);

        if (startDate != null) {
          final newOcrData =
              createOcrData(eventName, startDate, kConfigTimeForSubtract);
          extractedEvents.add(newOcrData);
        } else {
          debugPrint("Error: Invalid Start Date");
        }

        if (endDate != null && endDate.isAfter(startDate!)) {
          final newOcrData =
              createOcrData(eventName, endDate, kConfigTimeForSubtract);
          extractedEvents.add(newOcrData);
        } else {
          debugPrint("Error: Invalid End Date or End Date equals Start Date");
        }
      }

      for (final event in extractedEvents) {
        ref.read(ocrListProvider.notifier).addOcrData(event);
      }
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      textRecognizer.close();
    }
  }

  OCRData createOcrData(
      String eventName, DateTime dateTime, Duration subtractDuration) {
    var finalDate = dateTime.subtract(subtractDuration).copyWith(hour: 10);
    if (finalDate.weekday == DateTime.sunday) {
      finalDate = finalDate.subtract(subtractDuration).copyWith(hour: 10);
    }
    return OCRData(eventName: eventName, dateTime: finalDate);
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
