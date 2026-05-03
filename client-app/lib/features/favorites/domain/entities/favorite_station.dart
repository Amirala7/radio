import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../stations/domain/entities/station.dart';

part 'favorite_station.freezed.dart';

@freezed
abstract class FavoriteStation with _$FavoriteStation {
  const factory FavoriteStation({
    required Station station,
    required DateTime addedAt,
  }) = _FavoriteStation;
}
