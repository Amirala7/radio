import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/favorite_station.dart';
import '../../domain/usecases/add_favorite_use_case.dart';
import '../../domain/usecases/remove_favorite_use_case.dart';
import '../../domain/usecases/toggle_favorite_use_case.dart';
import '../../domain/usecases/watch_favorites_use_case.dart';
import 'favorites_state.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({
    required WatchFavoritesUseCase watchFavorites,
    required AddFavoriteUseCase addFavorite,
    required RemoveFavoriteUseCase removeFavorite,
    required ToggleFavoriteUseCase toggleFavorite,
  })  : _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        _toggleFavorite = toggleFavorite {
    _subscription = watchFavorites().listen(
      (items) {
        if (_disposed) return;
        _state = _state.copyWith(
          items: items,
          isLoading: false,
          error: null,
        );
        notifyListeners();
      },
      onError: (Object e) {
        if (_disposed) return;
        final failure = e is AppFailure ? e : UnknownFailure(e.toString());
        _state = _state.copyWith(error: failure, isLoading: false);
        notifyListeners();
      },
    );
  }

  final AddFavoriteUseCase _addFavorite;
  final RemoveFavoriteUseCase _removeFavorite;
  final ToggleFavoriteUseCase _toggleFavorite;

  late final StreamSubscription<List<FavoriteStation>> _subscription;
  bool _disposed = false;

  FavoritesState _state = const FavoritesState();
  FavoritesState get state => _state;

  bool isFavorite(int stationId) =>
      _state.items.any((f) => f.station.id == stationId);

  Future<void> add(Station station) async {
    try {
      await _addFavorite(station);
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e);
      notifyListeners();
    }
  }

  Future<void> remove(int stationId) async {
    try {
      await _removeFavorite(stationId);
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e);
      notifyListeners();
    }
  }

  Future<void> toggle(Station station) async {
    try {
      await _toggleFavorite(station);
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _subscription.cancel();
    super.dispose();
  }
}
