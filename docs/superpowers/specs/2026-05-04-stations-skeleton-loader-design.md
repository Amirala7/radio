# Stations List Skeleton Loader + Header/Row Cleanup — Design

## Goal

Two cohesive changes to the stations list surface:

1. Replace the tiny `CircularProgressIndicator` shown while the list is empty + loading with a skeleton placeholder list. The skeleton should look like list rows arriving, in keeping with the Braun/Casio design language (no shimmer, no card chrome, no skeuomorphism).
2. Remove two pieces of dead UI from the list surface: the placeholder 3-dot menu in the app header, and the per-row signal-strength glyph (which represents nothing real).

## Trigger

Show the skeleton when **a list is empty AND a fetch is in progress**:

- Initial load (empty + `isLoading`).
- Tab / genre / search switch that clears `items` and triggers a new fetch.
- Empty favorites tab while `favorites.isLoading`.

Do **not** show the skeleton when:

- Pull-to-refresh on a populated list — `RefreshIndicator` already provides feedback, and existing rows stay rendered.
- Pagination — the list is already on screen; the existing footer spinner stays.

The condition reduces to `items.isEmpty && isLoading`, which is already the branch boundary in `stations_list_view.dart`.

## Components

One new file: `client-app/lib/features/home/presentation/widgets/station_row_skeleton.dart`. It exports two widgets.

### `StationRowSkeleton`

A single placeholder row that mirrors `StationRow`'s layout:

- Same outer padding: `horizontal: AppSpacing.xl`, `vertical: AppSpacing.md`.
- Left: 96 × 96 logo placeholder block (matches `StationLogoTile`).
- Middle: column of three stacked rectangle blocks:
  - Name line — height ≈ 16pt, width ≈ 70% of available.
  - Genre line — height ≈ 11pt, width ≈ 50% of available.
  - Meta line — height ≈ 11pt, width ≈ 35% of available.
  - Vertical gap of 2pt between lines (matches `StationRow`).
- No heart button placeholder, no signal-strength glyph placeholder. Their absence is intentional — those reflect state we don't yet know.

All blocks are plain rectangles (no rounded corners beyond a subtle `BorderRadius.circular(2)` to soften pixel edges). They paint at the same opacity, driven by a parent-supplied `Animation<double>`.

### `StationsListSkeleton`

The list-level wrapper.

- Renders **8** `StationRowSkeleton` rows separated by the same `Divider()` used in the real list.
- Owns a single `AnimationController` so all 8 rows pulse in unison (no per-row controllers).
- Controller config: `duration: 1800ms`, repeated with `reverse: true` (so a full cycle is 3.6s).
- Tween: `Tween<double>(begin: 0.35, end: 0.7)` — drives the alpha of every block via `AppColors.textSecondary.withValues(alpha: t)`.
- The animation value is passed down to each `StationRowSkeleton` (constructor param) so children stay stateless.
- Implements `dispose()` for the controller.

## Wire-up

Edit `client-app/lib/features/home/presentation/widgets/stations_list_view.dart`:

1. Stations branch — replace the existing `items.isEmpty && stations.isLoading` block (currently returns the tiny `CircularProgressIndicator`) with `const StationsListSkeleton()`.
2. Favorites branch — add a new check **above** the existing empty-state guard:

```dart
if (favorites.items.isEmpty && favorites.isLoading) {
  return const StationsListSkeleton();
}
```

This fixes a current latent gap where empty + loading favorites would fall through to an empty `ListView`.

No other call-sites change. The skeleton is fully self-contained.

## Visual + animation rules

- Color: `AppColors.textSecondary` modulated by alpha. No shadows, no gradients, no shimmer sweep.
- Geometry: rectangles only. Skeleton is a tonal echo of the real row geometry, not a stylized "loading bar."
- Cycle is calm (~3.6s round trip) so the screen doesn't feel agitated.
- The skeleton list does **not** scroll — it's a fixed column. There's no need for `ListView` semantics here; a `Column` (or `ListView` with `physics: NeverScrollableScrollPhysics()`) is fine.

## Cleanup: remove dead UI

### 3-dot header button

`app_header.dart` currently renders an `IconButton` with `Icons.more_horiz` and `onPressed: null` ("Placeholder for v1."). It opens nothing and serves no purpose. Remove the `IconButton` and the preceding `Spacer()` (which only existed to push the icon right) — leave just the `RADIO` wordmark in the header row. The `AppColors` import becomes unused after removal — drop it.

### Per-row signal-strength glyph

`StationRow` renders `SignalStrengthGlyph` on the right of every row. It's a static three-bar icon — it doesn't reflect actual signal/bitrate, so it's decorative noise. Remove:

- The `SignalStrengthGlyph` widget from the row.
- The preceding `SizedBox(width: AppSpacing.sm)` separator between the heart button and the glyph.
- The `import 'signal_strength_glyph.dart'` line.
- The file `client-app/lib/features/home/presentation/widgets/signal_strength_glyph.dart` itself, once verified that no other call-site references it (grep already confirms only `station_row.dart` imports it).

The skeleton row was already designed without a glyph placeholder, so no rework is needed there.

## Out of scope

- No skeleton for the pagination footer — list is already populated.
- No skeleton for the player panel or LCD.
- No new theme tokens. Reuse `AppColors.textSecondary` and existing `AppSpacing`.
- No accessibility/semantics work beyond Flutter defaults — these are decorative placeholders.

## Files touched

- **New:** `client-app/lib/features/home/presentation/widgets/station_row_skeleton.dart`
- **Modified:** `client-app/lib/features/home/presentation/widgets/stations_list_view.dart`
- **Modified:** `client-app/lib/features/home/presentation/widgets/station_row.dart` (remove signal glyph)
- **Modified:** `client-app/lib/features/home/presentation/widgets/app_header.dart` (remove 3-dot button)
- **Deleted:** `client-app/lib/features/home/presentation/widgets/signal_strength_glyph.dart`

## Testing

No unit tests required — the skeleton is presentation-only with no business logic, and the cleanup is mechanical removal. Manual verification:

1. Cold-start the app on the stations tab → skeleton replaces the spinner, rows then materialize.
2. Switch to a genre that triggers a fetch → skeleton appears while items reload.
3. Pull-to-refresh on a populated list → no skeleton, existing rows stay, `RefreshIndicator` runs.
4. Switch to an empty favorites state while loading → skeleton appears (previously: blank screen).
5. App header shows only the `RADIO` wordmark, no 3-dot button.
6. Station rows end at the heart button, no signal-strength bars.
7. `flutter analyze` is clean (no unused imports from the deletions).
