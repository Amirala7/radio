# Radio App — Code of Conduct

A Flutter radio app consuming the RapidAPI Radio Stations API.
Reference: https://medium.com/@herihermawan/free-api-to-access-90-000-radio-stations-worldwide-33768facc0de

## Monorepo layout

```
radio/
  client-app/        # Flutter app (everything below "Architecture" applies here)
  backend-service/   # Firebase project: Functions (TS) + Firestore + Auth
  CLAUDE.md
```

## Architecture

**CLEAN architecture** with strict layering:

```
View  ─▶  ViewModel  ─▶  UseCase  ─▶  Repository  ─▶  DataSource (API)
```

- **View** — Widgets only. No business logic. Listens to ViewModel via Provider.
- **ViewModel** — Holds UI state, exposes intents, calls UseCases. No direct repository access.
- **UseCase** — One use case = one action. Orchestrates repositories. Pure Dart.
- **Repository** — Abstracts data sources. Returns domain models (never DTOs).
- **DataSource** — Talks to the API / local storage. Returns DTOs.

Dependencies point **inward only**. Inner layers know nothing about outer layers.

## Patterns

- **Provider** — for dependency injection and state propagation to the View layer.
- **Singleton** — for app-wide services (API client, repositories registered once).

## Folder Structure

**Feature-based**, not layer-based. Rooted at `client-app/lib/`:

```
client-app/lib/
  core/                      # shared infra (network, di, errors, theme)
  features/
    stations/
      data/
        models/              # DTOs (freezed)
        mappers/             # DTO ↔ domain mappers
        datasources/
        repositories/        # repository implementations
      domain/
        entities/            # domain models (freezed)
        repositories/        # repository interfaces
        usecases/
      presentation/
        view_models/
        views/
        widgets/
    player/
      ...
  main.dart
```

## Models

- **All models use `freezed`** — both DTOs (data layer) and entities (domain layer).
- **Mappers are extension methods, one file per object graph.** Live in `data/mappers/` (e.g. `station_mapper.dart` covers `Station` plus all nested types — Stream, Genre, Location, etc.). Never put `toEntity()` / `fromEntity()` on the model itself.
- DTOs handle JSON (`fromJson` / `toJson`). Entities never know about JSON.
- **`Page<T>` and `PageMeta` are shared infrastructure**, defined once in `core/pagination/` and reused by every paginated feature.

## Testing

Unit tests are **required** for:
- ViewModels
- UseCases
- Repositories

Mock dependencies at layer boundaries. Tests live under `test/` mirroring `lib/` structure.

## Conventions

- One class per file.
- Repository interfaces in `domain/`, implementations in `data/`.
- ViewModels expose immutable state; mutations happen through intent methods.
- No business logic in widgets — if it's not layout or wiring, it belongs in the ViewModel or below.

## Feature contracts

- **Stations** — `StationRepository` owns all four station feeds: `listStations`, `popularStations`, `searchStations`, `stationsByGenre`. The genre-keyed fetch lives here (not on `GenreRepository`) because it returns `Station`. All four return `Page<Station>`.
- **Genres** — `GenreRepository.listGenres({page, limit})` only. Surfacing genres in the UI is a separate concern from filtering stations by them.
- **Favorites** — `FavoritesRepository` exposes `Stream<List<FavoriteStation>> watchAll()` backed by Firestore snapshots, plus `add(Station)`, `remove(int stationId)`, `Stream<bool> isFavorite(int stationId)`. Sorted by `addedAt desc`. `FavoriteStation` wraps `Station` + `DateTime addedAt` rather than re-flattening fields.
- **Player** — `PlayerRepository` exposes `Stream<PlaybackState> state` and `play(Station) / pause() / resume() / stop()`. `PlaybackState` carries `status` (idle/loading/playing/paused/error), `currentStation`, `currentStream`, `position`, `bufferedPosition`, `isBuffering`, `error`. The repo wraps an `AudioPlayerDataSource` that abstracts `just_audio.AudioPlayer`. Stream selection is a pure helper `pickBestStream(List<Stream>) → Stream?` — ranks by `(isHttps desc, bitrate desc)`, skips `works == false`, falls back to first.

## Design language

**Braun + Casio, filtered through modern mobile UI.** Read this section before any presentation-layer work. UI that drifts toward generic Material/iOS card aesthetics is wrong even when functionally correct.

### Two surfaces, two materials

The app has **two visually distinct regions** that read as different physical materials:
- **Body** (top, scrolling content): warm cream/off-white (~`#EFEBE2`). Not pure white.
- **Control panel** (bottom, fixed): brushed silver-gray metal gradient (~`#B6B1A8` → `#8E8881`). Visible material seam at the top edge.

### Palette

One accent. No multi-color UI.

- `surface.body` ≈ `#EFEBE2` · `surface.panel` ≈ `#B6B1A8` · `surface.lcd` ≈ `#B8C2A8`
- `text.primary` ≈ `#1A1A1A` · `text.secondary` ≈ `#8E8881` · `text.lcd` ≈ `#2A2E22`
- `accent.live` ≈ `#E96A2D` (used only for active states — `LIVE` text and the active-station dot)
- `indicator.power` ≈ `#D43A2A` · `metal.knob.light` ≈ `#D9D5CC` · `metal.knob.dark` ≈ `#6E6862`

### Typography

All five families are bundled in [`client-app/assets/fonts/`](client-app/assets/fonts/) under SIL OFL. Use the family names exactly as declared in `pubspec.yaml`.

| Role | Family | Notes |
|---|---|---|
| App wordmark `raDio` | `Jost` | Variable. Geometric Futura-feel. Bold weight. |
| Station names | `Inter` | Variable. Sentence case, medium-to-bold weight. |
| Meta text (genre, `LIVE`, location, section labels) | `IBMPlexSans` | Static Regular + Medium. **Always uppercase, letter-spaced ~+0.15em.** |
| LCD display | `DSEG14` | Static Regular + Bold (700). 14-segment, renders all letters cleanly. Used **only** inside the LCD widget. |
| Micro labels (`POWER`, `VOLUME`, `MIN`, `MAX`) | `RobotoMono` | Variable. All caps, small, spaced. |

### List item — physical label, not a card

Each station row is a **3-line label**, no background fill, no shadow. Hairline divider between rows.

1. Bold sentence-case station name (`Inter`, charcoal).
2. `GENRE / GENRE / GENRE` — uppercase, letter-spaced (`IBMPlexSans`).
3. `LIVE • LDN` *or* `128KBPS • LA` — uppercase, letter-spaced.

Square monochrome logo tile on the left (~96pt). Three-bar signal-strength glyph on the right. Tap = immediate play.

**Active station marker:** small orange dot (~6pt) to the left of the name + the word `LIVE` rendered in the `accent.live` orange. Nothing else changes — no fill, no border, no card chrome.

### Bottom control panel

Phone-as-radio. All the personality of the app lives here. Layout left → right:

1. **POWER cluster** — `POWER` micro-label · recessed circular silver button · red LED dot **below** the button (not inside) · small speaker-grille dot pattern below the LED.
2. **LCD display** — bordered, green-gray tint. Top row `FM` left / `STEREO` right. Big `DSEG14` station name. Smaller line for `ARTIST - TITLE` (scrolls horizontally if it overflows). Bottom row `LIVE • LDN` left / elapsed time right. `TUNED IN` caption sits *outside* the LCD on the metal panel.
3. **VOLUME cluster** — `VOLUME` micro-label up top · large knurled knob with a small dark indicator notch at the rim · tick marks fanning across the **top semicircle only** · `MIN` / `MAX` labels at the bottom corners.
4. **Decoration** — `BRAUN` wordmark bottom-right · horizontal grille lines along the bottom edge · visible screw heads at the four corners.

### Micro-interactions

Driven by the .wav files in [`client-app/assets/sounds/`](client-app/assets/sounds/).

- Volume knob rotation: subtle click sound + light haptic ticks.
- Power ON: quick fade + brief boot-flicker animation on the LCD.
- LCD long text: scrolls horizontally like an old segmented display.

### Hard nos

Fake textures · noise/scratch overlays · skeuomorphic drop shadows · multi-color palettes · rounded bubbly UI · generic Material card chrome · using shadows where contrast and spacing would do the job.

## Backend (Firebase)

- **Region:** `europe-west` (pick a single sub-region, e.g. `europe-west1`, and use it for both Functions and Firestore).
- **Auth:** Anonymous only. No signup, no Google/Apple. Every client gets a uid; favorites are scoped to it.
- **Functions language:** TypeScript.
- **No offline / no curated mirror.** The app requires network. Stations are fetched live through callable Cloud Functions; there is no `stations_curated` collection.
- **RapidAPI key never ships to the client.** All RapidAPI calls happen inside Cloud Functions.

### Cloud Functions

Callable functions only (no HTTP triggers). Each function:
1. Rejects unauthenticated calls (`request.auth` required).
2. Validates input by hand (`lib/input.ts`), throwing `HttpsError('invalid-argument', …)` on bad shape.
3. Builds a cache key from its args (skipped for `randomStation`).
4. Checks in-memory cache → Firestore `cache/{key}` → RapidAPI, in that order.
5. Normalizes the upstream response into our DTO via `lib/normalize.ts` before returning.

**Upstream:** RapidAPI host `50k-radio-stations.p.rapidapi.com` (hardcoded in `lib/rapidapi.ts`). Only the API key is a secret.

**Secret:** `RAPIDAPI_KEY` — set via `firebase functions:secrets:set RAPIDAPI_KEY`.

**Callables:**

| Function | Upstream path | TTL | Notes |
|---|---|---|---|
| `listStations` | `/radios?page=&limit=` | 1h | Browse all stations; paginated. No filters — use `searchStations` for those. |
| `popularStations` | `/radios/popular[/{country}]` | 6h | Optional country narrows results; paginated |
| `searchStations` | `/radios/search?q=` | 1h | Free-text search; paginated |
| `listGenres` | `/genres?page=&limit=` | 7d | Paginated; default limit 100 (~3 pages covers all genres) |
| `stationsByGenre` | `/genres/{id}/radios` or `/genres/slug/{slug}/radios` | 1h | Pass `genreId` or `genreSlug`; paginated |

Pagination: `page` (default 1, max 1000) and `limit` (default 20, max 100; `listGenres` default 100). Response shape is `Page<T> = { data: T[], meta: { page, limit, total?, totalPages? }, keywords? }` — `total`/`totalPages` are populated only when upstream returns them; otherwise clients infer end-of-list when `data.length < limit`. `keywords` is populated only by `searchStations` (echoed query terms after server-side normalization).

**Upstream wrapping is inconsistent across endpoints** — most return `{ success, data: [...], meta? }`; search returns `{ success, data: { radios: [...], keywords }, meta }`. `normalize.ts` absorbs all variants so the client sees one stable `Page<T>` shape.

**Genre field naming:** the inline `genre` on a Station uses `text`; the standalone `Genre` from `/genres` uses `name`. Two different upstream shapes — both preserved in our types.

Layout under `backend-service/functions/src/`:

```
src/
  index.ts                # initializes admin SDK, sets europe-west1, exports callables
  callable/               # one file per callable
  lib/
    rapidapi.ts           # rapidApiGet(path, params) — uses RAPIDAPI_KEY secret
    cache.ts              # withCache(key, ttl, fetcher) — in-memory + Firestore
    auth.ts               # requireAuth(request) — throws if unauthenticated
    input.ts              # asObject / requiredString / optionalInt / requiredInt …
    normalize.ts          # defensive upstream → DTO transforms
    types.ts              # Station, Stream, Genre, Page<T>, …
```

### Firestore collections

| Path | Writer | Reader |
|---|---|---|
| `users/{uid}` | owner | owner |
| `users/{uid}/favorites/{stationId}` | owner | owner |
| `cache/{key}` | CF (admin SDK) | CF only — client denied |

Favorites are **denormalized**: each doc stores the full `Station` snapshot — including the complete `streams` array — plus `addedAt`. The favorites screen can render and play without a CF round-trip, and the player picks the best stream at playback time (same `pickBestStream` helper as for live stations). There is no per-station refresh callable — snapshots stay as captured at favorite-time; if they need refreshing later, it'll mean adding a `getStation` callable.
