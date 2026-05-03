# Providers & View Models Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire the four feature view models (`stations`, `genres`, `favorites`, `player`) into the app via `get_it` for services and `provider` for view models, following the design at [docs/superpowers/specs/2026-05-03-providers-and-view-models-design.md](../specs/2026-05-03-providers-and-view-models-design.md).

**Architecture:** `get_it` registers all app-wide services (clients, data sources, repositories) once at startup. `MultiProvider` at the root of `RadioApp` registers the four `ChangeNotifier` view models. Each VM exposes a single immutable `XyzState get state` (freezed) plus intent methods. Stream-based VMs (`Favorites`, `Player`) subscribe in their constructor and cancel in `dispose()`.

**Tech Stack:** Flutter 3 / Dart 3, `provider` (already in pubspec), `get_it` (added by Task 1), `freezed` for state classes, `mocktail` for tests, `build_runner` for codegen.

**Repo conventions** (already in place — match these):
- All file paths under `client-app/lib/...`; tests mirror under `client-app/test/...`.
- Imports use `package:radio/...` from tests and relative imports inside `lib/`.
- After editing any file with `@freezed` or `*.freezed.dart` part directives, run `dart run build_runner build --delete-conflicting-outputs` from `client-app/`.
- After every task: `flutter analyze` must be clean; `flutter test` must pass.
- Working directory for all `flutter` / `dart` commands: `client-app/`.

---

## File Structure

**Created in this plan:**

```
client-app/
  lib/
    core/di/
      dependencies.dart                                 # configureDependencies(AuthService)
    features/
      stations/presentation/view_models/
        stations_state.dart                             # freezed; StationsState + StationsMode enum
        stations_view_model.dart                        # ChangeNotifier
      genres/presentation/view_models/
        genres_state.dart                               # freezed
        genres_view_model.dart                          # ChangeNotifier
      favorites/presentation/view_models/
        favorites_state.dart                            # freezed
        favorites_view_model.dart                       # ChangeNotifier
      player/presentation/view_models/
        player_view_model.dart                          # ChangeNotifier — no extra state class
  test/features/
    stations/presentation/view_models/stations_view_model_test.dart
    genres/presentation/view_models/genres_view_model_test.dart
    favorites/presentation/view_models/favorites_view_model_test.dart
    player/presentation/view_models/player_view_model_test.dart
```

**Modified in this plan:**
- `client-app/pubspec.yaml` — add `get_it`.
- `client-app/lib/main.dart` — call `configureDependencies` and replace the `_BootHome` placeholder with a `MultiProvider` of the four VMs.

---

## Task 1: Add `get_it` dependency

**Files:**
- Modify: `client-app/pubspec.yaml`

- [ ] **Step 1: Add `get_it` under `dependencies`**

In `client-app/pubspec.yaml`, locate the `dependencies:` block and add `get_it: ^8.0.0` after `provider`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  firebase_core: ^4.7.0
  firebase_auth: ^6.4.0
  cloud_functions: ^6.2.0
  cloud_firestore: ^6.3.0
  provider: ^6.1.5+1
  get_it: ^8.0.0
  just_audio: ^0.10.5
  freezed_annotation: ^3.1.0
  json_annotation: ^4.11.0
```

- [ ] **Step 2: Resolve dependencies**

Run from `client-app/`:

```bash
flutter pub get
```

Expected: completes without errors; `pubspec.lock` updated.

- [ ] **Step 3: Verify analyzer is clean**

Run from `client-app/`:

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add client-app/pubspec.yaml client-app/pubspec.lock
git commit -m "chore(client): add get_it dependency"
```

---

## Task 2: Create the DI module

**Files:**
- Create: `client-app/lib/core/di/dependencies.dart`

Registers every app-wide service as a lazy singleton. `AuthService` is passed in (already constructed in `main`). `FirebaseFirestore.instance` and `just_audio.AudioPlayer()` are SDK singletons / cheap constructors used directly by the data sources that own them and are NOT separately registered.

- [ ] **Step 1: Create the module**

Create `client-app/lib/core/di/dependencies.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import '../auth/auth_service.dart';
import '../network/cloud_functions_client.dart';
import '../../features/favorites/data/datasources/favorites_remote_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/genres/data/datasources/genre_remote_data_source.dart';
import '../../features/genres/data/repositories/genre_repository_impl.dart';
import '../../features/genres/domain/repositories/genre_repository.dart';
import '../../features/player/data/datasources/audio_player_data_source.dart';
import '../../features/player/data/repositories/player_repository_impl.dart';
import '../../features/player/domain/repositories/player_repository.dart';
import '../../features/stations/data/datasources/station_remote_data_source.dart';
import '../../features/stations/data/repositories/station_repository_impl.dart';
import '../../features/stations/domain/repositories/station_repository.dart';

void configureDependencies({required AuthService authService}) {
  final di = GetIt.I;

  di.registerSingleton<AuthService>(authService);
  di.registerLazySingleton<CloudFunctionsClient>(() => CloudFunctionsClient());

  di.registerLazySingleton<StationRemoteDataSource>(
    () => StationRemoteDataSource(di()),
  );
  di.registerLazySingleton<GenreRemoteDataSource>(
    () => GenreRemoteDataSource(di()),
  );
  di.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSource(FirebaseFirestore.instance),
  );
  di.registerLazySingleton<AudioPlayerDataSource>(
    () => AudioPlayerDataSource(AudioPlayer()),
  );

  di.registerLazySingleton<StationRepository>(
    () => StationRepositoryImpl(di()),
  );
  di.registerLazySingleton<GenreRepository>(
    () => GenreRepositoryImpl(di()),
  );
  di.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      dataSource: di(),
      authService: di(),
    ),
  );
  di.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(di()),
  );
}
```

- [ ] **Step 2: Verify analyzer**

Run from `client-app/`:

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add client-app/lib/core/di/dependencies.dart
git commit -m "feat(core): add get_it-based DI registration"
```

---

## Task 3: Create `StationsState` (freezed)

**Files:**
- Create: `client-app/lib/features/stations/presentation/view_models/stations_state.dart`

- [ ] **Step 1: Write the state class**

Create `client-app/lib/features/stations/presentation/view_models/stations_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/station.dart';

part 'stations_state.freezed.dart';

enum StationsMode { list, popular, search, byGenre }

@freezed
abstract class StationsState with _$StationsState {
  const factory StationsState({
    @Default(StationsMode.list) StationsMode mode,
    @Default(<Station>[]) List<Station> items,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    String? query,
    String? country,
    int? genreId,
    String? genreSlug,
    AppFailure? error,
  }) = _StationsState;
}
```

- [ ] **Step 2: Run codegen**

Run from `client-app/`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: builds successfully; `stations_state.freezed.dart` is generated next to the source file.

- [ ] **Step 3: Verify analyzer**

Run from `client-app/`:

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add client-app/lib/features/stations/presentation/view_models/
git commit -m "feat(stations): add StationsState and StationsMode"
```

---

## Task 4: `StationsViewModel` — initial state and the four mode-entry methods

**Files:**
- Create: `client-app/lib/features/stations/presentation/view_models/stations_view_model.dart`
- Create: `client-app/test/features/stations/presentation/view_models/stations_view_model_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `client-app/test/features/stations/presentation/view_models/stations_view_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/usecases/get_popular_stations_use_case.dart';
import 'package:radio/features/stations/domain/usecases/get_stations_by_genre_use_case.dart';
import 'package:radio/features/stations/domain/usecases/list_stations_use_case.dart';
import 'package:radio/features/stations/domain/usecases/search_stations_use_case.dart';
import 'package:radio/features/stations/presentation/view_models/stations_state.dart';
import 'package:radio/features/stations/presentation/view_models/stations_view_model.dart';

class _MockListStations extends Mock implements ListStationsUseCase {}
class _MockPopular extends Mock implements GetPopularStationsUseCase {}
class _MockSearch extends Mock implements SearchStationsUseCase {}
class _MockByGenre extends Mock implements GetStationsByGenreUseCase {}

Page<Station> _pageOf(List<Station> data, {int page = 1, int limit = 20}) =>
    Page<Station>(data: data, meta: PageMeta(page: page, limit: limit));

void main() {
  late _MockListStations listStations;
  late _MockPopular popular;
  late _MockSearch search;
  late _MockByGenre byGenre;
  late StationsViewModel vm;

  const a = Station(id: 1, name: 'A', streams: []);
  const b = Station(id: 2, name: 'B', streams: []);

  setUp(() {
    listStations = _MockListStations();
    popular = _MockPopular();
    search = _MockSearch();
    byGenre = _MockByGenre();
    vm = StationsViewModel(
      listStations: listStations,
      popularStations: popular,
      searchStations: search,
      stationsByGenre: byGenre,
    );
  });

  test('initial state defaults', () {
    expect(vm.state.mode, StationsMode.list);
    expect(vm.state.items, isEmpty);
    expect(vm.state.page, 1);
    expect(vm.state.limit, 20);
    expect(vm.state.isLoading, false);
    expect(vm.state.isLoadingMore, false);
    expect(vm.state.hasMore, true);
    expect(vm.state.error, isNull);
  });

  test('showList fetches page 1 in list mode and populates items', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a, b]));

    await vm.showList();

    expect(vm.state.mode, StationsMode.list);
    expect(vm.state.items, [a, b]);
    expect(vm.state.page, 1);
    expect(vm.state.isLoading, false);
    expect(vm.state.hasMore, false); // returned 2 < limit 20
    verify(() => listStations(page: 1, limit: 20)).called(1);
  });

  test('showPopular forwards country and switches mode', () async {
    when(() => popular(country: 'GB', page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a]));

    await vm.showPopular(country: 'GB');

    expect(vm.state.mode, StationsMode.popular);
    expect(vm.state.country, 'GB');
    expect(vm.state.items, [a]);
    verify(() => popular(country: 'GB', page: 1, limit: 20)).called(1);
  });

  test('showSearch with empty query is a no-op', () async {
    await vm.showSearch('');
    expect(vm.state.mode, StationsMode.list); // unchanged
    verifyZeroInteractions(search);
  });

  test('showSearch sets query, switches mode, and fetches', () async {
    when(() => search(query: 'jazz', page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([b]));

    await vm.showSearch('jazz');

    expect(vm.state.mode, StationsMode.search);
    expect(vm.state.query, 'jazz');
    expect(vm.state.items, [b]);
  });

  test('showByGenre forwards id and slug', () async {
    when(() => byGenre(genreId: 7, genreSlug: null, page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a]));

    await vm.showByGenre(genreId: 7);

    expect(vm.state.mode, StationsMode.byGenre);
    expect(vm.state.genreId, 7);
    expect(vm.state.items, [a]);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run from `client-app/`:

```bash
flutter test test/features/stations/presentation/view_models/stations_view_model_test.dart
```

Expected: build error / compilation failure (`StationsViewModel` not defined).

- [ ] **Step 3: Implement `StationsViewModel`**

Create `client-app/lib/features/stations/presentation/view_models/stations_view_model.dart`:

```dart
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/pagination/page.dart';
import '../../domain/entities/station.dart';
import '../../domain/usecases/get_popular_stations_use_case.dart';
import '../../domain/usecases/get_stations_by_genre_use_case.dart';
import '../../domain/usecases/list_stations_use_case.dart';
import '../../domain/usecases/search_stations_use_case.dart';
import 'stations_state.dart';

class StationsViewModel extends ChangeNotifier {
  StationsViewModel({
    required ListStationsUseCase listStations,
    required GetPopularStationsUseCase popularStations,
    required SearchStationsUseCase searchStations,
    required GetStationsByGenreUseCase stationsByGenre,
  })  : _listStations = listStations,
        _popularStations = popularStations,
        _searchStations = searchStations,
        _stationsByGenre = stationsByGenre;

  final ListStationsUseCase _listStations;
  final GetPopularStationsUseCase _popularStations;
  final SearchStationsUseCase _searchStations;
  final GetStationsByGenreUseCase _stationsByGenre;

  StationsState _state = const StationsState();
  StationsState get state => _state;

  Future<void> showList() async {
    _state = const StationsState(mode: StationsMode.list, isLoading: true);
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> showPopular({String? country}) async {
    _state = StationsState(
      mode: StationsMode.popular,
      country: country,
      isLoading: true,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> showSearch(String query) async {
    if (query.isEmpty) return;
    _state = StationsState(
      mode: StationsMode.search,
      query: query,
      isLoading: true,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> showByGenre({int? genreId, String? genreSlug}) async {
    _state = StationsState(
      mode: StationsMode.byGenre,
      genreId: genreId,
      genreSlug: genreSlug,
      isLoading: true,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> _fetchPageOne() async {
    try {
      final pageResult = await _fetchByMode(1);
      _state = _state.copyWith(
        items: pageResult.data,
        page: 1,
        hasMore: pageResult.data.length >= _state.limit,
        isLoading: false,
      );
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e, isLoading: false);
    }
    notifyListeners();
  }

  Future<Page<Station>> _fetchByMode(int page) {
    switch (_state.mode) {
      case StationsMode.list:
        return _listStations(page: page, limit: _state.limit);
      case StationsMode.popular:
        return _popularStations(
          country: _state.country,
          page: page,
          limit: _state.limit,
        );
      case StationsMode.search:
        return _searchStations(
          query: _state.query!,
          page: page,
          limit: _state.limit,
        );
      case StationsMode.byGenre:
        return _stationsByGenre(
          genreId: _state.genreId,
          genreSlug: _state.genreSlug,
          page: page,
          limit: _state.limit,
        );
    }
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run from `client-app/`:

```bash
flutter test test/features/stations/presentation/view_models/stations_view_model_test.dart
```

Expected: all 6 tests pass.

- [ ] **Step 5: Commit**

```bash
git add client-app/lib/features/stations/presentation/view_models/stations_view_model.dart \
        client-app/test/features/stations/presentation/view_models/stations_view_model_test.dart
git commit -m "feat(stations): add StationsViewModel with mode-entry methods"
```

---

## Task 5: `StationsViewModel` — `refresh` and `loadMore`

**Files:**
- Modify: `client-app/lib/features/stations/presentation/view_models/stations_view_model.dart`
- Modify: `client-app/test/features/stations/presentation/view_models/stations_view_model_test.dart`

- [ ] **Step 1: Add failing tests**

Append the following test cases to the existing `main()` block of `stations_view_model_test.dart` (before the closing `});`):

```dart
  test('refresh re-fetches the current mode at page 1', () async {
    when(() => popular(country: 'US', page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a]));
    await vm.showPopular(country: 'US');

    when(() => popular(country: 'US', page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a, b]));
    await vm.refresh();

    expect(vm.state.items, [a, b]);
    expect(vm.state.page, 1);
    verify(() => popular(country: 'US', page: 1, limit: 20)).called(2);
  });

  test('loadMore appends the next page and advances page', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf(List.generate(20, (i) => Station(id: i, name: '$i', streams: const []))));
    await vm.showList();
    expect(vm.state.hasMore, true);

    when(() => listStations(page: 2, limit: 20))
        .thenAnswer((_) async => _pageOf([a, b], page: 2));
    await vm.loadMore();

    expect(vm.state.page, 2);
    expect(vm.state.items.length, 22);
    expect(vm.state.hasMore, false); // 2 < limit
    expect(vm.state.isLoadingMore, false);
  });

  test('loadMore is a no-op when hasMore is false', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a]));
    await vm.showList();
    expect(vm.state.hasMore, false);

    await vm.loadMore();

    verifyNever(() => listStations(page: 2, limit: 20));
  });

  test('loadMore is a no-op while isLoadingMore', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf(List.generate(20, (i) => Station(id: i, name: '$i', streams: const []))));
    await vm.showList();

    final completer = Completer<Page<Station>>();
    when(() => listStations(page: 2, limit: 20))
        .thenAnswer((_) => completer.future);

    final first = vm.loadMore();
    final second = vm.loadMore();
    completer.complete(_pageOf([a], page: 2));
    await Future.wait([first, second]);

    verify(() => listStations(page: 2, limit: 20)).called(1);
  });
```

Add these imports at the top of the test file:

```dart
import 'dart:async';
```

- [ ] **Step 2: Run tests to verify they fail**

Run from `client-app/`:

```bash
flutter test test/features/stations/presentation/view_models/stations_view_model_test.dart
```

Expected: 4 new tests fail with "method not defined" (no `refresh` / `loadMore`).

- [ ] **Step 3: Add `refresh` and `loadMore` to the VM**

In `stations_view_model.dart`, add the following methods inside the class (after `showByGenre`):

```dart
  Future<void> refresh() async {
    _state = _state.copyWith(
      page: 1,
      items: const [],
      hasMore: true,
      isLoading: true,
      error: null,
    );
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> loadMore() async {
    if (_state.isLoading || _state.isLoadingMore || !_state.hasMore) return;
    _state = _state.copyWith(isLoadingMore: true, error: null);
    notifyListeners();
    final nextPage = _state.page + 1;
    try {
      final pageResult = await _fetchByMode(nextPage);
      _state = _state.copyWith(
        items: [..._state.items, ...pageResult.data],
        page: nextPage,
        hasMore: pageResult.data.length >= _state.limit,
        isLoadingMore: false,
      );
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e, isLoadingMore: false);
    }
    notifyListeners();
  }
```

- [ ] **Step 4: Run tests**

Run from `client-app/`:

```bash
flutter test test/features/stations/presentation/view_models/stations_view_model_test.dart
```

Expected: all 10 tests pass.

- [ ] **Step 5: Commit**

```bash
git add client-app/lib/features/stations/presentation/view_models/stations_view_model.dart \
        client-app/test/features/stations/presentation/view_models/stations_view_model_test.dart
git commit -m "feat(stations): add refresh and loadMore to StationsViewModel"
```

---

## Task 6: `StationsViewModel` — error handling and `clearError`

**Files:**
- Modify: `client-app/lib/features/stations/presentation/view_models/stations_view_model.dart`
- Modify: `client-app/test/features/stations/presentation/view_models/stations_view_model_test.dart`

- [ ] **Step 1: Add failing tests**

Append to the same test file's `main()`:

```dart
  test('failure during showList populates error and clears isLoading', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenThrow(const NetworkFailure());

    await vm.showList();

    expect(vm.state.error, isA<NetworkFailure>());
    expect(vm.state.isLoading, false);
  });

  test('failure during loadMore preserves items and clears isLoadingMore', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf(List.generate(20, (i) => Station(id: i, name: '$i', streams: const []))));
    await vm.showList();

    when(() => listStations(page: 2, limit: 20))
        .thenThrow(const NetworkFailure());
    await vm.loadMore();

    expect(vm.state.error, isA<NetworkFailure>());
    expect(vm.state.isLoadingMore, false);
    expect(vm.state.items.length, 20); // preserved
    expect(vm.state.page, 1);           // not advanced
  });

  test('clearError clears state.error without invoking any use case', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenThrow(const NetworkFailure());
    await vm.showList();
    expect(vm.state.error, isNotNull);

    vm.clearError();

    expect(vm.state.error, isNull);
    verify(() => listStations(page: 1, limit: 20)).called(1); // not 2
  });
```

Add this import at the top:

```dart
import 'package:radio/core/errors/failures.dart';
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/stations/presentation/view_models/stations_view_model_test.dart
```

Expected: the `clearError` test fails with "method not defined". The two error tests should already pass since the impl in Task 4/5 catches `AppFailure`.

- [ ] **Step 3: Add `clearError` to the VM**

In `stations_view_model.dart`, add inside the class (after `loadMore`):

```dart
  void clearError() {
    if (_state.error == null) return;
    _state = _state.copyWith(error: null);
    notifyListeners();
  }
```

- [ ] **Step 4: Run tests**

```bash
flutter test test/features/stations/presentation/view_models/stations_view_model_test.dart
```

Expected: all 13 tests pass.

- [ ] **Step 5: Commit**

```bash
git add client-app/lib/features/stations/presentation/view_models/stations_view_model.dart \
        client-app/test/features/stations/presentation/view_models/stations_view_model_test.dart
git commit -m "feat(stations): add clearError and verify error handling"
```

---

## Task 7: Create `GenresState` (freezed)

**Files:**
- Create: `client-app/lib/features/genres/presentation/view_models/genres_state.dart`

- [ ] **Step 1: Write the state class**

Create `client-app/lib/features/genres/presentation/view_models/genres_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/genre.dart';

part 'genres_state.freezed.dart';

@freezed
abstract class GenresState with _$GenresState {
  const factory GenresState({
    @Default(<Genre>[]) List<Genre> items,
    @Default(1) int page,
    @Default(100) int limit,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    AppFailure? error,
  }) = _GenresState;
}
```

- [ ] **Step 2: Run codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 3: Verify analyzer**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add client-app/lib/features/genres/presentation/view_models/
git commit -m "feat(genres): add GenresState"
```

---

## Task 8: `GenresViewModel`

**Files:**
- Create: `client-app/lib/features/genres/presentation/view_models/genres_view_model.dart`
- Create: `client-app/test/features/genres/presentation/view_models/genres_view_model_test.dart`

- [ ] **Step 1: Write failing tests**

Create `client-app/test/features/genres/presentation/view_models/genres_view_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/genres/domain/entities/genre.dart';
import 'package:radio/features/genres/domain/usecases/list_genres_use_case.dart';
import 'package:radio/features/genres/presentation/view_models/genres_view_model.dart';

class _MockListGenres extends Mock implements ListGenresUseCase {}

Page<Genre> _pageOf(List<Genre> data, {int page = 1, int limit = 100}) =>
    Page<Genre>(data: data, meta: PageMeta(page: page, limit: limit));

void main() {
  late _MockListGenres listGenres;
  late GenresViewModel vm;

  const rock = Genre(id: 1, name: 'Rock');
  const jazz = Genre(id: 2, name: 'Jazz');

  setUp(() {
    listGenres = _MockListGenres();
    vm = GenresViewModel(listGenres: listGenres);
  });

  test('initial state', () {
    expect(vm.state.items, isEmpty);
    expect(vm.state.page, 1);
    expect(vm.state.limit, 100);
    expect(vm.state.hasMore, true);
  });

  test('load fetches page 1 and populates items', () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock, jazz]));

    await vm.load();

    expect(vm.state.items, [rock, jazz]);
    expect(vm.state.isLoading, false);
    expect(vm.state.hasMore, false); // returned 2 < limit 100
  });

  test('load is idempotent — second call without error is a no-op', () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock]));

    await vm.load();
    await vm.load();

    verify(() => listGenres(page: 1, limit: 100)).called(1);
  });

  test('refresh always re-fetches page 1', () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock]));
    await vm.load();

    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock, jazz]));
    await vm.refresh();

    expect(vm.state.items, [rock, jazz]);
    verify(() => listGenres(page: 1, limit: 100)).called(2);
  });

  test('loadMore appends next page and advances page', () async {
    final fullPage =
        List.generate(100, (i) => Genre(id: i, name: 'g$i'));
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf(fullPage));
    await vm.load();

    when(() => listGenres(page: 2, limit: 100))
        .thenAnswer((_) async => _pageOf([rock], page: 2));
    await vm.loadMore();

    expect(vm.state.page, 2);
    expect(vm.state.items.length, 101);
    expect(vm.state.hasMore, false);
  });

  test('failure populates error and clears loading; clearError clears it',
      () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenThrow(const NetworkFailure());
    await vm.load();
    expect(vm.state.error, isA<NetworkFailure>());
    expect(vm.state.isLoading, false);

    vm.clearError();
    expect(vm.state.error, isNull);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/genres/presentation/view_models/genres_view_model_test.dart
```

Expected: build error / compilation failure.

- [ ] **Step 3: Implement `GenresViewModel`**

Create `client-app/lib/features/genres/presentation/view_models/genres_view_model.dart`:

```dart
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/list_genres_use_case.dart';
import 'genres_state.dart';

class GenresViewModel extends ChangeNotifier {
  GenresViewModel({required ListGenresUseCase listGenres})
      : _listGenres = listGenres;

  final ListGenresUseCase _listGenres;

  GenresState _state = const GenresState();
  GenresState get state => _state;

  Future<void> load() async {
    if (_state.items.isNotEmpty && _state.error == null) return;
    await _fetchPageOne();
  }

  Future<void> refresh() async {
    _state = const GenresState(isLoading: true);
    notifyListeners();
    await _fetchPageOne();
  }

  Future<void> loadMore() async {
    if (_state.isLoading || _state.isLoadingMore || !_state.hasMore) return;
    _state = _state.copyWith(isLoadingMore: true, error: null);
    notifyListeners();
    final nextPage = _state.page + 1;
    try {
      final pageResult =
          await _listGenres(page: nextPage, limit: _state.limit);
      _state = _state.copyWith(
        items: [..._state.items, ...pageResult.data],
        page: nextPage,
        hasMore: pageResult.data.length >= _state.limit,
        isLoadingMore: false,
      );
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e, isLoadingMore: false);
    }
    notifyListeners();
  }

  void clearError() {
    if (_state.error == null) return;
    _state = _state.copyWith(error: null);
    notifyListeners();
  }

  Future<void> _fetchPageOne() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();
    try {
      final pageResult = await _listGenres(page: 1, limit: _state.limit);
      _state = _state.copyWith(
        items: pageResult.data,
        page: 1,
        hasMore: pageResult.data.length >= _state.limit,
        isLoading: false,
      );
    } on AppFailure catch (e) {
      _state = _state.copyWith(error: e, isLoading: false);
    }
    notifyListeners();
  }
}
```

- [ ] **Step 4: Run tests**

```bash
flutter test test/features/genres/presentation/view_models/genres_view_model_test.dart
```

Expected: all 6 tests pass.

- [ ] **Step 5: Commit**

```bash
git add client-app/lib/features/genres/presentation/view_models/genres_view_model.dart \
        client-app/test/features/genres/presentation/view_models/genres_view_model_test.dart
git commit -m "feat(genres): add GenresViewModel"
```

---

## Task 9: Create `FavoritesState` (freezed)

**Files:**
- Create: `client-app/lib/features/favorites/presentation/view_models/favorites_state.dart`

- [ ] **Step 1: Write the state class**

Create `client-app/lib/features/favorites/presentation/view_models/favorites_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite_station.dart';

part 'favorites_state.freezed.dart';

@freezed
abstract class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default(<FavoriteStation>[]) List<FavoriteStation> items,
    @Default(true) bool isLoading,
    AppFailure? error,
  }) = _FavoritesState;
}
```

- [ ] **Step 2: Run codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 3: Verify analyzer**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add client-app/lib/features/favorites/presentation/view_models/
git commit -m "feat(favorites): add FavoritesState"
```

---

## Task 10: `FavoritesViewModel`

**Files:**
- Create: `client-app/lib/features/favorites/presentation/view_models/favorites_view_model.dart`
- Create: `client-app/test/features/favorites/presentation/view_models/favorites_view_model_test.dart`

- [ ] **Step 1: Write failing tests**

Create `client-app/test/features/favorites/presentation/view_models/favorites_view_model_test.dart`:

```dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/favorites/domain/entities/favorite_station.dart';
import 'package:radio/features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:radio/features/favorites/domain/usecases/remove_favorite_use_case.dart';
import 'package:radio/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:radio/features/favorites/domain/usecases/watch_favorites_use_case.dart';
import 'package:radio/features/favorites/presentation/view_models/favorites_view_model.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockWatch extends Mock implements WatchFavoritesUseCase {}
class _MockAdd extends Mock implements AddFavoriteUseCase {}
class _MockRemove extends Mock implements RemoveFavoriteUseCase {}
class _MockToggle extends Mock implements ToggleFavoriteUseCase {}

void main() {
  late StreamController<List<FavoriteStation>> controller;
  late _MockWatch watch;
  late _MockAdd add;
  late _MockRemove remove;
  late _MockToggle toggle;
  late FavoritesViewModel vm;

  const station = Station(id: 42, name: 'Hot 97', streams: []);
  final fav = FavoriteStation(
    station: station,
    addedAt: DateTime.utc(2026, 5, 3),
  );

  setUpAll(() {
    registerFallbackValue(station);
  });

  setUp(() {
    controller = StreamController<List<FavoriteStation>>.broadcast();
    watch = _MockWatch();
    add = _MockAdd();
    remove = _MockRemove();
    toggle = _MockToggle();
    when(() => watch()).thenAnswer((_) => controller.stream);
    vm = FavoritesViewModel(
      watchFavorites: watch,
      addFavorite: add,
      removeFavorite: remove,
      toggleFavorite: toggle,
    );
  });

  tearDown(() async {
    vm.dispose();
    await controller.close();
  });

  test('initial state is loading with empty items', () {
    expect(vm.state.isLoading, true);
    expect(vm.state.items, isEmpty);
    expect(vm.state.error, isNull);
  });

  test('first emission flips isLoading false and populates items', () async {
    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    expect(vm.state.isLoading, false);
    expect(vm.state.items, [fav]);
  });

  test('isFavorite reflects items', () async {
    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    expect(vm.isFavorite(42), true);
    expect(vm.isFavorite(7), false);
  });

  test('add / remove / toggle call the matching use case', () async {
    when(() => add(any())).thenAnswer((_) async {});
    when(() => remove(any())).thenAnswer((_) async {});
    when(() => toggle(any())).thenAnswer((_) async {});

    await vm.add(station);
    await vm.remove(42);
    await vm.toggle(station);

    verify(() => add(station)).called(1);
    verify(() => remove(42)).called(1);
    verify(() => toggle(station)).called(1);
  });

  test('stream error populates state.error and preserves prior items',
      () async {
    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    controller.addError(const NetworkFailure());
    await Future<void>.delayed(Duration.zero);

    expect(vm.state.error, isA<NetworkFailure>());
    expect(vm.state.items, [fav]); // preserved
  });

  test('dispose cancels the subscription and is idempotent', () async {
    vm.dispose();

    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    // state did not update after dispose
    expect(vm.state.items, isEmpty);

    // dispose is idempotent (tearDown will call it again safely)
    expect(() => vm.dispose(), returnsNormally);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/favorites/presentation/view_models/favorites_view_model_test.dart
```

Expected: build error / compilation failure.

- [ ] **Step 3: Implement `FavoritesViewModel`**

Create `client-app/lib/features/favorites/presentation/view_models/favorites_view_model.dart`:

```dart
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/favorite_station.dart';
import '../../domain/usecases/add_favorite_use_case.dart';
import '../../domain/usecases/remove_favorite_use_case.dart';
import '../../domain/usecases/toggle_favorite_use_case.dart';
import '../../domain/usecases/watch_favorites_use_case.dart';
import 'favorites_state.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({
    required WatchFavoritesUseCase watchFavorites,
    required AddFavoriteUseCase addFavorite,
    required RemoveFavoriteUseCase removeFavorite,
    required ToggleFavoriteUseCase toggleFavorite,
  })  : _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        _toggleFavorite = toggleFavorite {
    _subscription = watchFavorites().listen(
      (items) {
        _state = _state.copyWith(
          items: items,
          isLoading: false,
          error: null,
        );
        notifyListeners();
      },
      onError: (Object e) {
        final failure = e is AppFailure ? e : UnknownFailure(e.toString());
        _state = _state.copyWith(error: failure, isLoading: false);
        notifyListeners();
      },
    );
  }

  final AddFavoriteUseCase _addFavorite;
  final RemoveFavoriteUseCase _removeFavorite;
  final ToggleFavoriteUseCase _toggleFavorite;

  late final StreamSubscription<List<FavoriteStation>> _subscription;
  bool _disposed = false;

  FavoritesState _state = const FavoritesState();
  FavoritesState get state => _state;

  bool isFavorite(int stationId) =>
      _state.items.any((f) => f.station.id == stationId);

  Future<void> add(Station station) => _addFavorite(station);
  Future<void> remove(int stationId) => _removeFavorite(stationId);
  Future<void> toggle(Station station) => _toggleFavorite(station);

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _subscription.cancel();
    super.dispose();
  }
}
```

- [ ] **Step 4: Run tests**

```bash
flutter test test/features/favorites/presentation/view_models/favorites_view_model_test.dart
```

Expected: all 6 tests pass.

- [ ] **Step 5: Commit**

```bash
git add client-app/lib/features/favorites/presentation/view_models/favorites_view_model.dart \
        client-app/test/features/favorites/presentation/view_models/favorites_view_model_test.dart
git commit -m "feat(favorites): add FavoritesViewModel"
```

---

## Task 11: `PlayerViewModel`

**Files:**
- Create: `client-app/lib/features/player/presentation/view_models/player_view_model.dart`
- Create: `client-app/test/features/player/presentation/view_models/player_view_model_test.dart`

No separate state file — `PlayerViewModel.state` is the existing `PlaybackState` entity.

- [ ] **Step 1: Write failing tests**

Create `client-app/test/features/player/presentation/view_models/player_view_model_test.dart`:

```dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/entities/playback_state.dart';
import 'package:radio/features/player/domain/usecases/pause_use_case.dart';
import 'package:radio/features/player/domain/usecases/play_station_use_case.dart';
import 'package:radio/features/player/domain/usecases/resume_use_case.dart';
import 'package:radio/features/player/domain/usecases/stop_use_case.dart';
import 'package:radio/features/player/domain/usecases/watch_playback_use_case.dart';
import 'package:radio/features/player/presentation/view_models/player_view_model.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockWatch extends Mock implements WatchPlaybackUseCase {}
class _MockPlay extends Mock implements PlayStationUseCase {}
class _MockPause extends Mock implements PauseUseCase {}
class _MockResume extends Mock implements ResumeUseCase {}
class _MockStop extends Mock implements StopUseCase {}

void main() {
  late StreamController<PlaybackState> controller;
  late _MockWatch watch;
  late _MockPlay play;
  late _MockPause pause;
  late _MockResume resume;
  late _MockStop stop;
  late PlayerViewModel vm;

  const station = Station(id: 1, name: 'A', streams: []);

  setUpAll(() {
    registerFallbackValue(station);
  });

  setUp(() {
    controller = StreamController<PlaybackState>.broadcast();
    watch = _MockWatch();
    play = _MockPlay();
    pause = _MockPause();
    resume = _MockResume();
    stop = _MockStop();
    when(() => watch()).thenAnswer((_) => controller.stream);
    when(() => play(any())).thenAnswer((_) async {});
    when(() => pause()).thenAnswer((_) async {});
    when(() => resume()).thenAnswer((_) async {});
    when(() => stop()).thenAnswer((_) async {});
    vm = PlayerViewModel(
      watchPlayback: watch,
      playStation: play,
      pause: pause,
      resume: resume,
      stop: stop,
    );
  });

  tearDown(() async {
    vm.dispose();
    await controller.close();
  });

  test('initial state is the default PlaybackState', () {
    expect(vm.state, const PlaybackState());
    expect(vm.isPlaying, false);
    expect(vm.isPaused, false);
    expect(vm.isLoading, false);
    expect(vm.hasError, false);
    expect(vm.currentStation, isNull);
  });

  test('mirrors emitted PlaybackState', () async {
    controller.add(const PlaybackState(
      status: PlaybackStatus.playing,
      currentStation: station,
    ));
    await Future<void>.delayed(Duration.zero);

    expect(vm.state.status, PlaybackStatus.playing);
    expect(vm.isPlaying, true);
    expect(vm.currentStation, station);
  });

  test('isLoading is true when status is loading or isBuffering', () async {
    controller.add(const PlaybackState(status: PlaybackStatus.loading));
    await Future<void>.delayed(Duration.zero);
    expect(vm.isLoading, true);

    controller.add(const PlaybackState(
      status: PlaybackStatus.playing,
      isBuffering: true,
    ));
    await Future<void>.delayed(Duration.zero);
    expect(vm.isLoading, true);

    controller.add(const PlaybackState(status: PlaybackStatus.playing));
    await Future<void>.delayed(Duration.zero);
    expect(vm.isLoading, false);
  });

  test('intent methods call matching use cases', () async {
    await vm.play(station);
    await vm.pause();
    await vm.resume();
    await vm.stop();

    verify(() => play(station)).called(1);
    verify(() => pause()).called(1);
    verify(() => resume()).called(1);
    verify(() => stop()).called(1);
  });

  test('dispose cancels subscription', () async {
    vm.dispose();
    controller.add(const PlaybackState(status: PlaybackStatus.playing));
    await Future<void>.delayed(Duration.zero);

    // state did not update after dispose
    expect(vm.state.status, PlaybackStatus.idle);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/player/presentation/view_models/player_view_model_test.dart
```

Expected: build error / compilation failure.

- [ ] **Step 3: Implement `PlayerViewModel`**

Create `client-app/lib/features/player/presentation/view_models/player_view_model.dart`:

```dart
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/usecases/pause_use_case.dart';
import '../../domain/usecases/play_station_use_case.dart';
import '../../domain/usecases/resume_use_case.dart';
import '../../domain/usecases/stop_use_case.dart';
import '../../domain/usecases/watch_playback_use_case.dart';

class PlayerViewModel extends ChangeNotifier {
  PlayerViewModel({
    required WatchPlaybackUseCase watchPlayback,
    required PlayStationUseCase playStation,
    required PauseUseCase pause,
    required ResumeUseCase resume,
    required StopUseCase stop,
  })  : _playStation = playStation,
        _pause = pause,
        _resume = resume,
        _stop = stop {
    _subscription = watchPlayback().listen((s) {
      _state = s;
      notifyListeners();
    });
  }

  final PlayStationUseCase _playStation;
  final PauseUseCase _pause;
  final ResumeUseCase _resume;
  final StopUseCase _stop;

  late final StreamSubscription<PlaybackState> _subscription;
  bool _disposed = false;

  PlaybackState _state = const PlaybackState();
  PlaybackState get state => _state;

  bool get isPlaying => _state.status == PlaybackStatus.playing;
  bool get isPaused => _state.status == PlaybackStatus.paused;
  bool get isLoading =>
      _state.status == PlaybackStatus.loading || _state.isBuffering;
  bool get hasError => _state.status == PlaybackStatus.error;
  Station? get currentStation => _state.currentStation;

  Future<void> play(Station station) => _playStation(station);
  Future<void> pause() => _pause();
  Future<void> resume() => _resume();
  Future<void> stop() => _stop();

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _subscription.cancel();
    super.dispose();
  }
}
```

- [ ] **Step 4: Run tests**

```bash
flutter test test/features/player/presentation/view_models/player_view_model_test.dart
```

Expected: all 5 tests pass.

- [ ] **Step 5: Commit**

```bash
git add client-app/lib/features/player/presentation/view_models/player_view_model.dart \
        client-app/test/features/player/presentation/view_models/player_view_model_test.dart
git commit -m "feat(player): add PlayerViewModel"
```

---

## Task 12: Wire VMs into `RadioApp` and call `configureDependencies` in `main`

**Files:**
- Modify: `client-app/lib/main.dart`

This task replaces the existing `MultiProvider` block (which currently registers `CloudFunctionsClient` and `AuthService`) with a `MultiProvider` containing only the four `ChangeNotifierProvider`s. Service registration moves to `configureDependencies`. The existing `_BootHome` placeholder body stays — it will be replaced by real screens in a later plan — but its dependency on `context.read<AuthService>()` is updated to use `GetIt.I<AuthService>()`.

- [ ] **Step 1: Rewrite `main.dart`**

Replace the entire contents of `client-app/lib/main.dart` with:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/auth/auth_service.dart';
import 'core/di/dependencies.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'features/favorites/domain/usecases/remove_favorite_use_case.dart';
import 'features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'features/favorites/domain/usecases/watch_favorites_use_case.dart';
import 'features/favorites/presentation/view_models/favorites_view_model.dart';
import 'features/genres/domain/usecases/list_genres_use_case.dart';
import 'features/genres/presentation/view_models/genres_view_model.dart';
import 'features/player/domain/usecases/pause_use_case.dart';
import 'features/player/domain/usecases/play_station_use_case.dart';
import 'features/player/domain/usecases/resume_use_case.dart';
import 'features/player/domain/usecases/stop_use_case.dart';
import 'features/player/domain/usecases/watch_playback_use_case.dart';
import 'features/player/presentation/view_models/player_view_model.dart';
import 'features/stations/domain/usecases/get_popular_stations_use_case.dart';
import 'features/stations/domain/usecases/get_stations_by_genre_use_case.dart';
import 'features/stations/domain/usecases/list_stations_use_case.dart';
import 'features/stations/domain/usecases/search_stations_use_case.dart';
import 'features/stations/presentation/view_models/stations_view_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final auth = AuthService();
  await auth.ensureSignedIn();

  configureDependencies(authService: auth);

  runApp(const RadioApp());
}

class RadioApp extends StatelessWidget {
  const RadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final di = GetIt.I;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StationsViewModel(
            listStations: ListStationsUseCase(di()),
            popularStations: GetPopularStationsUseCase(di()),
            searchStations: SearchStationsUseCase(di()),
            stationsByGenre: GetStationsByGenreUseCase(di()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GenresViewModel(
            listGenres: ListGenresUseCase(di()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(
            watchFavorites: WatchFavoritesUseCase(di()),
            addFavorite: AddFavoriteUseCase(di()),
            removeFavorite: RemoveFavoriteUseCase(di()),
            toggleFavorite: ToggleFavoriteUseCase(di()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PlayerViewModel(
            watchPlayback: WatchPlaybackUseCase(di()),
            playStation: PlayStationUseCase(di()),
            pause: PauseUseCase(di()),
            resume: ResumeUseCase(di()),
            stop: StopUseCase(di()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Radio',
        theme: AppTheme.light,
        home: const _BootHome(),
      ),
    );
  }
}

class _BootHome extends StatelessWidget {
  const _BootHome();

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<AuthService>().currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('raDio', style: AppTypography.wordmark),
              const SizedBox(height: AppSpacing.xl),
              const Text('ALL STATIONS', style: AppTypography.sectionLabel),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                user == null ? 'Not signed in' : 'Signed in as ${user.uid}',
                style: AppTypography.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyzer is clean**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Run the full test suite**

```bash
flutter test
```

Expected: every test in `client-app/test/` passes.

- [ ] **Step 4: Commit**

```bash
git add client-app/lib/main.dart
git commit -m "feat(app): wire view-model providers and configureDependencies into RadioApp"
```

---

## Final verification

- [ ] **Step 1: Full analyzer + test sweep**

```bash
flutter analyze
flutter test
```

Both must be clean. If anything fails, stop and fix before reporting completion.

- [ ] **Step 2: Confirm spec coverage**

Walk through `docs/superpowers/specs/2026-05-03-providers-and-view-models-design.md` once more and confirm:

- DI module registers every service from the spec table (Task 2). ✓
- `MultiProvider` holds exactly the four VM providers (Task 12). ✓
- All four VMs match the spec's class signatures. ✓
- Tests cover every behavior listed in the spec's "Testing" section. ✓
- `clearError` exists only on Stations + Genres. ✓
- Player intents are named `pause` / `resume` / `stop`. ✓
- Player exposes convenience getters (`isPlaying`, `isPaused`, `isLoading`, `hasError`, `currentStation`). ✓
- `FavoritesViewModel.isFavorite(int)` is a pure derivation from `state.items`. ✓
