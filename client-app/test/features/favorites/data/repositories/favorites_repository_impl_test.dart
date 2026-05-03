import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/auth/auth_service.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:radio/features/favorites/data/models/favorite_station_dto.dart';
import 'package:radio/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:radio/features/stations/data/models/station_dto.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockDataSource extends Mock implements FavoritesRemoteDataSource {}

class _MockAuthService extends Mock implements AuthService {}

class _MockUser extends Mock implements User {}

class _FakeFavoriteDto extends Fake implements FavoriteStationDto {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeFavoriteDto());
  });

  late _MockDataSource ds;
  late _MockAuthService auth;
  late FavoritesRepositoryImpl repo;
  late _MockUser user;

  setUp(() {
    ds = _MockDataSource();
    auth = _MockAuthService();
    user = _MockUser();
    when(() => user.uid).thenReturn('u1');
    when(() => auth.currentUser).thenReturn(user);
    repo = FavoritesRepositoryImpl(dataSource: ds, authService: auth);
  });

  group('uid guard', () {
    test('watchAll emits UnauthenticatedFailure when no user', () {
      when(() => auth.currentUser).thenReturn(null);
      expectLater(repo.watchAll(), emitsError(isA<UnauthenticatedFailure>()));
    });

    test('isFavorite emits UnauthenticatedFailure when no user', () {
      when(() => auth.currentUser).thenReturn(null);
      expectLater(
        repo.isFavorite(1),
        emitsError(isA<UnauthenticatedFailure>()),
      );
    });

    test('add throws when no user', () async {
      when(() => auth.currentUser).thenReturn(null);
      await expectLater(
        repo.add(const Station(id: 1, name: 'X', streams: [])),
        throwsA(isA<UnauthenticatedFailure>()),
      );
    });

    test('remove throws when no user', () async {
      when(() => auth.currentUser).thenReturn(null);
      await expectLater(repo.remove(1), throwsA(isA<UnauthenticatedFailure>()));
    });
  });

  group('watchAll', () {
    test('emits mapped FavoriteStation list from data source stream', () async {
      final dto = FavoriteStationDto(
        station: const StationDto(id: 1, name: 'X', streams: []),
        addedAt: Timestamp.fromDate(DateTime.utc(2026, 5, 3)),
      );
      when(() => ds.watchAll('u1')).thenAnswer((_) => Stream.value([dto]));

      final list = await repo.watchAll().first;
      expect(list.first.station.id, 1);
      expect(list.first.addedAt.toUtc(), DateTime.utc(2026, 5, 3));
    });
  });

  group('isFavorite', () {
    test('forwards uid and stationId', () async {
      when(
        () => ds.watchIsFavorite('u1', 7),
      ).thenAnswer((_) => Stream.value(true));
      final v = await repo.isFavorite(7).first;
      expect(v, isTrue);
      verify(() => ds.watchIsFavorite('u1', 7)).called(1);
    });
  });

  group('add', () {
    test('writes a FavoriteStationDto with the station id', () async {
      when(() => ds.add('u1', any())).thenAnswer((_) async {});
      await repo.add(const Station(id: 42, name: 'X', streams: []));
      final captured =
          verify(() => ds.add('u1', captureAny())).captured.single
              as FavoriteStationDto;
      expect(captured.station.id, 42);
    });

    test(
      'maps Firestore permission-denied to UnauthenticatedFailure',
      () async {
        when(() => ds.add('u1', any())).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
          ),
        );
        await expectLater(
          repo.add(const Station(id: 1, name: 'X', streams: [])),
          throwsA(isA<UnauthenticatedFailure>()),
        );
      },
    );
  });

  group('remove', () {
    test('forwards uid and stationId', () async {
      when(() => ds.remove('u1', 9)).thenAnswer((_) async {});
      await repo.remove(9);
      verify(() => ds.remove('u1', 9)).called(1);
    });
  });
}
