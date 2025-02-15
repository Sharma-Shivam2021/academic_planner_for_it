import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/event_repository.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/pagination_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A provider that adds a new [Events] to the database.
///
/// This provider uses the [EventRepository] to add the event.
final createEventProvider =
    FutureProvider.family<void, Events>((ref, event) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  await eventRepository.addEvent(event);
});

/// A provider that reads all [Events] from the database.
///
/// This provider uses the [EventRepository] to load all events.
final readAllEventProvider = FutureProvider<List<Events>>((ref) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  return eventRepository.loadEvents();
});

/// A provider that deletes an [Events] from the database.
///
/// This provider uses the [EventRepository] to delete the event.
final deleteEventProvider =
    FutureProvider.family<void, Events>((ref, event) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  return eventRepository.deleteEvent(event);
});

/// A provider that manages a paginated list of [Events].
///
/// This provider uses the [PaginatedEventNotifier] to manage the list.
final paginatedEventsProvider =
    StateNotifierProvider<PaginatedEventNotifier, AsyncValue<List<Events>>>(
        (ref) {
  final eventRepository = ref.watch(eventRepositoryProvider);
  return PaginatedEventNotifier(eventRepository);
});
