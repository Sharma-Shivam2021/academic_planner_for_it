import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final excelListNotifierProvider =
    StateNotifierProvider<ExcelListNotifier, List<ExcelData>>((ref) {
  return ExcelListNotifier();
});

class ExcelListNotifier extends StateNotifier<List<ExcelData>> {
  ExcelListNotifier() : super([]);

  void addExcelData(ExcelData excelData) {
    state = [...state, excelData];
  }

  void clearList() {
    state = [];
  }

  void deleteExcelData(ExcelData excelData) {
    state = state.where((data) => data != excelData).toList();
  }

  void updateExcelData(ExcelData prevData, ExcelData updatedData) {
    state = [
      for (final data in state)
        if (data == prevData) updatedData else data,
    ];
  }
}
