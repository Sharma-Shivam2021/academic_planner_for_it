//Project Packages
import 'package:academic_planner_for_it/features/home_screen/view_models/event_repository.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/all_event_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Project Classes
import '../../../utilities/services/share_event_function.dart';
import '../models/events.dart';
import '../view_models/event_provider.dart';
import '../widgets/add_event_modal_bottom_sheet.dart';
import '../widgets/event_list_card.dart';
import '../../../utilities/common_widgets/custom_drawer.dart';
import 'search_delegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/homeScreen';
  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Events> filteredList = [];
  Set<Events> selectedEvents = {};
  bool isSelectionMode = false;
  @override
  void initState() {
    super.initState();
    _updateNotificationState();
    _searchController.addListener(_updateFilteredList);
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateFilteredList);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _updateFilteredList() async {
    String searchText = _searchController.text.toLowerCase();
    final allEvents = ref.read(allEventsProvider);
    setState(() {
      filteredList = allEvents
          .where((event) => event.eventName.toLowerCase().contains(searchText))
          .toList();
    });
  }

  void _opensSearchView(BuildContext context) {
    final allEvents = ref.read(allEventsProvider);
    showSearch(
      context: context,
      delegate: EventSearchDelegate(allEvents),
    );
  }

  void _deleteEvent(Events deletingEvent) async {
    try {
      await ref.read(deleteEventProvider(deletingEvent).future);
      ref.invalidate(paginatedEventsProvider);
      ref.read(allEventsProvider.notifier).removeEvent(deletingEvent);
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
                ref.read(allEventsProvider.notifier).addEvent(event);
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
                    ref.read(allEventsProvider.notifier).clearEvents();
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

  void _toggleSelection(Events event) {
    setState(() {
      if (selectedEvents.contains(event)) {
        selectedEvents.remove(event);
      } else {
        selectedEvents.add(event);
      }
      isSelectionMode = selectedEvents.isNotEmpty;
    });
  }

  void _deleteSelectedEvents() {
    for (var event in selectedEvents) {
      ref.read(deleteEventProvider(event).future);
      ref.read(allEventsProvider.notifier).removeEvent(event);
    }
    ref.invalidate(paginatedEventsProvider);

    setState(() {
      isSelectionMode = false;
      selectedEvents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventAsyncValue = ref.watch(paginatedEventsProvider);
    final eventAsyncValueNotifier = ref.read(paginatedEventsProvider.notifier);
    final List<int> pageNoList = List.generate(
      eventAsyncValueNotifier.totalPage,
      (i) => i + 1,
    );
    ref.watch(allEventsProvider);
    _updateFilteredList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Planner'),
        actions: [
          if (isSelectionMode) ...[
            IconButton(
              onPressed: _deleteSelectedEvents,
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                onShareMultipleEvents(context, selectedEvents.toList());
              },
              icon: const Icon(Icons.share),
            )
          ],
          IconButton(
            onPressed: _clearDatabase,
            icon: const Icon(Icons.delete_sweep),
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
                          _paginationButtons(
                              eventAsyncValueNotifier, pageNoList),
                          _searchBar(),
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
                                isSelectionMode: isSelectionMode,
                                isSelected: selectedEvents.contains(event),
                                onSelectToggle: () => _toggleSelection(event),
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

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          _opensSearchView(context);
        },
        icon: const Icon(Icons.search),
      ),
    );
  }

  Widget _paginationButtons(eventAsyncValueNotifier, List<int> pageNoList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.outlined(
          style: IconButton.styleFrom(
            minimumSize: const Size(50, 1),
          ),
          onPressed: eventAsyncValueNotifier.page == 1
              ? null
              : () {
                  eventAsyncValueNotifier.previousPage();
                },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 10),
        _dropDownButton(pageNoList, eventAsyncValueNotifier),
        const SizedBox(width: 10),
        IconButton.outlined(
          style: IconButton.styleFrom(
            minimumSize: const Size(50, 1),
          ),
          onPressed: (eventAsyncValueNotifier.page ==
                  eventAsyncValueNotifier.totalPage)
              ? null
              : () {
                  eventAsyncValueNotifier.nextPage();
                },
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  Widget _dropDownButton(List<int> pageNoList, eventAsyncValueNotifier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: DropdownMenu<int>(
        initialSelection: eventAsyncValueNotifier.page,
        dropdownMenuEntries:
            pageNoList.map<DropdownMenuEntry<int>>((int value) {
          return DropdownMenuEntry<int>(
            value: value,
            label: '$value',
          );
        }).toList(),
        onSelected: (int? newValue) {
          if (newValue != null) {
            eventAsyncValueNotifier.goToPage(newValue);
          }
        },
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints.tight(
            const Size.fromHeight(50),
          ),
        ),
      ),
    );
  }
}
