import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/genre.dart';

part 'genres_state.freezed.dart';

@freezed
abstract class GenresState with _$GenresState {
  const factory GenresState({
    @Default(<Genre>[]) List<Genre> items,
    @Default(1) int page,
    @Default(100) int limit,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    AppFailure? error,
  }) = _GenresState;
}
