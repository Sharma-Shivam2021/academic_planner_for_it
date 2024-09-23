import 'package:academic_planner_for_it/features/home_screen/view_models/event_provider.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/themes.dart';

class ExcelUtilityButtons extends ConsumerWidget {
  const ExcelUtilityButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excelData = ref.watch(excelListNotifierProvider);
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
                onPressed: () async {
                  ref.read(excelListNotifierProvider.notifier).clearList();
                },
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
                onPressed: () async {
                  ref
                      .read(saveExcelToDatabaseProvider(excelData).future)
                      .then((_) {
                    ref.invalidate(readAllEventProvider);
                    ref.read(excelListNotifierProvider.notifier).clearList();
                    Navigator.pop(context);
                  });
                },
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
