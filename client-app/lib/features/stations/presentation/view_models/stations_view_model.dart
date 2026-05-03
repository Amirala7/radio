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

  Future<void> showList() async {
    _state = const StationsState(mode: StationsMode.list, isLoading: true);
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> showPopular({String? country}) async {
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
    try {
      final pageResult = await _fetchByMode(1);
      _state = _state.copyWith(
        items: pageResult.data,
        page: 1,
        hasMore: pageResult.data.length >= _state.limit,
        isLoading: false,
      );
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e, isLoading: false);
    }
    notifyListeners();
  }

  Future<void> refresh() async {
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
    _state = _state.copyWith(isLoadingMore: true, error: null);
    notifyListeners();
    final nextPage = _state.page + 1;
    try {
      final pageResult = await _fetchByMode(nextPage);
      _state = _state.copyWith(
        items: [..._state.items, ...pageResult.data],
        page: nextPage,
        hasMore: pageResult.data.length >= _state.limit,
        isLoadingMore: false,
      );
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e, isLoadingMore: false);
    }
    notifyListeners();
  }

  void clearError() {
    if (_state.error == null) return;
    _state = _state.copyWith(error: null);
    notifyListeners();
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
