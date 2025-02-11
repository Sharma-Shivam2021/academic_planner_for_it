import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllEventsProvider extends StateNotifier<List<Events>> {
  AllEventsProvider(this.ref) : super([]) {
    fetchEvents();
  }
  final Ref ref;

  Future<void> fetchEvents() async {
    state = await ref.read(readAllEventProvider.future);
  }

  void addEvent(Events event) {
    state = [...state, event];
  }

  void removeEvent(Events event) {
    state = state
        .where(
          (e) => e.eventName.toLowerCase() != event.eventName.toLowerCase(),
        )
        .toList();
  }

  void updateEvent(Events updatedEvent) {
    state = [
      for (final event in state)
        if (event.id == updatedEvent.id) updatedEvent else event
    ];
  }

  void clearEvents() {
    state = [];
  }

  void addMultipleEvents(List<Events> events) {
    // Check for duplicates before adding
    List<Events> uniqueEvents = [];
    for (var newEvent in events) {
      bool isDuplicate = false;
      for (var existingEvent in state) {
        if (newEvent.id == existingEvent.id) {
          isDuplicate = true;
          break;
        }
      }
      if (!isDuplicate) {
        uniqueEvents.add(newEvent);
      }
    }
    state = [...state, ...uniqueEvents];
  }
}

final allEventsProvider =
    StateNotifierProvider<AllEventsProvider, List<Events>>((ref) {
  return AllEventsProvider(ref);
});
