import 'package:academic_planner_for_it/features/ocr_screen/model/ocr_model.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view/edit_ocr_data.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/constants/date_formatter.dart';

class OcrList extends ConsumerWidget {
  const OcrList({required this.data, super.key});

  final OCRData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(
          data.eventName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(dateFormatter(data.dateTime)),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditOcrData(ocrData: data),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(ocrListProvider.notifier).deleteOcrData(data);
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
