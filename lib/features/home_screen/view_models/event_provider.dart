import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createEventProvider =
    FutureProvider.family<void, Events>((ref, event) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  await eventRepository.addEvent(event);
});

final readAllEventProvider = FutureProvider<List<Events>>((ref) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  return eventRepository.loadEvents();
});

final deleteEventProvider =
    FutureProvider.family<void, Events>((ref, event) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  return eventRepository.deleteEvent(event);
});

// final clearDBProvider = FutureProvider<void>((ref) async {
//   final eventRepository = ref.read(eventRepositoryProvider);
//   return eventRepository.clearDatabase();
// });
