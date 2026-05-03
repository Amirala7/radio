# Models, Repositories & Use Cases — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the data layer (DTOs, mappers), domain layer (entities, repositories, use cases), and unit tests for the four client features — `stations`, `genres`, `favorites`, `player` — wiring them on top of the already-scaffolded `core/` infrastructure.

**Architecture:** Strict CLEAN layering per [CLAUDE.md](../../../CLAUDE.md). Each feature gets DTOs (freezed + json_serializable) → entity (freezed) → mapper (extension methods, one file per object graph) → datasource → repository (interface + impl) → use cases. Errors normalized via `mapException` to `AppFailure` subclasses at the repository boundary. `Page<T>` and `PageMeta` are shared infrastructure under `core/pagination/`.

**Tech Stack:** Dart 3.11, Flutter, freezed 3.x, json_serializable, mocktail, cloud_functions, cloud_firestore, firebase_auth, just_audio.

**Spec:** [docs/superpowers/specs/2026-05-03-models-repositories-usecases-design.md](../specs/2026-05-03-models-repositories-usecases-design.md)

**Working directory:** All commands run from `client-app/` unless stated otherwise.

**Codegen:** Every task that adds or changes a freezed class ends with `dart run build_runner build --delete-conflicting-outputs` before tests are run.

**Naming clash:** Domain `Stream` collides with `dart:async.Stream`. The entity is named `RadioStream`. The DTO stays `StreamDto` because the data layer doesn't reference `dart:async.Stream`.

**Commits:** If the project uses git, commit after each task with the message shown in the final step. If not, skip the commit step — the rest is unaffected.

---

## File map

### Created

```
client-app/lib/
  core/
    pagination/
      page.dart
      page_meta.dart
      page_dto.dart
      page_meta_dto.dart
      page_mapper.dart
  features/
    stations/
      data/
        models/
          station_dto.dart
          stream_dto.dart
          station_genre_dto.dart
          station_location_dto.dart
          coordinates_dto.dart
          station_dial_dto.dart
          station_aliases_dto.dart
          station_language_dto.dart
          station_popularity_dto.dart
        mappers/station_mapper.dart
        datasources/station_remote_data_source.dart
        repositories/station_repository_impl.dart
      domain/
        entities/
          station.dart
          radio_stream.dart
          station_genre.dart
          station_location.dart
          coordinates.dart
          station_dial.dart
          station_aliases.dart
          station_language.dart
          station_popularity.dart
        repositories/station_repository.dart
        usecases/
          list_stations_use_case.dart
          get_popular_stations_use_case.dart
          search_stations_use_case.dart
          get_stations_by_genre_use_case.dart
    genres/
      data/
        models/genre_dto.dart
        mappers/genre_mapper.dart
        datasources/genre_remote_data_source.dart
        repositories/genre_repository_impl.dart
      domain/
        entities/genre.dart
        repositories/genre_repository.dart
        usecases/list_genres_use_case.dart
    favorites/
      data/
        models/favorite_station_dto.dart
        mappers/favorite_station_mapper.dart
        datasources/favorites_remote_data_source.dart
        repositories/favorites_repository_impl.dart
      domain/
        entities/favorite_station.dart
        repositories/favorites_repository.dart
        usecases/
          watch_favorites_use_case.dart
          is_favorite_use_case.dart
          add_favorite_use_case.dart
          remove_favorite_use_case.dart
          toggle_favorite_use_case.dart
    player/
      data/
        datasources/audio_player_data_source.dart
        repositories/player_repository_impl.dart
      domain/
        pick_best_stream.dart
        entities/playback_state.dart
        repositories/player_repository.dart
        usecases/
          watch_playback_use_case.dart
          play_station_use_case.dart
          pause_use_case.dart
          resume_use_case.dart
          stop_use_case.dart

client-app/test/
  core/
    pagination/page_mapper_test.dart
    errors/failure_mapper_test.dart
  features/
    stations/
      data/mappers/station_mapper_test.dart
      data/repositories/station_repository_impl_test.dart
      domain/usecases/list_stations_use_case_test.dart
      domain/usecases/get_popular_stations_use_case_test.dart
      domain/usecases/search_stations_use_case_test.dart
      domain/usecases/get_stations_by_genre_use_case_test.dart
    genres/
      data/mappers/genre_mapper_test.dart
      data/repositories/genre_repository_impl_test.dart
      domain/usecases/list_genres_use_case_test.dart
    favorites/
      data/mappers/favorite_station_mapper_test.dart
      data/repositories/favorites_repository_impl_test.dart
      domain/usecases/watch_favorites_use_case_test.dart
      domain/usecases/is_favorite_use_case_test.dart
      domain/usecases/add_favorite_use_case_test.dart
      domain/usecases/remove_favorite_use_case_test.dart
      domain/usecases/toggle_favorite_use_case_test.dart
    player/
      domain/pick_best_stream_test.dart
      data/repositories/player_repository_impl_test.dart
      domain/usecases/watch_playback_use_case_test.dart
      domain/usecases/play_station_use_case_test.dart
      domain/usecases/pause_use_case_test.dart
      domain/usecases/resume_use_case_test.dart
      domain/usecases/stop_use_case_test.dart
```

### Modified

```
client-app/lib/core/errors/failure_mapper.dart   (extend with FirebaseException handling)
```

---

## Task 1: Sanity check the toolchain

**Files:**
- Read-only

- [ ] **Step 1: Verify Flutter can resolve dependencies.**

Run: `flutter pub get`
Expected: completes without errors. If it doesn't, do not proceed — fix the environment first.

- [ ] **Step 2: Verify build_runner runs.**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: prints "Succeeded" with 0 outputs. (No freezed files exist yet — this just confirms the codegen pipeline starts.)

- [ ] **Step 3: Verify the existing smoke test passes.**

Run: `flutter test test/smoke_test.dart`
Expected: `+1: All tests passed!`

- [ ] **Step 4: Verify the analyzer is clean on the existing source.**

Run: `flutter analyze`
Expected: `No issues found!`

If any of these fail, stop and report. They are preconditions for everything below.

---

## Task 2: Shared pagination infrastructure

**Files:**
- Create: `lib/core/pagination/page_meta.dart`
- Create: `lib/core/pagination/page.dart`
- Create: `lib/core/pagination/page_meta_dto.dart`
- Create: `lib/core/pagination/page_dto.dart`
- Create: `lib/core/pagination/page_mapper.dart`
- Test: `test/core/pagination/page_mapper_test.dart`

- [ ] **Step 1: Write the failing mapper test.**

Create `test/core/pagination/page_mapper_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_dto.dart';
import 'package:radio/core/pagination/page_mapper.dart';
import 'package:radio/core/pagination/page_meta_dto.dart';

void main() {
  group('PageMetaDtoX.toEntity', () {
    test('preserves all fields including optional ones', () {
      const dto = PageMetaDto(page: 2, limit: 20, total: 100, totalPages: 5);
      final entity = dto.toEntity();
      expect(entity.page, 2);
      expect(entity.limit, 20);
      expect(entity.total, 100);
      expect(entity.totalPages, 5);
    });

    test('keeps optionals null when absent', () {
      const dto = PageMetaDto(page: 1, limit: 20);
      final entity = dto.toEntity();
      expect(entity.total, isNull);
      expect(entity.totalPages, isNull);
    });
  });

  group('PageDtoX.toEntity', () {
    test('maps each item via the supplied itemMapper', () {
      const dto = PageDto<int>(
        data: [1, 2, 3],
        meta: PageMetaDto(page: 1, limit: 20),
      );
      final Page<String> entity = dto.toEntity((i) => i.toString());
      expect(entity.data, ['1', '2', '3']);
      expect(entity.meta.page, 1);
      expect(entity.keywords, isNull);
    });

    test('passes through keywords when present', () {
      const dto = PageDto<int>(
        data: [1],
        meta: PageMetaDto(page: 1, limit: 20),
        keywords: ['rock', 'jazz'],
      );
      final entity = dto.toEntity((i) => i.toString());
      expect(entity.keywords, ['rock', 'jazz']);
    });
  });

  group('PageDto JSON', () {
    test('round-trips with a generic decoder', () {
      final json = {
        'data': [1, 2, 3],
        'meta': {'page': 1, 'limit': 20, 'total': 3, 'totalPages': 1},
        'keywords': ['k'],
      };
      final dto = PageDto<int>.fromJson(json, (v) => v! as int);
      expect(dto.data, [1, 2, 3]);
      expect(dto.meta.total, 3);
      expect(dto.keywords, ['k']);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails.**

Run: `flutter test test/core/pagination/page_mapper_test.dart`
Expected: compile error — `Page`, `PageDto`, `PageMetaDto`, etc. don't exist.

- [ ] **Step 3: Create the entity for `PageMeta`.**

Create `lib/core/pagination/page_meta.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_meta.freezed.dart';

@freezed
abstract class PageMeta with _$PageMeta {
  const factory PageMeta({
    required int page,
    required int limit,
    int? total,
    int? totalPages,
  }) = _PageMeta;
}
```

- [ ] **Step 4: Create the entity for `Page<T>`.**

Create `lib/core/pagination/page.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'page_meta.dart';

part 'page.freezed.dart';

@freezed
abstract class Page<T> with _$Page<T> {
  const factory Page({
    required List<T> data,
    required PageMeta meta,
    List<String>? keywords,
  }) = _Page<T>;
}
```

- [ ] **Step 5: Create the DTO for `PageMetaDto`.**

Create `lib/core/pagination/page_meta_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_meta_dto.freezed.dart';
part 'page_meta_dto.g.dart';

@freezed
abstract class PageMetaDto with _$PageMetaDto {
  const factory PageMetaDto({
    required int page,
    required int limit,
    int? total,
    int? totalPages,
  }) = _PageMetaDto;

  factory PageMetaDto.fromJson(Map<String, dynamic> json) =>
      _$PageMetaDtoFromJson(json);
}
```

- [ ] **Step 6: Create the generic DTO for `PageDto<T>`.**

Create `lib/core/pagination/page_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'page_meta_dto.dart';

part 'page_dto.freezed.dart';
part 'page_dto.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PageDto<T> with _$PageDto<T> {
  const factory PageDto({
    required List<T> data,
    required PageMetaDto meta,
    List<String>? keywords,
  }) = _PageDto<T>;

  factory PageDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PageDtoFromJson(json, fromJsonT);
}
```

- [ ] **Step 7: Create the mapper.**

Create `lib/core/pagination/page_mapper.dart`:

```dart
import 'page.dart';
import 'page_dto.dart';
import 'page_meta.dart';
import 'page_meta_dto.dart';

extension PageMetaDtoX on PageMetaDto {
  PageMeta toEntity() => PageMeta(
        page: page,
        limit: limit,
        total: total,
        totalPages: totalPages,
      );
}

extension PageDtoX<T> on PageDto<T> {
  Page<E> toEntity<E>(E Function(T) itemMapper) => Page<E>(
        data: data.map(itemMapper).toList(),
        meta: meta.toEntity(),
        keywords: keywords,
      );
}
```

- [ ] **Step 8: Run codegen.**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: succeeds; produces `page.freezed.dart`, `page_meta.freezed.dart`, `page_dto.freezed.dart`, `page_dto.g.dart`, `page_meta_dto.freezed.dart`, `page_meta_dto.g.dart`.

- [ ] **Step 9: Run tests.**

Run: `flutter test test/core/pagination/`
Expected: all pass.

- [ ] **Step 10: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 11: Commit.**

```bash
git add lib/core/pagination/ test/core/pagination/
git commit -m "feat(core): add shared Page<T> + PageMeta with mapper"
```

---

## Task 3: Extend the failure mapper for Firestore

**Files:**
- Modify: `lib/core/errors/failure_mapper.dart`
- Test: `test/core/errors/failure_mapper_test.dart`

- [ ] **Step 1: Write the failing test.**

Create `test/core/errors/failure_mapper_test.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radio/core/errors/failure_mapper.dart';
import 'package:radio/core/errors/failures.dart';

void main() {
  group('mapException — FirebaseFunctionsException', () {
    test('unauthenticated maps to UnauthenticatedFailure', () {
      final f = mapException(
        FirebaseFunctionsException(message: 'no auth', code: 'unauthenticated'),
      );
      expect(f, isA<UnauthenticatedFailure>());
    });

    test('invalid-argument maps to InvalidArgumentFailure', () {
      final f = mapException(
        FirebaseFunctionsException(message: 'bad', code: 'invalid-argument'),
      );
      expect(f, isA<InvalidArgumentFailure>());
      expect((f as InvalidArgumentFailure).message, 'bad');
    });

    test('unavailable maps to NetworkFailure', () {
      final f = mapException(
        FirebaseFunctionsException(message: '', code: 'unavailable'),
      );
      expect(f, isA<NetworkFailure>());
    });
  });

  group('mapException — FirebaseAuthException', () {
    test('any code maps to UnauthenticatedFailure', () {
      final f = mapException(
        FirebaseAuthException(code: 'user-not-found', message: 'gone'),
      );
      expect(f, isA<UnauthenticatedFailure>());
    });
  });

  group('mapException — FirebaseException (Firestore)', () {
    test('permission-denied maps to UnauthenticatedFailure', () {
      final f = mapException(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      );
      expect(f, isA<UnauthenticatedFailure>());
    });

    test('unavailable maps to NetworkFailure', () {
      final f = mapException(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
      );
      expect(f, isA<NetworkFailure>());
    });

    test('arbitrary code maps to UnknownFailure with message', () {
      final f = mapException(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'aborted',
          message: 'tx clash',
        ),
      );
      expect(f, isA<UnknownFailure>());
      expect((f as UnknownFailure).message, contains('tx clash'));
    });
  });

  group('mapException — fallthrough', () {
    test('arbitrary error maps to UnknownFailure', () {
      final f = mapException(StateError('boom'));
      expect(f, isA<UnknownFailure>());
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails.**

Run: `flutter test test/core/errors/failure_mapper_test.dart`
Expected: the three "FirebaseException (Firestore)" tests fail. The Functions / Auth / fallthrough cases already pass against the current mapper.

- [ ] **Step 3: Extend the mapper.**

Edit `lib/core/errors/failure_mapper.dart`:

```dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'failures.dart';

AppFailure mapException(Object error) {
  if (error is FirebaseFunctionsException) {
    switch (error.code) {
      case 'unauthenticated':
        return const UnauthenticatedFailure();
      case 'invalid-argument':
        return InvalidArgumentFailure(
          error.message ?? 'invalid argument',
          code: error.code,
        );
      case 'unavailable':
      case 'deadline-exceeded':
        return const NetworkFailure();
      default:
        return UnknownFailure(error.message ?? error.code);
    }
  }
  if (error is FirebaseAuthException) {
    return const UnauthenticatedFailure();
  }
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return const UnauthenticatedFailure();
      case 'unavailable':
      case 'deadline-exceeded':
        return const NetworkFailure();
      default:
        return UnknownFailure(error.message ?? error.code);
    }
  }
  return UnknownFailure(error.toString());
}
```

> Note: the order matters — `FirebaseFunctionsException` and `FirebaseAuthException` extend `FirebaseException`, so they must be matched first.

- [ ] **Step 4: Run tests.**

Run: `flutter test test/core/errors/failure_mapper_test.dart`
Expected: all pass.

- [ ] **Step 5: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit.**

```bash
git add lib/core/errors/failure_mapper.dart test/core/errors/failure_mapper_test.dart
git commit -m "feat(core): map Firestore FirebaseException to AppFailure"
```

---

## Task 4: Stations — entities, DTOs, mapper

**Files:**
- Create: 9 entity files in `lib/features/stations/domain/entities/`
- Create: 9 DTO files in `lib/features/stations/data/models/`
- Create: `lib/features/stations/data/mappers/station_mapper.dart`
- Test: `test/features/stations/data/mappers/station_mapper_test.dart`

This is the largest task in the plan because the Station object graph is interconnected — eight nested types share the mapper file. Build all of them in one task so the round-trip tests can exercise the full graph.

- [ ] **Step 1: Write the failing mapper test.**

Create `test/features/stations/data/mappers/station_mapper_test.dart`:

```dart
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
        aliases: StationAliasesDto(cleanName: 'BBC Radio One', alsoKnownAs: 'R1'),
        location: StationLocationDto(
          cityId: 1,
          cityName: 'London',
          countryName: 'United Kingdom',
          countryCode: 'GB',
          locationText: 'London, UK',
          coordinates: CoordinatesDto(latitude: 51.5, longitude: -0.12),
        ),
        genre: StationGenreDto(text: 'Pop', tags: ['pop', 'top40']),
        popularity: StationPopularityDto(
          global: 999,
          byCountry: {'GB': 999},
        ),
        streams: [
          StreamDto(url: 'https://a', bitrate: 128, isHttps: true),
          StreamDto(url: 'http://b', bitrate: 64),
        ],
        languages: [
          StationLanguageDto(code: 'en', name: 'English'),
        ],
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
        'genre': {'text': 'Pop', 'tags': ['pop']},
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
```

- [ ] **Step 2: Run the test to verify it fails.**

Run: `flutter test test/features/stations/data/mappers/station_mapper_test.dart`
Expected: compile error — types don't exist.

- [ ] **Step 3: Create the nested entities.**

Create `lib/features/stations/domain/entities/coordinates.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinates.freezed.dart';

@freezed
abstract class Coordinates with _$Coordinates {
  const factory Coordinates({
    required double latitude,
    required double longitude,
  }) = _Coordinates;
}
```

Create `lib/features/stations/domain/entities/station_location.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates.dart';

part 'station_location.freezed.dart';

@freezed
abstract class StationLocation with _$StationLocation {
  const factory StationLocation({
    int? cityId,
    String? cityName,
    String? countryName,
    String? countryCode,
    String? locationText,
    Coordinates? coordinates,
  }) = _StationLocation;
}
```

Create `lib/features/stations/domain/entities/station_genre.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_genre.freezed.dart';

@freezed
abstract class StationGenre with _$StationGenre {
  const factory StationGenre({
    String? text,
    List<String>? tags,
  }) = _StationGenre;
}
```

Create `lib/features/stations/domain/entities/station_dial.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_dial.freezed.dart';

@freezed
abstract class StationDial with _$StationDial {
  const factory StationDial({
    String? band,
    String? dial,
    String? dialStripped,
  }) = _StationDial;
}
```

Create `lib/features/stations/domain/entities/station_aliases.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_aliases.freezed.dart';

@freezed
abstract class StationAliases with _$StationAliases {
  const factory StationAliases({
    String? cleanName,
    String? alsoKnownAs,
  }) = _StationAliases;
}
```

Create `lib/features/stations/domain/entities/station_language.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_language.freezed.dart';

@freezed
abstract class StationLanguage with _$StationLanguage {
  const factory StationLanguage({
    required String code,
    String? name,
  }) = _StationLanguage;
}
```

Create `lib/features/stations/domain/entities/station_popularity.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_popularity.freezed.dart';

@freezed
abstract class StationPopularity with _$StationPopularity {
  const factory StationPopularity({
    int? global,
    Map<String, int>? byCountry,
  }) = _StationPopularity;
}
```

Create `lib/features/stations/domain/entities/radio_stream.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_stream.freezed.dart';

@freezed
abstract class RadioStream with _$RadioStream {
  const factory RadioStream({
    required String url,
    int? id,
    int? bitrate,
    String? contentType,
    String? codec,
    String? protocol,
    bool? isHttps,
    bool? works,
  }) = _RadioStream;
}
```

- [ ] **Step 4: Create the Station entity.**

Create `lib/features/stations/domain/entities/station.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'radio_stream.dart';
import 'station_aliases.dart';
import 'station_dial.dart';
import 'station_genre.dart';
import 'station_language.dart';
import 'station_location.dart';
import 'station_popularity.dart';

part 'station.freezed.dart';

@freezed
abstract class Station with _$Station {
  const factory Station({
    required int id,
    required String name,
    required List<RadioStream> streams,
    String? slug,
    bool? isActive,
    String? logo,
    StationDial? dial,
    StationAliases? aliases,
    StationLocation? location,
    StationGenre? genre,
    StationPopularity? popularity,
    List<StationLanguage>? languages,
  }) = _Station;
}
```

- [ ] **Step 5: Create the nested DTOs.**

Create `lib/features/stations/data/models/coordinates_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinates_dto.freezed.dart';
part 'coordinates_dto.g.dart';

@freezed
abstract class CoordinatesDto with _$CoordinatesDto {
  const factory CoordinatesDto({
    required double latitude,
    required double longitude,
  }) = _CoordinatesDto;

  factory CoordinatesDto.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesDtoFromJson(json);
}
```

Create `lib/features/stations/data/models/station_location_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates_dto.dart';

part 'station_location_dto.freezed.dart';
part 'station_location_dto.g.dart';

@freezed
abstract class StationLocationDto with _$StationLocationDto {
  const factory StationLocationDto({
    int? cityId,
    String? cityName,
    String? countryName,
    String? countryCode,
    String? locationText,
    CoordinatesDto? coordinates,
  }) = _StationLocationDto;

  factory StationLocationDto.fromJson(Map<String, dynamic> json) =>
      _$StationLocationDtoFromJson(json);
}
```

Create `lib/features/stations/data/models/station_genre_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_genre_dto.freezed.dart';
part 'station_genre_dto.g.dart';

@freezed
abstract class StationGenreDto with _$StationGenreDto {
  const factory StationGenreDto({
    String? text,
    List<String>? tags,
  }) = _StationGenreDto;

  factory StationGenreDto.fromJson(Map<String, dynamic> json) =>
      _$StationGenreDtoFromJson(json);
}
```

Create `lib/features/stations/data/models/station_dial_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_dial_dto.freezed.dart';
part 'station_dial_dto.g.dart';

@freezed
abstract class StationDialDto with _$StationDialDto {
  const factory StationDialDto({
    String? band,
    String? dial,
    String? dialStripped,
  }) = _StationDialDto;

  factory StationDialDto.fromJson(Map<String, dynamic> json) =>
      _$StationDialDtoFromJson(json);
}
```

Create `lib/features/stations/data/models/station_aliases_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_aliases_dto.freezed.dart';
part 'station_aliases_dto.g.dart';

@freezed
abstract class StationAliasesDto with _$StationAliasesDto {
  const factory StationAliasesDto({
    String? cleanName,
    String? alsoKnownAs,
  }) = _StationAliasesDto;

  factory StationAliasesDto.fromJson(Map<String, dynamic> json) =>
      _$StationAliasesDtoFromJson(json);
}
```

Create `lib/features/stations/data/models/station_language_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_language_dto.freezed.dart';
part 'station_language_dto.g.dart';

@freezed
abstract class StationLanguageDto with _$StationLanguageDto {
  const factory StationLanguageDto({
    required String code,
    String? name,
  }) = _StationLanguageDto;

  factory StationLanguageDto.fromJson(Map<String, dynamic> json) =>
      _$StationLanguageDtoFromJson(json);
}
```

Create `lib/features/stations/data/models/station_popularity_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_popularity_dto.freezed.dart';
part 'station_popularity_dto.g.dart';

@freezed
abstract class StationPopularityDto with _$StationPopularityDto {
  const factory StationPopularityDto({
    int? global,
    Map<String, int>? byCountry,
  }) = _StationPopularityDto;

  factory StationPopularityDto.fromJson(Map<String, dynamic> json) =>
      _$StationPopularityDtoFromJson(json);
}
```

Create `lib/features/stations/data/models/stream_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_dto.freezed.dart';
part 'stream_dto.g.dart';

@freezed
abstract class StreamDto with _$StreamDto {
  const factory StreamDto({
    required String url,
    int? id,
    int? bitrate,
    String? contentType,
    String? codec,
    String? protocol,
    bool? isHttps,
    bool? works,
  }) = _StreamDto;

  factory StreamDto.fromJson(Map<String, dynamic> json) =>
      _$StreamDtoFromJson(json);
}
```

- [ ] **Step 6: Create the StationDto.**

Create `lib/features/stations/data/models/station_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'station_aliases_dto.dart';
import 'station_dial_dto.dart';
import 'station_genre_dto.dart';
import 'station_language_dto.dart';
import 'station_location_dto.dart';
import 'station_popularity_dto.dart';
import 'stream_dto.dart';

part 'station_dto.freezed.dart';
part 'station_dto.g.dart';

@freezed
abstract class StationDto with _$StationDto {
  const factory StationDto({
    required int id,
    required String name,
    required List<StreamDto> streams,
    String? slug,
    bool? isActive,
    String? logo,
    StationDialDto? dial,
    StationAliasesDto? aliases,
    StationLocationDto? location,
    StationGenreDto? genre,
    StationPopularityDto? popularity,
    List<StationLanguageDto>? languages,
  }) = _StationDto;

  factory StationDto.fromJson(Map<String, dynamic> json) =>
      _$StationDtoFromJson(json);
}
```

- [ ] **Step 7: Create the mapper file.**

Create `lib/features/stations/data/mappers/station_mapper.dart`:

```dart
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
```

- [ ] **Step 8: Run codegen.**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: succeeds; produces `.freezed.dart` + `.g.dart` for every DTO and `.freezed.dart` for every entity.

- [ ] **Step 9: Run tests.**

Run: `flutter test test/features/stations/data/mappers/`
Expected: all pass.

- [ ] **Step 10: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 11: Commit.**

```bash
git add lib/features/stations/data/models/ lib/features/stations/data/mappers/ lib/features/stations/domain/entities/ test/features/stations/data/mappers/
git commit -m "feat(stations): add Station entity graph and mapper"
```

---

## Task 5: Stations — remote data source

**Files:**
- Create: `lib/features/stations/data/datasources/station_remote_data_source.dart`

The data source has no unit test of its own — it is a thin pass-through over `CloudFunctionsClient`, and the repository tests in Task 6 mock it. Logic worth testing lives in the repository layer.

- [ ] **Step 1: Create the data source.**

Create `lib/features/stations/data/datasources/station_remote_data_source.dart`:

```dart
import 'package:cloud_functions/cloud_functions.dart';

import '../../../../core/network/cloud_functions_client.dart';
import '../../../../core/pagination/page_dto.dart';
import '../models/station_dto.dart';

class StationRemoteDataSource {
  StationRemoteDataSource(this._client);

  final CloudFunctionsClient _client;

  Future<PageDto<StationDto>> listStations({
    int page = 1,
    int limit = 20,
  }) =>
      _callPage('listStations', {'page': page, 'limit': limit});

  Future<PageDto<StationDto>> popularStations({
    String? country,
    int page = 1,
    int limit = 20,
  }) =>
      _callPage('popularStations', {
        if (country != null) 'country': country,
        'page': page,
        'limit': limit,
      });

  Future<PageDto<StationDto>> searchStations({
    required String query,
    int page = 1,
    int limit = 20,
  }) =>
      _callPage('searchStations', {
        'q': query,
        'page': page,
        'limit': limit,
      });

  Future<PageDto<StationDto>> stationsByGenre({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  }) =>
      _callPage('stationsByGenre', {
        if (genreId != null) 'genreId': genreId,
        if (genreSlug != null) 'genreSlug': genreSlug,
        'page': page,
        'limit': limit,
      });

  Future<PageDto<StationDto>> _callPage(
    String name,
    Map<String, Object?> args,
  ) async {
    final HttpsCallableResult<Object?> result =
        await _client.call(name).call<Object?>(args);
    final json = _asJsonMap(result.data);
    return PageDto<StationDto>.fromJson(
      json,
      (v) => StationDto.fromJson(_asJsonMap(v)),
    );
  }

  Map<String, dynamic> _asJsonMap(Object? raw) {
    if (raw is Map) return raw.cast<String, dynamic>();
    throw StateError(
      'Expected a Map from cloud function, got ${raw.runtimeType}',
    );
  }
}
```

- [ ] **Step 2: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit.**

```bash
git add lib/features/stations/data/datasources/
git commit -m "feat(stations): add remote data source over cloud functions"
```

---

## Task 6: Stations — repository interface, implementation, tests

**Files:**
- Create: `lib/features/stations/domain/repositories/station_repository.dart`
- Create: `lib/features/stations/data/repositories/station_repository_impl.dart`
- Test: `test/features/stations/data/repositories/station_repository_impl_test.dart`

- [ ] **Step 1: Create the repository interface.**

Create `lib/features/stations/domain/repositories/station_repository.dart`:

```dart
import '../../../../core/pagination/page.dart';
import '../entities/station.dart';

abstract interface class StationRepository {
  Future<Page<Station>> listStations({int page = 1, int limit = 20});

  Future<Page<Station>> popularStations({
    String? country,
    int page = 1,
    int limit = 20,
  });

  Future<Page<Station>> searchStations({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<Page<Station>> stationsByGenre({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  });
}
```

- [ ] **Step 2: Write the failing repository test.**

Create `test/features/stations/data/repositories/station_repository_impl_test.dart`:

```dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page_dto.dart';
import 'package:radio/core/pagination/page_meta_dto.dart';
import 'package:radio/features/stations/data/datasources/station_remote_data_source.dart';
import 'package:radio/features/stations/data/models/station_dto.dart';
import 'package:radio/features/stations/data/repositories/station_repository_impl.dart';

class _MockDataSource extends Mock implements StationRemoteDataSource {}

void main() {
  late _MockDataSource ds;
  late StationRepositoryImpl repo;

  const sampleDto = StationDto(id: 1, name: 'X', streams: []);
  const samplePage = PageDto<StationDto>(
    data: [sampleDto],
    meta: PageMetaDto(page: 1, limit: 20),
  );

  setUp(() {
    ds = _MockDataSource();
    repo = StationRepositoryImpl(ds);
  });

  group('listStations', () {
    test('returns mapped Page<Station> on success', () async {
      when(() => ds.listStations(page: 1, limit: 20))
          .thenAnswer((_) async => samplePage);

      final page = await repo.listStations();

      expect(page.data.first.id, 1);
      expect(page.data.first.name, 'X');
      expect(page.meta.page, 1);
    });

    test('maps unauthenticated to UnauthenticatedFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20)).thenThrow(
        FirebaseFunctionsException(message: 'no auth', code: 'unauthenticated'),
      );
      await expectLater(
        repo.listStations(),
        throwsA(isA<UnauthenticatedFailure>()),
      );
    });

    test('maps invalid-argument to InvalidArgumentFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20)).thenThrow(
        FirebaseFunctionsException(message: 'bad', code: 'invalid-argument'),
      );
      await expectLater(
        repo.listStations(),
        throwsA(isA<InvalidArgumentFailure>()),
      );
    });

    test('maps unavailable to NetworkFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20)).thenThrow(
        FirebaseFunctionsException(message: '', code: 'unavailable'),
      );
      await expectLater(
        repo.listStations(),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('maps arbitrary exceptions to UnknownFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20))
          .thenThrow(StateError('boom'));
      await expectLater(
        repo.listStations(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('popularStations', () {
    test('forwards country and pagination, returns mapped page', () async {
      when(() => ds.popularStations(country: 'GB', page: 2, limit: 10))
          .thenAnswer((_) async => samplePage);
      final page = await repo.popularStations(country: 'GB', page: 2, limit: 10);
      expect(page.data.first.id, 1);
      verify(() => ds.popularStations(country: 'GB', page: 2, limit: 10))
          .called(1);
    });
  });

  group('searchStations', () {
    test('forwards query and returns mapped page', () async {
      when(() => ds.searchStations(query: 'jazz', page: 1, limit: 20))
          .thenAnswer((_) async => samplePage);
      final page = await repo.searchStations(query: 'jazz');
      expect(page.data, isNotEmpty);
      verify(() => ds.searchStations(query: 'jazz', page: 1, limit: 20))
          .called(1);
    });
  });

  group('stationsByGenre', () {
    test('forwards genreId and returns mapped page', () async {
      when(() =>
              ds.stationsByGenre(genreId: 5, page: 1, limit: 20))
          .thenAnswer((_) async => samplePage);
      final page = await repo.stationsByGenre(genreId: 5);
      expect(page.data, isNotEmpty);
    });

    test('forwards genreSlug and returns mapped page', () async {
      when(() => ds.stationsByGenre(
            genreSlug: 'rock',
            page: 1,
            limit: 20,
          )).thenAnswer((_) async => samplePage);
      final page = await repo.stationsByGenre(genreSlug: 'rock');
      expect(page.data, isNotEmpty);
    });
  });
}
```

- [ ] **Step 3: Run the test to verify it fails.**

Run: `flutter test test/features/stations/data/repositories/station_repository_impl_test.dart`
Expected: compile error — `StationRepositoryImpl` does not exist.

- [ ] **Step 4: Implement the repository.**

Create `lib/features/stations/data/repositories/station_repository_impl.dart`:

```dart
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/pagination/page.dart';
import '../../../../core/pagination/page_mapper.dart';
import '../../domain/entities/station.dart';
import '../../domain/repositories/station_repository.dart';
import '../datasources/station_remote_data_source.dart';
import '../mappers/station_mapper.dart';

class StationRepositoryImpl implements StationRepository {
  StationRepositoryImpl(this._dataSource);

  final StationRemoteDataSource _dataSource;

  @override
  Future<Page<Station>> listStations({int page = 1, int limit = 20}) =>
      _guarded(() async {
        final dto = await _dataSource.listStations(page: page, limit: limit);
        return dto.toEntity((s) => s.toEntity());
      });

  @override
  Future<Page<Station>> popularStations({
    String? country,
    int page = 1,
    int limit = 20,
  }) =>
      _guarded(() async {
        final dto = await _dataSource.popularStations(
          country: country,
          page: page,
          limit: limit,
        );
        return dto.toEntity((s) => s.toEntity());
      });

  @override
  Future<Page<Station>> searchStations({
    required String query,
    int page = 1,
    int limit = 20,
  }) =>
      _guarded(() async {
        final dto = await _dataSource.searchStations(
          query: query,
          page: page,
          limit: limit,
        );
        return dto.toEntity((s) => s.toEntity());
      });

  @override
  Future<Page<Station>> stationsByGenre({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  }) =>
      _guarded(() async {
        final dto = await _dataSource.stationsByGenre(
          genreId: genreId,
          genreSlug: genreSlug,
          page: page,
          limit: limit,
        );
        return dto.toEntity((s) => s.toEntity());
      });

  Future<T> _guarded<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      throw mapException(e);
    }
  }
}
```

- [ ] **Step 5: Run tests.**

Run: `flutter test test/features/stations/data/repositories/`
Expected: all pass.

- [ ] **Step 6: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 7: Commit.**

```bash
git add lib/features/stations/domain/repositories/ lib/features/stations/data/repositories/ test/features/stations/data/repositories/
git commit -m "feat(stations): add repository interface and impl"
```

---

## Task 7: Stations — use cases

**Files:**
- Create: 4 use case files in `lib/features/stations/domain/usecases/`
- Test: 4 test files in `test/features/stations/domain/usecases/`

All four are thin pass-throughs. The tests verify: arguments forwarded correctly, return value passed through, thrown failure propagated.

- [ ] **Step 1: Write the failing tests.**

Create `test/features/stations/domain/usecases/list_stations_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/repositories/station_repository.dart';
import 'package:radio/features/stations/domain/usecases/list_stations_use_case.dart';

class _MockRepo extends Mock implements StationRepository {}

void main() {
  late _MockRepo repo;
  late ListStationsUseCase useCase;
  const sample = Station(id: 1, name: 'X', streams: []);
  const page = Page<Station>(data: [sample], meta: PageMeta(page: 1, limit: 20));

  setUp(() {
    repo = _MockRepo();
    useCase = ListStationsUseCase(repo);
  });

  test('forwards page and limit and returns the repo result', () async {
    when(() => repo.listStations(page: 2, limit: 50))
        .thenAnswer((_) async => page);
    final result = await useCase(page: 2, limit: 50);
    expect(result.data.first.id, 1);
    verify(() => repo.listStations(page: 2, limit: 50)).called(1);
  });

  test('propagates failures from the repo', () async {
    when(() => repo.listStations(page: 1, limit: 20))
        .thenThrow(const NetworkFailure());
    await expectLater(useCase(), throwsA(isA<NetworkFailure>()));
  });
}
```

Create `test/features/stations/domain/usecases/get_popular_stations_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/repositories/station_repository.dart';
import 'package:radio/features/stations/domain/usecases/get_popular_stations_use_case.dart';

class _MockRepo extends Mock implements StationRepository {}

void main() {
  late _MockRepo repo;
  late GetPopularStationsUseCase useCase;
  const page = Page<Station>(data: [], meta: PageMeta(page: 1, limit: 20));

  setUp(() {
    repo = _MockRepo();
    useCase = GetPopularStationsUseCase(repo);
  });

  test('forwards country, page, limit', () async {
    when(() => repo.popularStations(country: 'GB', page: 1, limit: 20))
        .thenAnswer((_) async => page);
    await useCase(country: 'GB');
    verify(() => repo.popularStations(country: 'GB', page: 1, limit: 20))
        .called(1);
  });
}
```

Create `test/features/stations/domain/usecases/search_stations_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/repositories/station_repository.dart';
import 'package:radio/features/stations/domain/usecases/search_stations_use_case.dart';

class _MockRepo extends Mock implements StationRepository {}

void main() {
  late _MockRepo repo;
  late SearchStationsUseCase useCase;
  const page = Page<Station>(data: [], meta: PageMeta(page: 1, limit: 20));

  setUp(() {
    repo = _MockRepo();
    useCase = SearchStationsUseCase(repo);
  });

  test('forwards query and pagination', () async {
    when(() => repo.searchStations(query: 'jazz', page: 1, limit: 20))
        .thenAnswer((_) async => page);
    await useCase(query: 'jazz');
    verify(() => repo.searchStations(query: 'jazz', page: 1, limit: 20))
        .called(1);
  });
}
```

Create `test/features/stations/domain/usecases/get_stations_by_genre_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/repositories/station_repository.dart';
import 'package:radio/features/stations/domain/usecases/get_stations_by_genre_use_case.dart';

class _MockRepo extends Mock implements StationRepository {}

void main() {
  late _MockRepo repo;
  late GetStationsByGenreUseCase useCase;
  const page = Page<Station>(data: [], meta: PageMeta(page: 1, limit: 20));

  setUp(() {
    repo = _MockRepo();
    useCase = GetStationsByGenreUseCase(repo);
  });

  test('forwards genreId variant', () async {
    when(() => repo.stationsByGenre(genreId: 7, page: 1, limit: 20))
        .thenAnswer((_) async => page);
    await useCase(genreId: 7);
    verify(() => repo.stationsByGenre(genreId: 7, page: 1, limit: 20))
        .called(1);
  });

  test('forwards genreSlug variant', () async {
    when(() => repo.stationsByGenre(genreSlug: 'rock', page: 1, limit: 20))
        .thenAnswer((_) async => page);
    await useCase(genreSlug: 'rock');
    verify(() => repo.stationsByGenre(genreSlug: 'rock', page: 1, limit: 20))
        .called(1);
  });
}
```

- [ ] **Step 2: Run the tests to verify they fail.**

Run: `flutter test test/features/stations/domain/usecases/`
Expected: compile errors — use case classes don't exist.

- [ ] **Step 3: Implement the use cases.**

Create `lib/features/stations/domain/usecases/list_stations_use_case.dart`:

```dart
import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class ListStationsUseCase {
  ListStationsUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({int page = 1, int limit = 20}) =>
      _repository.listStations(page: page, limit: limit);
}
```

Create `lib/features/stations/domain/usecases/get_popular_stations_use_case.dart`:

```dart
import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class GetPopularStationsUseCase {
  GetPopularStationsUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({
    String? country,
    int page = 1,
    int limit = 20,
  }) =>
      _repository.popularStations(country: country, page: page, limit: limit);
}
```

Create `lib/features/stations/domain/usecases/search_stations_use_case.dart`:

```dart
import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class SearchStationsUseCase {
  SearchStationsUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({
    required String query,
    int page = 1,
    int limit = 20,
  }) =>
      _repository.searchStations(query: query, page: page, limit: limit);
}
```

Create `lib/features/stations/domain/usecases/get_stations_by_genre_use_case.dart`:

```dart
import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class GetStationsByGenreUseCase {
  GetStationsByGenreUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  }) =>
      _repository.stationsByGenre(
        genreId: genreId,
        genreSlug: genreSlug,
        page: page,
        limit: limit,
      );
}
```

- [ ] **Step 4: Run tests.**

Run: `flutter test test/features/stations/domain/usecases/`
Expected: all pass.

- [ ] **Step 5: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit.**

```bash
git add lib/features/stations/domain/usecases/ test/features/stations/domain/usecases/
git commit -m "feat(stations): add use cases"
```

---

## Task 8: Genres — entity, DTO, mapper

**Files:**
- Create: `lib/features/genres/domain/entities/genre.dart`
- Create: `lib/features/genres/data/models/genre_dto.dart`
- Create: `lib/features/genres/data/mappers/genre_mapper.dart`
- Test: `test/features/genres/data/mappers/genre_mapper_test.dart`

- [ ] **Step 1: Write the failing test.**

Create `test/features/genres/data/mappers/genre_mapper_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:radio/features/genres/data/mappers/genre_mapper.dart';
import 'package:radio/features/genres/data/models/genre_dto.dart';

void main() {
  test('maps id, slug, name, radioCount', () {
    const dto =
        GenreDto(id: 1, slug: 'rock', name: 'Rock', radioCount: 1234);
    final genre = dto.toEntity();
    expect(genre.id, 1);
    expect(genre.slug, 'rock');
    expect(genre.name, 'Rock');
    expect(genre.radioCount, 1234);
  });

  test('keeps optional fields null', () {
    const dto = GenreDto(id: 2);
    final genre = dto.toEntity();
    expect(genre.slug, isNull);
    expect(genre.name, isNull);
    expect(genre.radioCount, isNull);
  });

  test('GenreDto JSON round-trip', () {
    final json = {'id': 1, 'slug': 'rock', 'name': 'Rock', 'radioCount': 9};
    final dto = GenreDto.fromJson(json);
    expect(dto.id, 1);
    expect(dto.radioCount, 9);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails.**

Run: `flutter test test/features/genres/data/mappers/genre_mapper_test.dart`
Expected: compile error.

- [ ] **Step 3: Create the entity.**

Create `lib/features/genres/domain/entities/genre.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';

@freezed
abstract class Genre with _$Genre {
  const factory Genre({
    required int id,
    String? slug,
    String? name,
    int? radioCount,
  }) = _Genre;
}
```

- [ ] **Step 4: Create the DTO.**

Create `lib/features/genres/data/models/genre_dto.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre_dto.freezed.dart';
part 'genre_dto.g.dart';

@freezed
abstract class GenreDto with _$GenreDto {
  const factory GenreDto({
    required int id,
    String? slug,
    String? name,
    int? radioCount,
  }) = _GenreDto;

  factory GenreDto.fromJson(Map<String, dynamic> json) =>
      _$GenreDtoFromJson(json);
}
```

- [ ] **Step 5: Create the mapper.**

Create `lib/features/genres/data/mappers/genre_mapper.dart`:

```dart
import '../../domain/entities/genre.dart';
import '../models/genre_dto.dart';

extension GenreDtoX on GenreDto {
  Genre toEntity() => Genre(
        id: id,
        slug: slug,
        name: name,
        radioCount: radioCount,
      );
}
```

- [ ] **Step 6: Run codegen.**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: succeeds.

- [ ] **Step 7: Run tests.**

Run: `flutter test test/features/genres/data/mappers/`
Expected: all pass.

- [ ] **Step 8: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 9: Commit.**

```bash
git add lib/features/genres/data/models/ lib/features/genres/data/mappers/ lib/features/genres/domain/entities/ test/features/genres/data/mappers/
git commit -m "feat(genres): add Genre entity and mapper"
```

---

## Task 9: Genres — data source, repository, use case

**Files:**
- Create: `lib/features/genres/data/datasources/genre_remote_data_source.dart`
- Create: `lib/features/genres/domain/repositories/genre_repository.dart`
- Create: `lib/features/genres/data/repositories/genre_repository_impl.dart`
- Create: `lib/features/genres/domain/usecases/list_genres_use_case.dart`
- Test: `test/features/genres/data/repositories/genre_repository_impl_test.dart`
- Test: `test/features/genres/domain/usecases/list_genres_use_case_test.dart`

- [ ] **Step 1: Create the data source.**

Create `lib/features/genres/data/datasources/genre_remote_data_source.dart`:

```dart
import 'package:cloud_functions/cloud_functions.dart';

import '../../../../core/network/cloud_functions_client.dart';
import '../../../../core/pagination/page_dto.dart';
import '../models/genre_dto.dart';

class GenreRemoteDataSource {
  GenreRemoteDataSource(this._client);

  final CloudFunctionsClient _client;

  Future<PageDto<GenreDto>> listGenres({
    int page = 1,
    int limit = 100,
  }) async {
    final HttpsCallableResult<Object?> result =
        await _client.call('listGenres').call<Object?>({
      'page': page,
      'limit': limit,
    });
    final json = (result.data! as Map).cast<String, dynamic>();
    return PageDto<GenreDto>.fromJson(
      json,
      (v) => GenreDto.fromJson((v! as Map).cast<String, dynamic>()),
    );
  }
}
```

- [ ] **Step 2: Create the repository interface.**

Create `lib/features/genres/domain/repositories/genre_repository.dart`:

```dart
import '../../../../core/pagination/page.dart';
import '../entities/genre.dart';

abstract interface class GenreRepository {
  Future<Page<Genre>> listGenres({int page = 1, int limit = 100});
}
```

- [ ] **Step 3: Write the failing repository test.**

Create `test/features/genres/data/repositories/genre_repository_impl_test.dart`:

```dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page_dto.dart';
import 'package:radio/core/pagination/page_meta_dto.dart';
import 'package:radio/features/genres/data/datasources/genre_remote_data_source.dart';
import 'package:radio/features/genres/data/models/genre_dto.dart';
import 'package:radio/features/genres/data/repositories/genre_repository_impl.dart';

class _MockDataSource extends Mock implements GenreRemoteDataSource {}

void main() {
  late _MockDataSource ds;
  late GenreRepositoryImpl repo;

  const samplePage = PageDto<GenreDto>(
    data: [GenreDto(id: 1, slug: 'rock', name: 'Rock')],
    meta: PageMetaDto(page: 1, limit: 100),
  );

  setUp(() {
    ds = _MockDataSource();
    repo = GenreRepositoryImpl(ds);
  });

  test('returns mapped Page<Genre> on success', () async {
    when(() => ds.listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => samplePage);
    final page = await repo.listGenres();
    expect(page.data.first.id, 1);
    expect(page.data.first.name, 'Rock');
  });

  test('maps unauthenticated to UnauthenticatedFailure', () async {
    when(() => ds.listGenres(page: 1, limit: 100)).thenThrow(
      FirebaseFunctionsException(message: '', code: 'unauthenticated'),
    );
    await expectLater(repo.listGenres(), throwsA(isA<UnauthenticatedFailure>()));
  });

  test('maps unavailable to NetworkFailure', () async {
    when(() => ds.listGenres(page: 1, limit: 100)).thenThrow(
      FirebaseFunctionsException(message: '', code: 'unavailable'),
    );
    await expectLater(repo.listGenres(), throwsA(isA<NetworkFailure>()));
  });

  test('maps arbitrary exceptions to UnknownFailure', () async {
    when(() => ds.listGenres(page: 1, limit: 100))
        .thenThrow(StateError('boom'));
    await expectLater(repo.listGenres(), throwsA(isA<UnknownFailure>()));
  });
}
```

- [ ] **Step 4: Run the test to verify it fails.**

Run: `flutter test test/features/genres/data/repositories/genre_repository_impl_test.dart`
Expected: compile error.

- [ ] **Step 5: Implement the repository.**

Create `lib/features/genres/data/repositories/genre_repository_impl.dart`:

```dart
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/pagination/page.dart';
import '../../../../core/pagination/page_mapper.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/genre_repository.dart';
import '../datasources/genre_remote_data_source.dart';
import '../mappers/genre_mapper.dart';

class GenreRepositoryImpl implements GenreRepository {
  GenreRepositoryImpl(this._dataSource);

  final GenreRemoteDataSource _dataSource;

  @override
  Future<Page<Genre>> listGenres({int page = 1, int limit = 100}) async {
    try {
      final dto = await _dataSource.listGenres(page: page, limit: limit);
      return dto.toEntity((g) => g.toEntity());
    } catch (e) {
      throw mapException(e);
    }
  }
}
```

- [ ] **Step 6: Write the failing use-case test.**

Create `test/features/genres/domain/usecases/list_genres_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/genres/domain/entities/genre.dart';
import 'package:radio/features/genres/domain/repositories/genre_repository.dart';
import 'package:radio/features/genres/domain/usecases/list_genres_use_case.dart';

class _MockRepo extends Mock implements GenreRepository {}

void main() {
  late _MockRepo repo;
  late ListGenresUseCase useCase;

  const page = Page<Genre>(
    data: [Genre(id: 1)],
    meta: PageMeta(page: 1, limit: 100),
  );

  setUp(() {
    repo = _MockRepo();
    useCase = ListGenresUseCase(repo);
  });

  test('forwards page and limit, returns repo result', () async {
    when(() => repo.listGenres(page: 2, limit: 50))
        .thenAnswer((_) async => page);
    final result = await useCase(page: 2, limit: 50);
    expect(result.data.first.id, 1);
  });

  test('propagates failures', () async {
    when(() => repo.listGenres(page: 1, limit: 100))
        .thenThrow(const NetworkFailure());
    await expectLater(useCase(), throwsA(isA<NetworkFailure>()));
  });
}
```

- [ ] **Step 7: Implement the use case.**

Create `lib/features/genres/domain/usecases/list_genres_use_case.dart`:

```dart
import '../../../../core/pagination/page.dart';
import '../entities/genre.dart';
import '../repositories/genre_repository.dart';

class ListGenresUseCase {
  ListGenresUseCase(this._repository);

  final GenreRepository _repository;

  Future<Page<Genre>> call({int page = 1, int limit = 100}) =>
      _repository.listGenres(page: page, limit: limit);
}
```

- [ ] **Step 8: Run tests.**

Run: `flutter test test/features/genres/`
Expected: all pass.

- [ ] **Step 9: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 10: Commit.**

```bash
git add lib/features/genres/ test/features/genres/
git commit -m "feat(genres): add data source, repository, list use case"
```

---

## Task 10: Favorites — entity, DTO, mapper

**Files:**
- Create: `lib/features/favorites/domain/entities/favorite_station.dart`
- Create: `lib/features/favorites/data/models/favorite_station_dto.dart`
- Create: `lib/features/favorites/data/mappers/favorite_station_mapper.dart`
- Test: `test/features/favorites/data/mappers/favorite_station_mapper_test.dart`

The DTO uses hand-rolled `fromMap`/`toMap` because Firestore's `Timestamp` is not standard JSON. Station fields are flattened at the doc root; `addedAt` lives alongside as a `Timestamp`.

- [ ] **Step 1: Write the failing test.**

Create `test/features/favorites/data/mappers/favorite_station_mapper_test.dart`:

```dart
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
```

- [ ] **Step 2: Run the test to verify it fails.**

Run: `flutter test test/features/favorites/data/mappers/favorite_station_mapper_test.dart`
Expected: compile error.

- [ ] **Step 3: Create the entity.**

Create `lib/features/favorites/domain/entities/favorite_station.dart`:

```dart
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
```

- [ ] **Step 4: Create the DTO.**

Create `lib/features/favorites/data/models/favorite_station_dto.dart`:

```dart
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
```

- [ ] **Step 5: Create the mapper.**

Create `lib/features/favorites/data/mappers/favorite_station_mapper.dart`:

```dart
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
```

> The reverse mapper (`Station → StationDto`) lives only here because it is only ever needed when writing favorites to Firestore. The favorites mapper imports DTO classes directly from `stations/data/models/`, which is allowed since both files are inside the data layer.

- [ ] **Step 6: Run codegen.**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: succeeds.

- [ ] **Step 7: Run tests.**

Run: `flutter test test/features/favorites/data/mappers/`
Expected: all pass.

- [ ] **Step 8: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 9: Commit.**

```bash
git add lib/features/favorites/data/models/ lib/features/favorites/data/mappers/ lib/features/favorites/domain/entities/ test/features/favorites/data/mappers/
git commit -m "feat(favorites): add FavoriteStation entity and bidirectional mapper"
```

---

## Task 11: Favorites — remote data source

**Files:**
- Create: `lib/features/favorites/data/datasources/favorites_remote_data_source.dart`

The data source is a thin pass-through over `FirebaseFirestore`. The repository tests in Task 12 mock it. No unit test for the data source itself in this iteration (Firestore-emulator integration tests are explicitly out of scope per the spec).

- [ ] **Step 1: Create the data source.**

Create `lib/features/favorites/data/datasources/favorites_remote_data_source.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favorite_station_dto.dart';

class FavoritesRemoteDataSource {
  FavoritesRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _favoritesCol(String uid) =>
      _firestore.collection('users').doc(uid).collection('favorites');

  Stream<List<FavoriteStationDto>> watchAll(String uid) {
    return _favoritesCol(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => FavoriteStationDto.fromMap(d.data()))
            .toList());
  }

  Stream<bool> watchIsFavorite(String uid, int stationId) {
    return _favoritesCol(uid)
        .doc(stationId.toString())
        .snapshots()
        .map((d) => d.exists);
  }

  Future<void> add(String uid, FavoriteStationDto dto) async {
    await _favoritesCol(uid)
        .doc(dto.station.id.toString())
        .set(dto.toMap());
  }

  Future<void> remove(String uid, int stationId) async {
    await _favoritesCol(uid).doc(stationId.toString()).delete();
  }
}
```

- [ ] **Step 2: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit.**

```bash
git add lib/features/favorites/data/datasources/
git commit -m "feat(favorites): add Firestore remote data source"
```

---

## Task 12: Favorites — repository interface, implementation, tests

**Files:**
- Create: `lib/features/favorites/domain/repositories/favorites_repository.dart`
- Create: `lib/features/favorites/data/repositories/favorites_repository_impl.dart`
- Test: `test/features/favorites/data/repositories/favorites_repository_impl_test.dart`

- [ ] **Step 1: Create the repository interface.**

Create `lib/features/favorites/domain/repositories/favorites_repository.dart`:

```dart
import '../../../stations/domain/entities/station.dart';
import '../entities/favorite_station.dart';

abstract interface class FavoritesRepository {
  Stream<List<FavoriteStation>> watchAll();

  Stream<bool> isFavorite(int stationId);

  Future<void> add(Station station);

  Future<void> remove(int stationId);
}
```

- [ ] **Step 2: Write the failing repository test.**

Create `test/features/favorites/data/repositories/favorites_repository_impl_test.dart`:

```dart
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
    test('watchAll throws UnauthenticatedFailure when no user', () {
      when(() => auth.currentUser).thenReturn(null);
      expect(() => repo.watchAll(), throwsA(isA<UnauthenticatedFailure>()));
    });

    test('isFavorite throws when no user', () {
      when(() => auth.currentUser).thenReturn(null);
      expect(
        () => repo.isFavorite(1),
        throwsA(isA<UnauthenticatedFailure>()),
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
      await expectLater(
        repo.remove(1),
        throwsA(isA<UnauthenticatedFailure>()),
      );
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
      when(() => ds.watchIsFavorite('u1', 7))
          .thenAnswer((_) => Stream.value(true));
      final v = await repo.isFavorite(7).first;
      expect(v, isTrue);
      verify(() => ds.watchIsFavorite('u1', 7)).called(1);
    });
  });

  group('add', () {
    test('writes a FavoriteStationDto with the station id', () async {
      when(() => ds.add('u1', any())).thenAnswer((_) async {});
      await repo.add(const Station(id: 42, name: 'X', streams: []));
      final captured = verify(() => ds.add('u1', captureAny()))
          .captured
          .single as FavoriteStationDto;
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
```

- [ ] **Step 3: Run the test to verify it fails.**

Run: `flutter test test/features/favorites/data/repositories/`
Expected: compile error.

- [ ] **Step 4: Implement the repository.**

Create `lib/features/favorites/data/repositories/favorites_repository_impl.dart`:

```dart
import '../../../../core/auth/auth_service.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/favorite_station.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';
import '../mappers/favorite_station_mapper.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({
    required FavoritesRemoteDataSource dataSource,
    required AuthService authService,
  })  : _dataSource = dataSource,
        _authService = authService;

  final FavoritesRemoteDataSource _dataSource;
  final AuthService _authService;

  String _uidOrThrow() {
    final uid = _authService.currentUser?.uid;
    if (uid == null) throw const UnauthenticatedFailure();
    return uid;
  }

  @override
  Stream<List<FavoriteStation>> watchAll() {
    final uid = _uidOrThrow();
    return _dataSource
        .watchAll(uid)
        .map((dtos) => dtos.map((d) => d.toEntity()).toList())
        .handleError((Object e) => throw mapException(e));
  }

  @override
  Stream<bool> isFavorite(int stationId) {
    final uid = _uidOrThrow();
    return _dataSource
        .watchIsFavorite(uid, stationId)
        .handleError((Object e) => throw mapException(e));
  }

  @override
  Future<void> add(Station station) async {
    final uid = _uidOrThrow();
    final dto = station.toFavoriteDto(addedAt: DateTime.now());
    try {
      await _dataSource.add(uid, dto);
    } catch (e) {
      throw mapException(e);
    }
  }

  @override
  Future<void> remove(int stationId) async {
    final uid = _uidOrThrow();
    try {
      await _dataSource.remove(uid, stationId);
    } catch (e) {
      throw mapException(e);
    }
  }
}
```

- [ ] **Step 5: Run tests.**

Run: `flutter test test/features/favorites/data/repositories/`
Expected: all pass.

- [ ] **Step 6: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 7: Commit.**

```bash
git add lib/features/favorites/domain/repositories/ lib/features/favorites/data/repositories/ test/features/favorites/data/repositories/
git commit -m "feat(favorites): add repository interface and impl"
```

---

## Task 13: Favorites — use cases

**Files:**
- Create: 5 use case files in `lib/features/favorites/domain/usecases/`
- Test: 5 test files in `test/features/favorites/domain/usecases/`

Four are pass-throughs; `ToggleFavoriteUseCase` is a real composite.

- [ ] **Step 1: Write the failing tests.**

Create `test/features/favorites/domain/usecases/watch_favorites_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/favorites/domain/entities/favorite_station.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/watch_favorites_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

void main() {
  late _MockRepo repo;
  late WatchFavoritesUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = WatchFavoritesUseCase(repo);
  });

  test('forwards the repository stream', () async {
    final fav = FavoriteStation(
      station: const Station(id: 1, name: 'X', streams: []),
      addedAt: DateTime.utc(2026, 5, 3),
    );
    when(() => repo.watchAll()).thenAnswer((_) => Stream.value([fav]));
    final result = await useCase().first;
    expect(result.first.station.id, 1);
  });
}
```

Create `test/features/favorites/domain/usecases/is_favorite_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/is_favorite_use_case.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

void main() {
  late _MockRepo repo;
  late IsFavoriteUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = IsFavoriteUseCase(repo);
  });

  test('forwards stationId', () async {
    when(() => repo.isFavorite(7)).thenAnswer((_) => Stream.value(true));
    final v = await useCase(7).first;
    expect(v, isTrue);
    verify(() => repo.isFavorite(7)).called(1);
  });
}
```

Create `test/features/favorites/domain/usecases/add_favorite_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

class _FakeStation extends Fake implements Station {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeStation());
  });

  late _MockRepo repo;
  late AddFavoriteUseCase useCase;
  const station = Station(id: 1, name: 'X', streams: []);

  setUp(() {
    repo = _MockRepo();
    useCase = AddFavoriteUseCase(repo);
  });

  test('forwards the station to the repository', () async {
    when(() => repo.add(any())).thenAnswer((_) async {});
    await useCase(station);
    verify(() => repo.add(station)).called(1);
  });

  test('propagates failures', () async {
    when(() => repo.add(any())).thenThrow(const UnauthenticatedFailure());
    await expectLater(
      useCase(station),
      throwsA(isA<UnauthenticatedFailure>()),
    );
  });
}
```

Create `test/features/favorites/domain/usecases/remove_favorite_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/remove_favorite_use_case.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

void main() {
  late _MockRepo repo;
  late RemoveFavoriteUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = RemoveFavoriteUseCase(repo);
  });

  test('forwards stationId', () async {
    when(() => repo.remove(9)).thenAnswer((_) async {});
    await useCase(9);
    verify(() => repo.remove(9)).called(1);
  });
}
```

Create `test/features/favorites/domain/usecases/toggle_favorite_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

class _FakeStation extends Fake implements Station {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeStation());
  });

  late _MockRepo repo;
  late ToggleFavoriteUseCase useCase;
  const station = Station(id: 7, name: 'X', streams: []);

  setUp(() {
    repo = _MockRepo();
    useCase = ToggleFavoriteUseCase(repo);
  });

  test('removes when isFavorite emits true', () async {
    when(() => repo.isFavorite(7)).thenAnswer((_) => Stream.value(true));
    when(() => repo.remove(7)).thenAnswer((_) async {});
    await useCase(station);
    verify(() => repo.remove(7)).called(1);
    verifyNever(() => repo.add(any()));
  });

  test('adds when isFavorite emits false', () async {
    when(() => repo.isFavorite(7)).thenAnswer((_) => Stream.value(false));
    when(() => repo.add(any())).thenAnswer((_) async {});
    await useCase(station);
    verify(() => repo.add(station)).called(1);
    verifyNever(() => repo.remove(any()));
  });

  test('propagates failure from isFavorite without calling add/remove',
      () async {
    when(() => repo.isFavorite(7))
        .thenAnswer((_) => Stream.error(const UnauthenticatedFailure()));
    await expectLater(
      useCase(station),
      throwsA(isA<UnauthenticatedFailure>()),
    );
    verifyNever(() => repo.add(any()));
    verifyNever(() => repo.remove(any()));
  });
}
```

- [ ] **Step 2: Run the tests to verify they fail.**

Run: `flutter test test/features/favorites/domain/usecases/`
Expected: compile errors.

- [ ] **Step 3: Implement the use cases.**

Create `lib/features/favorites/domain/usecases/watch_favorites_use_case.dart`:

```dart
import '../entities/favorite_station.dart';
import '../repositories/favorites_repository.dart';

class WatchFavoritesUseCase {
  WatchFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Stream<List<FavoriteStation>> call() => _repository.watchAll();
}
```

Create `lib/features/favorites/domain/usecases/is_favorite_use_case.dart`:

```dart
import '../repositories/favorites_repository.dart';

class IsFavoriteUseCase {
  IsFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Stream<bool> call(int stationId) => _repository.isFavorite(stationId);
}
```

Create `lib/features/favorites/domain/usecases/add_favorite_use_case.dart`:

```dart
import '../../../stations/domain/entities/station.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  AddFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(Station station) => _repository.add(station);
}
```

Create `lib/features/favorites/domain/usecases/remove_favorite_use_case.dart`:

```dart
import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  RemoveFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(int stationId) => _repository.remove(stationId);
}
```

Create `lib/features/favorites/domain/usecases/toggle_favorite_use_case.dart`:

```dart
import '../../../stations/domain/entities/station.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(Station station) async {
    final isFav = await _repository.isFavorite(station.id).first;
    if (isFav) {
      await _repository.remove(station.id);
    } else {
      await _repository.add(station);
    }
  }
}
```

- [ ] **Step 4: Run tests.**

Run: `flutter test test/features/favorites/domain/usecases/`
Expected: all pass.

- [ ] **Step 5: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit.**

```bash
git add lib/features/favorites/domain/usecases/ test/features/favorites/domain/usecases/
git commit -m "feat(favorites): add use cases including ToggleFavorite composite"
```

---

## Task 14: Player — pickBestStream helper

**Files:**
- Create: `lib/features/player/domain/pick_best_stream.dart`
- Test: `test/features/player/domain/pick_best_stream_test.dart`

Pure function. Pure unit test.

- [ ] **Step 1: Write the failing test.**

Create `test/features/player/domain/pick_best_stream_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:radio/features/player/domain/pick_best_stream.dart';
import 'package:radio/features/stations/domain/entities/radio_stream.dart';

void main() {
  test('returns null for empty list', () {
    expect(pickBestStream(const []), isNull);
  });

  test('returns the only stream', () {
    const a = RadioStream(url: 'https://a');
    expect(pickBestStream(const [a]), a);
  });

  test('prefers higher bitrate', () {
    const low = RadioStream(url: 'https://low', bitrate: 64, isHttps: true);
    const high = RadioStream(url: 'https://high', bitrate: 128, isHttps: true);
    expect(pickBestStream(const [low, high]), high);
  });

  test('prefers HTTPS even when bitrate is lower', () {
    const httpHi = RadioStream(url: 'http://hi', bitrate: 192, isHttps: false);
    const httpsLo = RadioStream(url: 'https://lo', bitrate: 64, isHttps: true);
    expect(pickBestStream(const [httpHi, httpsLo]), httpsLo);
  });

  test('skips works == false candidates', () {
    const broken =
        RadioStream(url: 'https://b', bitrate: 320, isHttps: true, works: false);
    const ok = RadioStream(url: 'https://ok', bitrate: 64, isHttps: true);
    expect(pickBestStream(const [broken, ok]), ok);
  });

  test('falls back to first when all are works == false', () {
    const a = RadioStream(url: 'https://a', works: false);
    const b = RadioStream(url: 'https://b', works: false);
    expect(pickBestStream(const [a, b]), a);
  });

  test('treats missing bitrate as 0 when ranking', () {
    const noBitrate = RadioStream(url: 'https://x', isHttps: true);
    const withBitrate = RadioStream(url: 'https://y', bitrate: 1, isHttps: true);
    expect(pickBestStream(const [noBitrate, withBitrate]), withBitrate);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails.**

Run: `flutter test test/features/player/domain/pick_best_stream_test.dart`
Expected: compile error — `pickBestStream` doesn't exist.

- [ ] **Step 3: Implement the helper.**

Create `lib/features/player/domain/pick_best_stream.dart`:

```dart
import '../../stations/domain/entities/radio_stream.dart';

/// Picks the best stream from a station's variants.
///
/// Ranking: HTTPS preferred over non-HTTPS, then higher bitrate. Streams with
/// `works == false` are filtered out unless every stream is broken — in that
/// case the first one is returned as a last resort.
RadioStream? pickBestStream(List<RadioStream> streams) {
  if (streams.isEmpty) return null;
  final playable = streams.where((s) => s.works != false).toList();
  if (playable.isEmpty) return streams.first;

  playable.sort((a, b) {
    final httpsCmp = (b.isHttps == true ? 1 : 0) - (a.isHttps == true ? 1 : 0);
    if (httpsCmp != 0) return httpsCmp;
    return (b.bitrate ?? 0) - (a.bitrate ?? 0);
  });
  return playable.first;
}
```

- [ ] **Step 4: Run tests.**

Run: `flutter test test/features/player/domain/pick_best_stream_test.dart`
Expected: all pass.

- [ ] **Step 5: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit.**

```bash
git add lib/features/player/domain/pick_best_stream.dart test/features/player/domain/pick_best_stream_test.dart
git commit -m "feat(player): add pickBestStream helper"
```

---

## Task 15: Player — PlaybackState entity + audio data source

**Files:**
- Create: `lib/features/player/domain/entities/playback_state.dart`
- Create: `lib/features/player/data/datasources/audio_player_data_source.dart`

Defines the entity the repository emits and the abstraction over `just_audio.AudioPlayer`. The data source is not unit-tested directly — coupling to `just_audio` makes that prohibitive in this iteration. The repository tests in Task 16 mock it.

- [ ] **Step 1: Create the PlaybackState entity.**

Create `lib/features/player/domain/entities/playback_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/radio_stream.dart';
import '../../../stations/domain/entities/station.dart';

part 'playback_state.freezed.dart';

enum PlaybackStatus { idle, loading, playing, paused, error }

@freezed
abstract class PlaybackState with _$PlaybackState {
  const factory PlaybackState({
    @Default(PlaybackStatus.idle) PlaybackStatus status,
    Station? currentStation,
    RadioStream? currentStream,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration bufferedPosition,
    @Default(false) bool isBuffering,
    AppFailure? error,
  }) = _PlaybackState;
}
```

- [ ] **Step 2: Create the audio data source.**

Create `lib/features/player/data/datasources/audio_player_data_source.dart`:

```dart
import 'dart:async';

import 'package:just_audio/just_audio.dart';

enum RawProcessingState { idle, loading, buffering, ready, completed }

class RawPlayerSnapshot {
  const RawPlayerSnapshot({
    required this.processingState,
    required this.playing,
    required this.position,
    required this.bufferedPosition,
    this.errorMessage,
  });

  final RawProcessingState processingState;
  final bool playing;
  final Duration position;
  final Duration bufferedPosition;
  final String? errorMessage;
}

/// Thin wrapper over [AudioPlayer]. Catches just_audio errors and emits them
/// as [RawPlayerSnapshot] entries with `errorMessage` set, rather than throwing.
class AudioPlayerDataSource {
  AudioPlayerDataSource({AudioPlayer? player})
      : _player = player ?? AudioPlayer() {
    _attach();
  }

  final AudioPlayer _player;
  final StreamController<RawPlayerSnapshot> _events =
      StreamController<RawPlayerSnapshot>.broadcast();

  Duration _position = Duration.zero;
  Duration _buffered = Duration.zero;
  PlayerState _state = PlayerState(false, ProcessingState.idle);
  String? _lastError;

  Stream<RawPlayerSnapshot> get events => _events.stream;

  Future<void> setUrlAndPlay(String url) async {
    _lastError = null;
    try {
      await _player.setUrl(url);
      await _player.play();
    } on PlayerException catch (e) {
      _lastError = e.message ?? 'PlayerException(${e.code})';
      _emit();
    } on PlayerInterruptedException catch (e) {
      _lastError = e.message ?? 'PlayerInterruptedException';
      _emit();
    } catch (e) {
      _lastError = e.toString();
      _emit();
    }
  }

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.play();

  Future<void> stop() => _player.stop();

  Future<void> dispose() async {
    await _events.close();
    await _player.dispose();
  }

  void _attach() {
    _player.playerStateStream.listen((s) {
      _state = s;
      _emit();
    });
    _player.positionStream.listen((p) {
      _position = p;
      _emit();
    });
    _player.bufferedPositionStream.listen((p) {
      _buffered = p;
      _emit();
    });
  }

  void _emit() {
    _events.add(RawPlayerSnapshot(
      processingState: _mapProcessingState(_state.processingState),
      playing: _state.playing,
      position: _position,
      bufferedPosition: _buffered,
      errorMessage: _lastError,
    ));
  }

  RawProcessingState _mapProcessingState(ProcessingState s) {
    switch (s) {
      case ProcessingState.idle:
        return RawProcessingState.idle;
      case ProcessingState.loading:
        return RawProcessingState.loading;
      case ProcessingState.buffering:
        return RawProcessingState.buffering;
      case ProcessingState.ready:
        return RawProcessingState.ready;
      case ProcessingState.completed:
        return RawProcessingState.completed;
    }
  }
}
```

- [ ] **Step 3: Run codegen.**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: succeeds; produces `playback_state.freezed.dart`.

- [ ] **Step 4: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 5: Commit.**

```bash
git add lib/features/player/domain/entities/ lib/features/player/data/datasources/
git commit -m "feat(player): add PlaybackState entity and audio data source"
```

---

## Task 16: Player — repository interface, implementation, tests

**Files:**
- Create: `lib/features/player/domain/repositories/player_repository.dart`
- Create: `lib/features/player/data/repositories/player_repository_impl.dart`
- Test: `test/features/player/data/repositories/player_repository_impl_test.dart`

- [ ] **Step 1: Create the repository interface.**

Create `lib/features/player/domain/repositories/player_repository.dart`:

```dart
import '../../../stations/domain/entities/station.dart';
import '../entities/playback_state.dart';

abstract interface class PlayerRepository {
  Stream<PlaybackState> get state;

  Future<void> play(Station station);

  Future<void> pause();

  Future<void> resume();

  Future<void> stop();
}
```

- [ ] **Step 2: Write the failing repository test.**

Create `test/features/player/data/repositories/player_repository_impl_test.dart`:

```dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/player/data/datasources/audio_player_data_source.dart';
import 'package:radio/features/player/data/repositories/player_repository_impl.dart';
import 'package:radio/features/player/domain/entities/playback_state.dart';
import 'package:radio/features/stations/domain/entities/radio_stream.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockDataSource extends Mock implements AudioPlayerDataSource {}

void main() {
  late _MockDataSource ds;
  late StreamController<RawPlayerSnapshot> events;
  late PlayerRepositoryImpl repo;

  const goodStream = RadioStream(
    url: 'https://good',
    bitrate: 128,
    isHttps: true,
  );
  const station = Station(id: 1, name: 'X', streams: [goodStream]);

  setUp(() {
    ds = _MockDataSource();
    events = StreamController<RawPlayerSnapshot>.broadcast();
    when(() => ds.events).thenAnswer((_) => events.stream);
    when(() => ds.setUrlAndPlay(any())).thenAnswer((_) async {});
    when(() => ds.pause()).thenAnswer((_) async {});
    when(() => ds.resume()).thenAnswer((_) async {});
    when(() => ds.stop()).thenAnswer((_) async {});
    repo = PlayerRepositoryImpl(ds);
  });

  tearDown(() async {
    await events.close();
  });

  group('play(Station)', () {
    test('emits loading then forwards URL to data source', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      await Future<void>.delayed(Duration.zero);

      expect(emitted, isNotEmpty);
      expect(emitted.first.status, PlaybackStatus.loading);
      expect(emitted.first.currentStation, station);
      expect(emitted.first.currentStream, goodStream);
      verify(() => ds.setUrlAndPlay('https://good')).called(1);

      await sub.cancel();
    });

    test('emits error and skips data source when streams are empty', () async {
      const empty = Station(id: 2, name: 'Y', streams: []);
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(empty);
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.error);
      expect(emitted.last.error, isA<UnknownFailure>());
      verifyNever(() => ds.setUrlAndPlay(any()));

      await sub.cancel();
    });
  });

  group('state stream', () {
    test('maps ready+playing snapshot to PlaybackStatus.playing', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(const RawPlayerSnapshot(
        processingState: RawProcessingState.ready,
        playing: true,
        position: Duration(seconds: 3),
        bufferedPosition: Duration(seconds: 5),
      ));
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.playing);
      expect(emitted.last.position, const Duration(seconds: 3));
      expect(emitted.last.bufferedPosition, const Duration(seconds: 5));
      expect(emitted.last.isBuffering, isFalse);

      await sub.cancel();
    });

    test('maps ready+!playing to PlaybackStatus.paused', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(const RawPlayerSnapshot(
        processingState: RawProcessingState.ready,
        playing: false,
        position: Duration.zero,
        bufferedPosition: Duration.zero,
      ));
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.paused);
      await sub.cancel();
    });

    test('maps buffering snapshot to isBuffering=true', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(const RawPlayerSnapshot(
        processingState: RawProcessingState.buffering,
        playing: true,
        position: Duration.zero,
        bufferedPosition: Duration.zero,
      ));
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.isBuffering, isTrue);
      await sub.cancel();
    });

    test('maps errorMessage to error state via UnknownFailure', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(const RawPlayerSnapshot(
        processingState: RawProcessingState.idle,
        playing: false,
        position: Duration.zero,
        bufferedPosition: Duration.zero,
        errorMessage: 'codec failure',
      ));
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.error);
      expect(emitted.last.error, isA<UnknownFailure>());
      expect((emitted.last.error! as UnknownFailure).message,
          contains('codec failure'));
      await sub.cancel();
    });
  });

  group('pause / resume / stop', () {
    test('forward to data source', () async {
      await repo.pause();
      await repo.resume();
      await repo.stop();
      verify(() => ds.pause()).called(1);
      verify(() => ds.resume()).called(1);
      verify(() => ds.stop()).called(1);
    });
  });
}
```

- [ ] **Step 3: Run the test to verify it fails.**

Run: `flutter test test/features/player/data/repositories/player_repository_impl_test.dart`
Expected: compile error — `PlayerRepositoryImpl` doesn't exist.

- [ ] **Step 4: Implement the repository.**

Create `lib/features/player/data/repositories/player_repository_impl.dart`:

```dart
import 'dart:async';

import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/radio_stream.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/pick_best_stream.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/audio_player_data_source.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl(this._dataSource) {
    _subscription = _dataSource.events.listen(_onSnapshot);
  }

  final AudioPlayerDataSource _dataSource;
  final StreamController<PlaybackState> _state =
      StreamController<PlaybackState>.broadcast();
  late final StreamSubscription<RawPlayerSnapshot> _subscription;

  PlaybackState _current = const PlaybackState();
  Station? _currentStation;
  RadioStream? _currentStream;

  @override
  Stream<PlaybackState> get state => _state.stream;

  @override
  Future<void> play(Station station) async {
    final picked = pickBestStream(station.streams);
    if (picked == null) {
      _currentStation = station;
      _currentStream = null;
      _emit(_current.copyWith(
        status: PlaybackStatus.error,
        currentStation: station,
        currentStream: null,
        error: const UnknownFailure('no playable streams'),
      ));
      return;
    }
    _currentStation = station;
    _currentStream = picked;
    _emit(_current.copyWith(
      status: PlaybackStatus.loading,
      currentStation: station,
      currentStream: picked,
      error: null,
    ));
    await _dataSource.setUrlAndPlay(picked.url);
  }

  @override
  Future<void> pause() => _dataSource.pause();

  @override
  Future<void> resume() => _dataSource.resume();

  @override
  Future<void> stop() => _dataSource.stop();

  Future<void> dispose() async {
    await _subscription.cancel();
    await _state.close();
  }

  void _onSnapshot(RawPlayerSnapshot snap) {
    if (snap.errorMessage != null) {
      _emit(_current.copyWith(
        status: PlaybackStatus.error,
        currentStation: _currentStation,
        currentStream: _currentStream,
        position: snap.position,
        bufferedPosition: snap.bufferedPosition,
        isBuffering: false,
        error: UnknownFailure(snap.errorMessage!),
      ));
      return;
    }
    final isBuffering =
        snap.processingState == RawProcessingState.buffering;
    final status = _statusFor(snap);
    _emit(_current.copyWith(
      status: status,
      currentStation: _currentStation,
      currentStream: _currentStream,
      position: snap.position,
      bufferedPosition: snap.bufferedPosition,
      isBuffering: isBuffering,
      error: null,
    ));
  }

  PlaybackStatus _statusFor(RawPlayerSnapshot snap) {
    switch (snap.processingState) {
      case RawProcessingState.idle:
        return PlaybackStatus.idle;
      case RawProcessingState.loading:
      case RawProcessingState.buffering:
        return PlaybackStatus.loading;
      case RawProcessingState.ready:
        return snap.playing ? PlaybackStatus.playing : PlaybackStatus.paused;
      case RawProcessingState.completed:
        return PlaybackStatus.idle;
    }
  }

  void _emit(PlaybackState s) {
    _current = s;
    _state.add(s);
  }
}
```

- [ ] **Step 5: Run tests.**

Run: `flutter test test/features/player/data/repositories/player_repository_impl_test.dart`
Expected: all pass.

- [ ] **Step 6: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 7: Commit.**

```bash
git add lib/features/player/domain/repositories/ lib/features/player/data/repositories/ test/features/player/data/repositories/
git commit -m "feat(player): add repository interface and impl"
```

---

## Task 17: Player — use cases

**Files:**
- Create: 5 use case files in `lib/features/player/domain/usecases/`
- Test: 5 test files in `test/features/player/domain/usecases/`

All thin pass-throughs.

- [ ] **Step 1: Write the failing tests.**

Create `test/features/player/domain/usecases/watch_playback_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/entities/playback_state.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/watch_playback_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late WatchPlaybackUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = WatchPlaybackUseCase(repo);
  });

  test('forwards the repo state stream', () async {
    when(() => repo.state).thenAnswer(
      (_) => Stream<PlaybackState>.value(const PlaybackState()),
    );
    final v = await useCase().first;
    expect(v.status, PlaybackStatus.idle);
  });
}
```

Create `test/features/player/domain/usecases/play_station_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/play_station_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements PlayerRepository {}

class _FakeStation extends Fake implements Station {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeStation());
  });

  late _MockRepo repo;
  late PlayStationUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = PlayStationUseCase(repo);
  });

  test('forwards the station to repo.play', () async {
    when(() => repo.play(any())).thenAnswer((_) async {});
    const s = Station(id: 1, name: 'X', streams: []);
    await useCase(s);
    verify(() => repo.play(s)).called(1);
  });
}
```

Create `test/features/player/domain/usecases/pause_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/pause_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late PauseUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = PauseUseCase(repo);
  });

  test('calls repo.pause', () async {
    when(() => repo.pause()).thenAnswer((_) async {});
    await useCase();
    verify(() => repo.pause()).called(1);
  });
}
```

Create `test/features/player/domain/usecases/resume_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/resume_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late ResumeUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = ResumeUseCase(repo);
  });

  test('calls repo.resume', () async {
    when(() => repo.resume()).thenAnswer((_) async {});
    await useCase();
    verify(() => repo.resume()).called(1);
  });
}
```

Create `test/features/player/domain/usecases/stop_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/stop_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late StopUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = StopUseCase(repo);
  });

  test('calls repo.stop', () async {
    when(() => repo.stop()).thenAnswer((_) async {});
    await useCase();
    verify(() => repo.stop()).called(1);
  });
}
```

- [ ] **Step 2: Run the tests to verify they fail.**

Run: `flutter test test/features/player/domain/usecases/`
Expected: compile errors.

- [ ] **Step 3: Implement the use cases.**

Create `lib/features/player/domain/usecases/watch_playback_use_case.dart`:

```dart
import '../entities/playback_state.dart';
import '../repositories/player_repository.dart';

class WatchPlaybackUseCase {
  WatchPlaybackUseCase(this._repository);

  final PlayerRepository _repository;

  Stream<PlaybackState> call() => _repository.state;
}
```

Create `lib/features/player/domain/usecases/play_station_use_case.dart`:

```dart
import '../../../stations/domain/entities/station.dart';
import '../repositories/player_repository.dart';

class PlayStationUseCase {
  PlayStationUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call(Station station) => _repository.play(station);
}
```

Create `lib/features/player/domain/usecases/pause_use_case.dart`:

```dart
import '../repositories/player_repository.dart';

class PauseUseCase {
  PauseUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call() => _repository.pause();
}
```

Create `lib/features/player/domain/usecases/resume_use_case.dart`:

```dart
import '../repositories/player_repository.dart';

class ResumeUseCase {
  ResumeUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call() => _repository.resume();
}
```

Create `lib/features/player/domain/usecases/stop_use_case.dart`:

```dart
import '../repositories/player_repository.dart';

class StopUseCase {
  StopUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call() => _repository.stop();
}
```

- [ ] **Step 4: Run tests.**

Run: `flutter test test/features/player/domain/usecases/`
Expected: all pass.

- [ ] **Step 5: Run analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit.**

```bash
git add lib/features/player/domain/usecases/ test/features/player/domain/usecases/
git commit -m "feat(player): add use cases"
```

---

## Task 18: Final integration check

**Files:**
- Read-only

- [ ] **Step 1: Run the full test suite.**

Run: `flutter test`
Expected: all tests pass (every group from every prior task).

- [ ] **Step 2: Run the analyzer.**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Verify codegen is up to date.**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: succeeds with no errors. (If any `.freezed.dart` or `.g.dart` file is regenerated with different content, that means a stale codegen output was committed — investigate.)

- [ ] **Step 4: Run the analyzer once more after codegen.**

Run: `flutter analyze`
Expected: `No issues found!`

If everything passes, the data and domain layers are complete for all four features. Next step (separate plan): wire ViewModels and Provider DI in `main.dart`.
