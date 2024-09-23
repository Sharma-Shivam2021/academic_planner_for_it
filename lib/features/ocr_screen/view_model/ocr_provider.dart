import 'package:academic_planner_for_it/features/ocr_screen/model/ocr_model.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveOcrToDatabaseProvider =
    FutureProvider.family<void, List<OCRData>>((ref, ocrData) async {
  final ocrRepository = ref.read(ocrRepositoryProvider);
  return ocrRepository.saveOcrDataToDb(ocrData);
});
