import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radio/features/favorites/data/mappers/favorite_station_mapper.dart';
import 'package:radio/features/favorites/data/models/favorite_station_dto.dart';
import 'package:radio/features/stations/data/models/station_dto.dart';
import 'package:radio/features/stations/data/models/stream_dto.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

void main() {
  group('FavoriteStationDto fromMap / toMap', () {
    test('round-trips Station fields plus addedAt Timestamp', () {
      final addedAt = DateTime.utc(2026, 5, 3, 12);
      final map = {
        'id': 1,
        'name': 'X',
        'streams': [
          {'url': 'https://a', 'bitrate': 128, 'isHttps': true},
        ],
        'addedAt': Timestamp.fromDate(addedAt),
      };

      final dto = FavoriteStationDto.fromMap(map);
      expect(dto.station.id, 1);
      expect(dto.station.streams.first.url, 'https://a');
      expect(dto.addedAt.toDate().toUtc(), addedAt);

      final round = dto.toMap();
      expect(round['id'], 1);
      expect(round['streams'], isA<List<dynamic>>());
      expect(round['addedAt'], isA<Timestamp>());
      expect((round['addedAt']! as Timestamp).toDate().toUtc(), addedAt);
    });
  });

  group('FavoriteStationDtoX.toEntity', () {
    test('produces a FavoriteStation wrapping Station + DateTime', () {
      final addedAt = DateTime.utc(2026, 5, 3);
      const station = StationDto(
        id: 1,
        name: 'X',
        streams: [StreamDto(url: 'https://a')],
      );
      final dto = FavoriteStationDto(
        station: station,
        addedAt: Timestamp.fromDate(addedAt),
      );
      final entity = dto.toEntity();
      expect(entity.station, isA<Station>());
      expect(entity.station.id, 1);
      expect(entity.addedAt.toUtc(), addedAt);
    });
  });

  group('Station.toFavoriteDto', () {
    test('wraps a Station entity into a DTO with the supplied addedAt', () {
      final addedAt = DateTime.utc(2026, 1, 2);
      const station = Station(id: 9, name: 'Y', streams: []);
      final dto = station.toFavoriteDto(addedAt: addedAt);
      expect(dto.station.id, 9);
      expect(dto.station.streams, isEmpty);
      expect(dto.addedAt.toDate().toUtc(), addedAt);
    });
  });
}
