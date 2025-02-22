//Project Package
import 'package:academic_planner_for_it/features/home_screen/view_models/all_event_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project Class
import '../../../utilities/common_widgets/custom_text_field.dart';
import '../models/events.dart';
import '../view_models/event_provider.dart';
import '../../../utilities/common_widgets/alert_dialog_box.dart';
import '../../../utilities/common_widgets/custom_selector_fields.dart';
import '../../../utilities/constants/constants.dart';
import '../../../utilities/services/speech_manager.dart';
import '../../../utilities/constants/date_formatter.dart';

/// A widget for adding a new event.
///
/// This widget allows the user to input the event name, date, and time,
/// and then add the event to the application's data.
class AddNewEvent extends ConsumerStatefulWidget {
  const AddNewEvent({super.key});

  @override
  ConsumerState createState() => _AddNewEventState();
}

class _AddNewEventState extends ConsumerState<AddNewEvent> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? _selectedDateTime = DateTime.now();

  /// Shows a date picker and updates the selected date.
  ///
  /// Parameters:
  ///   - [context]: The build context.
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: kInitialDate,
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
        _dateController.text = returnDate(picked);
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
      initialTime: TimeOfDay.now(),
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
        _timeController.text = returnTime(_selectedDateTime!);
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
        _eventNameController.text = result;
      });
    });
    setState(() {});
  }

  /// Stops listening for speech input.
  void _stopListening() async {
    await ref.read(speechProvider).stopListening();
    setState(() {});
  }

  /// Adds a new event to the application's data.
  ///
  /// This method creates a new [Events] object with the data entered by the
  /// user, saves it to the database, invalidates the
  /// [paginatedEventsProvider] to refresh the event list, adds the event to
  /// the [allEventsProvider], and then navigates back.
  void _addEvent() async {
    Events newEvent = Events(
      eventName: _eventNameController.text,
      dateTime: _selectedDateTime!,
      eventNotificationState: EventNotificationState.created,
    );
    try {
      await ref.read(createEventProvider(newEvent).future).then((_) {
        ref.invalidate(paginatedEventsProvider);
        ref.read(allEventsProvider.notifier).addEvent(newEvent);
        if (mounted) {
          pop();
        }
      });
    } catch (e) {
      throw Exception(' Add Event :$e');
    }
  }

  /// Navigates back to the previous screen.
  void pop() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    _initSpeech();
    _dateController.text = returnDate(_selectedDateTime!);
    _timeController.text = returnTime(_selectedDateTime!);
    super.initState();
  }

  @override
  void dispose() {
    _timeController.dispose();
    _eventNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speech = ref.watch(speechProvider);
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 10,
        right: 10,
      ),
      child: SingleChildScrollView(
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
                    icon:
                        Icon(speech.isNotListening ? Icons.mic : Icons.mic_off),
                  )
                ],
              ),
              const SizedBox(height: 20),
              CustomSelectorFields(
                controller: _dateController,
                onTap: () {
                  _selectDate(context);
                },
                hintText: 'Select Date',
                icon: Icons.date_range,
              ),
              const SizedBox(height: 20),
              CustomSelectorFields(
                controller: _timeController,
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
                    _addEvent();
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
                  'Add Event',
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
