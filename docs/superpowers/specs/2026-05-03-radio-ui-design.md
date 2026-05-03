# Radio app — UI design (presentation layer)

**Status:** Design approved 2026-05-03 — ready to plan.
**Scope:** Build the entire presentation layer (widgets + a small `HomeViewModel`) on top of existing data/domain/view-model code. No data, repository, use-case, or theme changes — those layers are complete.

## 1. Goals and non-goals

### Goals

- One home screen with a fixed silver hardware panel at the bottom (Power · LCD · Volume) and a scrolling list of radio stations above.
- Three primary tabs (`POPULAR`, `ALL`, `FAVORITES`) plus search and genre-filter affordances.
- Tap-to-play with a "tuning" loading animation on the LCD while a stream buffers.
- Knob-controlled volume that drives both the in-app player and the device system volume, with knurl click sounds keyed to drag velocity.
- Power button drives play/stop; red LED tracks active playback.
- All hardware visuals are pure Flutter (`CustomPainter` + gradients); no new image assets.
- Strict adherence to the design language declared in `client-app/CLAUDE.md`.

### Non-goals

- No station detail screen.
- No settings screen (the `⋯` icon in the header is a non-functional placeholder).
- No multi-screen navigation — the app is one screen + one bottom-sheet.
- No tests for cosmetic widgets beyond smoke coverage; presentation tests focus on state-driven branches.

## 2. Inputs already in place

- Theme tokens (`AppColors`, `AppTypography`, `AppSpacing`, `AppTheme`).
- View models: `StationsViewModel`, `GenresViewModel`, `FavoritesViewModel`, `PlayerViewModel` — all wired in `main.dart` via `MultiProvider`.
- Domain entities (`Station`, `PlaybackState`, `FavoriteStation`, etc.).
- `pickBestStream` helper.
- Sound assets in `client-app/assets/sounds/`:
  - `DIA_LG_perc_kata_click.wav` — power-button click.
  - `SwitchLampKnob_S08FO.2508.wav` — volume-knob detent click.
  - `OS_VMT_SFX_Old_Radio_Tuning_1.wav` and `…_3.wav` — buffering/tuning loops.
- Five typeface families in `assets/fonts/` (Jost, Inter, IBMPlexSans, RobotoMono, DSEG14).

## 3. Decisions

These were locked during brainstorming on 2026-05-03 and drive the shape of the design.

| Question | Decision |
|---|---|
| Filter bar layout | 3 tabs (`POPULAR · ALL · FAVORITES`) + search and genre icons top-right. |
| Search UX | Slide-down field below the tab bar. Cancel button dismisses. |
| Genre picker | Bottom sheet of chips (modal). |
| Tap on station row | Plays immediately. While loading, LCD shows scanning animation and tuning sound loops. |
| Favorite gesture | Heart icon on each row (tap = toggle). |
| Volume knob scope | Both — drags drive system volume **and** in-app player volume. Velocity-based click sound. |
| Play/stop button | Toggles play/stop. Click sound on tap. Red LED on while playing, dim otherwise. |
| LCD idle | `STANDBY` placeholder + `TAP A STATION` hint. |
| Station logo fallback | Initials in a monochrome tile. |
| Empty favorites | Centred `NO FAVORITES YET` label + hint. |
| List error UX | Inline empty-state with `RETRY` button (`SIGNAL LOST`). |
| Hardware graphics | Pure Flutter `CustomPainter` + gradients. No PNG/SVG assets. |

## 4. Architecture

### Top-level widget tree

```
RadioApp (existing — MultiProvider + MaterialApp)
└─ HomeScreen (new — replaces _BootHome)
   └─ Scaffold (cream surfaceBody)
      └─ Column
         ├─ Expanded
         │  └─ HomeTopSection
         │     ├─ AppHeader            (raDio + ⋯)
         │     ├─ FilterBar            (POPULAR · ALL · FAVORITES + 🔍 ☰)
         │     ├─ SearchField          (animated slide-down)
         │     ├─ SectionLabel         (e.g. POPULAR STATIONS)
         │     └─ StationsListView     (or EmptyState / ErrorState)
         │        └─ StationRow × N
         └─ HardwarePanel              (fixed, ~220pt + bottom safe-area)
            ├─ PowerButton (left)
            ├─ LcdDisplay  (centre)
            └─ VolumeKnob  (right)
```

The genre picker is a separate `showModalBottomSheet` hosting `GenrePickerSheet`, not part of the persistent tree.

### New `HomeViewModel`

The existing `StationsViewModel` knows about feed `mode`, but it does not know whether the user is viewing favourites or whether the search field is open. `HomeViewModel` owns this UI-level navigation state and orchestrates which underlying VM the body reads from.

```dart
enum HomeTab { popular, all, favorites }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeTab.popular) HomeTab tab,
    @Default(false) bool isSearchOpen,
    @Default('') String searchQuery,
    int? activeGenreId,
    String? activeGenreName,
  }) = _HomeState;
}

class HomeViewModel extends ChangeNotifier {
  void setTab(HomeTab next);          // switches tab + resets search
  void openSearch();                  // toggles isSearchOpen true
  void closeSearch();                 // dismisses + clears query, restores prior tab feed
  void setSearchQuery(String q);      // debounced upstream — 300ms
  void applyGenre(int id, String name);
  void clearGenre();
}
```

The body renders feeds from:
- `StationsViewModel` when `tab` is `popular`/`all`, `isSearchOpen`, or `activeGenreId != null`.
- `FavoritesViewModel` when `tab` is `favorites`.

Switching tab to `popular` or `all` triggers the corresponding `stationsViewModel.show…()` call. Switching to `favorites` does no fetch — the favourites stream is already live.

### Folder structure (new files only)

```
client-app/lib/
  core/
    audio/
      sfx_player.dart                           # one-shot + loop wav playback
    haptics/
      haptics.dart                              # thin HapticFeedback wrapper
    volume/
      volume_controller.dart                    # ChangeNotifier, fans system + app sinks
      system_volume_sink.dart                   # interface + default plugin-backed impl
  features/
    home/
      presentation/
        view_models/
          home_view_model.dart
          home_state.dart
          home_state.freezed.dart
        views/
          home_screen.dart
        widgets/
          app_header.dart
          filter_bar.dart
          search_field.dart
          section_label.dart
          stations_list_view.dart
          station_row.dart
          station_logo_tile.dart
          signal_strength_glyph.dart
          favorite_heart_button.dart
          empty_state.dart                       # NO FAVORITES / SIGNAL LOST / NO RESULTS
    genres/
      presentation/
        widgets/
          genre_picker_sheet.dart
          genre_chip.dart
    player/
      presentation/
        widgets/
          hardware_panel.dart
          power_button.dart
          lcd_display.dart
          volume_knob.dart
          panel_decoration.dart                  # screws + grille + BRAUN wordmark
  test/
    features/home/presentation/view_models/
      home_view_model_test.dart
    core/volume/
      volume_controller_test.dart
    features/player/data/repositories/
      player_repository_set_volume_test.dart     # additive test for new method
    features/home/presentation/widgets/
      station_row_test.dart                      # smoke
      lcd_display_test.dart                      # smoke per PlaybackStatus
```

### Modified existing files

- `lib/main.dart` — replace `_BootHome` with `HomeScreen`; add a `ChangeNotifierProvider<HomeViewModel>`.
- `lib/core/di/dependencies.dart` — register `SfxPlayer`, `Haptics`, `VolumeController` as singletons.
- `lib/features/player/data/datasources/audio_player_data_source.dart` — add `Future<void> setVolume(double v)`.
- `lib/features/player/domain/repositories/player_repository.dart` — declare `Future<void> setVolume(double v)`.
- `lib/features/player/data/repositories/player_repository_impl.dart` — implement `setVolume`.

These are additive only; no existing behaviour changes.

## 5. Component specs

### 5.1 `HardwarePanel`

Fixed-height `Container` (≈`AppSpacing.panelHeight` + `MediaQuery.viewPadding.bottom`).

- Background: vertical `LinearGradient` from `surfacePanelLight` → `surfacePanelDark`.
- 1px hairline at the top edge in a slightly darker shade than the gradient top — produces the visible material seam between cream body and silver panel.
- Children: a `Row` with three slots at flex 1 / 2 / 1 (Power · LCD · Volume).
- Cosmetic overlay (`PanelDecoration`): four screw heads at the corners, horizontal grille lines along the bottom edge, `BRAUN` wordmark bottom-right (Jost, ~10pt, 60% black). Painted in a single `CustomPainter`.

### 5.2 `PowerButton`

Stack of:

1. Outer recessed ring — `RadialGradient` from darker outside to lighter inside pocket.
2. Button surface — circular `RadialGradient` (`knobLight` top-left → `knobDark` bottom-right).
3. Pressed state — gradient darkens by ~6% and the surface scales down 1pt for 80ms.
4. LED dot below the button — `indicatorPower` (#D43A2A) when `playerVm.isPlaying`, dim grey otherwise.
5. 3×3 speaker-grille dot pattern below the LED.
6. `POWER` micro-label above (Roboto Mono, `microLabel` style).

Tap binding (against `PlayerViewModel`):
- `isPlaying` → `stop()`.
- `currentStation != null && (paused || idle || error)` → `play(currentStation)` (or `resume()` if paused).
- No current station → no-op.

Side-effects on tap: `SfxPlayer.playOnce(SfxId.click)` + `Haptics.light()`.

### 5.3 `LcdDisplay`

A `Container`:
- Border 1.5pt in a darker shade than `surfaceLcd`.
- Filled `surfaceLcd` (#B8C2A8).
- Corner radius 4pt.
- Internal padding `lg`.

Internal layout — 3 rows, all DSEG14:

```
FM                          STEREO     ← lcdSmall
█ STATION NAME █                       ← lcdLarge (marquee on overflow)
artist - title                         ← lcdSmall (marquee on overflow)
LIVE • LDN              00:28          ← lcdSmall
```

Driven by `PlayerViewModel.state`:

| `PlaybackStatus` | LCD content |
|---|---|
| `idle` | Big = `STANDBY`. Bottom = `TAP A STATION`. No `LIVE` token. Time = `--:--`. |
| `loading` | Scanning animation (see below). Tuning sound loops via `SfxPlayer`. |
| `playing` | Station name + (artist–title if present) + `LIVE • <city>` + elapsed time. |
| `paused` | Same as playing but `LIVE` token dim and elapsed time frozen. |
| `error` | Big = `NO SIGNAL`. Bottom = `RETRY`. |

**Scanning animation.** A `Timer.periodic(80ms)` cycles the big-line text through randomly-generated 8-character strings of DSEG14-safe glyphs. When `isBuffering` flips false, the cycle resolves into the real station name with a brief lock-in pulse (one final mismatched frame, then the real string).

The `TUNED IN` caption sits below the LCD frame, on the silver panel, in `microLabel`.

### 5.4 `VolumeKnob`

A `CustomPaint` circle wrapped in a `GestureDetector`. Visuals:

- Circular brushed-metal `RadialGradient` (`knobLight` → `knobDark`).
- ~30 short radial knurl ticks around the rim, top semicircle only.
- Small dark indicator notch at the rim, rotated by current value.
- `VOLUME` micro-label above the knob.
- `MIN` / `MAX` labels at the bottom-left / bottom-right corners.

Drag handling:
- `onPanUpdate` computes angular delta from the knob centre using `atan2` on the previous and current pointer positions.
- Angular delta accumulates into `volume ∈ [0.0, 1.0]`.
- Clamped at the ends (no wraparound).
- Rotation is purely visual; `volume` is the source of truth.

Click sounds (velocity-based):
- A `Stopwatch` tracks ms since last knurl click.
- Next click fires when `elapsedMs >= max(20ms, 200ms - rotationSpeed * scale)`.
- Each click: `SfxPlayer.playOnce(SfxId.switchKnob)` + `Haptics.selection()`.

Volume sinks (per the "both" decision):
- `VolumeController.setVolume(v)` is called on every value change.
- `VolumeController` fans out to:
  1. **System volume** via the chosen package (see §7 — open package question).
  2. **App volume** via `PlayerRepository.setVolume(v)` → data source → `_player.setVolume(v)`.

### 5.5 `AppHeader`

`Row` at the top of the body. `raDio` left in `wordmark` style; `⋯` icon button right (no-op for v1, hooks for future settings). Padding `xl` horizontal, `lg` top.

### 5.6 `FilterBar`

`Row`:

- Three left-aligned text "tabs" (`POPULAR`, `ALL`, `FAVORITES`) using `meta` style. Active tab uses `textPrimary`; inactive uses `textSecondary`. Active tab has a 1pt orange dot (`accentLive`) to its left. No background, no underline — colour swap only, in keeping with the design language ("physical labels, not card chrome").
- Trailing two `IconButton`s — `Icons.search` and `Icons.tune` (both thin charcoal, ≈22pt). Tapping search calls `homeVm.openSearch()`; tapping tune opens the genre picker sheet.

Tab taps call `homeVm.setTab(...)` which:
- Closes the search field if open.
- For `popular`/`all`: invokes the corresponding `stationsViewModel.show…()`.
- For `favorites`: switches the body source — no fetch.

### 5.7 `SearchField`

`AnimatedSize` + `AnimatedOpacity` panel below the FilterBar; height transitions 0 → ~52pt over 200ms.

Layout:

```
🔍  [text input]                  CANCEL
```

- Borderless `TextField`, Inter 16pt, placeholder `Search stations…` in `textSecondary`.
- Debounced 300ms — emits to `stationsViewModel.showSearch(query)`.
- While the query is non-empty, the FilterBar's active tab visually deactivates (search "owns" the body).
- `CANCEL` clears the query, dismisses the field, and restores the previously active tab feed.

### 5.8 `SectionLabel`

A small widget rendering `AppTypography.sectionLabel`. Text varies by current state:

- `POPULAR STATIONS` / `ALL STATIONS` / `FAVORITES`.
- `SEARCH RESULTS` while search is active.
- `<GENRE NAME>` (uppercased) when a genre filter is applied.

### 5.9 `StationsListView`

`RefreshIndicator` wrapping a `ListView.separated`:

- Item builder — `StationRow` (or `_SkeletonRow` while `isLoading && items.isEmpty`).
- Separator — themed `Divider` (1px hairline, full width inside horizontal padding).
- Pull-to-refresh — calls `stationsVm.refresh()` (or `favoritesVm` is stream-based, so the gesture is suppressed there — fall back to a no-op).
- Scroll listener triggers `loadMore()` when within ~200pt of the bottom.
- Footer states:
  - `isLoadingMore` → centred animated dot indicator (Plex Sans `· · · ·`).
  - `!hasMore && items.isNotEmpty` → centred `END OF LIST` micro-label.

When the body has no items, swap the list for `EmptyState`:

| Source state | EmptyState content |
|---|---|
| Favorites empty (no items, no error) | `NO FAVORITES YET` + `Tap the heart on a station to save it.` |
| Search empty (query non-empty, no items, no error) | `NO RESULTS` + `Try a different keyword.` |
| Error (any feed) | `SIGNAL LOST` + short reason + `RETRY` text button (Plex Sans uppercase, `accentLive`). |

### 5.10 `StationRow`

`Padding` + `Row`:

1. `StationLogoTile` — 96×96pt.
   - Loads `station.logo` via `Image.network` with `errorBuilder`.
   - On null/error → renders **initials** (first letter of each word in `station.name`, max 4 chars) in bold Inter centred on a `surfaceBody`-tinted square with a 1pt charcoal border.
   - No new image-cache dependency for v1; `cached_network_image` can be added later if perf demands.
2. Centre column (`Expanded`):
   - **Row 1** — orange `accentLive` bullet dot (only if this is the currently-playing station) + `station.name` in `stationName` style.
   - **Row 2** — genres joined `' / '` (uppercased) in `meta` style.
   - **Row 3** — `LIVE` (in `metaLive` orange, only when this row is currently playing) **or** the bitrate of the picked stream (`128KBPS`); then ` • `; then a derived 3-letter location code. The code is computed by a small helper: prefer the first three uppercased letters of `station.location.cityName` (e.g. `LDN`, `BER`); fall back to `station.location.countryCode` (uppercased); fall back to nothing. All `meta`.
3. `FavoriteHeartButton` — outline heart when not favourited, filled charcoal heart when favourited. Tap toggles via `favoritesVm.toggle(station)`. Animated cross-fade. Tapping the heart **does not** trigger play.
4. `SignalStrengthGlyph` — three vertical bars of increasing height (`CustomPainter`), static charcoal. Cosmetic for v1; could later reflect bitrate.

Row tap (anywhere except the heart) → `playerVm.play(station)`.

"Currently playing" = `playerVm.currentStation?.id == station.id && playerVm.isPlaying`.

### 5.11 `GenrePickerSheet`

`showModalBottomSheet` rendered on the silver-panel material so it visually rises from the panel (background `surfacePanelLight`, top corner radius 12pt).

Content:

- Header row — `SELECT GENRE` (section label) left, `CLEAR` text button right (enabled only when `homeVm.activeGenreId != null`).
- Body — `Wrap` of `GenreChip` components. Sharp 2pt corners (no pills), thin charcoal border, Plex Sans uppercase. Active genre fills charcoal with cream text.
- Tap chip → `homeVm.applyGenre(id, name)` → triggers `stationsViewModel.showByGenre(genreId: id)` → dismiss sheet.
- Pulls genre data from `GenresViewModel`. The home screen calls `genresVm.load()` lazily when the sheet opens.
- `CLEAR` clears the genre filter and returns to the previously active tab's feed.

### 5.12 `SfxPlayer`

Wraps a small set of dedicated `just_audio` players for short fire-and-forget effects. Separate from the streaming player so volume changes and stream interruptions don't affect SFX.

```dart
enum SfxId { click, switchKnob, tuning1, tuning3 }

class SfxPlayer {
  Future<void> init();                  // pre-loads each asset via setAsset
  Future<void> playOnce(SfxId id);      // seeks to 0 and plays
  Future<void> startLoop(SfxId id);     // looping playback for tuning sounds
  Future<void> stopLoop();
  Future<void> dispose();
}
```

- Construction is async (DI registers a factory and awaits `init()`).
- A single `switchKnob` player is reused for rapid clicks — `playOnce` seeks to 0 each time, so overlapping rapid clicks are fine (they preempt each other).
- `tuning` runs as a looped player; `LcdDisplay` starts/stops it on `PlaybackStatus.loading` transitions via the player view model state stream.

### 5.13 `Haptics`

Thin wrapper over `HapticFeedback`:

```dart
class Haptics {
  void light();        // power-button tap
  void selection();    // each volume-knob click
  void medium();       // reserved for future long-presses
}
```

Registered as a singleton so widget tests can register a no-op replacement.

### 5.14 `VolumeController`

```dart
class VolumeController extends ChangeNotifier {
  VolumeController({
    required PlayerRepository player,
    required SystemVolumeSink system,
  });

  double get volume;                          // 0.0 .. 1.0
  Future<void> setVolume(double v);           // clamps + fans out
}
```

Fans out to both:
- `_player.setVolume(v)` — the new method on `PlayerRepository`.
- `_system.set(v)` — the `SystemVolumeSink` adapter (see §7).

`VolumeKnob` reads/writes via the controller (via Provider/GetIt); no view model coupling.

## 6. State wiring summary

```
HomeScreen
├─ HomeViewModel (Provider)        — tab, search open, search query, active genre
├─ StationsViewModel               — feeds for popular/all/search/byGenre
├─ FavoritesViewModel              — feed for favourites tab + heart toggles
├─ GenresViewModel                 — chip list for the picker sheet
└─ PlayerViewModel                 — drives LCD, power button, row "playing" state
```

Body source resolution (pseudo-code):

```dart
Widget body() {
  if (home.isSearchOpen && home.searchQuery.isNotEmpty) {
    return ListFromStations(state: stationsVm.state);
  }
  if (home.activeGenreId != null) {
    return ListFromStations(state: stationsVm.state);
  }
  switch (home.tab) {
    case HomeTab.popular:
    case HomeTab.all:
      return ListFromStations(state: stationsVm.state);
    case HomeTab.favorites:
      return ListFromFavorites(state: favoritesVm.state);
  }
}
```

## 7. Open question — system-volume package

Decision required before implementation. The "both" answer for the volume knob requires a Flutter plugin that can read and write the device's system media volume.

Candidates:

| Package | Status | Notes |
|---|---|---|
| `volume_controller` | Maintained, popular | Read/write system volume on iOS + Android. Default choice. |
| `realtime_volume_controller` | Newer fork | Adds change-listener support. Heavier than we need for one-way writes. |
| App-volume only | Fallback | Drop the system-volume sink; knob only affects in-app `just_audio`. |

**Default for the plan:** `volume_controller`, encapsulated behind a `SystemVolumeSink` interface so swapping is a one-file change. If the user prefers app-only or a different package, the plan adjusts the `SystemVolumeSink` implementation only.

## 8. Edge cases and known limitations

1. **Tap-to-play during loading.** Tapping a different station while one is buffering replaces the upstream stream (existing behaviour of `PlayStationUseCase`). The LCD scan stays on but is now scanning for the new station. Acceptable.
2. **Pagination + tab switch.** Switching tabs mid-load lets the pending fetch land. `StationsViewModel` does not currently expose cancellation; the resulting `state.items` will be replaced when the new tab's first page lands. Acceptable for v1.
3. **Volume knob vs pull-to-refresh.** The knob lives in the bottom panel; the list owns vertical pan above. Hit regions don't overlap, so no gesture-arena conflict. Manual test on device.
4. **Safe area.** `HardwarePanel` adds `MediaQuery.viewPadding.bottom` to its height so the knob isn't pushed under the iPhone home indicator.
5. **First launch / sign-in race.** `PlayerViewModel.state` defaults to `idle`, so the LCD shows `STANDBY` from the first frame. No flicker.
6. **Marquee scrolling on LCD.** Implemented as a `LayoutBuilder` + `AnimationController` shifting an `Offset`. If the text fits, no animation runs.

## 9. Testing

Per CLAUDE.md, ViewModels / UseCases / Repositories require unit tests. New tests:

- **`HomeViewModel`** — tab switching emits state, switching tabs closes search, applying a genre updates state, `clearGenre` restores feed, `setSearchQuery` debounces upstream.
- **`VolumeController`** — `setVolume` clamps to `[0.0, 1.0]`, calls both sinks, notifies listeners.
- **`PlayerRepository.setVolume`** — additive test verifying it forwards to the data source.

Smoke widget tests (not required by CLAUDE.md but valuable):

- **`StationRow`** — renders name/genres/heart correctly; tapping the heart calls `toggle` and not `play`; tapping anywhere else calls `play` and not `toggle`.
- **`LcdDisplay`** — renders the right text per `PlaybackStatus`.

## 10. Out-of-scope follow-ups

These would be reasonable next-iteration improvements but are explicitly not in this plan:

- Caching network images (`cached_network_image`).
- A station detail screen.
- Settings reachable from the `⋯` icon.
- Connecting `SignalStrengthGlyph` to bitrate.
- Cancellation on `StationsViewModel` so tab-switching aborts in-flight fetches.
- Multi-region support for the `popularStations` feed (the country argument exists but isn't surfaced in UI).
