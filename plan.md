# Greenie Implementation Plan

## Context

The app is a Flutter golf league manager. Most features are implemented with fake data: league home, round management, interactive scorecard with golf indicators and skins, score entry, light/dark theming, and 156 passing tests. Built UI-first with fake repositories so screens are functional immediately.

## Remaining work
- [x] **5.4** Handicap net score row rendered in scorecard
- [x] **6.3** Widget test: `league_home_screen_test.dart`
- [x] **6.3** Widget test: `upcoming_round_card_test.dart`
- [x] **6.3** Widget test: `score_entry_screen_test.dart`
- [x] **6** Measure coverage and reach 95% target (96.5% excluding *.g.dart)

---

## Phase 1: Foundation ✅

### 1.1 Move `go_router` from dev_dependencies to dependencies in `pubspec.yaml` ✅
It's used at runtime but currently listed as a dev dependency.

### 1.2 Strengthen linting rules ✅
- **Modify:** `analysis_options.yaml`
- Add `include: package:flutter_lints/flutter.yaml` (or `package:lints/recommended.yaml`)
- Enable `strict-casts`, `strict-raw-types`
- Add rules: `avoid_print`, `prefer_const_constructors`, `prefer_final_locals`, `require_trailing_commas`, `unawaited_futures`, etc.

### 1.3 Build theme system (light + dark) ✅
- **Modify:** `lib/app/core/theme.dart` — contains brand colors (fairwayGreen, teeBoxGreen, clubhouseCream), spacing scale (extraSmall through doubleExtraLarge, multiples of 4), `buildLightTheme()` and `buildDarkTheme()` with rich component themes (AppBarTheme, CardTheme, FilledButtonTheme, BottomSheetTheme, DividerTheme, ListTileTheme), and `GreenieScoreColors` ThemeExtension.
- **Modify:** `lib/main.dart` — add `theme`, `darkTheme`, `themeMode: ThemeMode.system` to `MaterialApp.router`.
- Design principles: no separate design constants file; spacing scale lives in theme.dart; no hardcoded widget sizes (use flex layouts, padding, Column/Row spacing); component sizing inlined only where absolutely necessary (e.g. scorecard grid cells).

### 1.4 Create shared widgets ✅
- `lib/app/presentation/components/section_header.dart` — titled section with optional trailing action
- `lib/app/presentation/components/info_card.dart` — themed Card wrapper with optional `onTap`
- `lib/app/presentation/components/empty_state.dart` — icon + message for empty lists
- `lib/app/core/extensions/date_extensions.dart` — display formatting for dates

### 1.5 Theme & styling redesign ✅
Applied polished golf-app styling across all widgets:
- Dark-green AppBar, green CTA button with chevron arrow, leaderboard with CircleAvatars
- Responsive layouts using flex values and GridView (supports iPad)
- No SizedBox spacers — uses Column/Row `spacing` parameter and Padding instead
- All 17 widget files updated to use theme constants from `theme.dart`

### Phase 1 verification ✅
1. `flutter analyze` — zero issues
2. `dart format . --set-exit-if-changed` — all formatted
3. `flutter test` — all 156 tests pass
4. Visual: dark green AppBar, green CTA button with arrow, leaderboard with avatars, scorecard with colored cells. Dark mode works.

---

## Phase 2: Data Layer ✅

### 2.1 User & Member models ✅
- **Modify:** `lib/user/user_model.dart` (currently empty) — `UserModel` with id, name, email, isAdmin
- **Create:** `lib/user/infrastructure/models/member_model.dart` — `MemberModel` with id, name, handicap

### 2.2 Add IDs to existing models ✅
- **Modify:** `lib/course/infrastructure/models/course.dart` — add `id` field
- **Modify:** `lib/league/infrastructure/models/league_model.dart` — add `id`, `members`, `adminId` fields
- **Modify:** fake repositories to include IDs and member lists
- **Update:** HomeScreen and any callers to pass new required params so app compiles

### 2.3 Round & Score models ✅
- **Create:** `lib/round/infrastructure/models/round_status.dart` — enum: upcoming, inProgress, completed
- **Create:** `lib/round/infrastructure/models/round_model.dart` — id, leagueId, courseId, date, status, holeNumbers (subset of 18 for 9-hole rounds), scores
- **Create:** `lib/round/infrastructure/models/score_model.dart` — memberId, holeScores (Map<int,int>), totalStrokes getter
- **Create:** `lib/round/infrastructure/models/score_relative_to_par.dart` — enum with `fromDifference(int)` factory (eagle ≤-2, birdie -1, par 0, bogey +1, double +2, triple+ ≥+3)

### 2.4 Round repository + fake data ✅
- **Create:** `lib/round/infrastructure/round_repository.dart` — abstract with `fetchRoundsForLeague`, `fetchRound`, `updateScore`, `startRound`
- **Create:** `lib/round/infrastructure/fake_round_repository.dart` — rich mock data: 4-5 past rounds with varied scores, 1 upcoming, 1 in-progress

### 2.5 User repository + fake data ✅
- **Create:** `lib/user/infrastructure/user_repository.dart` — abstract with `getCurrentUser`, `fetchMembersForLeague`
- **Create:** `lib/user/infrastructure/fake_user_repository.dart` — hardcoded admin user + 6-8 members with varied handicaps

### 2.6 Providers ✅
- **Create:** `lib/round/round_providers.dart` — `@riverpod` providers for round repository, fetchRoundsForLeague, fetchRound
- **Create:** `lib/user/user_providers.dart` — `@riverpod` providers for user repository, currentUser, fetchMembers
- Run `dart run build_runner build --delete-conflicting-outputs` to generate `*.g.dart`

### Phase 2 verification ✅
1. `flutter analyze` — zero issues
2. `dart run build_runner build --delete-conflicting-outputs` — codegen succeeds
3. `flutter run` — app launches, existing HomeScreen still renders with updated models

---

## Phase 3: League Home + Routing ✅

### 3.1 Update HomeScreen as league list ✅
- **Rewrite:** `lib/app/presentation/home_screen.dart` — show list of leagues, each tappable to navigate to `/league/:id`

### 3.2 Redesign LeagueHomeScreen ✅
- **Rewrite:** `lib/league/presentation/league_home_screen.dart` — now a `ConsumerWidget` receiving `leagueId` via route param. Watches league, rounds, and currentUser providers.
- **Create:** `lib/league/presentation/components/league_info_header.dart` — league name (headline), course name + day (subtitle with icons)
- **Create:** `lib/league/presentation/components/upcoming_round_card.dart` — InfoCard showing next round date/course, tappable to navigate to round detail
- **Create:** `lib/league/presentation/components/league_quick_links.dart` — Wrap of tappable tiles: Members, Past Rounds, Standings. Admin tile shown conditionally based on `currentUser.isAdmin`.

Layout: `Scaffold > AppBar > SingleChildScrollView > Column[LeagueInfoHeader, UpcomingRoundCard, LeagueQuickLinks]`

### 3.3 Members List Screen ✅
- **Create:** `lib/league/presentation/members_screen.dart` — `ConsumerWidget` using `AsyncValue` switch pattern → `ListView` of `MemberListTile`
- **Create:** `lib/league/presentation/components/member_list_tile.dart` — ListTile with CircleAvatar initials, name, handicap

### 3.4 Add routes ✅
- **Modify:** `lib/app/core/routing.dart` — add routes for `/league/:leagueId` and `/league/:leagueId/members`

### Phase 3 verification ✅
1. `flutter run` — HomeScreen shows league list. Tap a league → LeagueHomeScreen displays league name, course, day, upcoming round card, and quick link tiles. Admin tile visible (fake user is admin). Tap Members → member list with names and handicaps. Back navigation works. Light/dark theming applies to all new widgets.

---

## Phase 4: Round Feature + Routing ✅

### 4.1 Round List Screen ✅
- **Create:** `lib/round/presentation/round_list_screen.dart` — watches `fetchRoundsForLeague`, shows `ListView` sorted by date with status chips (upcoming/in-progress/completed)
- **Create:** `lib/round/presentation/components/round_list_tile.dart` — InfoCard with course name, date, status indicator, tap → round detail

### 4.2 Round Detail Screen ✅
- **Create:** `lib/round/presentation/round_detail_screen.dart` — watches `fetchRound` + `currentUser`. Shows round info, Start/Continue button based on status, leaderboard if scores exist.
- **Create:** `lib/round/presentation/components/round_info_section.dart` — Card with course name, date, hole count, status chip
- **Create:** `lib/round/presentation/components/round_leaderboard.dart` — ranked list of players by total strokes with relative-to-par display
- **Create:** `lib/round/presentation/components/start_round_button.dart` — full-width FilledButton

### 4.3 Add routes ✅
- **Modify:** `lib/app/core/routing.dart` — add routes for `/league/:leagueId/rounds` and `/league/:leagueId/round/:roundId`

### Phase 4 verification ✅
1. `flutter run` — from LeagueHomeScreen, tap "Past Rounds" → RoundListScreen shows completed, upcoming, and in-progress rounds with dates and status chips. Tap a completed round → RoundDetailScreen shows course info and leaderboard with ranked scores. Tap upcoming round → "Start Round" button visible. Tap in-progress round → "Continue Round" button visible. Back navigation works.

---

## Phase 5: Scorecard Feature + Routing ✅

### 5.1 Enhanced Scorecard with golf indicators ✅
- **Rewrite:** `lib/course/presentation/components/scorecard.dart` — now takes RoundModel + members + course, supports `isEditable` mode. Horizontally-scrollable table: hole header row, par row, one row per player, skins row, totals.
- **Create:** `lib/course/presentation/components/score_cell.dart` — individual score with visual golf indicators via `GreenieScoreColors` theme extension: circle for birdie, double-circle for eagle, square for bogey, double-square for double bogey, filled for triple+. Tappable when editable.
- **Create:** `lib/course/presentation/components/hole_header_cell.dart`, `scorecard_row.dart`, `scorecard_totals.dart`

### 5.2 Score Input flow ✅
- **Create:** `lib/round/presentation/score_entry_screen.dart` — `ConsumerStatefulWidget` managing local score edits. Editable Scorecard + Save action in AppBar.
- **Create:** `lib/round/presentation/components/score_input_bottom_sheet.dart` — number picker (ChoiceChips 1-10) shown when tapping an editable ScoreCell

### 5.3 Skins ✅
- **Create:** `lib/round/infrastructure/skins_calculator.dart` — pure Dart: for each hole, lowest unique score wins the skin; ties = no skin
- Skins row rendered inline in `scorecard.dart` (no separate component file)

### 5.4 Handicaps ✅
- **Create:** `lib/round/infrastructure/handicap_calculator.dart` — computes strokes per hole based on member handicap and hole count
- Net score row rendered inline in `scorecard.dart` below each player's score row

### 5.5 Add routes and integrate scorecard into round detail ✅
- **Modify:** `lib/app/core/routing.dart` — add route for `/league/:leagueId/round/:roundId/scorecard`
- **Modify:** `lib/round/presentation/round_detail_screen.dart` — embed read-only Scorecard for completed/in-progress rounds

### Phase 5 verification ✅
1. `flutter run` — from a completed round detail, scorecard displays with all players' scores and golf indicators (circles for birdies, squares for bogeys, etc.). Skins row shows winner initials or dashes. Net score row shows handicap-adjusted scores per player.
2. From an in-progress round detail, tap "Continue Round" → ScoreEntryScreen. Tap a score cell → bottom sheet with number picker. Select a score → cell updates with correct golf indicator. Tap Save → scores persist in fake repository. Navigate back → leaderboard reflects updated scores.

---

## Phase 6: Tests ✅

173 tests pass across 44 test files. 96.5% line coverage (excluding generated `*.g.dart` files).

### 6.1 Unit tests for models ✅
Mirror `lib/` structure under `test/`. Test constructors, computed properties (`totalPar`, `totalStrokes`, `ScoreRelativeToPar.fromDifference`), edge cases.

### 6.2 Unit tests for calculators & repositories ✅
- Skins calculator: clear winners, ties, empty/partial scores
- Handicap calculator: stroke distribution, net scores
- Fake repositories: expected data, mutation methods (updateScore, startRound)

### 6.3 Widget tests for screens & components ✅
Each screen: test loading/error/data states, navigation triggers, user interactions. Wrap in `ProviderScope` with overridden providers + `MaterialApp` with theme.

### Phase 6 verification
1. `flutter test` — all tests pass ✅
2. `flutter test --coverage` — ≥95% line coverage excluding generated (`*.g.dart`) files ✅ (96.5%)
3. `flutter analyze` — zero issues ✅
4. `dart format . --set-exit-if-changed` — all formatted ✅
