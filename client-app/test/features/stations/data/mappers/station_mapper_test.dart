import 'package:flutter_test/flutter_test.dart';
import 'package:radio/features/stations/data/mappers/station_mapper.dart';
import 'package:radio/features/stations/data/models/coordinates_dto.dart';
import 'package:radio/features/stations/data/models/station_aliases_dto.dart';
import 'package:radio/features/stations/data/models/station_dial_dto.dart';
import 'package:radio/features/stations/data/models/station_dto.dart';
import 'package:radio/features/stations/data/models/station_genre_dto.dart';
import 'package:radio/features/stations/data/models/station_language_dto.dart';
import 'package:radio/features/stations/data/models/station_location_dto.dart';
import 'package:radio/features/stations/data/models/station_popularity_dto.dart';
import 'package:radio/features/stations/data/models/stream_dto.dart';

void main() {
  group('StreamDtoX.toEntity', () {
    test('maps required url and all optionals', () {
      const dto = StreamDto(
        id: 7,
        url: 'https://example/stream',
        bitrate: 128,
        contentType: 'audio/mpeg',
        codec: 'mp3',
        protocol: 'http',
        isHttps: true,
        works: true,
      );
      final entity = dto.toEntity();
      expect(entity.id, 7);
      expect(entity.url, 'https://example/stream');
      expect(entity.bitrate, 128);
      expect(entity.isHttps, isTrue);
    });

    test('keeps optional fields null', () {
      const dto = StreamDto(url: 'https://x');
      final entity = dto.toEntity();
      expect(entity.bitrate, isNull);
      expect(entity.codec, isNull);
    });
  });

  group('StationDtoX.toEntity (full graph)', () {
    test('round-trips a fully-populated station', () {
      const dto = StationDto(
        id: 42,
        name: 'BBC Radio 1',
        slug: 'bbc-radio-1',
        isActive: true,
        logo: 'https://logo',
        dial: StationDialDto(band: 'FM', dial: '98.8', dialStripped: '988'),
        aliases: StationAliasesDto(
          cleanName: 'BBC Radio One',
          alsoKnownAs: 'R1',
        ),
        location: StationLocationDto(
          cityId: 1,
          cityName: 'London',
          countryName: 'United Kingdom',
          countryCode: 'GB',
          locationText: 'London, UK',
          coordinates: CoordinatesDto(latitude: 51.5, longitude: -0.12),
        ),
        genre: StationGenreDto(text: 'Pop', tags: ['pop', 'top40']),
        popularity: StationPopularityDto(global: 999, byCountry: {'GB': 999}),
        streams: [
          StreamDto(url: 'https://a', bitrate: 128, isHttps: true),
          StreamDto(url: 'http://b', bitrate: 64),
        ],
        languages: [StationLanguageDto(code: 'en', name: 'English')],
      );

      final station = dto.toEntity();

      expect(station.id, 42);
      expect(station.name, 'BBC Radio 1');
      expect(station.dial?.dial, '98.8');
      expect(station.aliases?.alsoKnownAs, 'R1');
      expect(station.location?.coordinates?.latitude, 51.5);
      expect(station.genre?.tags, ['pop', 'top40']);
      expect(station.popularity?.byCountry?['GB'], 999);
      expect(station.streams.length, 2);
      expect(station.streams.first.bitrate, 128);
      expect(station.languages?.first.code, 'en');
    });

    test('handles a minimal station (only id, name, empty streams)', () {
      const dto = StationDto(id: 1, name: 'X', streams: []);
      final station = dto.toEntity();
      expect(station.id, 1);
      expect(station.name, 'X');
      expect(station.streams, isEmpty);
      expect(station.dial, isNull);
      expect(station.location, isNull);
      expect(station.languages, isNull);
    });
  });

  group('StationDto JSON round-trip', () {
    test('decodes the upstream shape produced by normalize.ts', () {
      final json = {
        'id': 1,
        'name': 'X',
        'slug': 'x',
        'streams': [
          {'url': 'https://a', 'bitrate': 128, 'isHttps': true},
        ],
        'genre': {
          'text': 'Pop',
          'tags': ['pop'],
        },
        'location': {'countryCode': 'GB'},
      };
      final dto = StationDto.fromJson(json);
      expect(dto.id, 1);
      expect(dto.streams.first.bitrate, 128);
      expect(dto.genre?.tags, ['pop']);
      expect(dto.location?.countryCode, 'GB');
    });
  });
}
