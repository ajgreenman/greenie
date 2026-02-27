# Greenie Implementation Plan

Greenie is a Flutter mobile app for managing golf leagues. It tracks courses, rounds, leagues, members, and player scorecards with interactive score entry, skins, and handicap calculations. The app uses fake/mock data repositories with no backend.

---

## Phase 1: Foundation

### 1.1 Move `go_router` to runtime dependencies
Move `go_router` from `dev_dependencies` to `dependencies` in `pubspec.yaml` — it's used at runtime.

### 1.2 Strengthen linting rules
Modify `analysis_options.yaml`:
- Add `include: package:flutter_lints/flutter.yaml`
- Enable `strict-casts`, `strict-raw-types`
- Add rules: `avoid_print`, `prefer_const_constructors`, `prefer_final_locals`, `require_trailing_commas`, `unawaited_futures`

### 1.3 Build theme system
Create `lib/app/core/theme/` with four files:
- `theme.dart` — `GreenieTheme` with light and dark `ThemeData`
- `colors.dart` — `GreenieColors` with brand colors and score palettes
- `sizes.dart` — `GreenieSizes` spacing scale in multiples of 4 (extraSmall, small, medium, large, extraLarge)
- `text_styles.dart` — `GreenieTextStyles`

Move score colors to a `GolfScore` enum in `lib/app/core/enums/golf_score.dart`. Update `lib/main.dart` to pass `theme`, `darkTheme`, and `themeMode: ThemeMode.system` to `MaterialApp.router`.

Design principles: no separate design constants file; spacing lives in `sizes.dart`; no hardcoded widget sizes — use flex layouts, padding, and Column/Row `spacing`; component sizing inlined only where absolutely necessary (e.g. scorecard grid cells).

### 1.4 Create shared widgets
- `lib/app/presentation/components/section_header.dart` — titled section with optional trailing action
- `lib/app/presentation/components/info_card.dart` — themed Card wrapper with optional `onTap`
- `lib/app/presentation/components/empty_state.dart` — icon + message for empty lists
- `lib/app/core/extensions/date_extensions.dart` — display formatting for dates

### 1.5 Redesign existing screens
- Dark-green AppBar, green CTA button with chevron arrow, leaderboard with CircleAvatars
- Responsive layouts using flex values and GridView (supports iPad)
- No SizedBox spacers — use Column/Row `spacing` parameter and Padding instead
- Update all widget files to use theme constants

### App state after Phase 1
The app compiles and runs with a polished light/dark theme. The existing HomeScreen renders with the updated design: dark green AppBar, green CTA button with arrow, leaderboard with avatars, and scorecard with colored score cells. Dark mode applies automatically based on system preference.

---

## Phase 2: Data Layer

### 2.1 User and Member models
- Modify `lib/user/user_model.dart` — `UserModel` with `id`, `name`, `email`, `isAdmin`, `memberId`
- Create `lib/user/infrastructure/models/member_model.dart` — `MemberModel` with `id`, `name`, `handicap`, and computed `initials` getter

### 2.2 Update existing models with IDs
- Modify `lib/course/infrastructure/models/course.dart` — add `id` field
- Modify `lib/league/infrastructure/models/league_model.dart` — add `id`, `memberIds`, `adminId`, `teams` fields
- Update fake repositories to include IDs and member lists

### 2.3 Round and Score models
- Create `lib/round/infrastructure/models/round_status.dart` — enum: `upcoming`, `inProgress`, `completed`
- Create `lib/round/infrastructure/models/round_model.dart` — `id`, `leagueId`, `courseId`, `date`, `status`, `holeNumbers`, `scores`, `matchups`
- Create `lib/round/infrastructure/models/score_model.dart` — `memberId`, `holeScores` (`Map<int,int>`), `totalStrokes` getter
- Create `lib/round/infrastructure/models/score_relative_to_par.dart` — enum with `fromDifference(int)` factory (eagle ≤−2, birdie −1, par 0, bogey +1, double +2, triple+ ≥+3)

### 2.4 Scoring models for league matchups
- Create `lib/league/infrastructure/models/team_model.dart` — `TeamModel` with `id`, `leagueId`, `memberIds` (exactly 2), `name`
- Create `lib/round/infrastructure/models/matchup_model.dart` — `MatchupModel` with `id`, `roundId`, `team1Id`, `team2Id`
- Create `lib/round/infrastructure/models/matchup_result.dart` — three classes: `PointResult`, `HoleMatchupResult`, `MatchupResult`; plus `enum MatchupOutcome { win, loss, tie }`
- Create `lib/league/infrastructure/models/team_standing.dart` — `TeamStanding` with `team`, `wins`, `losses`, `ties`, `totalPoints`, `rank`, and computed `roundsPlayed` getter

### 2.5 Repositories
- Create `lib/round/infrastructure/round_repository.dart` — abstract with `fetchRoundsForLeague`, `fetchRound`, `updateScore`, `startRound`
- Create `lib/round/infrastructure/fake_round_repository.dart` — 6 rounds: 4 completed (with rich scores), 1 in-progress, 1 upcoming; matchups on all rounds; all 14 members covered
- Create `lib/user/infrastructure/user_repository.dart` — abstract with `getCurrentUser`, `fetchMembersForLeague`
- Create `lib/user/infrastructure/fake_user_repository.dart` — hardcoded admin user (`memberId: 'member-1'`) + 14 members with varied handicaps

### 2.6 Providers
- Create `lib/round/round_providers.dart` — `@riverpod` providers for round repository, `fetchRoundsForLeague`, `fetchRound`, `fetchMatchupResult`
- Create `lib/user/user_providers.dart` — `@riverpod` providers for user repository, `currentUser`, `fetchMembers`
- Modify `lib/league/league_providers.dart` — add `fetchStandings` provider
- Run `dart run build_runner build --delete-conflicting-outputs` to generate `*.g.dart`

### App state after Phase 2
The app compiles with a full data layer. Fake repositories provide leagues, rounds, members, and teams. All providers resolve correctly. No visible UI changes yet — this phase is purely foundational.

---

## Phase 3: League Home + Routing

### 3.1 Update HomeScreen as league list
Rewrite `lib/app/presentation/home_screen.dart` — show a list of leagues, each tappable to navigate to `/league/:id`.

### 3.2 Redesign LeagueHomeScreen
Rewrite `lib/league/presentation/league_home_screen.dart` as a `ConsumerWidget` receiving `leagueId` via route param. Watches league, rounds, members, standings, and currentUser providers.

Create supporting components:
- `lib/league/presentation/components/league_info_header.dart` — league name (headline), course name + day (subtitle with icons)
- `lib/league/presentation/components/upcoming_round_card.dart` — InfoCard showing next round date/course, tappable to round detail

### 3.3 Members List Screen
- Create `lib/league/presentation/members_screen.dart` — `ConsumerStatefulWidget` with alphabetical/handicap sort toggle using `SegmentedButton<bool>`; `_sorted()` helper sorts by name (default) or handicap ASC with alpha tiebreaker
- Create `lib/league/presentation/components/member_list_tile.dart` — `ListTile` with `CircleAvatar` initials, name, and handicap trailing text; `emphasizeHandicap` flag renders handicap as bold `titleLarge` when in handicap sort mode

### 3.4 Add routes
Modify `lib/app/core/routing.dart` to add routes for `/league/:leagueId` and `/league/:leagueId/members`.

### App state after Phase 3
Tapping a league on the home screen opens the league home. The screen shows the league name, course name, and day of the week. An "upcoming round" card shows the next scheduled round. A Members link navigates to the member list. Members can be sorted alphabetically or by handicap via a toggle.

---

## Phase 4: Round Feature

### 4.1 Round List Screen
- Create `lib/round/presentation/round_list_screen.dart` — watches `fetchRoundsForLeague`, shows `ListView` sorted by date with status chips
- Create `lib/round/presentation/components/round_list_tile.dart` — InfoCard with course name, date, status indicator, tap navigates to round detail

### 4.2 Round Detail Screen
- Create `lib/round/presentation/round_detail_screen.dart` — watches `fetchRound` + `currentUser`; shows round info, Start/Continue button based on status, leaderboard if scores exist
- Create `lib/round/presentation/components/round_info_section.dart` — Card with course name, date, hole count, status chip
- Create `lib/round/presentation/components/round_leaderboard.dart` — ranked list of players by total strokes with relative-to-par display and gross/net toggle
- Create `lib/round/presentation/components/start_round_button.dart` — full-width `FilledButton`

### 4.3 Add routes
Modify `lib/app/core/routing.dart` to add routes for `/league/:leagueId/rounds` and `/league/:leagueId/round/:roundId`.

### App state after Phase 4
The league home now shows a list of past and upcoming rounds. Tapping a completed round opens the round detail with a leaderboard showing player rankings and scores relative to par. Upcoming rounds show a "Start Round" button. In-progress rounds show a "Continue Round" button.

---

## Phase 5: Scorecard + Score Entry

### 5.1 Enhanced Scorecard with golf indicators
Rewrite `lib/course/presentation/components/scorecard.dart` — takes `RoundModel` + members + course, supports `isEditable` mode. Horizontally-scrollable table: hole header row, par row, one row per player, skins row, totals.

Create supporting components:
- `lib/course/presentation/components/score_cell.dart` — individual score cell with visual golf indicators via `GreenieScoreColors` theme extension: circle for birdie, double-circle for eagle, square for bogey, double-square for double bogey, filled for triple+. Tappable when editable.
- `lib/course/presentation/components/hole_header_cell.dart`
- `lib/course/presentation/components/scorecard_row.dart`
- `lib/course/presentation/components/scorecard_totals.dart`

### 5.2 Score input flow
- Create `lib/round/presentation/score_entry_screen.dart` — `ConsumerStatefulWidget` managing local score edits; editable Scorecard + Save action in AppBar
- Create `lib/round/presentation/components/score_input_bottom_sheet.dart` — number picker (ChoiceChips 1–10) shown when tapping an editable ScoreCell

### 5.3 Skins calculator
Create `lib/round/infrastructure/skins_calculator.dart` — pure Dart: for each hole, lowest unique score wins the skin; ties = no skin. Skins row rendered inline in `scorecard.dart`.

### 5.4 Handicap calculator
Create `lib/round/infrastructure/handicap_calculator.dart` — computes strokes per hole based on member handicap and hole count. Net score row rendered inline in `scorecard.dart` below each player's row.

### 5.5 Wire scorecard into round detail
- Modify `lib/app/core/routing.dart` to add `/league/:leagueId/round/:roundId/scorecard`
- Modify `lib/round/presentation/round_detail_screen.dart` to embed a read-only Scorecard for completed/in-progress rounds

### App state after Phase 5
Completed rounds show a full scorecard with color-coded golf indicators (circles for birdies/eagles, squares for bogeys/doubles), a skins row, and a net score row per player. Tapping "Continue Round" opens the score entry screen where players can tap cells to enter scores via a number picker. Saving persists scores and updates the leaderboard.

---

## Phase 6: Tests + Cleanup

### 6.1 Unit tests for models
Mirror `lib/` structure under `test/`. Test constructors, computed properties (`totalPar`, `totalStrokes`, `ScoreRelativeToPar.fromDifference`), edge cases.

### 6.2 Unit tests for calculators and repositories
- Skins calculator: clear winners, ties, empty/partial scores
- Handicap calculator: stroke distribution, net scores
- Fake repositories: expected data, mutation methods (`updateScore`, `startRound`)

### 6.3 Widget tests for screens and components
Each screen: test loading/error/data states, navigation triggers, user interactions. Wrap in `ProviderScope` with overridden providers and `MaterialApp` with theme.

### 6.4 Remove dead code
- Delete `lib/course/infrastructure/course_service.dart` — empty file, never imported
- Remove unused constants from `theme.dart`: `clubhouseCream`, `doubleExtraLarge`
- Remove unused `shortDate` getter from `date_extensions.dart` and its test
- Remove unused `copyWithHoleScore` method from `score_model.dart` and its test

### 6.5 Fix icon rendering
Replace icons that render as glyphs on some devices:
- `Icons.emoji_events` → `Icons.flag`, `Icons.sports_golf` → `Icons.flag_outlined`
- `Icons.leaderboard` → `Icons.bar_chart`, `Icons.admin_panel_settings` → `Icons.settings`
- Add `uses-material-design: true` to `pubspec.yaml`

### 6.6 Fix miscellaneous issues
- Replace `\u2022` bullet separators in `home_screen.dart`, `upcoming_round_card.dart`, and `round_list_tile.dart` with Row + small dot icon
- Fix hardcoded sizes to use `GreenieSizes` constants
- Fix stale null checks (fetchLeague is non-nullable)
- Fix duplicate member IDs in `fake_user_repository.dart` (members 7–14 now have unique IDs)

### App state after Phase 6
All screens remain functionally identical. 173 tests pass across 44 test files with 96.5% line coverage. Zero analyzer issues. No hardcoded sizes, dead code, or rendering glitches.

---

## Phase 7: Bottom Navigation + Stats

### 7.1 Theme provider
Create `lib/app/core/app_providers.dart` — `ThemeModeNotifier` (Riverpod `@riverpod` class) that holds `ThemeMode` state with a `setThemeMode` method. Generated as `themeModeProvider`. Modify `lib/main.dart` to watch `themeModeProvider` and pass it to `MaterialApp.router`.

### 7.2 Settings screen
Create `lib/app/presentation/settings_screen.dart` — `ConsumerWidget` with `RadioGroup<ThemeMode>` (System/Light/Dark). Add route `/league/:leagueId/settings`.

### 7.3 Bottom navigation
Embed `NavigationBar` (League / Stats tabs) directly in `LeagueHomeScreen` (selectedIndex: 0) and `StatsScreen` (selectedIndex: 1). Each uses `context.go()` to switch tabs. This avoids GoRouter's `StatefulShellRoute` limitation with parameterized routes.

### 7.4 Stats screen
Create `lib/league/presentation/stats_screen.dart` — `ConsumerStatefulWidget` with:
- `SegmentedButton<bool>` toggle: Personal / League views
- 2×2 `GridView` of `StatCard` widgets (rounds played, avg score, best score, season points)
- Recent rounds `ListView` section

Create `lib/league/presentation/components/stat_card.dart` — Card with label + value.

Add route `/league/:leagueId/stats` as a child of `/league/:leagueId`.

### 7.5 Gear menu (popup)
Replace the AppBar gear `IconButton` in `LeagueHomeScreen` with `PopupMenuButton<_MenuAction>` (private enum: `settings`, `admin`). Settings navigates to `/league/:leagueId/settings`. Admin item shown conditionally based on `currentUser.isAdmin`.

### App state after Phase 7
The league home and stats screens share a bottom nav bar. Tapping Stats shows personal stats (rounds played, avg score, best round, season points) and a recent rounds list; a toggle switches between Personal and League views. Tapping the gear icon opens a popup with Settings (and Admin for admins). The Settings screen lets users choose System/Light/Dark theme.

---

## Phase 8: League Scoring

### 8.1 League scoring calculator
Create `lib/round/infrastructure/league_scoring_calculator.dart` with two public functions:

`calculateMatchupResult({matchup, team1, team2, members, scores, holeNumbers})`:
1. Resolve both teams' `MemberModel`s
2. Assign A/B: lower handicap = A; tie → list order
3. Call `calculateHandicapStrokes` for all 4 players
4. For each hole: compute net scores for all 4; skip incomplete holes
5. Award per-hole points (A vs A, B vs B, team net combined — 5 pts per hole)
6. Round bonus: sum nets across all complete holes, same 3-way comparison (5 pts)
7. Return `MatchupResult`

`calculateStandings({teams, completedRounds, members})`:
- For each completed round, for each matchup, call `calculateMatchupResult`
- Accumulate W/L/T and total points per team
- Sort by `totalPoints` descending, assign dense ranks

### 8.2 Fake data expansion
Update `lib/league/infrastructure/fake_league_repository.dart`:
- Expand `league-1` `memberIds` to all 14
- Add 7 teams of 2 (varied handicap combos for interesting A/B results):
  - team-1: Ben (hdcp 1) + Joel (hdcp 17) — "Casciano / Bremer"
  - team-2: Brady (hdcp 2) + Matt (hdcp 12) — "Greenman / Ayers"
  - team-3: Aaron (hdcp 3) + Brett (hdcp 15) — "Greenman / Knaus"
  - team-4: Ryan C (hdcp 5) + Ryan A (hdcp 12) — "Confer / Ayers"
  - team-5: Andrew (hdcp 6) + Mike (hdcp 8) — "Dunscombe / Mike"
  - team-6: Brandon (hdcp 9) + Jake (hdcp 11) — "Ayers / Steggles"
  - team-7: AJ (hdcp 10) + Adam (hdcp 10) — "Greenman / Boelkins" (matching handicaps → AJ = A by list order)

Update `lib/round/infrastructure/fake_round_repository.dart`:
- Add 3 matchups per round (7 teams = 1 bye per round, byes rotate)
- Expand scores to cover all 12 playing members per round
- Round 5 (in-progress): partial scores for active matchup members
- Round 6 (upcoming): no scores, matchups defined

### 8.3 New providers
- Add `fetchMatchupResult(roundId, matchupId)` to `lib/round/round_providers.dart`
- Add `fetchStandings(leagueId)` to `lib/league/league_providers.dart`
- Run `dart run build_runner build --delete-conflicting-outputs`

### 8.4 Leaderboard gross/net toggle
Modify `lib/round/presentation/components/round_leaderboard.dart`:
- Convert to `ConsumerStatefulWidget` with `bool _showNet = false`
- Add `SegmentedButton<bool>` (Gross / Net) above the list
- In net mode: compute net total using `calculateHandicapStrokes` + `netScore`; sort by net total

### 8.5 MatchupCard component
Create `lib/round/presentation/components/matchup_card.dart` — `ConsumerWidget` that watches `fetchMatchupResult`. Shows team names, current point totals (e.g. "21.5 – 28.5"), outcome chip if complete. Taps to `/league/$leagueId/round/$roundId/matchup/${matchup.id}`.

Modify `lib/round/presentation/round_detail_screen.dart` to show `MatchupCard` (below `RoundInfoSection`, above `RoundLeaderboard`) when the current user's team has a matchup in this round.

### 8.6 MatchupDetailScreen
Create `lib/round/presentation/matchup_detail_screen.dart` — `ConsumerWidget` that watches `fetchMatchupResult`. Layout:
1. Header card: team names, grand totals, outcome chip
2. Per-hole table (horizontally scrollable): Hole | A1 Net | A2 Net | A Pts | B1 Net | B2 Net | B Pts | T1 Net | T2 Net | Team Pts
3. Bonus section: round total A, B, team comparisons + bonus points
4. Grand total row: total pts each team + W/L/T

### 8.7 StandingsScreen
Create `lib/league/presentation/standings_screen.dart` — watches `fetchStandingsProvider`. `ListView.builder` over `List<TeamStanding>`: rank, team name, W-L-T record, total points. Highlights current user's team. Empty state uses `EmptyState` widget.

### 8.8 Routing
Add to `lib/app/core/routing.dart`:
- `/league/:leagueId/standings` → `StandingsScreen`
- `/league/:leagueId/round/:roundId/matchup/:matchupId` → `MatchupDetailScreen`

Run `dart run build_runner build --delete-conflicting-outputs`.

### 8.9 Tests
- `test/round/infrastructure/league_scoring_calculator_test.dart` — A/B assignment, per-hole points, tie splits, bonus round, `team1GrandTotal + team2GrandTotal == 50.0` invariant, partial rounds, `calculateStandings` accumulation and ranking
- `test/round/infrastructure/models/matchup_result_test.dart` — computed getters, `MatchupOutcome`
- `test/league/infrastructure/models/team_standing_test.dart` — `roundsPlayed`
- Widget tests for `MatchupCard`, `MatchupDetailScreen`, `StandingsScreen`, `RoundLeaderboard` (gross/net toggle), and `RoundDetailScreen` (MatchupCard present/absent)

### App state after Phase 8
Completed rounds show a MatchupCard when the current user's team has a matchup. Tapping the card opens a per-hole breakdown table showing A-player, B-player, and team net comparisons with point totals per hole plus bonus round points. The leaderboard has a gross/net toggle. The Standings screen shows all 7 teams ranked by season points with W-L-T records. The current user's team is highlighted.

---

## Phase 9: League Home Enhancements

### 9.1 Shared PreviewTable widget
Create `lib/league/presentation/components/preview_table.dart`:
- `enum PreviewCellStyle { rank, name, secondary, value }` — controls text style and alignment
- `class PreviewColumn` — `label`, `style`, optional `flex` or fixed `width`, `alignment`
- `class PreviewRow` — `cells` (List<String>), `isHighlighted`, optional `onTap`
- `class PreviewTable extends StatelessWidget` — renders a `Card` with a header row, data rows (highlighted row gets primary color + `InkWell`), divider, and a "view all" footer tap target

### 9.2 Standings preview
Rewrite `lib/league/presentation/components/standings_preview.dart` to use `PreviewTable`:
- Columns: `#` (rank, w32), Team (name, flex), W-L-T (secondary, w56, center), Pts (value, w40, end)
- Windowing: user in middle ±1 neighbor; user at index 0 → top 3; user at last → bottom 3; ≤3 total → show all
- Each row taps to `/league/$leagueId/standings`

### 9.3 Members preview
Create `lib/league/presentation/components/members_preview.dart`:
- Sort members by handicap ASC (alpha tiebreaker), assign rank
- Apply same windowing logic as standings preview
- Columns: `#` (rank, w32), Player (name, flex), Hdcp (value, w48, end)
- Each row taps to `/league/$leagueId/members`

### 9.4 Rounds preview
Create `lib/league/presentation/components/rounds_preview.dart`:
- Filter completed rounds where the current user has a score entry
- Sort by date descending, take at most 3
- Columns: Date (name, flex), Score (value, w48, end)
- Each row taps to `/league/$leagueId/round/${round.id}`

### 9.5 League home screen overhaul
Modify `lib/league/presentation/league_home_screen.dart`:
- Watch `fetchStandingsProvider`, `fetchMembersProvider`, and `fetchRoundsForLeague`
- Section order (top to bottom): Standings → Recent Rounds → Members
- Use `SectionHeader` + respective preview widget for each section
- Show `UpcomingRoundCard` above sections when a round is upcoming or in-progress
- Remove `LeagueQuickLinks` entirely

### 9.6 Members screen sort toggle
Modify `lib/league/presentation/members_screen.dart`:
- Convert to `ConsumerStatefulWidget` with `bool _sortByHandicap = false`
- Add `_sorted()` method: alpha by default, handicap ASC with alpha tiebreaker
- Add `SegmentedButton<bool>` (Name / Handicap) above the `ListView`
- Pass `emphasizeHandicap: _sortByHandicap` to each `MemberListTile`

### 9.7 Member list tile enhancement
Modify `lib/league/presentation/components/member_list_tile.dart`:
- Add `emphasizeHandicap: bool = false` parameter
- When `false`: handicap as `bodySmall` in outline color
- When `true`: handicap as `titleLarge` bold (large number fills the trailing space without overflow)
- Remove "HC " prefix in both modes — the sort toggle label implies the meaning

### App state after Phase 9
The league home shows three inline preview tables: Standings (with W-L-T and points), Recent Rounds (dates and scores), and Members (with handicap ranks). Each table windows around the current user with ±1 neighbors. Every row is tappable and navigates to the detail screen for that entity. The Members screen has a sort toggle that switches between alphabetical order and handicap order; in handicap mode the handicap number is displayed large and bold.
