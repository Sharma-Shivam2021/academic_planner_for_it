//Project Packages
import 'package:academic_planner_for_it/features/home_screen/view_models/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Project Classes
import '../models/events.dart';
import '../view_models/event_provider.dart';
import '../widgets/add_event_modal_bottom_sheet.dart';
import '../widgets/event_list_card.dart';
import '../../../utilities/common_widgets/custom_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/homeScreen';

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _deleteEvent(Events deletingEvent) async {
    try {
      await ref.read(deleteEventProvider(deletingEvent).future);
      ref.invalidate(readAllEventProvider);
      _undo(deletingEvent);
    } catch (e) {
      throw Exception('$e');
    }
  }

  void _undo(Events event) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event Deleted Successfully'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref.read(createEventProvider(event));
                ref.invalidate(readAllEventProvider);
              },
            ),
          ),
        );
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  void _clearDatabase() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Caution!'),
              content: const Text(
                  "This will delete all the Events. Do you wish to proceed ?"),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(eventRepositoryProvider).clearDatabase();
                    ref.invalidate(readAllEventProvider);
                    _pop();
                  },
                  child: const Text('Yes'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          });
    } catch (e) {
      throw Exception('$e');
    }
  }

  void _pop() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _updateNotificationState();
    super.initState();
  }

  void _updateNotificationState() async {
    await ref.read(eventRepositoryProvider).updateEventNotificationState();
    ref.invalidate(readAllEventProvider);
  }

  @override
  Widget build(BuildContext context) {
    final eventAsyncValue = ref.watch(readAllEventProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Planner'),
        actions: [
          IconButton(
            onPressed: _clearDatabase,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: eventAsyncValue.when(
        data: (events) {
          return events.isEmpty
              ? const Center(
                  child: Text(
                    'Press the \'+\' button to add new Events.',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventListCard(
                        event: event,
                        onDelete: _deleteEvent,
                      );
                    },
                  ),
                );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return const AddNewEvent();
            },
            useSafeArea: true,
            enableDrag: true,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
