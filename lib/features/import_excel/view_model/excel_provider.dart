import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveExcelToDatabaseProvider =
    FutureProvider.family<void, List<ExcelData>>((ref, excelData) async {
  final excelRepository = ref.read(excelRepositoryProvider);
  return excelRepository.saveExcelDataToDb(excelData);
});
