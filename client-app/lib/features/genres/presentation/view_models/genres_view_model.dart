import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/list_genres_use_case.dart';
import 'genres_state.dart';

class GenresViewModel extends ChangeNotifier {
  GenresViewModel({required ListGenresUseCase listGenres})
    : _listGenres = listGenres;

  final ListGenresUseCase _listGenres;

  GenresState _state = const GenresState();
  GenresState get state => _state;

  /// Fetches every page of genres on first call, then caches the full list
  /// for the rest of the session. Subsequent calls are no-ops unless the
  /// previous attempt failed.
  Future<void> load() async {
    if (_state.items.isNotEmpty && _state.error == null) return;
    await _fetchAllPages();
  }

  /// Forces a re-fetch of every page, replacing the cache.
  Future<void> refresh() async {
    _state = const GenresState();
    await _fetchAllPages();
  }

  void clearError() {
    if (_state.error == null) return;
    _state = _state.copyWith(error: null);
    notifyListeners();
  }

  Future<void> _fetchAllPages() async {
    _state = _state.copyWith(items: const [], isLoading: true, error: null);
    notifyListeners();

    final all = <Genre>[];
    var page = 1;
    try {
      while (true) {
        final result = await _listGenres(page: page, limit: _state.limit);
        all.addAll(result.data);
        if (result.data.length < _state.limit) break;
        page++;
      }
      _state = _state.copyWith(
        items: all,
        page: page,
        hasMore: false,
        isLoading: false,
      );
    } on AppFailure catch (e) {
      _state = _state.copyWith(items: all, error: e, isLoading: false);
    }
    notifyListeners();
  }
}
