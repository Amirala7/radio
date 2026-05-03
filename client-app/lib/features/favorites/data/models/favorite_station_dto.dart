import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../stations/data/models/station_dto.dart';

part 'favorite_station_dto.freezed.dart';

/// Stored under `users/{uid}/favorites/{stationId}`.
/// Station fields are flattened at the document root alongside `addedAt`.
/// Custom `fromMap`/`toMap` (not json_serializable) because Firestore's
/// `Timestamp` is not standard JSON.
@freezed
abstract class FavoriteStationDto with _$FavoriteStationDto {
  const factory FavoriteStationDto({
    required StationDto station,
    required Timestamp addedAt,
  }) = _FavoriteStationDto;

  /// Builds a DTO from a Firestore document map. Recursively re-types nested
  /// maps and lists — Firestore returns `Map<Object?, Object?>` and
  /// `List<Object?>` for nested values, but `_$StationDtoFromJson` expects
  /// `Map<String, dynamic>` and `List<dynamic>` and will throw `TypeError`
  /// without the conversion.
  factory FavoriteStationDto.fromMap(Map<String, dynamic> map) {
    final addedAt = map['addedAt'];
    if (addedAt is! Timestamp) {
      throw StateError('favorite doc missing addedAt Timestamp');
    }
    final stationFields = <String, dynamic>{...map}..remove('addedAt');
    return FavoriteStationDto(
      station: StationDto.fromJson(_deepJsonMap(stationFields)),
      addedAt: addedAt,
    );
  }
}

extension FavoriteStationDtoMap on FavoriteStationDto {
  Map<String, dynamic> toMap() => {...station.toJson(), 'addedAt': addedAt};
}

Map<String, dynamic> _deepJsonMap(Map<dynamic, dynamic> source) =>
    source.map((k, v) => MapEntry(k as String, _castJsonValue(v)));

Object? _castJsonValue(Object? v) {
  if (v is Map) return _deepJsonMap(v);
  if (v is List) return v.map(_castJsonValue).toList();
  return v;
}
