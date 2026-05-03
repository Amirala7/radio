import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../stations/data/models/station_dto.dart';

/// Stored under `users/{uid}/favorites/{stationId}`.
/// Station fields are flattened at the document root alongside `addedAt`.
class FavoriteStationDto {
  const FavoriteStationDto({
    required this.station,
    required this.addedAt,
  });

  final StationDto station;
  final Timestamp addedAt;

  factory FavoriteStationDto.fromMap(Map<String, dynamic> map) {
    final addedAt = map['addedAt'];
    if (addedAt is! Timestamp) {
      throw StateError('favorite doc missing addedAt Timestamp');
    }
    final stationMap = Map<String, dynamic>.from(map)..remove('addedAt');
    return FavoriteStationDto(
      station: StationDto.fromJson(stationMap),
      addedAt: addedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final stationJson = station.toJson();
    return {
      ...stationJson,
      'addedAt': addedAt,
    };
  }
}
