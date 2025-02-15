import 'package:academic_planner_for_it/features/home_screen/view_models/all_event_list_notifier.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/event_provider.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/alert_dialog_box.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/custom_selector_fields.dart';
import 'package:academic_planner_for_it/utilities/common_widgets/custom_text_field.dart';
import 'package:academic_planner_for_it/utilities/constants/constants.dart';
import 'package:academic_planner_for_it/utilities/constants/date_formatter.dart';
import 'package:academic_planner_for_it/utilities/services/speech_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/events.dart';
import 'home_screen.dart';

class EditEvent extends ConsumerStatefulWidget {
  const EditEvent({required this.event, super.key});
  final Events event;
  @override
  ConsumerState createState() => _EditEventState();
}

class _EditEventState extends ConsumerState<EditEvent> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();

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
        _eventDateController.text = returnDate(picked);
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
        _eventTimeController.text = returnTime(_selectedDateTime!);
      });
    }
  }

  void _initSpeech() async {
    await ref.read(speechProvider).initialize();
  }

  void _startListening() async {
    await ref.read(speechProvider).startListening((result) {
      setState(() {
        _eventNameController.text = result;
      });
    });
  }

  void _stopListening() async {
    await ref.read(speechProvider).stopListening();
    setState(() {});
  }

  void _editEvent(Events prevEvent) async {
    try {
      Events updatedEvent = Events(
        eventName: _eventNameController.text,
        dateTime: _selectedDateTime!,
      );
      await _removePrevEvent(prevEvent);
      await _addEditedEvent(updatedEvent);
      _pop();
    } catch (e) {
      throw Exception('$e');
    }
  }

  void _pop() {
    Navigator.popAndPushNamed(context, HomeScreen.routeName);
  }

  Future<void> _removePrevEvent(Events prevEvent) async {
    try {
      await ref.read(deleteEventProvider(prevEvent).future);
      ref.invalidate(paginatedEventsProvider);
      ref.read(allEventsProvider.notifier).removeEvent(prevEvent);
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> _addEditedEvent(Events updatedEvent) async {
    try {
      await ref.read(createEventProvider(updatedEvent).future);
      ref.invalidate(paginatedEventsProvider);
      ref.read(allEventsProvider.notifier).addEvent(updatedEvent);
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  void initState() {
    _initSpeech();
    _selectedDateTime = widget.event.dateTime;
    _eventDateController.text = returnDate(_selectedDateTime!);
    _eventTimeController.text = returnTime(_selectedDateTime!);
    _eventNameController.text = widget.event.eventName;
    super.initState();
  }

  @override
  void dispose() {
    _eventTimeController.dispose();
    _eventDateController.dispose();
    _eventNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speech = ref.watch(speechProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
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
                      controller: _eventNameController,
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
                controller: _eventDateController,
                onTap: () {
                  _selectDate(context);
                },
                hintText: 'Select Date',
                icon: Icons.date_range,
              ),
              const SizedBox(height: 20),
              CustomSelectorFields(
                controller: _eventTimeController,
                onTap: () {
                  _selectTime(context);
                },
                hintText: 'Select Time',
                icon: Icons.alarm,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_eventNameController.text.isNotEmpty) {
                    _editEvent(widget.event);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return buildAlertDialog(
                          context,
                          'Alert!',
                          'Fields should not be empty.',
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  'Save Edit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
