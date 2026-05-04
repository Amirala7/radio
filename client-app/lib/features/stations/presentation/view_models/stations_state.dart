import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/station.dart';

part 'stations_state.freezed.dart';

enum StationsMode { list, popular, search, byGenre }

@freezed
abstract class StationsState with _$StationsState {
  const factory StationsState({
    @Default(StationsMode.list) StationsMode mode,
    @Default(<Station>[]) List<Station> items,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    String? query,
    String? country,
    int? genreId,
    String? genreSlug,
    AppFailure? error,
  }) = _StationsState;
}
