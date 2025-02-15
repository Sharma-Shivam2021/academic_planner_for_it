import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides access to a list of [ExcelData] objects.
///
/// This provider allows widgets to read and modify the list of Excel data.
final excelListNotifierProvider =
    StateNotifierProvider<ExcelListNotifier, List<ExcelData>>((ref) {
  return ExcelListNotifier();
});

/// A [StateNotifier] that manages a list of [ExcelData] objects.
///
/// This class handles adding, deleting, clearing, and updating Excel data in the list.
class ExcelListNotifier extends StateNotifier<List<ExcelData>> {
  /// Creates an [ExcelListNotifier].
  ///
  /// Initializes the list of Excel data as empty.
  ExcelListNotifier() : super([]);

  /// Adds a new [ExcelData] object to the list.
  ///
  /// Parameters:///   - [excelData]: The [ExcelData] object to add.
  void addExcelData(ExcelData excelData) {
    state = [...state, excelData];
  }

  /// Clears all [ExcelData] objects from the list.
  void clearList() {
    state = [];
  }

  /// Deletes an [ExcelData] object from the list.
  ///
  /// Parameters:
  ///   - [excelData]: The [ExcelData] object to delete.
  void deleteExcelData(ExcelData excelData) {
    state = state.where((data) => data != excelData).toList();
  }

  /// Updates an existing [ExcelData] object in the list.
  ///
  /// Parameters:
  ///   - [prevData]: The original [ExcelData] object to be replaced.
  ///   - [updatedData]: The new [ExcelData] object to replace the original one.
  void updateExcelData(ExcelData prevData, ExcelData updatedData) {
    state = [
      for (final data in state)
        if (data == prevData) updatedData else data,
    ];
  }
}
