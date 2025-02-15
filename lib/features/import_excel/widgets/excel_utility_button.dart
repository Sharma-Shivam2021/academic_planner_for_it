import 'package:academic_planner_for_it/features/home_screen/view_models/event_provider.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/themes.dart';
import '../../home_screen/views/home_screen.dart';

/// A widget that displays utility buttons for managing Excel data.
///
/// This widget provides buttons to delete all Excel data from the list and to
/// add the Excel data to the database.
class ExcelUtilityButtons extends ConsumerStatefulWidget {
  const ExcelUtilityButtons({super.key});

  @override
  ConsumerState createState() => _ExcelUtilityButtonsState();
}

class _ExcelUtilityButtonsState extends ConsumerState<ExcelUtilityButtons> {
  /// Clears all Excel data from the list.
  void onDelete() async {
    ref.read(excelListNotifierProvider.notifier).clearList();
  }

  /// Saves the Excel data to the database and navigates to the home screen.
  ///
  /// This method reads the current Excel data from the
  /// [excelListNotifierProvider], saves it to the database using the
  /// [saveExcelToDatabaseProvider], invalidates the [paginatedEventsProvider]
  /// to refresh the event list, clears the Excel data list, and then
  /// navigates to the home screen.
  void onAdd() async {
    final excelData = ref.watch(excelListNotifierProvider);
    ref.read(saveExcelToDatabaseProvider(excelData).future).then((_) {
      ref.invalidate(paginatedEventsProvider);
      ref.read(excelListNotifierProvider.notifier).clearList();
      _pop();
    });
  }

  /// Navigates to the home screen.void _pop() {
  void _pop() {
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
