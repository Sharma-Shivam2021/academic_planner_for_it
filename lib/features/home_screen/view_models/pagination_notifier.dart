import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/events.dart';
import 'event_repository.dart';

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
    await _loadPage(1);
  }

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

  void nextPage() {
    if (_hasMore && _page < _totalPages) {
      _loadPage(_page + 1);
    }
  }

  void previousPage() {
    if (_page > 1) {
      _loadPage(_page - 1);
    }
  }

  Future<void> goToPage(int pageNo) async {
    if (_isLoading) return;
    if (pageNo > 0 && pageNo <= _totalPages) {
      await _loadPage(pageNo);
    }
  }

  Future<void> refreshPagination() async {
    await _fetchTotalPages();
    await _loadPage(_page);
  }

  Future<void> _fetchTotalPages() async {
    try {
      int totalEvents = await _eventRepository.getTotalEventCount();
      _totalPages = (totalEvents / _pageSize).ceil();
      if (_totalPages == 0) _totalPages = 1;
    } catch (e) {
      throw Exception('$e');
    }
  }

  int get page => _page;

  int get totalPage => _totalPages;
}
