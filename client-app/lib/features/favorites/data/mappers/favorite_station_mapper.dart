import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../stations/data/mappers/station_mapper.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/favorite_station.dart';
import '../models/favorite_station_dto.dart';

extension FavoriteStationDtoX on FavoriteStationDto {
  FavoriteStation toEntity() => FavoriteStation(
        station: station.toEntity(),
        addedAt: addedAt.toDate(),
      );
}

extension StationFavoriteX on Station {
  FavoriteStationDto toFavoriteDto({required DateTime addedAt}) =>
      FavoriteStationDto(
        station: toDto(),
        addedAt: Timestamp.fromDate(addedAt),
      );
}
