import '../../domain/entities/coordinates.dart';
import '../../domain/entities/radio_stream.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/station_aliases.dart';
import '../../domain/entities/station_dial.dart';
import '../../domain/entities/station_genre.dart';
import '../../domain/entities/station_language.dart';
import '../../domain/entities/station_location.dart';
import '../../domain/entities/station_popularity.dart';
import '../models/coordinates_dto.dart';
import '../models/station_aliases_dto.dart';
import '../models/station_dial_dto.dart';
import '../models/station_dto.dart';
import '../models/station_genre_dto.dart';
import '../models/station_language_dto.dart';
import '../models/station_location_dto.dart';
import '../models/station_popularity_dto.dart';
import '../models/stream_dto.dart';

extension CoordinatesDtoX on CoordinatesDto {
  Coordinates toEntity() =>
      Coordinates(latitude: latitude, longitude: longitude);
}

extension StationLocationDtoX on StationLocationDto {
  StationLocation toEntity() => StationLocation(
        cityId: cityId,
        cityName: cityName,
        countryName: countryName,
        countryCode: countryCode,
        locationText: locationText,
        coordinates: coordinates?.toEntity(),
      );
}

extension StationGenreDtoX on StationGenreDto {
  StationGenre toEntity() => StationGenre(text: text, tags: tags);
}

extension StationDialDtoX on StationDialDto {
  StationDial toEntity() =>
      StationDial(band: band, dial: dial, dialStripped: dialStripped);
}

extension StationAliasesDtoX on StationAliasesDto {
  StationAliases toEntity() =>
      StationAliases(cleanName: cleanName, alsoKnownAs: alsoKnownAs);
}

extension StationLanguageDtoX on StationLanguageDto {
  StationLanguage toEntity() => StationLanguage(code: code, name: name);
}

extension StationPopularityDtoX on StationPopularityDto {
  StationPopularity toEntity() =>
      StationPopularity(global: global, byCountry: byCountry);
}

extension StreamDtoX on StreamDto {
  RadioStream toEntity() => RadioStream(
        id: id,
        url: url,
        bitrate: bitrate,
        contentType: contentType,
        codec: codec,
        protocol: protocol,
        isHttps: isHttps,
        works: works,
      );
}

extension StationDtoX on StationDto {
  Station toEntity() => Station(
        id: id,
        name: name,
        slug: slug,
        isActive: isActive,
        logo: logo,
        dial: dial?.toEntity(),
        aliases: aliases?.toEntity(),
        location: location?.toEntity(),
        genre: genre?.toEntity(),
        popularity: popularity?.toEntity(),
        streams: streams.map((s) => s.toEntity()).toList(),
        languages: languages?.map((l) => l.toEntity()).toList(),
      );
}
