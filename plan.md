# Greenie Implementation Plan

## Context

The app is a Flutter golf league manager. Most features are implemented with fake data: league home, round management, interactive scorecard with golf indicators and skins, score entry, light/dark theming, and 173 passing tests across 44 test files. Built UI-first with fake repositories so screens are functional immediately.

## Remaining work

See `specs/stats-tab-plan.md` for detailed implementation plan.

### Phase 8: Bottom Navigation + Stats Tab
- [ ] 8.1 Bottom navigation shell — `StatefulShellRoute` with League/Stats branches
- [ ] 8.2 Stats screen — personal stats, recent rounds, league stats placeholder
- [ ] 8.3 Settings screen + theme provider — theme toggle (light/dark/system)
- [ ] 8.4 Update quick links + polish — wire Standings tile, remove dead handlers
- [ ] 8.5 Tests — stats screen, stat card, settings screen, theme provider, routing updates

---

## Phase 1: Foundation

### 1.1 Move `go_router` from dev_dependencies to dependencies in `pubspec.yaml`
- [x] It's used at runtime but currently listed as a dev dependency.

### 1.2 Strengthen linting rules
- [x] **Modify:** `analysis_options.yaml`
- [x] Add `include: package:flutter_lints/flutter.yaml` (or `package:lints/recommended.yaml`)
- [x] Enable `strict-casts`, `strict-raw-types`
- [x] Add rules: `avoid_print`, `prefer_const_constructors`, `prefer_final_locals`, `require_trailing_commas`, `unawaited_futures`, etc.

### 1.3 Build theme system (light + dark)
- [x] **Restructured:** `lib/app/core/theme/` — split into `theme.dart` (`GreenieTheme` with light/dark themes), `colors.dart` (`GreenieColors`: brand colors, score palettes), `sizes.dart` (`GreenieSizes`: spacing scale, multiples of 4), `text_styles.dart` (`GreenieTextStyles`). Score colors moved to `GolfScore` enum in `lib/app/core/enums/golf_score.dart`.
- [x] **Modify:** `lib/main.dart` — add `theme`, `darkTheme`, `themeMode: ThemeMode.system` to `MaterialApp.router`.
- [x] Design principles: no separate design constants file; spacing scale lives in sizes.dart; no hardcoded widget sizes (use flex layouts, padding, Column/Row spacing); component sizing inlined only where absolutely necessary (e.g. scorecard grid cells).

### 1.4 Create shared widgets
- [x] `lib/app/presentation/components/section_header.dart` — titled section with optional trailing action
- [x] `lib/app/presentation/components/info_card.dart` — themed Card wrapper with optional `onTap`
- [x] `lib/app/presentation/components/empty_state.dart` — icon + message for empty lists
- [x] `lib/app/core/extensions/date_extensions.dart` — display formatting for dates

### 1.5 Theme & styling redesign
- [x] Dark-green AppBar, green CTA button with chevron arrow, leaderboard with CircleAvatars
- [x] Responsive layouts using flex values and GridView (supports iPad)
- [x] No SizedBox spacers — uses Column/Row `spacing` parameter and Padding instead
- [x] All 17 widget files updated to use theme constants from `theme.dart`

### Phase 1 verification
- [x] `flutter analyze` — zero issues
- [x] `dart format . --set-exit-if-changed` — all formatted
- [x] `flutter test` — all 156 tests pass
- [x] Visual: dark green AppBar, green CTA button with arrow, leaderboard with avatars, scorecard with colored cells. Dark mode works.

---

## Phase 2: Data Layer

### 2.1 User & Member models
- [x] **Modify:** `lib/user/user_model.dart` — `UserModel` with id, name, email, isAdmin
- [x] **Create:** `lib/user/infrastructure/models/member_model.dart` — `MemberModel` with id, name, handicap

### 2.2 Add IDs to existing models
- [x] **Modify:** `lib/course/infrastructure/models/course.dart` — add `id` field
- [x] **Modify:** `lib/league/infrastructure/models/league_model.dart` — add `id`, `members`, `adminId` fields
- [x] **Modify:** fake repositories to include IDs and member lists
- [x] **Update:** HomeScreen and any callers to pass new required params so app compiles

### 2.3 Round & Score models
- [x] **Create:** `lib/round/infrastructure/models/round_status.dart` — enum: upcoming, inProgress, completed
- [x] **Create:** `lib/round/infrastructure/models/round_model.dart` — id, leagueId, courseId, date, status, holeNumbers (subset of 18 for 9-hole rounds), scores
- [x] **Create:** `lib/round/infrastructure/models/score_model.dart` — memberId, holeScores (Map<int,int>), totalStrokes getter
- [x] **Create:** `lib/round/infrastructure/models/score_relative_to_par.dart` — enum with `fromDifference(int)` factory (eagle ≤-2, birdie -1, par 0, bogey +1, double +2, triple+ ≥+3)

### 2.4 Round repository + fake data
- [x] **Create:** `lib/round/infrastructure/round_repository.dart` — abstract with `fetchRoundsForLeague`, `fetchRound`, `updateScore`, `startRound`
- [x] **Create:** `lib/round/infrastructure/fake_round_repository.dart` — rich mock data: 4-5 past rounds with varied scores, 1 upcoming, 1 in-progress

### 2.5 User repository + fake data
- [x] **Create:** `lib/user/infrastructure/user_repository.dart` — abstract with `getCurrentUser`, `fetchMembersForLeague`
- [x] **Create:** `lib/user/infrastructure/fake_user_repository.dart` — hardcoded admin user + 6-8 members with varied handicaps

### 2.6 Providers
- [x] **Create:** `lib/round/round_providers.dart` — `@riverpod` providers for round repository, fetchRoundsForLeague, fetchRound
- [x] **Create:** `lib/user/user_providers.dart` — `@riverpod` providers for user repository, currentUser, fetchMembers
- [x] Run `dart run build_runner build --delete-conflicting-outputs` to generate `*.g.dart`

### Phase 2 verification
- [x] `flutter analyze` — zero issues
- [x] `dart run build_runner build --delete-conflicting-outputs` — codegen succeeds
- [x] `flutter run` — app launches, existing HomeScreen still renders with updated models

---

## Phase 3: League Home + Routing

### 3.1 Update HomeScreen as league list
- [x] **Rewrite:** `lib/app/presentation/home_screen.dart` — show list of leagues, each tappable to navigate to `/league/:id`

### 3.2 Redesign LeagueHomeScreen
- [x] **Rewrite:** `lib/league/presentation/league_home_screen.dart` — now a `ConsumerWidget` receiving `leagueId` via route param. Watches league, rounds, and currentUser providers.
- [x] **Create:** `lib/league/presentation/components/league_info_header.dart` — league name (headline), course name + day (subtitle with icons)
- [x] **Create:** `lib/league/presentation/components/upcoming_round_card.dart` — InfoCard showing next round date/course, tappable to navigate to round detail
- [x] **Create:** `lib/league/presentation/components/league_quick_links.dart` — Wrap of tappable tiles: Members, Past Rounds, Standings. Admin tile shown conditionally based on `currentUser.isAdmin`.
- [x] Layout: `Scaffold > AppBar > SingleChildScrollView > Column[LeagueInfoHeader, UpcomingRoundCard, LeagueQuickLinks]`

### 3.3 Members List Screen
- [x] **Create:** `lib/league/presentation/members_screen.dart` — `ConsumerWidget` using `AsyncValue` switch pattern → `ListView` of `MemberListTile`
- [x] **Create:** `lib/league/presentation/components/member_list_tile.dart` — ListTile with CircleAvatar initials, name, handicap

### 3.4 Add routes
- [x] **Modify:** `lib/app/core/routing.dart` — add routes for `/league/:leagueId` and `/league/:leagueId/members`

### Phase 3 verification
- [x] `flutter run` — HomeScreen shows league list. Tap a league → LeagueHomeScreen displays league name, course, day, upcoming round card, and quick link tiles. Admin tile visible (fake user is admin). Tap Members → member list with names and handicaps. Back navigation works. Light/dark theming applies to all new widgets.

---

## Phase 4: Round Feature + Routing

### 4.1 Round List Screen
- [x] **Create:** `lib/round/presentation/round_list_screen.dart` — watches `fetchRoundsForLeague`, shows `ListView` sorted by date with status chips (upcoming/in-progress/completed)
- [x] **Create:** `lib/round/presentation/components/round_list_tile.dart` — InfoCard with course name, date, status indicator, tap → round detail

### 4.2 Round Detail Screen
- [x] **Create:** `lib/round/presentation/round_detail_screen.dart` — watches `fetchRound` + `currentUser`. Shows round info, Start/Continue button based on status, leaderboard if scores exist.
- [x] **Create:** `lib/round/presentation/components/round_info_section.dart` — Card with course name, date, hole count, status chip
- [x] **Create:** `lib/round/presentation/components/round_leaderboard.dart` — ranked list of players by total strokes with relative-to-par display
- [x] **Create:** `lib/round/presentation/components/start_round_button.dart` — full-width FilledButton

### 4.3 Add routes
- [x] **Modify:** `lib/app/core/routing.dart` — add routes for `/league/:leagueId/rounds` and `/league/:leagueId/round/:roundId`

### Phase 4 verification
- [x] `flutter run` — from LeagueHomeScreen, tap "Past Rounds" → RoundListScreen shows completed, upcoming, and in-progress rounds with dates and status chips. Tap a completed round → RoundDetailScreen shows course info and leaderboard with ranked scores. Tap upcoming round → "Start Round" button visible. Tap in-progress round → "Continue Round" button visible. Back navigation works.

---

## Phase 5: Scorecard Feature + Routing

### 5.1 Enhanced Scorecard with golf indicators
- [x] **Rewrite:** `lib/course/presentation/components/scorecard.dart` — now takes RoundModel + members + course, supports `isEditable` mode. Horizontally-scrollable table: hole header row, par row, one row per player, skins row, totals.
- [x] **Create:** `lib/course/presentation/components/score_cell.dart` — individual score with visual golf indicators via `GreenieScoreColors` theme extension: circle for birdie, double-circle for eagle, square for bogey, double-square for double bogey, filled for triple+. Tappable when editable.
- [x] **Create:** `lib/course/presentation/components/hole_header_cell.dart`, `scorecard_row.dart`, `scorecard_totals.dart`

### 5.2 Score Input flow
- [x] **Create:** `lib/round/presentation/score_entry_screen.dart` — `ConsumerStatefulWidget` managing local score edits. Editable Scorecard + Save action in AppBar.
- [x] **Create:** `lib/round/presentation/components/score_input_bottom_sheet.dart` — number picker (ChoiceChips 1-10) shown when tapping an editable ScoreCell

### 5.3 Skins
- [x] **Create:** `lib/round/infrastructure/skins_calculator.dart` — pure Dart: for each hole, lowest unique score wins the skin; ties = no skin
- [x] Skins row rendered inline in `scorecard.dart` (no separate component file)

### 5.4 Handicaps
- [x] **Create:** `lib/round/infrastructure/handicap_calculator.dart` — computes strokes per hole based on member handicap and hole count
- [x] Net score row rendered inline in `scorecard.dart` below each player's score row

### 5.5 Add routes and integrate scorecard into round detail
- [x] **Modify:** `lib/app/core/routing.dart` — add route for `/league/:leagueId/round/:roundId/scorecard`
- [x] **Modify:** `lib/round/presentation/round_detail_screen.dart` — embed read-only Scorecard for completed/in-progress rounds

### Phase 5 verification
- [x] `flutter run` — from a completed round detail, scorecard displays with all players' scores and golf indicators (circles for birdies, squares for bogeys, etc.). Skins row shows winner initials or dashes. Net score row shows handicap-adjusted scores per player.
- [x] From an in-progress round detail, tap "Continue Round" → ScoreEntryScreen. Tap a score cell → bottom sheet with number picker. Select a score → cell updates with correct golf indicator. Tap Save → scores persist in fake repository. Navigate back → leaderboard reflects updated scores.

---

## Phase 6: Tests

173 tests pass across 44 test files. 96.5% line coverage (excluding generated `*.g.dart` files).

### 6.1 Unit tests for models
- [x] Mirror `lib/` structure under `test/`. Test constructors, computed properties (`totalPar`, `totalStrokes`, `ScoreRelativeToPar.fromDifference`), edge cases.

### 6.2 Unit tests for calculators & repositories
- [x] Skins calculator: clear winners, ties, empty/partial scores
- [x] Handicap calculator: stroke distribution, net scores
- [x] Fake repositories: expected data, mutation methods (updateScore, startRound)

### 6.3 Widget tests for screens & components
- [x] Each screen: test loading/error/data states, navigation triggers, user interactions. Wrap in `ProviderScope` with overridden providers + `MaterialApp` with theme.

### Phase 6 verification
- [x] `flutter test` — all tests pass
- [x] `flutter test --coverage` — 96.5% line coverage excluding generated (`*.g.dart`) files
- [x] `flutter analyze` — zero issues
- [x] `dart format . --set-exit-if-changed` — all formatted

---

## Phase 7: Cleanup

169 tests pass across 44 test files after removing 4 tests for deleted dead code.

### 7.1 Delete empty file
- [x] **Delete:** `lib/course/infrastructure/course_service.dart` — empty file, never imported

### 7.2 Remove unused constants from theme.dart
- [x] Remove `clubhouseCream` — defined but never used anywhere
- [x] Remove `doubleExtraLarge` — defined but never used anywhere

### 7.3 Remove unused `shortDate` extension method
- [x] **Modify:** `lib/app/core/extensions/date_extensions.dart` — remove the `shortDate` getter
- [x] **Modify:** `test/app/core/extensions/date_extensions_test.dart` — remove the test case for `shortDate`

### 7.4 Remove unused `copyWithHoleScore` method
- [x] **Modify:** `lib/round/infrastructure/models/score_model.dart` — remove `copyWithHoleScore` method
- [x] **Modify:** `test/round/infrastructure/models/score_model_test.dart` — remove the test case for `copyWithHoleScore`

### 7.5 Replace `\u2022` bullet separators with icon dots
- [x] **Modify:** `lib/app/presentation/home_screen.dart` — refactor ListTile subtitle to a Row with a small dot icon separator
- [x] **Modify:** `lib/league/presentation/components/upcoming_round_card.dart` — same pattern
- [x] **Modify:** `lib/round/presentation/components/round_list_tile.dart` — same pattern

### Phase 7 verification
- [x] `flutter analyze` — zero issues
- [x] `dart format . --set-exit-if-changed` — all formatted
- [x] `flutter test` — all 169 tests pass

---

## Pre-work: Theming Alignment + Icon Fixes

173 tests pass across 44 test files after pre-work cleanup.

### PW.1 Fix icons across the app
- [x] Replace problematic icons that render as Chinese-looking glyphs on some devices
- [x] `Icons.emoji_events` → `Icons.flag`, `Icons.sports_golf` → `Icons.flag_outlined`
- [x] `Icons.leaderboard` → `Icons.bar_chart`, `Icons.admin_panel_settings` → `Icons.settings`
- [x] Add `uses-material-design: true` to `pubspec.yaml`

### PW.2 Fix hardcoded sizes to use GreenieSizes
- [x] Dot separator padding/size in `home_screen.dart`, `upcoming_round_card.dart` → `GreenieSizes.extraSmall`
- [x] `empty_state.dart` — replaced `SizedBox(height: 16)` with `Column(spacing: GreenieSizes.large)`
- [x] `round_info_section.dart` — icon `size: 16` → `size: GreenieSizes.large`

### PW.3 Fix stale null checks
- [x] `league_home_screen.dart` — removed `when value != null` guards (fetchLeague is non-nullable)
- [x] Regenerated provider code via `build_runner`
- [x] Updated tests to remove unnecessary `!` operators and fix null-return expectations to `throwsStateError`

### PW.4 Fix duplicate member IDs
- [x] `fake_user_repository.dart` — members 7–14 now have unique IDs (`member-7` through `member-14`)

### PW.5 Update tests
- [x] `empty_state_test.dart` — use neutral `Icons.info` instead of `Icons.sports_golf`
- [x] `league_quick_links_test.dart` — `Icons.admin_panel_settings` → `Icons.settings`
- [x] `fake_user_repository_test.dart` — member count `6` → `14`
- [x] `members_screen_test.dart` — fixed pre-existing text mismatch (`'No members yet.'` → `'No members yet'`)

### Pre-work verification
- [x] `flutter analyze` — zero issues
- [x] `dart format . --set-exit-if-changed` — all formatted
- [x] `flutter test` — all 173 tests pass
