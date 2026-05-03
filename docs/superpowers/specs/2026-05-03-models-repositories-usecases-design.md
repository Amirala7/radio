# Models, Repositories & Use Cases — Design

**Date:** 2026-05-03
**Scope:** Data layer (DTOs, mappers), domain layer (entities, repositories, use cases), and unit tests for the four client features: `stations`, `genres`, `favorites`, `player`. ViewModels, views, and DI wiring are out of scope.

## Reference

- Architectural rules and feature contracts: [CLAUDE.md](../../../CLAUDE.md)
- Backend type source-of-truth: [backend-service/functions/src/lib/types.ts](../../../backend-service/functions/src/lib/types.ts)
- Backend normalization (defines exact JSON shapes the client receives): [backend-service/functions/src/lib/normalize.ts](../../../backend-service/functions/src/lib/normalize.ts)

## Decisions made during brainstorming

| # | Decision |
|---|---|
| 1 | All four features in scope (stations, genres, favorites, player). |
| 2 | Favorites store the **full Station snapshot** (incl. complete `streams[]`) plus `addedAt`, not the singular `streamUrl/bitrate` listed in the original CLAUDE.md draft. CLAUDE.md updated to match. |
| 3 | `PlaybackState` is **rich** — exposes `status`, `currentStation`, `currentStream`, `position`, `bufferedPosition`, `isBuffering`, `error`. |
| 4 | `Page<T>` and `PageMeta` are **shared** in `core/pagination/`, not per-feature. |
| 5 | `stationsByGenre` lives on `StationRepository` (returns `Station`). |
| 6 | `FavoritesRepository.watchAll()` returns `Stream<List<FavoriteStation>>` from Firestore snapshots. |
| 7 | Player stream selection is a pure helper `pickBestStream(List<Stream>) → Stream?` — ranks by `(isHttps desc, bitrate desc)`, skips `works == false`, falls back to first. |
| 8 | Mappers are extension methods, one file per object graph. |

---

## Component layout

### Shared — `lib/core/pagination/`

- `page.dart` — entity `Page<T> { List<T> data; PageMeta meta; List<String>? keywords; }`
- `page_meta.dart` — entity `PageMeta { int page; int limit; int? total; int? totalPages; }`
- `page_dto.dart` — DTO `PageDto<T>` with a generic `fromJson(Map, T Function(Object?) decoder)` factory and a matching `toJson` (toJson optional; we don't ship pages back to the server).
- `page_meta_dto.dart` — DTO `PageMetaDto`.
- `page_mapper.dart` — extension `PageDtoX<T, E>` exposing `Page<E> toEntity(E Function(T) itemMapper)`.

### `lib/features/stations/`

**DTOs** (`data/models/`, freezed + json_serializable):
`station_dto.dart`, `stream_dto.dart`, `station_genre_dto.dart`, `station_location_dto.dart`, `coordinates_dto.dart`, `station_dial_dto.dart`, `station_aliases_dto.dart`, `station_language_dto.dart`, `station_popularity_dto.dart`.

**Entities** (`domain/entities/`, freezed): matching set without the `Dto` suffix.

> Note: domain `Stream` collides with `dart:async.Stream`. The entity class is named `RadioStream` to avoid the clash; DTO stays `StreamDto` because it's only ever referenced inside the `data/models/` folder where there's no collision.

**Mapper** (`data/mappers/station_mapper.dart`): one file with extensions covering `StationDto`, `StreamDto`, and all nested types — they form one object graph.

**DataSource** (`data/datasources/station_remote_data_source.dart`): one class with four methods (`listStations`, `popularStations`, `searchStations`, `stationsByGenre`); each calls `CloudFunctionsClient.call('<name>').call(args)`, parses the returned `Map<String, dynamic>` into a `PageDto<StationDto>`, throws on failure.

**Repository interface** (`domain/repositories/station_repository.dart`):

```dart
abstract interface class StationRepository {
  Future<Page<Station>> listStations({int page = 1, int limit = 20});
  Future<Page<Station>> popularStations({String? country, int page = 1, int limit = 20});
  Future<Page<Station>> searchStations({required String query, int page = 1, int limit = 20});
  Future<Page<Station>> stationsByGenre({int? genreId, String? genreSlug, int page = 1, int limit = 20});
}
```

**Repository impl** (`data/repositories/station_repository_impl.dart`): wraps datasource, applies the page mapper, catches everything via `mapException`.

### `lib/features/genres/`

- DTO `GenreDto`, entity `Genre`, mapper `genre_mapper.dart`.
- DataSource `GenreRemoteDataSource.listGenres({page, limit})` → `PageDto<GenreDto>`.
- Repository `GenreRepository.listGenres({int page = 1, int limit = 100}) → Future<Page<Genre>>`.

### `lib/features/favorites/`

- DTO `FavoriteStationDto` — Station fields **flattened** at the root of the Firestore doc plus an `addedAt: Timestamp` field. Stored at `users/{uid}/favorites/{stationId}` with `stationId.toString()` as the doc id. Flattened (not `{station: {...}, addedAt: ...}`) so doc id maps cleanly to stationId and downstream queries can filter on station fields if needed. Because Firestore's `Timestamp` is not standard JSON, this DTO uses hand-rolled `fromMap(Map<String, dynamic>)` / `toMap()` rather than `json_serializable`'s default codegen — the rest of the field marshaling can still come from freezed.
- Entity `FavoriteStation { Station station; DateTime addedAt; }`.
- Mapper `favorite_station_mapper.dart` — handles `Timestamp ↔ DateTime`, embeds the `Station` mapper (re-uses `StationDtoX.toEntity()`), so most of the work delegates.
- DataSource `FavoritesRemoteDataSource` — depends on `FirebaseFirestore.instance` and a uid string. Methods:
  - `Stream<List<FavoriteStationDto>> watchAll(String uid)` — `users/{uid}/favorites` ordered by `addedAt desc`.
  - `Stream<bool> watchIsFavorite(String uid, int stationId)` — doc snapshot, maps to `exists`.
  - `Future<void> add(String uid, FavoriteStationDto dto)` — `set(...)` keyed by `dto.id.toString()`.
  - `Future<void> remove(String uid, int stationId)` — `delete(...)` keyed by `stationId.toString()`.
- Repository `FavoritesRepository`:
  - `Stream<List<FavoriteStation>> watchAll()`
  - `Stream<bool> isFavorite(int stationId)`
  - `Future<void> add(Station station)` — wraps Station in a FavoriteStation with `addedAt = DateTime.now()` and converts to DTO.
  - `Future<void> remove(int stationId)`
  - All methods read `AuthService.currentUser?.uid` once at the top; `null` → throws `UnauthenticatedFailure` before touching Firestore.

### `lib/features/player/`

- Helper `domain/pick_best_stream.dart` — pure function `RadioStream? pickBestStream(List<RadioStream> streams)`.
- Enum `PlaybackStatus { idle, loading, playing, paused, error }`.
- Entity `PlaybackState { PlaybackStatus status; Station? currentStation; RadioStream? currentStream; Duration position; Duration bufferedPosition; bool isBuffering; AppFailure? error; }` (freezed).
- DataSource `AudioPlayerDataSource` — wraps `just_audio.AudioPlayer`. Exposes:
  - `Future<void> setUrlAndPlay(String url)`
  - `Future<void> pause()`, `resume()`, `stop()`
  - `Stream<RawPlayerEvent> events` — a small internal event type combining `PlayerState`, `Duration position`, `Duration bufferedPosition` from just_audio's separate streams.
  - All `just_audio` exceptions are caught here and emitted into the event stream as `RawPlayerEvent.error(...)`; not thrown out of `setUrlAndPlay`.
- Repository `PlayerRepository`:
  - `Stream<PlaybackState> state` — broadcast stream; combines `AudioPlayerDataSource.events` with the currently-known `Station` + chosen `RadioStream`.
  - `Future<void> play(Station station)` — picks best stream (empty → emits `error` state, returns), calls `setUrlAndPlay`. Records the station/stream as "current".
  - `pause()`, `resume()`, `stop()`.

---

## Data flow

### Read (stations example)
```
ViewModel → ListStationsUseCase(page, limit)
         → StationRepository.listStations(page, limit)
            → StationRemoteDataSource.listStations(page, limit)
               → CloudFunctionsClient.call('listStations')(...)
               ← Map<String, dynamic>
            ← PageDto<StationDto>
         ← Page<Station>
```

### Favorites toggle
```
ViewModel → ToggleFavoriteUseCase(Station)
         → FavoritesRepository.isFavorite(id).first
         → if true:  FavoritesRepository.remove(id)
           if false: FavoritesRepository.add(station)
```

### Player play
```
ViewModel → PlayStationUseCase(Station)
         → PlayerRepository.play(Station)
            → pickBestStream(streams) → RadioStream
            → AudioPlayerDataSource.setUrlAndPlay(stream.url)
         emits PlaybackState updates via state stream
```

---

## Use case inventory

One use case = one action; invoke via `call()`.

**Stations** (`features/stations/domain/usecases/`):
- `ListStationsUseCase`, `GetPopularStationsUseCase`, `SearchStationsUseCase`, `GetStationsByGenreUseCase`

**Genres** (`features/genres/domain/usecases/`):
- `ListGenresUseCase`

**Favorites** (`features/favorites/domain/usecases/`):
- `WatchFavoritesUseCase`, `IsFavoriteUseCase`, `AddFavoriteUseCase`, `RemoveFavoriteUseCase`, `ToggleFavoriteUseCase`

**Player** (`features/player/domain/usecases/`):
- `WatchPlaybackUseCase`, `PlayStationUseCase`, `PauseUseCase`, `ResumeUseCase`, `StopUseCase`

`ToggleFavoriteUseCase` is the only composite — it calls `IsFavorite` then `Add` or `Remove` on the same repository. All others are thin pass-throughs whose value is the layer boundary, not orchestration.

---

## Error handling

- **Datasources** never catch. Exceptions from `cloud_functions`, `firebase_auth`, `cloud_firestore`, and `just_audio` bubble up untouched. (Exception: `AudioPlayerDataSource` catches and emits errors as events because playback is a stream-of-state operation, not a request/response.)
- **Repositories** wrap every call in `try/catch`, convert via `mapException(...)`, then `throw` an `AppFailure`. Use case callers see only `AppFailure` subclasses or successful values.
- **`mapException` extension** — the existing [client-app/lib/core/errors/failure_mapper.dart](../../../client-app/lib/core/errors/failure_mapper.dart) handles `FirebaseFunctionsException` and `FirebaseAuthException`. Add `FirebaseException` (Firestore) handling: `permission-denied → UnauthenticatedFailure`, `unavailable → NetworkFailure`, fallback `UnknownFailure(message)`.
- **Player error path** — `just_audio.PlayerException` and `PlayerInterruptedException` map to `UnknownFailure(message)` via an inline helper inside `AudioPlayerDataSource`, surface through `PlaybackState.error` with `status = error`.
- **Use cases** don't catch. `AppFailure` propagates to the ViewModel.
- **Unauthenticated favorites** — `FavoritesRepository` reads `AuthService.currentUser?.uid` at the top of every method; `null` → throws `UnauthenticatedFailure` before touching Firestore.

---

## Testing

Test files live under `client-app/test/` mirroring `lib/`. `mocktail` is already in `pubspec.yaml`.

### Mappers (pure unit, no mocks)
- `test/core/pagination/page_mapper_test.dart`
- `test/features/stations/data/mappers/station_mapper_test.dart` — full-fields round-trip; nested types covered (Stream, Genre, Location, etc.); `null` upstream stays `null` in entity.
- `test/features/genres/data/mappers/genre_mapper_test.dart`
- `test/features/favorites/data/mappers/favorite_station_mapper_test.dart` — incl. `Timestamp ↔ DateTime`.

### Repositories (mock the datasource)
- `test/features/stations/data/repositories/station_repository_impl_test.dart` — for each method (list/popular/search/byGenre): happy path returns `Page<Station>`; `FirebaseFunctionsException('unauthenticated')` → `UnauthenticatedFailure`; `'invalid-argument'` → `InvalidArgumentFailure`; `'unavailable'` → `NetworkFailure`; arbitrary exception → `UnknownFailure`.
- `test/features/genres/data/repositories/genre_repository_impl_test.dart` — same shape, single method.
- `test/features/favorites/data/repositories/favorites_repository_impl_test.dart` — `watchAll` emits mapped list on snapshot; `add` writes to correct `users/{uid}/favorites/{id}` doc with snapshot fields; `remove` deletes correct doc; missing uid → `UnauthenticatedFailure`; `FirebaseException('permission-denied')` → `UnauthenticatedFailure`.
- `test/features/player/data/repositories/player_repository_impl_test.dart` — `play(Station)` calls `pickBestStream` then datasource `setUrlAndPlay`; emits `loading → playing` PlaybackStates; datasource error event yields `status: error` + `error: AppFailure`; `play(station with empty streams)` → emits `error` state without calling the audio player.

### Use cases (mock the repository)
One file per use case. Verifies it forwards args correctly and propagates the repository's return value or thrown failure unchanged.

`test/features/favorites/domain/usecases/toggle_favorite_use_case_test.dart` is the interesting one: `isFavorite.first == true` → calls `remove(id)`; `false` → calls `add(station)`; failure on `isFavorite` short-circuits.

### Helper
- `test/features/player/domain/pick_best_stream_test.dart` — empty list → null; ranks bitrate desc; HTTPS preferred over higher-bitrate non-HTTPS; `works == false` skipped; falls back to first when all tied.

### Out of scope (this iteration)
- ViewModels and widget tests
- Firestore-emulator / cloud-functions-emulator integration tests
- DI wiring (Provider tree in `main.dart`)

---

## Files touched outside the new code

- [CLAUDE.md](../../../CLAUDE.md) — already updated during brainstorming: Models section (mapper style + Page<T> placement), new "Feature contracts" section, Backend favorites paragraph.
- [client-app/lib/core/errors/failure_mapper.dart](../../../client-app/lib/core/errors/failure_mapper.dart) — extended to handle `FirebaseException` from Firestore.

No other modifications to existing files. The four `features/<feature>/...` directory trees are already scaffolded with `.gitkeep`s; this work fills them in.
