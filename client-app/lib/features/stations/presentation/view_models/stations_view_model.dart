import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/pagination/page.dart';
import '../../domain/entities/station.dart';
import '../../domain/usecases/get_popular_stations_use_case.dart';
import '../../domain/usecases/get_stations_by_genre_use_case.dart';
import '../../domain/usecases/list_stations_use_case.dart';
import '../../domain/usecases/search_stations_use_case.dart';
import 'stations_state.dart';

class StationsViewModel extends ChangeNotifier {
  StationsViewModel({
    required ListStationsUseCase listStations,
    required GetPopularStationsUseCase popularStations,
    required SearchStationsUseCase searchStations,
    required GetStationsByGenreUseCase stationsByGenre,
  }) : _listStations = listStations,
       _popularStations = popularStations,
       _searchStations = searchStations,
       _stationsByGenre = stationsByGenre;

  final ListStationsUseCase _listStations;
  final GetPopularStationsUseCase _popularStations;
  final SearchStationsUseCase _searchStations;
  final GetStationsByGenreUseCase _stationsByGenre;

  StationsState _state = const StationsState();
  StationsState get state => _state;

  // Bumped on every fetch entry point. A fetch only commits its result if
  // its token still matches at completion — otherwise a slow earlier
  // request (e.g. for an older search query) would overwrite the results
  // of a newer one.
  int _fetchToken = 0;

  // Tab-switch cache. When the user moves between tabs, we restore the
  // previous fetch instead of refetching, as long as it's recent. Pull-
  // to-refresh and filter changes always bypass this. Search and
  // by-genre are not cached — too many possible keys to be useful.
  static const _cacheTtl = Duration(seconds: 60);
  final Map<StationsMode, _ModeSnapshot> _cache = {};

  @visibleForTesting
  DateTime Function() now = DateTime.now;

  Future<void> showList({bool useCacheIfFresh = false}) async {
    if (useCacheIfFresh && _restoreFromCache(StationsMode.list)) return;
    _state = const StationsState(mode: StationsMode.list, isLoading: true);
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> showPopular({
    String? country,
    bool useCacheIfFresh = false,
  }) async {
    if (useCacheIfFresh &&
        country == null &&
        _restoreFromCache(StationsMode.popular)) {
      return;
    }
    _state = StationsState(
      mode: StationsMode.popular,
      country: country,
      isLoading: true,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> showSearch(String query) async {
    if (query.isEmpty) return;
    _state = StationsState(
      mode: StationsMode.search,
      query: query,
      isLoading: true,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> showByGenre({int? genreId, String? genreSlug}) async {
    _state = StationsState(
      mode: StationsMode.byGenre,
      genreId: genreId,
      genreSlug: genreSlug,
      isLoading: true,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> _fetchPageOne() async {
    final token = ++_fetchToken;
    try {
      final pageResult = await _fetchByMode(1);
      if (token != _fetchToken) return;
      // Popular is a single-page feed upstream — disable pagination
      // regardless of how many rows the response contains.
      final hasMore = _state.mode == StationsMode.popular
          ? false
          : pageResult.data.length >= _state.limit;
      _state = _state.copyWith(
        items: pageResult.data,
        page: 1,
        hasMore: hasMore,
        isLoading: false,
      );
      _cacheCurrentMode();
    } on AppFailure catch (e) {
      if (token != _fetchToken) return;
      _state = _state.copyWith(error: e, isLoading: false);
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    _cache.remove(_state.mode);
    _state = _state.copyWith(
      page: 1,
      items: const [],
      hasMore: true,
      isLoading: true,
      error: null,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> loadMore() async {
    if (_state.isLoading || _state.isLoadingMore || !_state.hasMore) return;
    final token = ++_fetchToken;
    _state = _state.copyWith(isLoadingMore: true, error: null);
    notifyListeners();
    final nextPage = _state.page + 1;
    try {
      final pageResult = await _fetchByMode(nextPage);
      if (token != _fetchToken) return;
      _state = _state.copyWith(
        items: [..._state.items, ...pageResult.data],
        page: nextPage,
        hasMore: pageResult.data.length >= _state.limit,
        isLoadingMore: false,
      );
      _cacheCurrentMode();
    } on AppFailure catch (e) {
      if (token != _fetchToken) return;
      _state = _state.copyWith(error: e, isLoadingMore: false);
    }
    notifyListeners();
  }

  bool _restoreFromCache(StationsMode mode) {
    final snap = _cache[mode];
    if (snap == null) return false;
    if (now().difference(snap.fetchedAt) > _cacheTtl) {
      _cache.remove(mode);
      return false;
    }
    // A fetch may be in flight from a prior tab — invalidate it so its
    // late response can't overwrite the restored snapshot.
    ++_fetchToken;
    _state = StationsState(
      mode: mode,
      items: snap.items,
      page: snap.page,
      hasMore: snap.hasMore,
    );
    notifyListeners();
    return true;
  }

  void _cacheCurrentMode() {
    final mode = _state.mode;
    if (mode != StationsMode.list && mode != StationsMode.popular) return;
    _cache[mode] = _ModeSnapshot(
      items: _state.items,
      page: _state.page,
      hasMore: _state.hasMore,
      fetchedAt: now(),
    );
  }

  void clearError() {
    if (_state.error == null) return;
    _state = _state.copyWith(error: null);
    notifyListeners();
  }

  @visibleForTesting
  bool hasFreshCacheFor(StationsMode mode) {
    final snap = _cache[mode];
    if (snap == null) return false;
    return now().difference(snap.fetchedAt) <= _cacheTtl;
  }

  Future<Page<Station>> _fetchByMode(int page) {
    switch (_state.mode) {
      case StationsMode.list:
        return _listStations(page: page, limit: _state.limit);
      case StationsMode.popular:
        return _popularStations(
          country: _state.country,
          page: page,
          limit: _state.limit,
        );
      case StationsMode.search:
        return _searchStations(
          query: _state.query!,
          page: page,
          limit: _state.limit,
        );
      case StationsMode.byGenre:
        return _stationsByGenre(
          genreId: _state.genreId,
          genreSlug: _state.genreSlug,
          page: page,
          limit: _state.limit,
        );
    }
  }
}

class _ModeSnapshot {
  const _ModeSnapshot({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.fetchedAt,
  });

  final List<Station> items;
  final int page;
  final bool hasMore;
  final DateTime fetchedAt;
}
