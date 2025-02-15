import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:academic_planner_for_it/features/import_excel/views/edit_excel_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/constants/date_formatter.dart';
import '../model/excel_data.dart';

/// A widget that displays an [ExcelData] object in a card format.
///
/// This widget shows the event name and date/time of an [ExcelData] object
/// and provides buttons to edit or delete the data.
class ExcelCard extends ConsumerWidget {
  /// Creates an [ExcelCard].
  ///
  /// Parameters:
  ///   - [data]: The [ExcelData] object to display.
  const ExcelCard({super.key, required this.data});

  final ExcelData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excelListProvider = ref.watch(excelListNotifierProvider.notifier);
    return Card(
      child: ListTile(
        title: Text(
          data.eventName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(dateFormatter(data.dateTime)),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditExcelData(
                        excelData: data,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  excelListProvider.deleteExcelData(data);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
