import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../stations/data/mappers/station_mapper.dart';
import '../../../stations/data/models/coordinates_dto.dart';
import '../../../stations/data/models/station_aliases_dto.dart';
import '../../../stations/data/models/station_dial_dto.dart';
import '../../../stations/data/models/station_dto.dart';
import '../../../stations/data/models/station_genre_dto.dart';
import '../../../stations/data/models/station_language_dto.dart';
import '../../../stations/data/models/station_location_dto.dart';
import '../../../stations/data/models/station_popularity_dto.dart';
import '../../../stations/data/models/stream_dto.dart';
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
  FavoriteStationDto toFavoriteDto({required DateTime addedAt}) {
    return FavoriteStationDto(
      station: _toDto(this),
      addedAt: Timestamp.fromDate(addedAt),
    );
  }
}

StationDto _toDto(Station s) => StationDto(
      id: s.id,
      name: s.name,
      slug: s.slug,
      isActive: s.isActive,
      logo: s.logo,
      dial: s.dial == null
          ? null
          : StationDialDto(
              band: s.dial!.band,
              dial: s.dial!.dial,
              dialStripped: s.dial!.dialStripped,
            ),
      aliases: s.aliases == null
          ? null
          : StationAliasesDto(
              cleanName: s.aliases!.cleanName,
              alsoKnownAs: s.aliases!.alsoKnownAs,
            ),
      location: s.location == null
          ? null
          : StationLocationDto(
              cityId: s.location!.cityId,
              cityName: s.location!.cityName,
              countryName: s.location!.countryName,
              countryCode: s.location!.countryCode,
              locationText: s.location!.locationText,
              coordinates: s.location!.coordinates == null
                  ? null
                  : CoordinatesDto(
                      latitude: s.location!.coordinates!.latitude,
                      longitude: s.location!.coordinates!.longitude,
                    ),
            ),
      genre: s.genre == null
          ? null
          : StationGenreDto(text: s.genre!.text, tags: s.genre!.tags),
      popularity: s.popularity == null
          ? null
          : StationPopularityDto(
              global: s.popularity!.global,
              byCountry: s.popularity!.byCountry,
            ),
      streams: s.streams
          .map((r) => StreamDto(
                id: r.id,
                url: r.url,
                bitrate: r.bitrate,
                contentType: r.contentType,
                codec: r.codec,
                protocol: r.protocol,
                isHttps: r.isHttps,
                works: r.works,
              ))
          .toList(),
      languages: s.languages
          ?.map((l) => StationLanguageDto(code: l.code, name: l.name))
          .toList(),
    );
