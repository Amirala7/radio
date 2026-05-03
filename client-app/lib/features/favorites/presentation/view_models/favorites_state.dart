import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite_station.dart';

part 'favorites_state.freezed.dart';

@freezed
abstract class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default(<FavoriteStation>[]) List<FavoriteStation> items,
    @Default(true) bool isLoading,
    AppFailure? error,
  }) = _FavoritesState;
}
