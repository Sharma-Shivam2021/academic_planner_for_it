import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A[FutureProvider] that saves a list of [ExcelData] to the database.
///
/// This provider uses the [ExcelRepository] to persist the given Excel data.
final saveExcelToDatabaseProvider =
    FutureProvider.family<void, List<ExcelData>>((ref, excelData) async {
  final excelRepository = ref.read(excelRepositoryProvider);
  return excelRepository.saveExcelDataToDb(excelData);
});
