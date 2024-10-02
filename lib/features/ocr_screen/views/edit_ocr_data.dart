import 'package:academic_planner_for_it/features/ocr_screen/model/ocr_model.dart';
import 'package:academic_planner_for_it/features/ocr_screen/view_model/ocr_list_notifier.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/custom_selector_fields.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../utilities/common_widgets/alert_dialog_box.dart';
import '../../../utilities/constants/constants.dart';
import '../../../utilities/constants/date_formatter.dart';
import '../../../utilities/services/speech_manager.dart';

class EditOcrData extends ConsumerStatefulWidget {
  const EditOcrData({
    required this.ocrData,
    super.key,
  });

  final OCRData ocrData;

  @override
  ConsumerState createState() => _EditOcrDataState();
}

class _EditOcrDataState extends ConsumerState<EditOcrData> {
  final TextEditingController _ocrDataEventNameController =
      TextEditingController();
  final TextEditingController _ocrDataDateController = TextEditingController();
  final TextEditingController _ocrDataTimeController = TextEditingController();

  DateTime? _selectedDateTime = DateTime.now();

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
        _ocrDataDateController.text = returnDate(picked);
      });
    }
  }

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
        _ocrDataTimeController.text = returnTime(_selectedDateTime!);
      });
    }
  }

  void _initSpeech() async {
    await ref.read(speechProvider).initialize();
  }

  void _startListening() async {
    await ref.read(speechProvider).startListening((result) {
      setState(() {
        _ocrDataEventNameController.text = result;
      });
    });
    setState(() {});
  }

  void _stopListening() async {
    await ref.read(speechProvider).stopListening();
    setState(() {});
  }

  void _editEvent(OCRData prevData) {
    OCRData updatedData = OCRData(
      eventName: _ocrDataEventNameController.text,
      dateTime: _selectedDateTime!,
    );
    ref.read(ocrListProvider.notifier).updateOcrData(prevData, updatedData);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _initSpeech();
    _selectedDateTime = widget.ocrData.dateTime;
    _ocrDataEventNameController.text = widget.ocrData.eventName;
    _ocrDataTimeController.text = returnTime(widget.ocrData.dateTime);
    _ocrDataDateController.text = returnDate(widget.ocrData.dateTime);
    super.initState();
  }

  @override
  void dispose() {
    _ocrDataDateController.dispose();
    _ocrDataTimeController.dispose();
    _ocrDataEventNameController.dispose();
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
                      controller: _ocrDataEventNameController,
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
                controller: _ocrDataDateController,
                onTap: () {
                  _selectDate(context);
                },
                hintText: 'Select Date',
                icon: Icons.date_range,
              ),
              const SizedBox(height: 20),
              CustomSelectorFields(
                controller: _ocrDataTimeController,
                onTap: () {
                  _selectTime(context);
                },
                hintText: 'Select Time',
                icon: Icons.alarm,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_ocrDataEventNameController.text.isNotEmpty) {
                    _editEvent(widget.ocrData);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return buildAlertDialog(context);
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
