import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/events.dart';
import 'event_repository.dart';

/// A notifier that manages a paginated list of [Events].
///
/// This class handles fetching events in pages, managing the current page,
/// total pages, and loading state.
class PaginatedEventNotifier extends StateNotifier<AsyncValue<List<Events>>> {
  final EventRepository _eventRepository;
  int _page = 1;
  int _totalPages = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  /// Creates a [PaginatedEventNotifier].
  ///
  /// Parameters:
  ///   - [_eventRepository]: The repository for fetching event data.
  PaginatedEventNotifier(this._eventRepository)
      : super(const AsyncValue.loading()) {
    _initialize();
  }

  /// Initializes the notifier by fetching the total number of pages and loading the first page.
  Future<void> _initialize() async {
    await _fetchTotalPages();
    await _loadPage(1);
  }

  /// Loads a specific page of events.
  ///
  /// Parameters:
  ///   - [pageNo]: The page number to load.
  Future<void> _loadPage(int pageNo) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final newEvents = await _eventRepository.loadEventsPaginated(
        page: pageNo,
        pageSize: _pageSize,
      );
      _page = pageNo;
      _hasMore = newEvents.length == _pageSize;
      state = AsyncValue.data(newEvents);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }

  /// Loads the next page of events.
  void nextPage() {
    if (_hasMore && _page < _totalPages) {
      _loadPage(_page + 1);
    }
  }

  /// Loads the previous page of events.
  void previousPage() {
    if (_page > 1) {
      _loadPage(_page - 1);
    }
  }

  /// Loads a specific page of events.
  ///
  /// Parameters:
  ///   - [pageNo]: The page number to load.
  Future<void> goToPage(int pageNo) async {
    if (_isLoading) return;
    if (pageNo > 0 && pageNo <= _totalPages) {
      await _loadPage(pageNo);
    }
  }

  /// Refreshes the pagination by fetching the total number of pages and reloading the current page.
  Future<void> refreshPagination() async {
    await _fetchTotalPages();
    await _loadPage(_page);
  }

  /// Fetches the total number of pages based on the total number of events and the page size.
  Future<void> _fetchTotalPages() async {
    try {
      int totalEvents = await _eventRepository.getTotalEventCount();
      _totalPages = (totalEvents / _pageSize).ceil();
      if (_totalPages == 0) _totalPages = 1;
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// The current page number.
  int get page => _page;

  /// The total number of pages.
  int get totalPage => _totalPages;
}
