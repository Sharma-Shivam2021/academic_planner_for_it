import 'dart:io';

import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:academic_planner_for_it/features/settings_screen/view_model/setting_notifier.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilePickerServices {
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

  // Future<(void, String)> _creatingExcelModelAndStoringInDB(
  //     Excel excel, WidgetRef ref) async {
  //   try {
  //     final kConfigTimeForSubtract =
  //         ref.watch(settingsProvider).configTimeForSubtract;
  //     List<ExcelData> tempExcelDataList = [];
  //     for (var table in excel.tables.keys) {
  //       final sheet = excel.tables[table];
  //       if (sheet == null) continue;
  //
  //       int? noOfRows = sheet.maxRows;
  //
  //       for (int rowIndex = 0; rowIndex < noOfRows; rowIndex++) {
  //         final row = sheet.row(rowIndex);
  //
  //         final eventName = row[0]?.value?.toString();
  //         final startDateTimeString =
  //             row.length > 1 ? row[1]?.value?.toString() : null;
  //         final endDateTimeString =
  //             row.length > 2 ? row[2]?.value?.toString() : null;
  //
  //         if (eventName != null && startDateTimeString != null) {
  //           DateTime? firstDateTime;
  //           try {
  //             firstDateTime = DateTime.parse(startDateTimeString);
  //           } catch (e) {
  //             debugPrint(
  //                 'Invalid start date format for event "$eventName": $startDateTimeString');
  //             continue; // Skip this row if parsing fails
  //           }
  //
  //           if (firstDateTime.weekday == DateTime.sunday) {
  //             final date = firstDateTime
  //                 .subtract(kConfigTimeForSubtract)
  //                 .copyWith(hour: 10);
  //             tempExcelDataList
  //                 .add(ExcelData(eventName: eventName, dateTime: date));
  //           } else {
  //             var date = firstDateTime
  //                 .subtract(kConfigTimeForSubtract)
  //                 .copyWith(hour: 10);
  //             if (date.weekday == DateTime.sunday) {
  //               date = date.subtract(kConfigTimeForSubtract);
  //             }
  //             tempExcelDataList
  //                 .add(ExcelData(eventName: eventName, dateTime: date));
  //           }
  //
  //           if (endDateTimeString != null &&
  //               endDateTimeString != startDateTimeString) {
  //             DateTime? secondDateTime;
  //             try {
  //               secondDateTime = DateTime.parse(endDateTimeString);
  //             } catch (e) {
  //               debugPrint(
  //                   'Invalid end date format for event "$eventName": $endDateTimeString');
  //               continue; // Skip this row if parsing fails
  //             }
  //
  //             if (secondDateTime.weekday == DateTime.sunday) {
  //               final date = secondDateTime
  //                   .subtract(kConfigTimeForSubtract)
  //                   .copyWith(hour: 10);
  //               tempExcelDataList
  //                   .add(ExcelData(eventName: eventName, dateTime: date));
  //             } else {
  //               var date = secondDateTime
  //                   .subtract(kConfigTimeForSubtract)
  //                   .copyWith(hour: 10);
  //               if (date.weekday == DateTime.sunday) {
  //                 date = date.subtract(kConfigTimeForSubtract);
  //               }
  //               secondDateTime = secondDateTime.copyWith(hour: 10);
  //               tempExcelDataList
  //                   .add(ExcelData(eventName: eventName, dateTime: date));
  //             }
  //           }
  //         }
  //       }
  //     }
  //
  //     for (var excelData in tempExcelDataList) {
  //       ref.read(excelListNotifierProvider.notifier).addExcelData(excelData);
  //     }
  //   } catch (e) {
  //     throw Exception('$e');
  //   }
  // }
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

  // Helper function to adjust date and handle Sundays
  DateTime _adjustDate(DateTime dateTime, Duration subtractDuration) {
    var adjustedDate = dateTime.subtract(subtractDuration).copyWith(hour: 10);
    if (adjustedDate.weekday == DateTime.sunday) {
      adjustedDate = adjustedDate.subtract(subtractDuration);
    }
    return adjustedDate;
  }
}
