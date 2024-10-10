import 'package:academic_planner_for_it/features/home_screen/view_models/event_provider.dart';
import 'package:academic_planner_for_it/features/home_screen/views/home_screen.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_list_notifier.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../utilities/theme/themes.dart';

class OcrUtilityButton extends ConsumerStatefulWidget {
  const OcrUtilityButton({super.key});

  @override
  ConsumerState createState() => _OcrUtilityButtonState();
}

class _OcrUtilityButtonState extends ConsumerState<OcrUtilityButton> {
  void onDelete() async {
    ref.read(ocrListProvider.notifier).clearList();
  }

  void onAdd() async {
    final ocrData = ref.watch(ocrListProvider);
    ref.read(saveOcrToDatabaseProvider(ocrData).future).then((_) {
      ref.invalidate(readAllEventProvider);
      ref.read(ocrListProvider.notifier).clearList();
      pop();
    });
  }

  void pop() {
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: AppTheme.lightScheme.primaryFixedDim,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onDelete,
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: onAdd,
                child: const Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
