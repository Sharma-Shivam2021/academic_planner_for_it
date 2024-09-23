import 'package:academic_planner_for_it/features/ocr_screen/model/ocr_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ocrListProvider =
    StateNotifierProvider<OcrListNotifier, List<OCRData>>((ref) {
  return OcrListNotifier();
});

class OcrListNotifier extends StateNotifier<List<OCRData>> {
  OcrListNotifier() : super([]);

  void addOcrData(OCRData ocrData) {
    state = [...state, ocrData];
  }

  void clearList() {
    state = [];
  }

  void deleteOcrData(OCRData ocrData) {
    state = state.where((data) => data != ocrData).toList();
  }

  void updateOcrData(OCRData prevData, OCRData updatedData) {
    state = [
      for (final data in state)
        if (data == prevData) updatedData else data,
    ];
  }
}
