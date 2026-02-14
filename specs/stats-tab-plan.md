# Bottom Navigation + Stats Tab — Implementation Plan

## Context

The app currently navigates linearly: HomeScreen (league list) → LeagueHomeScreen → sub-screens. We're adding bottom navigation at the league level so users can easily switch between the League tab and a new Stats tab. We're also adding a Settings screen accessible from the AppBar, with a working theme toggle.

The current LeagueHomeScreen layout stays as-is — this work focuses on navigation structure, the Stats tab, and Settings.

---

## Phase 1: Bottom Navigation Shell

Restructure routing to use GoRouter's `StatefulShellRoute` at the `/league/:leagueId` level with two branches (League, Stats). Bottom nav only appears on the main tabs — sub-screens (Members, Rounds, Round Detail, Scorecard, Settings) push full-screen without it.

### Files to modify
- `lib/app/core/routing.dart` — wrap `/league/:leagueId` in `StatefulShellRoute.indexedStack` with two branches
- `lib/app/core/theme.dart` — add `BottomNavigationBarThemeData` to both light and dark themes (fairwayGreen selected, neutral unselected)

### Routing structure
```
/                                          → HomeScreen
/league/:leagueId                          → StatefulShellRoute (bottom nav)
  ├─ Branch 0 (League tab)                 → LeagueHomeScreen
  │   ├─ members                           → MembersScreen (full-screen, no bottom nav)
  │   ├─ rounds                            → RoundListScreen (full-screen)
  │   └─ round/:roundId                    → RoundDetailScreen (full-screen)
  │       └─ scorecard                     → ScoreEntryScreen (full-screen)
  └─ Branch 1 (Stats tab)                  → StatsScreen
/league/:leagueId/settings                 → SettingsScreen (full-screen, no bottom nav)
```

### Bottom nav items
- League: `Icons.emoji_events` (trophy)
- Stats: `Icons.bar_chart`

### Run codegen after routing changes
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Verification
- [ ] App launches, tap league → bottom nav appears with League/Stats tabs
- [ ] Tapping tabs switches content, preserves scroll state
- [ ] Sub-screens (Members, Rounds, etc.) push full-screen without bottom nav
- [ ] Back from sub-screen returns to correct tab with bottom nav
- [ ] `flutter analyze` clean

---

## Phase 2: Stats Screen

Build a Stats tab showing personal stats calculated from fake round data. Toggle for league stats is present but shows placeholder content for now.

### Files to create
- `lib/league/presentation/stats_screen.dart` — `ConsumerWidget` taking `leagueId`
  - Watches `currentUserProvider`, `fetchMembersProvider(leagueId)`, `fetchRoundsForLeagueProvider(leagueId)`
  - `SegmentedButton` or `ChoiceChip` toggle: Personal / League
  - **Personal stats section** (calculated from completed rounds where current user has scores):
    - Rounds played (count)
    - Average score (mean total strokes)
    - Best round (lowest total strokes)
    - Current handicap (from MemberModel)
  - **Recent rounds section**: last 3 completed rounds with date, course name, score
  - **League stats**: placeholder with "Coming soon" messaging

- `lib/league/presentation/components/stat_card.dart` — reusable label + value card widget

### Verification
- [ ] Stats tab renders personal stats calculated correctly from fake data
- [ ] Toggle switches between personal and league views
- [ ] Recent rounds shows last 3 completed rounds
- [ ] Loading/error states handled via AsyncValue switch
- [ ] `flutter analyze` clean

---

## Phase 3: Settings Screen + Theme Provider

Build settings screen with a working theme toggle (light/dark/system). Wire up a Riverpod provider so changes take effect immediately (in-memory, resets on restart).

### Files to create
- `lib/app/core/app_providers.dart` — `@riverpod` Notifier for `ThemeMode` state with `setThemeMode` method
- `lib/app/presentation/settings_screen.dart` — Scaffold with theme mode selector (RadioListTile for Light, Dark, System)

### Files to modify
- `lib/main.dart` — watch theme mode provider, pass to `MaterialApp.router(themeMode: ...)`
- `lib/app/core/routing.dart` — add `/league/:leagueId/settings` route

### AppBar settings gear
- Add settings `IconButton` (gear icon) to the AppBar `actions` on LeagueHomeScreen and StatsScreen
- Navigates to `/league/:leagueId/settings`

### Run codegen after adding provider
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Verification
- [ ] Settings gear appears in AppBar on both tabs
- [ ] Tapping gear → settings screen opens full-screen (no bottom nav)
- [ ] Selecting theme mode → app theme changes immediately
- [ ] Back from settings → returns to correct tab
- [ ] `flutter analyze` clean

---

## Phase 4: Update Quick Links + Polish

### Files to modify
- `lib/league/presentation/components/league_quick_links.dart` — wire "Standings" tile to switch to Stats tab (or remove if redundant with bottom nav)

### Verification
- [ ] All quick link tiles that should navigate do navigate correctly
- [ ] No dead/empty `onTap` handlers remain
- [ ] `flutter analyze` clean
- [ ] `dart format . --set-exit-if-changed` passes

---

## Phase 5: Tests

### Files to create
- `test/league/presentation/stats_screen_test.dart` — loading/data/error states, stat calculations, toggle behavior
- `test/league/presentation/components/stat_card_test.dart` — renders label + value
- `test/app/presentation/settings_screen_test.dart` — renders options, theme mode changes
- `test/app/core/app_providers_test.dart` — theme mode provider state changes

### Files to modify
- Update any existing routing/navigation tests affected by the StatefulShellRoute refactor

### Verification
- [ ] `flutter test` — all tests pass (old + new)
- [ ] `flutter analyze` clean
- [ ] `dart format . --set-exit-if-changed` passes
