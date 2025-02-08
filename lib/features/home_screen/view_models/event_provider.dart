import 'package:academic_planner_for_it/features/home_screen/models/events.dart';
import 'package:academic_planner_for_it/features/home_screen/view_models/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createEventProvider =
    FutureProvider.family<void, Events>((ref, event) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  await eventRepository.addEvent(event);
});

// final readAllEventProvider = FutureProvider<List<Events>>((ref) async {
//   final eventRepository = ref.read(eventRepositoryProvider);
//   return eventRepository.loadEvents();
// });

final deleteEventProvider =
    FutureProvider.family<void, Events>((ref, event) async {
  final eventRepository = ref.read(eventRepositoryProvider);
  return eventRepository.deleteEvent(event);
});

// final clearDBProvider = FutureProvider<void>((ref) async {
//   final eventRepository = ref.read(eventRepositoryProvider);
//   return eventRepository.clearDatabase();
// });

class PaginatedEventNotifier extends StateNotifier<AsyncValue<List<Events>>> {
  final EventRepository _eventRepository;
  int _page = 1;
  int _totalPages = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  PaginatedEventNotifier(this._eventRepository)
      : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchTotalPages();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    try {
      final newEvents = await _eventRepository.loadEventsPaginated(
        page: _page,
        pageSize: _pageSize,
      );
      if (newEvents.isEmpty) {
        _hasMore = false;
      }
      state = AsyncValue.data(newEvents);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }

  void nextPage() {
    if (!_hasMore) return;
    _page++;
    _loadNextPage();
  }

  void previousPage() {
    if (_page > 1) {
      _page--;
      _loadNextPage();
    }
  }

  Future<void> _fetchTotalPages() async {
    try {
      int totalEvents = await _eventRepository.getTotalEventCount();
      _totalPages = (totalEvents / _pageSize).ceil();
    } catch (e) {
      throw Exception('$e');
    }
  }

  int get page => _page;

  int get totalPage => _totalPages;
}

final paginatedEventsProvider =
    StateNotifierProvider<PaginatedEventNotifier, AsyncValue<List<Events>>>(
        (ref) {
  final eventRepository = ref.watch(eventRepositoryProvider);
  return PaginatedEventNotifier(eventRepository);
});
