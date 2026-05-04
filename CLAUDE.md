# Radio App — Code of Conduct

A Flutter radio app consuming the RapidAPI Radio Stations API.
Reference: https://medium.com/@herihermawan/free-api-to-access-90-000-radio-stations-worldwide-33768facc0de

## Monorepo

```
radio/
  client-app/        # Flutter app (everything below "Architecture" applies here)
  backend-service/   # Firebase: TypeScript Cloud Functions + Firestore + Auth
  docs/              # Specs and ADRs
  CLAUDE.md
```

## Architecture

**CLEAN architecture** with strict layering. Dependencies point inward only — outer layers know inner layers, never the reverse.

```
View  ─▶  ViewModel  ─▶  UseCase  ─▶  Repository  ─▶  DataSource (API / disk)
```

- **View** — widgets only. No business logic. Listens via `Provider`.
- **ViewModel** — holds immutable UI state (freezed), exposes intent methods, calls UseCases. Never touches a repository directly.
- **UseCase** — one action per class, pure Dart.
- **Repository** — interface in `domain/`, impl in `data/`. Returns domain entities, never DTOs.
- **DataSource** — talks to network/storage. Returns DTOs.

## Folder structure

Feature-based, not layer-based:

```
client-app/lib/
  core/
    audio/              # SfxPlayer (audioplayers — sound effects only)
    auth/               # AuthService (anonymous Firebase auth)
    di/                 # GetIt registration
    errors/             # AppFailure hierarchy
    haptics/
    network/
      cloud_functions_client.dart
      connectivity_service.dart
    pagination/         # Page<T>, PageMeta — shared
    theme/              # AppColors, AppSpacing, AppTypography
    volume/             # System-volume bridge
  features/
    {feature}/
      data/
        models/          # DTOs (freezed + json_serializable)
        mappers/         # DTO ↔ entity, one file per object graph
        datasources/
        repositories/    # implementations
      domain/
        entities/        # domain models (freezed)
        repositories/    # interfaces
        usecases/
      presentation/
        view_models/
        views/
        widgets/
  main.dart
```

Features today: `stations`, `genres`, `favorites`, `player`, `home`.

## Patterns

- **Provider** for state propagation to widgets.
- **GetIt** for DI of services / repositories. Wired in `core/di/dependencies.dart`, exposed to widgets via top-level `MultiProvider` in `main.dart`.
- **Freezed** for every model (DTO and entity). DTOs handle JSON; entities don't know JSON exists.
- **Mappers** are extension methods, one file per object graph (e.g. `station_mapper.dart` covers `Station` + `Stream` + `Genre` + `Location`). Never put `toEntity()` on the model itself.

## Testing

Unit tests required for: ViewModels, UseCases, Repositories. Mock at layer boundaries with `mocktail`. Tests live under `test/` mirroring `lib/`.

## Conventions

- One class per file.
- Repository interfaces in `domain/`, impls in `data/`.
- ViewModels expose immutable state; mutations happen through intent methods.
- No business logic in widgets — if it's not layout or wiring, it belongs in the ViewModel or below.
- Commit messages are conventional (`feat`/`fix`/`refactor`/`docs`/`chore` + scope).

## Feature contracts

- **Stations** — `StationRepository` owns all four feeds (`listStations`, `popularStations`, `searchStations`, `stationsByGenre`). All return `Page<Station>`. The genre-keyed fetch lives here, not on `GenreRepository`, because it returns `Station`.
- **Genres** — `GenreRepository.listGenres({page, limit})` only.
- **Favorites** — `FavoritesRepository` exposes `Stream<List<FavoriteStation>> watchAll()`, `add(Station)`, `remove(int stationId)`, `toggle(Station)`, `Stream<bool> isFavorite(int stationId)`. Sorted by `addedAt desc`. `FavoriteStation` wraps `Station + DateTime addedAt` rather than re-flattening fields.
- **Player** — `PlayerRepository` exposes `Stream<PlaybackState> state` and `play(Station) / pause() / resume() / stop()`. `PlaybackState` carries `status` (idle/loading/playing/paused/error), `currentStation`, `currentStream`, `position`, `bufferedPosition`, `isBuffering`, `error`. Stream selection is the pure helper `pickBestStream(List<Stream>) → Stream?` — ranks by `(isHttps desc, bitrate desc)`, skips `works == false`, falls back to first.

## Audio engines (two players, no overlap)

The single station-playback engine is bound to the OS background-service slot, so we isolate the engines:

- **Station playback** — `just_audio` wrapped in a custom `RadioAudioHandler` (extends `audio_service`'s `BaseAudioHandler`). Only `RadioAudioHandler` constructs an `AudioPlayer`; `AudioPlayerDataSource` is a thin facade that adapts the player's streams into the `RawPlayerSnapshot` the repository consumes. The handler pushes `mediaItem.add(...)` explicitly per `openStation` so station switches update the lock-screen tag (works around the `.distinct(TrackInfo)` filter in `just_audio_background` that would otherwise keep the lock-screen stuck on the first station). It also masks transient `ja.ProcessingState.idle` events as `ready` while no `stop()` was requested — `audio_service`'s `_observePlaybackState` interprets idle as "stop the service" and clears `MPNowPlayingInfoCenter` for the rest of the process. iOS needs `UIBackgroundModes: [audio]`; Android needs `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, `MainActivity` extending `AudioServiceActivity`, and the `com.ryanheise.audioservice.AudioService` + `MediaButtonReceiver` registered in `AndroidManifest.xml`.
- **Sound effects** — `audioplayers`. `SfxPlayer` (in `core/audio/`) handles UI clicks, knob ticks, and the tuning loop. Each player is configured with `AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers)` so it can't yank the AVAudioSession or `MPNowPlayingInfoCenter` slot from the station. Never use `just_audio` here; it would contend for the BG slot.

**Known iOS limitation:** the lock-screen widget shows on first background but vanishes after the app is foregrounded and re-backgrounded. iOS picks "now playing app" via opaque heuristics at the moment of backgrounding; `setActive(true)`, re-publishing `playbackState`, and pause/play toggles all fail to re-claim source-app status from the Dart layer. Fixing it would require custom platform channels around `MPRemoteCommandCenter`. Documented in `RadioAudioHandler`'s class doc.

## Connectivity

`ConnectivityService` (in `core/network/`) wraps `connectivity_plus`, exposes a single `bool isOnline` via `ChangeNotifier`. Provided app-wide. The LCD overrides its own text with `CONNECTION LOST / CHECK NETWORK` while offline. The default is optimistic (true) until the first probe completes.

## Caching policy (client-side)

- **Stations list / popular** — per-mode in-memory cache in `StationsViewModel`, 60s TTL. Tab switches between *All* and *Popular* skip the refetch when fresh; pull-to-refresh and filter changes always bypass. `popular` is treated as a single-page feed and never paginates.
- **Genres** — `GenresViewModel.load()` walks every page eagerly on first call and keeps the result for the rest of the session. `refresh()` forces a full re-fetch.
- **Stale-response gating** — `StationsViewModel` bumps a `_fetchToken` on every fetch. A response only writes to state if its token is still current — protects against rapid search typing where slow earlier responses would otherwise overwrite newer ones.

## Design language

**Braun + Casio, filtered through modern mobile UI.** Read this section before any presentation-layer work. UI that drifts toward generic Material/iOS card aesthetics is wrong even when functionally correct.

### Two surfaces

The app has two visually distinct regions, read as different physical materials:

- **Body** — warm cream `#EFEBE2`, scrolling content.
- **Hardware panel** — solid dark `#2A2A2C` at the bottom, fixed height. Top edge has a 2pt white→transparent highlight ("light catching the front lip"). The same lighting rule applies to the LCD bezel and the LCD screen interior (top-white / bottom-black, 2pt, consistent alpha).
- **Overlay panels** (e.g. genre picker bottom sheet) use the light brushed-metal surface `surfacePanelLight #B6B1A8`.

### Palette (one accent, no multi-colour UI)

- Body `#EFEBE2` · Panel `#1C1C1E` (gradient top `#2A2A2C`) · LCD surface `#B8C2A8`
- Text primary `#1A1A1A` · secondary `#8E8881` · LCD `#2A2E22` · on-dark `#C8C5BD`
- Accent `#E96A2D` — only for active states (LIVE text, active dot, TUNING).
- Power LED `#D43A2A`. Knob metal: light `#C8CDC9` / dark `#5C6362` (cool silver, matches the play-button asset).
- Hairline divider `#D9D2C5`.

Tokens live in `core/theme/app_colors.dart`. Don't introduce new colour values inline.

### Typography

Five families, all SIL OFL, in `client-app/assets/fonts/`. Family names match `pubspec.yaml`.

| Role | Family | Notes |
|---|---|---|
| App wordmark `RADIO` | `Jost` | Geometric, bold (700). |
| Station names | `Inter` | Sentence case, weight 600. |
| Meta text (genre / LIVE / location / section labels) | `IBMPlexSans` | Always uppercase, letter-spaced. |
| LCD text | `VT323` | Static Regular only. Used **only** inside the LCD widget. Lacks `U+2022` (bullet) — use `-` as separator. |
| Micro labels (POWER / VOLUME / MIN / MAX) | `RobotoMono` | All caps, 9pt. |

### Station row — physical label, not a card

No background fill. No shadow. Hairline divider between rows. ~96pt logo tile on the left.

```
[logo]  STATION NAME                                 [♡]
        GENRE / GENRE / GENRE
        LONDON, UNITED KINGDOM
        LIVE  ·  128KBPS
```

- Genre line and location line are single-line meta text with ellipsis. Genre is the upstream-formatted string, not chips.
- Status line shows `LIVE` / `TUNING` / `${bitrate}KBPS` only. No location code on this line.
- **Active states**, driven by `PlayerViewModel.currentStation` + status:
  - **idle** — no dot, status shows `KBPS`.
  - **tuning** — small orange dot pulses (700ms ease-in-out, 1.0↔0.3) + `TUNING` in accent orange.
  - **live** — solid orange dot + `LIVE` in accent orange.

While `items.isEmpty && isLoading` (initial load, tab switch, empty favorites loading), the list shows a `StationsListSkeleton` of 8 placeholder rows pulsing in unison (`textSecondary` alpha 0.18 ↔ 0.42, 1.8s reverse-loop). Pull-to-refresh keeps existing rows.

### Hardware panel (bottom, fixed)

Vertical layout, with the LCD on top and the controls in a row below.

1. **LCD** — full width. See LCD anatomy below.
2. **PowerButton** — brushed-metal asset (`assets/images/...metallic-button-...webp`) with a small red LED next to it.
3. **VolumeSlider** — horizontal track of 22 dots, rectangular thumb with a knurled grip. Drag emits a click sound + selection haptic.
4. **SpeakerGrille** — 48×48 decorative grille on the right.

Top edge of the panel has a 2pt white highlight so the surface reads as raised metal under directional light.

### LCD

- **Bezel:** rounded `#3A3A3C`, 2pt outer drop shadow, top-white / bottom-black 2pt edges (3D rule).
- **Screen:** clipped, 2pt inner shadow on top/left/right and a 2pt white reflection on the bottom — reads as recessed inside the bezel from all four sides. Four screws decorate the corners.
- **Locked geometry:** every row reserves its space so the bezel never grows or shrinks across states. The favourite-heart slot reserves padded dimensions even when no station is loaded.

LCD content (top to bottom):

1. **`FM`     `STEREO`** — small decorative band, 10pt.
2. **Big station name** — `lcdLarge` (36pt). Marquees horizontally when overflowing, clipped so it never enters the playing-indicator region. Indicator is a 3-bar equalizer that flickers at low fps; only shown when `status == playing`.
3. **Bottom row** — `lcdSmall` text on the left, **pixelated favourite heart** (7×6 grid) on the right.
   - When playing, the bottom text alternates every 4s between **location** (city, falling back to country name — never country code), **genre**, and **language**. Empty/missing fields are skipped.
   - In other states: `TAP A STATION` (idle), blank (loading/paused), `RETRY` / `SOMETHING WENT WRONG` (error).
   - When `ConnectivityService` reports offline, the LCD overrides everything with `CONNECTION LOST / CHECK NETWORK`.
   - The heart toggles `FavoritesRepository` for the current station.

### Micro-interactions

Driven by the .wav files in `client-app/assets/sounds/` via `SfxPlayer`.

- Volume slider drag: subtle click + light haptic ticks.
- Power on: brief LCD boot flicker + click.
- Tuning: looped tuning sound (alternates between two .wav files).

### Hard nos

Fake textures · noise/scratch overlays · skeuomorphic drop shadows · multi-colour palettes · rounded bubbly UI · generic Material card chrome · using shadows where contrast and spacing would do the job.

## Backend (Firebase)

- **Region:** `europe-west1` (single sub-region, used for both Functions and Firestore).
- **Auth:** anonymous only. Every client gets a uid; favorites are scoped to it.
- **Functions language:** TypeScript.
- **No offline / no curated mirror.** The app requires network.
- **RapidAPI key never ships to the client.** All RapidAPI calls happen inside Cloud Functions.

### Cloud Functions

Callable functions only (no HTTP triggers). Each function:

1. Rejects unauthenticated calls (`requireAuth`).
2. Validates input by hand (`lib/input.ts`), throwing `HttpsError('invalid-argument', …)` on bad shape.
3. Builds a cache key from its args.
4. Checks in-memory cache → Firestore `cache/{key}` → RapidAPI, in that order.
5. Normalises the upstream response into our DTO via `lib/normalize.ts` before returning.

**Upstream:** RapidAPI host `50k-radio-stations.p.rapidapi.com` (hardcoded). Only `RAPIDAPI_KEY` is a secret — set via `firebase functions:secrets:set RAPIDAPI_KEY`.

**Callables:**

| Function | Upstream path | TTL | Notes |
|---|---|---|---|
| `listStations` | `/radios?page=&limit=` | 1h | Browse all stations; paginated. |
| `popularStations` | `/radios/popular[/{country}]` | 6h | Single-page feed. **No pagination** — upstream returns the same payload regardless of page args, so we don't accept or forward them. |
| `searchStations` | `/radios/search?q=` | 1h | Free-text search; paginated. |
| `listGenres` | `/genres?page=&limit=` | 7d | Paginated; default limit 100. Client walks every page on first fetch. |
| `stationsByGenre` | `/genres/{id}/radios` or `/genres/slug/{slug}/radios` | 1h | Pass `genreId` or `genreSlug`; paginated. |

**Pagination contract (paginated functions only):** `page` (default 1, max 1000) and `limit` (default 20, max 100; `listGenres` default 100). Response shape is `Page<T> = { data: T[], meta: { page, limit, total?, totalPages? }, keywords? }` — `total`/`totalPages` populated only when upstream returns them; clients infer end-of-list when `data.length < limit`. `keywords` is populated only by `searchStations`.

**Upstream wrapping is inconsistent across endpoints** — most return `{ success, data: [...], meta? }`; search returns `{ success, data: { radios: [...], keywords }, meta }`. `normalize.ts` absorbs all variants so the client sees one stable `Page<T>` shape.

**Genre field naming:** the inline `genre` on a Station uses `text`; the standalone `Genre` from `/genres` uses `name`. Two different upstream shapes — both preserved in our types.

Layout under `backend-service/functions/src/`:

```
src/
  index.ts           # initialises admin SDK, sets europe-west1, exports callables
  callable/          # one file per callable
  lib/
    rapidapi.ts      # rapidApiGet(path, params) — uses RAPIDAPI_KEY secret
    cache.ts         # withCache(key, ttl, fetcher) — in-memory + Firestore
    auth.ts          # requireAuth(request)
    input.ts         # asObject / requiredString / optionalInt / requiredInt …
    normalize.ts     # defensive upstream → DTO transforms
    types.ts         # Station, Stream, Genre, Page<T>, …
```

### Firestore collections

| Path | Writer | Reader |
|---|---|---|
| `users/{uid}` | owner | owner |
| `users/{uid}/favorites/{stationId}` | owner | owner |
| `cache/{key}` | CF (admin SDK) | CF only — client denied |

Favorites are **denormalised**: each doc stores the full `Station` snapshot — including the complete `streams` array — plus `addedAt`. The favorites screen renders and plays without a CF round-trip; the player picks the best stream at playback time (same `pickBestStream` helper as for live stations). There is no per-station refresh callable — snapshots stay as captured at favorite-time.
