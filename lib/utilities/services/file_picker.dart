import 'dart:io';

import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:academic_planner_for_it/features/settings_screen/view_model/setting_notifier.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilePickerServices {
  void pickFile(WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );
      if (result == null) return;
      File file = File(result.files.single.path!);
      await _readExcel(file, ref);
      await file.delete();
      FilePickerStatus.done;
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> _readExcel(File excelFile, WidgetRef ref) async {
    final bytes = excelFile.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    await _creatingExcelModelAndStoringInDB(excel, ref);
  }

  Future<void> _creatingExcelModelAndStoringInDB(
      Excel excel, WidgetRef ref) async {
    try {
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
              debugPrint(
                  'Invalid start date format for event "$eventName": $startDateTimeString');
              continue; // Skip this row if parsing fails
            }

            if (firstDateTime.weekday == DateTime.sunday) {
              final date = firstDateTime
                  .subtract(kConfigTimeForSubtract)
                  .copyWith(hour: 10);
              tempExcelDataList
                  .add(ExcelData(eventName: eventName, dateTime: date));
            } else {
              var date = firstDateTime
                  .subtract(kConfigTimeForSubtract)
                  .copyWith(hour: 10);
              if (date.weekday == DateTime.sunday) {
                date = date.subtract(kConfigTimeForSubtract);
              }
              tempExcelDataList
                  .add(ExcelData(eventName: eventName, dateTime: date));
            }

            if (endDateTimeString != null &&
                endDateTimeString != startDateTimeString) {
              DateTime? secondDateTime;
              try {
                secondDateTime = DateTime.parse(endDateTimeString);
              } catch (e) {
                debugPrint(
                    'Invalid end date format for event "$eventName": $endDateTimeString');
                continue; // Skip this row if parsing fails
              }

              if (secondDateTime.weekday == DateTime.sunday) {
                final date = secondDateTime
                    .subtract(kConfigTimeForSubtract)
                    .copyWith(hour: 10);
                tempExcelDataList
                    .add(ExcelData(eventName: eventName, dateTime: date));
              } else {
                var date = secondDateTime
                    .subtract(kConfigTimeForSubtract)
                    .copyWith(hour: 10);
                if (date.weekday == DateTime.sunday) {
                  date = date.subtract(kConfigTimeForSubtract);
                }
                secondDateTime = secondDateTime.copyWith(hour: 10);
                tempExcelDataList
                    .add(ExcelData(eventName: eventName, dateTime: date));
              }
            }
          }
        }
      }

      for (var excelData in tempExcelDataList) {
        ref.read(excelListNotifierProvider.notifier).addExcelData(excelData);
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
