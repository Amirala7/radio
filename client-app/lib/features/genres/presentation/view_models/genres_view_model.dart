import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/list_genres_use_case.dart';
import 'genres_state.dart';

class GenresViewModel extends ChangeNotifier {
  GenresViewModel({required ListGenresUseCase listGenres})
    : _listGenres = listGenres;

  final ListGenresUseCase _listGenres;

  GenresState _state = const GenresState();
  GenresState get state => _state;

  Future<void> load() async {
    if (_state.items.isNotEmpty && _state.error == null) return;
    await _fetchPageOne();
  }

  Future<void> refresh() async {
    _state = const GenresState(isLoading: true);
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> loadMore() async {
    if (_state.isLoading || _state.isLoadingMore || !_state.hasMore) return;
    _state = _state.copyWith(isLoadingMore: true, error: null);
    notifyListeners();
    final nextPage = _state.page + 1;
    try {
      final pageResult = await _listGenres(page: nextPage, limit: _state.limit);
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

  Future<void> _fetchPageOne() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();
    try {
      final pageResult = await _listGenres(page: 1, limit: _state.limit);
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
}
