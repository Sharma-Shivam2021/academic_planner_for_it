import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:academic_planner_for_it/features/import_excel/widgets/example_table_structure.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/custom_drawer.dart';
import 'package:academic_planner_for_it/utilities/services/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/common_widgets/alert_dialog_box.dart';
import '../widgets/excel_list.dart';
import '../widgets/excel_utility_button.dart';

/// The screen for importing data from an Excel file.
///
/// This screen allows the user to pick an Excel file, view its contents, and
/// import the data into the application.
class ImportExcelScreen extends ConsumerStatefulWidget {
  const ImportExcelScreen({super.key});
  static const String routeName = '/importExcelScreen';

  @override
  ConsumerState createState() => _ImportExcelScreenState();
}

class _ImportExcelScreenState extends ConsumerState<ImportExcelScreen> {
  final FilePickerServices _pickerServices = FilePickerServices();

  /// Picks an Excel file and processes it.
  ///
  /// This method uses the [_pickerServices] to allow the user to select an
  /// Excel file. If an error occurs during file picking or processing, a
  /// warning dialog is displayed.
  ///
  /// Parameters:
  ///   - [ref]: The [WidgetRef] for interacting with Riverpod.
  void _pickFile(ref) async {
    try {
      final errorText = await _pickerServices.pickFile(ref);
      if (errorText.isNotEmpty) {
        warning(errorText);
      }
    } catch (e) {
      warning('An unexpected error occurred: $e');
    }
  }

  /// Displays a warning dialog.
  ///
  /// Parameters:
  ///   - [errorText]: The text to display in the warning dialog.
  void warning(String errorText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildAlertDialog(context, "Warning!", errorText);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final excelData = ref.watch(excelListNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Excel'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.12,
          ),
          child: const ExcelUtilityButtons(),
        ),
      ),
      body: Column(
        children: [
          if (excelData.isEmpty)
            const ExampleTableStructure()
          else
            Expanded(
              child: ListView.builder(
                itemCount: excelData.length,
                itemBuilder: (context, index) {
                  final data = excelData[index];
                  return ExcelCard(data: data);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickFile(ref);
        },
        child: const Icon(Icons.upload_rounded),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
