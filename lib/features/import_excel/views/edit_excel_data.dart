import 'package:academic_planner_for_it/features/import_excel/model/excel_data.dart';
import 'package:academic_planner_for_it/features/import_excel/view_model/excel_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/common_widgets/alert_dialog_box.dart';
import '../../../utilities/common_widgets/custom_selector_fields.dart';
import '../../../utilities/common_widgets/custom_text_field.dart';
import '../../../utilities/constants/constants.dart';
import '../../../utilities/constants/date_formatter.dart';
import '../../../utilities/services/speech_manager.dart';

/// A widget for editing [ExcelData].
///
/// This widget allows the user to modify the event name, date, and time of an
/// existing [ExcelData] object.
class EditExcelData extends ConsumerStatefulWidget {
  /// Creates an [EditExcelData] widget.
  ///
  /// Parameters:
  ///   - [excelData]: The [ExcelData] object to edit.
  const EditExcelData({
    super.key,
    required this.excelData,
  });
  final ExcelData excelData;
  @override
  ConsumerState createState() => _EditExcelDataState();
}

class _EditExcelDataState extends ConsumerState<EditExcelData> {
  final TextEditingController _excelDataEventNameController =
      TextEditingController();
  final TextEditingController _excelDataDateController =
      TextEditingController();
  final TextEditingController _excelDataTimeController =
      TextEditingController();

  DateTime? _selectedDateTime = DateTime.now();

  /// Shows a date picker and updates the selected date.
  ///
  /// Parameters:
  ///   - [context]: The build context.
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: kFirstDate,
      lastDate: kLastDate,
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime?.hour ?? 0,
          _selectedDateTime?.minute ?? 0,
        );
        _excelDataDateController.text = returnDate(picked);
      });
    }
  }

  /// Shows a time picker and updates the selected time.
  ///
  /// Parameters:
  ///   - [context]: The build context.
  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime!),
    );
    if (picked != null &&
        picked != TimeOfDay.fromDateTime(_selectedDateTime!)) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime?.year ?? DateTime.now().year,
          _selectedDateTime?.month ?? DateTime.now().month,
          _selectedDateTime?.day ?? DateTime.now().day,
          picked.hour,
          picked.minute,
        );
        _excelDataTimeController.text = returnTime(_selectedDateTime!);
      });
    }
  }

  /// Initializes the speech recognition service.
  void _initSpeech() async {
    await ref.read(speechProvider).initialize();
  }

  /// Starts listening for speech input.
  void _startListening() async {
    await ref.read(speechProvider).startListening((result) {
      setState(() {
        _excelDataEventNameController.text = result;
      });
    });
    setState(() {});
  }

  /// Stops listening for speech input.
  void _stopListening() async {
    await ref.read(speechProvider).stopListening();
    setState(() {});
  }

  /// Edits the event with the new data.
  ///
  /// Parameters:
  ///   - [prevData]: The original [ExcelData] object.
  void _editEvent(ExcelData prevData) {
    ExcelData updatedData = ExcelData(
      eventName: _excelDataEventNameController.text,
      dateTime: _selectedDateTime!,
    );
    ref
        .read(excelListNotifierProvider.notifier)
        .updateExcelData(prevData, updatedData);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _initSpeech();
    _selectedDateTime = widget.excelData.dateTime;
    _excelDataDateController.text = returnDate(_selectedDateTime!);
    _excelDataTimeController.text = returnTime(_selectedDateTime!);
    _excelDataEventNameController.text = widget.excelData.eventName;
    super.initState();
  }

  @override
  void dispose() {
    _excelDataTimeController.dispose();
    _excelDataEventNameController.dispose();
    _excelDataDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speech = ref.watch(speechProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _excelDataEventNameController,
                      hintText: 'Event Name',
                    ),
                  ),
                  IconButton(
                    onPressed: speech.isNotListening
                        ? _startListening
                        : _stopListening,
                    icon: Icon(
                      speech.isNotListening ? Icons.mic : Icons.mic_off,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              CustomSelectorFields(
                controller: _excelDataDateController,
                onTap: () {
                  _selectDate(context);
                },
                hintText: 'Select Date',
                icon: Icons.date_range,
              ),
              const SizedBox(height: 20),
              CustomSelectorFields(
                controller: _excelDataTimeController,
                onTap: () {
                  _selectTime(context);
                },
                hintText: 'Select Time',
                icon: Icons.alarm,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_excelDataEventNameController.text.isNotEmpty) {
                    _editEvent(widget.excelData);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return buildAlertDialog(
                            context, "Alert!", "Fields should not be empty.");
                      },
                    );
                  }
                },
                child: const Text(
                  'Edit Event',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
