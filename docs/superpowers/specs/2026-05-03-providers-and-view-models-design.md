# Providers & View Models — Design

**Date:** 2026-05-03
**Scope:** Presentation-layer plumbing for the four client features (`stations`, `genres`, `favorites`, `player`): the DI strategy, one `ChangeNotifier` view model per module, and the public API each view model exposes to views. Views, widgets, and screen layout are out of scope.

## Reference

- Architectural rules and feature contracts: [CLAUDE.md](../../../CLAUDE.md)
- Models, repositories, and use cases (already implemented): [2026-05-03-models-repositories-usecases-design.md](./2026-05-03-models-repositories-usecases-design.md)

## Decisions made during brainstorming

| # | Decision |
|---|---|
| 1 | One `ChangeNotifier`-based view model per feature module (4 total). Each exposes a single immutable `XyzState get state` (freezed) plus intent methods. |
| 2 | `StationsViewModel` is **a single VM with a `mode`** (list / popular / search / byGenre), not four separate VMs — matches the single-scrolling-list Braun design. |
| 3 | DI strategy: **`get_it` for app-wide services** (clients, data sources, repositories) + **`provider` for view models**. `MultiProvider` holds only the four `ChangeNotifierProvider`s. |
| 4 | All view models are **app-scoped** (registered at the root). Stations + Genres are lazy (created on first read); Favorites + Player begin streaming as soon as their VM is first read. |
| 5 | Pagination shape: a single state with appended items — `items`, `page`, `hasMore`, `isLoadingMore`, plus first-load `isLoading`. End-of-list inferred when `data.length < limit` (matches backend contract). |
| 6 | `FavoritesViewModel` watches the full favorites list once; `bool isFavorite(int stationId)` is a pure derivation from `state.items`. The per-station `IsFavoriteUseCase` is left unused for now. |
| 7 | `PlayerViewModel` subscribes to `WatchPlaybackUseCase` internally and mirrors `PlaybackState` into its own state. View reads `playerVM.state` consistently with all other VMs. |
| 8 | Player intent methods are named `pause()` / `resume()` / `stop()` (no suffix). |
| 9 | View models expose convenience getters where the derivation is non-trivial (e.g. `PlayerViewModel.isLoading` collapses `status == loading || isBuffering`). |
| 10 | `clearError()` is provided on Stations + Genres so the view can dismiss an error banner without triggering a refetch. |

---

## Top-level wiring

### Boot sequence (`lib/main.dart`)

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final auth = AuthService();
  await auth.ensureSignedIn();

  configureDependencies(authService: auth);   // registers all services with GetIt
  runApp(const RadioApp());
}
```

### `lib/core/di/dependencies.dart`

A single function that registers every app-wide service against `GetIt.I`. All registrations are `registerLazySingleton` except `AuthService` (already constructed) which uses `registerSingleton`.

| Type registered | Construction |
|---|---|
| `AuthService` | passed in |
| `CloudFunctionsClient` | `CloudFunctionsClient()` |
| `StationRemoteDataSource` | `StationRemoteDataSource(GetIt.I())` |
| `GenreRemoteDataSource` | `GenreRemoteDataSource(GetIt.I())` |
| `FavoritesRemoteDataSource` | `FavoritesRemoteDataSource(FirebaseFirestore.instance)` |
| `AudioPlayerDataSource` | `AudioPlayerDataSource(AudioPlayer())` |
| `StationRepository` | `StationRepositoryImpl(GetIt.I())` |
| `GenreRepository` | `GenreRepositoryImpl(GetIt.I())` |
| `FavoritesRepository` | `FavoritesRepositoryImpl(dataSource: GetIt.I(), authService: GetIt.I())` |
| `PlayerRepository` | `PlayerRepositoryImpl(GetIt.I())` |

`FirebaseFirestore.instance` and `just_audio.AudioPlayer()` are not separately registered; they are SDK singletons / cheap constructors used directly by the data source that owns them.

Tests do `GetIt.I.reset()` and re-register fakes per test.

### `RadioApp` (replaces existing `MultiProvider` block)

```dart
class RadioApp extends StatelessWidget {
  const RadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StationsViewModel(
          listStations: ListStationsUseCase(GetIt.I()),
          popularStations: GetPopularStationsUseCase(GetIt.I()),
          searchStations: SearchStationsUseCase(GetIt.I()),
          stationsByGenre: GetStationsByGenreUseCase(GetIt.I()),
        )),
        ChangeNotifierProvider(create: (_) => GenresViewModel(
          listGenres: ListGenresUseCase(GetIt.I()),
        )),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel(
          watchFavorites: WatchFavoritesUseCase(GetIt.I()),
          addFavorite: AddFavoriteUseCase(GetIt.I()),
          removeFavorite: RemoveFavoriteUseCase(GetIt.I()),
          toggleFavorite: ToggleFavoriteUseCase(GetIt.I()),
        )),
        ChangeNotifierProvider(create: (_) => PlayerViewModel(
          watchPlayback: WatchPlaybackUseCase(GetIt.I()),
          playStation: PlayStationUseCase(GetIt.I()),
          pause: PauseUseCase(GetIt.I()),
          resume: ResumeUseCase(GetIt.I()),
          stop: StopUseCase(GetIt.I()),
        )),
      ],
      child: MaterialApp(
        title: 'Radio',
        theme: AppTheme.light,
        home: const _Home(),
      ),
    );
  }
}
```

Use cases are constructed inline (cheap, single-dep on a repository, no benefit to being independently registered).

### Dependency added to `pubspec.yaml`

```yaml
dependencies:
  get_it: ^8.0.0
```

---

## File layout

```
client-app/lib/
  core/
    di/
      dependencies.dart                     # configureDependencies(authService)
  features/
    stations/presentation/view_models/
      stations_state.dart                   # freezed StationsState + StationsMode
      stations_view_model.dart
    genres/presentation/view_models/
      genres_state.dart                     # freezed GenresState
      genres_view_model.dart
    favorites/presentation/view_models/
      favorites_state.dart                  # freezed FavoritesState
      favorites_view_model.dart
    player/presentation/view_models/
      player_view_model.dart                # exposes PlaybackState directly; no extra state class

client-app/test/
  features/
    stations/presentation/view_models/stations_view_model_test.dart
    genres/presentation/view_models/genres_view_model_test.dart
    favorites/presentation/view_models/favorites_view_model_test.dart
    player/presentation/view_models/player_view_model_test.dart
```

---

## View Model APIs

Every view model extends `ChangeNotifier`, exposes its state via a single getter, and mutates `_state` then calls `notifyListeners()` from intent methods. State classes are `freezed`.

### StationsViewModel

```dart
enum StationsMode { list, popular, search, byGenre }

@freezed
abstract class StationsState with _$StationsState {
  const factory StationsState({
    @Default(StationsMode.list) StationsMode mode,
    @Default([]) List<Station> items,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(false) bool isLoading,         // first page or after a mode change
    @Default(false) bool isLoadingMore,     // appending pages 2..n
    @Default(true) bool hasMore,            // false once a page returned < limit
    String? query,                          // populated when mode == search
    String? country,                        // populated when mode == popular
    int? genreId,                           // populated when mode == byGenre
    String? genreSlug,                      // populated when mode == byGenre
    AppFailure? error,
  }) = _StationsState;
}

class StationsViewModel extends ChangeNotifier {
  StationsViewModel({
    required ListStationsUseCase listStations,
    required GetPopularStationsUseCase popularStations,
    required SearchStationsUseCase searchStations,
    required GetStationsByGenreUseCase stationsByGenre,
  });

  StationsState get state;

  /// Switch to mode=list, fetch page 1. No-op if already in list mode and not in error.
  Future<void> showList();

  /// Switch to mode=popular with the given country filter, fetch page 1.
  Future<void> showPopular({String? country});

  /// Switch to mode=search, set query, fetch page 1. Empty `query` is treated as a no-op.
  Future<void> showSearch(String query);

  /// Switch to mode=byGenre with either id or slug (one required), fetch page 1.
  Future<void> showByGenre({int? genreId, String? genreSlug});

  /// Re-fetch current mode/args from page 1 (resets `items`).
  Future<void> refresh();

  /// Fetch next page and append to `items`. No-op if `!hasMore || isLoadingMore || isLoading`.
  Future<void> loadMore();

  /// Clears `state.error` without triggering a refetch.
  void clearError();
}
```

**Notes:**
- Mode transitions clear `items`, `page`, `hasMore`, and `error` before fetching.
- `loadMore()` advances `page` only on a successful fetch; failures leave `page` unchanged and surface `error`.
- `hasMore` flips to `false` when a fetch returns fewer than `limit` items (per backend contract).

### GenresViewModel

```dart
@freezed
abstract class GenresState with _$GenresState {
  const factory GenresState({
    @Default([]) List<Genre> items,
    @Default(1) int page,
    @Default(100) int limit,                // backend default for genres
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    AppFailure? error,
  }) = _GenresState;
}

class GenresViewModel extends ChangeNotifier {
  GenresViewModel({required ListGenresUseCase listGenres});

  GenresState get state;

  /// Idempotent first load — no-op if `items` already populated and no error.
  Future<void> load();

  /// Re-fetch from page 1 (resets `items`).
  Future<void> refresh();

  /// Fetch next page and append. No-op if `!hasMore || isLoadingMore || isLoading`.
  Future<void> loadMore();

  void clearError();
}
```

### FavoritesViewModel

Subscribes to `WatchFavoritesUseCase` in the constructor; cancels in `dispose()`. `state.isLoading` starts `true` and flips to `false` on the first emission (success or empty list). Stream errors populate `state.error` while keeping the previous `items` visible.

```dart
@freezed
abstract class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default([]) List<FavoriteStation> items,
    @Default(true) bool isLoading,          // true until first emission
    AppFailure? error,
  }) = _FavoritesState;
}

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({
    required WatchFavoritesUseCase watchFavorites,
    required AddFavoriteUseCase addFavorite,
    required RemoveFavoriteUseCase removeFavorite,
    required ToggleFavoriteUseCase toggleFavorite,
  });

  FavoritesState get state;

  /// Pure derivation from `state.items`. Returns false until first emission lands.
  bool isFavorite(int stationId);

  /// Errors during these intents are surfaced via `state.error`; the snapshot
  /// in `state.items` will update via the watch stream once Firestore confirms.
  Future<void> add(Station station);
  Future<void> remove(int stationId);
  Future<void> toggle(Station station);

  @override
  void dispose();   // cancels stream subscription
}
```

### PlayerViewModel

Subscribes to `WatchPlaybackUseCase` in the constructor; cancels in `dispose()`. The VM mirrors the latest `PlaybackState` and exposes it directly — `PlaybackState` is already a freezed domain entity covering all UI needs. Initial `state` value before the first emission is `const PlaybackState()` (status: idle, no station). Convenience getters collapse common UI conditions.

```dart
class PlayerViewModel extends ChangeNotifier {
  PlayerViewModel({
    required WatchPlaybackUseCase watchPlayback,
    required PlayStationUseCase playStation,
    required PauseUseCase pause,
    required ResumeUseCase resume,
    required StopUseCase stop,
  });

  PlaybackState get state;

  // Convenience derivations
  bool get isPlaying;            // state.status == playing
  bool get isPaused;             // state.status == paused
  bool get isLoading;            // state.status == loading || state.isBuffering
  bool get hasError;             // state.status == error
  Station? get currentStation;   // state.currentStation

  Future<void> play(Station station);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();

  @override
  void dispose();
}
```

---

## Testing

Per CLAUDE.md, view models are required to have unit tests. All tests use `mocktail` to fake the use cases each VM depends on; no real repositories or data sources.

### `StationsViewModel` (`stations_view_model_test.dart`)

- `showList()` sets mode + fetches page 1, populates `items`, sets `isLoading` true→false.
- `showPopular({country})` / `showSearch(q)` / `showByGenre(...)` each call the corresponding use case with the right args and reset state.
- `refresh()` re-invokes the use case for the current mode with page=1.
- `loadMore()` appends the next page; advances `page` only on success.
- `loadMore()` is a no-op when `!hasMore`, `isLoadingMore`, or `isLoading`.
- A fetch returning `< limit` flips `hasMore` to false.
- `AppFailure` thrown by a use case populates `state.error` and clears `isLoading` / `isLoadingMore`.
- `clearError()` clears `state.error` without invoking any use case.

### `GenresViewModel` (`genres_view_model_test.dart`)

- `load()` is idempotent — second call without an error is a no-op.
- `refresh()` always re-fetches page 1.
- `loadMore()` appends; failure paths preserve current `items`.
- Error / clearError behavior as above.

### `FavoritesViewModel` (`favorites_view_model_test.dart`)

- Constructor subscribes to `WatchFavoritesUseCase`.
- First emission flips `isLoading` from true to false and populates `items`.
- Subsequent emissions update `items`.
- Stream error populates `state.error` while preserving the most recent `items`.
- `isFavorite(id)` reflects current `state.items`.
- `add` / `remove` / `toggle` call the matching use case with the right args.
- `dispose()` cancels the subscription (no further `notifyListeners` after dispose).

### `PlayerViewModel` (`player_view_model_test.dart`)

- Constructor subscribes to `WatchPlaybackUseCase`.
- `state` mirrors emitted `PlaybackState` values.
- Convenience getters resolve correctly for each `PlaybackStatus`.
- `play` / `pause` / `resume` / `stop` call the matching use case.
- `dispose()` cancels the subscription.

---

## Out of scope

- Views, widgets, screen layout, navigation.
- Volume control on the player (the bottom-panel knob) — `PlayerRepository` does not currently expose `setVolume`; will be added when the control panel is built.
- Search debouncing — `showSearch` triggers an immediate fetch; debounce can live in the search input widget if needed.
- Throttling rapid mode switches — out of scope; the VM cancels older in-flight fetches by ignoring their results (a monotonically increasing request id will be added if races become a problem in practice).
