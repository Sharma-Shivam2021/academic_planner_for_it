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
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _updateNotificationState();
  }

  void _deleteEvent(Events deletingEvent) async {
    try {
      await ref.read(deleteEventProvider(deletingEvent).future);
      ref.invalidate(paginatedEventsProvider);
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
                ref.invalidate(paginatedEventsProvider);
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
                    ref.invalidate(paginatedEventsProvider);
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

  void _updateNotificationState() async {
    await ref.read(eventRepositoryProvider).updateEventNotificationState();
    ref.invalidate(paginatedEventsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final eventAsyncValue = ref.watch(paginatedEventsProvider);
    final eventAsyncValueNotifier = ref.read(paginatedEventsProvider.notifier);
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
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      'Press the \'+\' button to add new Events.',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Row(
                            children: [
                              IconButton.outlined(
                                onPressed: eventAsyncValueNotifier.page == 1
                                    ? null
                                    : () {
                                        eventAsyncValueNotifier.previousPage();
                                      },
                                icon: const Icon(Icons.arrow_back),
                              ),
                              const SizedBox(width: 10),
                              Text('${eventAsyncValueNotifier.page}'),
                              const SizedBox(width: 10),
                              IconButton.outlined(
                                onPressed: eventAsyncValueNotifier.page ==
                                        eventAsyncValueNotifier.totalPage
                                    ? null
                                    : () {
                                        eventAsyncValueNotifier.nextPage();
                                      },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: events.length + 1,
                          itemBuilder: (context, index) {
                            if (index < events.length) {
                              final event = events[index];
                              return EventListCard(
                                event: event,
                                onDelete: _deleteEvent,
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
