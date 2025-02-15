import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A state notifier that manages a list of all [Events].
///
/// This class provides methods for fetching, adding, removing, updating,
/// and clearing events, as well as adding multiple events at once.
class AllEventsProvider extends StateNotifier<List<Events>> {
  /// Creates an [AllEventsProvider].
  ///
  /// Parameters:
  ///   - [ref]: The [Ref] used to interact with other providers.
  AllEventsProvider(this.ref) : super([]) {
    fetchEvents();
  }
  final Ref ref;

  /// Fetches all events from the database and updates the state.
  Future<void> fetchEvents() async {
    state = await ref.read(readAllEventProvider.future);
  }

  /// Adds a new [Events] to the list.
  ///
  /// Parameters:
  ///   - [event]: The [Events] to add.
  void addEvent(Events event) {
    state = [...state, event];
  }

  /// Removes an [Events] from the list.
  ///
  /// Parameters:
  ///   - [event]: The [Events] to remove.
  void removeEvent(Events event) {
    state = state
        .where(
          (e) => e.eventName.toLowerCase() != event.eventName.toLowerCase(),
        )
        .toList();
  }

  /// Updates an existing [Events] in the list.
  ///
  /// Parameters:
  ///   - [updatedEvent]: The updated [Events].
  void updateEvent(Events updatedEvent) {
    state = [
      for (final event in state)
        if (event.id == updatedEvent.id) updatedEvent else event
    ];
  }

  /// Clears all [Events] from the list.
  void clearEvents() {
    state = [];
  }

  /// Adds multiple [Events] to the list, avoiding duplicates.
  ///
  /// Parameters:
  ///   - [events]: The list of [Events] to add.
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

/// A provider that exposes an [AllEventsProvider] instance.
final allEventsProvider =
    StateNotifierProvider<AllEventsProvider, List<Events>>((ref) {
  return AllEventsProvider(ref);
});
