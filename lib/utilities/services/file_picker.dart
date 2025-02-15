import 'dart:io';

import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:academic_planner_for_it/features/settings_screen/view_model/setting_notifier.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A service class for picking and processing Excel files.
///
/// This class uses the `file_picker` package to allow the user to select an
/// Excel file, and the `excel` package to read and process the data within the file.
class FilePickerServices {
  /// Picks an Excel file from the device's storage.
  ///
  /// This method opens the file picker dialog, allowing the user to select an
  /// Excel file (`.xls` or `.xlsx`). It then reads the file, processes the data,
  /// and stores it in the database.
  ///
  /// Parameters:
  ///   - [ref]: The [WidgetRef] object for interacting with Riverpod providers.
  ///
  /// Returns:
  ///   A [Future] that completes with a [String] indicating the result of the operation.
  ///   - If successful, it returns an empty string or an error message if any.
  ///   - If no file is selected, it returns "No File Selected".
  ///   - If an error occurs, it returns a string describing the error.
  Future<String> pickFile(WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );
      if (result == null) return "No File Selected";
      File file = File(result.files.single.path!);
      final readFile = await _readExcel(file, ref);
      if (readFile.isNotEmpty) {
        await file.delete();
        FilePickerStatus.done;
        return readFile;
      }
      await file.delete();
      FilePickerStatus.done;
      return "";
    } catch (e) {
      return '$e';
    }
  }

  /// Reads the data from the selected Excel file.
  ///
  /// This method reads the Excel file's bytes and decodes them using the `excel`
  /// package. It then calls [_creatingExcelModelAndStoringInDB] to process the data.
  ///
  /// Parameters:
  ///   - [excelFile]: The [File] object representing the selected Excel file.
  ///   - [ref]: The [WidgetRef] object for interacting with Riverpod providers.
  ///
  /// Returns:
  ///   A [Future] that completes with a [String] indicating the result of the operation.
  ///   - If successful, it returns an empty string or an error message if any.
  ///   - If an error occurs, it returns a string describing the error.
  Future<String> _readExcel(File excelFile, WidgetRef ref) async {
    try {
      final bytes = excelFile.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final result = await _creatingExcelModelAndStoringInDB(excel, ref);
      if (result.isNotEmpty) {
        return result;
      }
      return "";
    } catch (e) {
      return "Error reading Excel file: $e";
    }
  }

  /// Processes the Excel data and stores it in the database.
  ///
  /// This method iterates through the Excel tables, extracts event data,
  /// adjusts the dates, and stores the data in the database using the
  /// [excelListNotifierProvider].
  ///
  /// Parameters:
  ///   - [excel]: The [Excel] object containing the decoded Excel data.
  ///   - [ref]: The [WidgetRef] object for interacting with Riverpod providers.
  ///
  /// Returns:
  ///   A [Future] that completes with a [String] indicating the result of the operation.
  ///   - If successful, it returns an empty string or an error message if any.
  ///   - If an error occurs, it returns a string describing the error.
  Future<String> _creatingExcelModelAndStoringInDB(
      Excel excel, WidgetRef ref) async {
    try {
      String errorText = "";
      final kConfigTimeForSubtract =
          ref.watch(settingsProvider).configTimeForSubtract;
      List<ExcelData> tempExcelDataList = [];
      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        int? noOfRows = sheet.maxRows;

        for (int rowIndex = 0; rowIndex < noOfRows; rowIndex++) {
          final row = sheet.row(rowIndex);

          final eventName = row[0]?.value?.toString();
          final startDateTimeString =
              row.length > 1 ? row[1]?.value?.toString() : null;
          final endDateTimeString =
              row.length > 2 ? row[2]?.value?.toString() : null;

          if (eventName != null && startDateTimeString != null) {
            DateTime? firstDateTime;
            try {
              firstDateTime = DateTime.parse(startDateTimeString);
            } catch (e) {
              errorText =
                  'Invalid start date format for event "$eventName": $startDateTimeString';
              continue; // Skip this row if parsing fails
            }

            // Process start date
            DateTime adjustedStartDate =
                _adjustDate(firstDateTime, kConfigTimeForSubtract);
            tempExcelDataList.add(
                ExcelData(eventName: eventName, dateTime: adjustedStartDate));

            // Process end date if it's different from the start date
            if (endDateTimeString != null &&
                endDateTimeString != startDateTimeString) {
              DateTime? secondDateTime;
              try {
                secondDateTime = DateTime.parse(endDateTimeString);
              } catch (e) {
                errorText =
                    'Invalid end date format for event "$eventName": $endDateTimeString';
                continue; // Skip this row if parsing fails
              }

              DateTime adjustedEndDate =
                  _adjustDate(secondDateTime, kConfigTimeForSubtract);
              tempExcelDataList.add(
                  ExcelData(eventName: eventName, dateTime: adjustedEndDate));
            }
          }
        }
      }

      // Store the Excel data in the database
      for (var excelData in tempExcelDataList) {
        ref.read(excelListNotifierProvider.notifier).addExcelData(excelData);
      }
      return errorText;
    } catch (e) {
      return "Error processing Excel data: $e";
    }
  }

  /// Helper function to adjust the date and handle Sundays.
  ///
  /// This method subtracts a duration from the given [dateTime] and sets the hour to 10.
  /// If the adjusted date falls on a Sunday, it subtracts the duration again.
  ///
  /// Parameters:
  ///   - [dateTime]: The [DateTime] to adjust.
  ///   - [subtractDuration]: The [Duration] to subtract from the date.
  ///
  /// Returns:
  ///   The adjusted [DateTime].
  DateTime _adjustDate(DateTime dateTime, Duration subtractDuration) {
    var adjustedDate = dateTime.subtract(subtractDuration).copyWith(hour: 10);
    if (adjustedDate.weekday == DateTime.sunday) {
      adjustedDate = adjustedDate.subtract(subtractDuration);
    }
    return adjustedDate;
  }
}
