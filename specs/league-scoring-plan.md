# Phase 9: League Scoring

## Context

Greenie needs to support the actual scoring system used by golf leagues. Every league has season-long teams of 2 players. Each round, teams are paired in matchups. Scoring is based on handicap-adjusted (net) scores: within each matchup, the A player (lower handicap) plays the opposing A player, the B player plays the opposing B player, and team net totals are compared. A/B designation is dynamic — determined each round based on current handicap, not fixed at season start.

This phase adds the full data model and calculator, fake data for 7 teams / 6 rounds, a per-round matchup breakdown view, season standings, and a gross/net toggle on the leaderboard.

See `specs/league-scoring.md` for the scoring rules reference.

---

## Step 1 — New models (pure Dart, no dependencies)

### `lib/league/infrastructure/models/team_model.dart`
```
TeamModel { id, leagueId, memberIds (List<String>, exactly 2), name (e.g. "Casciano / Bremer") }
```

### `lib/round/infrastructure/models/matchup_model.dart`
```
MatchupModel { id, roundId, team1Id, team2Id }
```

### `lib/round/infrastructure/models/matchup_result.dart`
Three classes:
- `PointResult { team1Points, team2Points }` — doubles (handles 0.5 ties)
- `HoleMatchupResult { holeNumber, team1ANet, team2ANet, team1BNet, team2BNet, team1TeamNet, team2TeamNet, aPoints (PointResult), bPoints (PointResult), teamPoints (PointResult) }` — computed getters: `team1HoleTotal`, `team2HoleTotal`
- `MatchupResult { matchup, team1, team2, team1AMember, team2AMember, team1BMember, team2BMember, holeResults, bonusAPoints, bonusBPoints, bonusTeamPoints }` — computed: `team1GrandTotal`, `team2GrandTotal`, `team1Outcome`, `team2Outcome`
- `enum MatchupOutcome { win, loss, tie }`

### `lib/league/infrastructure/models/team_standing.dart`
```
TeamStanding { team, wins, losses, ties, totalPoints, rank }
computed: roundsPlayed getter
```

---

## Step 2 — Update existing models

### `lib/league/infrastructure/models/league_model.dart`
Add required field: `teams: List<TeamModel>`

### `lib/round/infrastructure/models/round_model.dart`
Add required field: `matchups: List<MatchupModel>`
Update `copyWith` to include `matchups`.

### `lib/user/user_model.dart`
Add required field: `memberId: String` (links UserModel → MemberModel)

**Breaking changes:** Every constructor callsite for these 3 models needs updating. Affected: fake repositories, all test files that construct these models directly. Add `teams: const []` / `matchups: const []` / `memberId: ''` as needed in tests that don't exercise the new fields.

---

## Step 3 — Calculator

### `lib/round/infrastructure/league_scoring_calculator.dart`

Two public functions:

**`calculateMatchupResult({matchup, team1, team2, members, scores, holeNumbers}) → MatchupResult`**

Logic:
1. Resolve both teams' MemberModels from `members` list
2. Assign A/B: lower handicap = A. Tie → use list order (index 0 = A)
3. Call `calculateHandicapStrokes(handicap, holeNumbers)` for all 4 players (reuse existing `lib/round/infrastructure/handicap_calculator.dart`)
4. For each hole: compute net scores for all 4 players. Only include holes where all 4 have a gross score (skip incomplete holes gracefully)
5. Award per-hole points using `_awardPoints(int score1, int score2, double max)` helper: lower score wins, tie splits
6. Round bonus: sum nets across all complete holes for each player/team, apply same 3-way comparison
7. Return `MatchupResult`

**`calculateStandings({teams, completedRounds, members}) → List<TeamStanding>`**

Logic: for each completed round, for each matchup, call `calculateMatchupResult`. Accumulate W/L/T and total points per team. Sort by `totalPoints` descending, assign dense ranks.

---

## Step 4 — Providers (run build_runner after)

### `lib/round/round_providers.dart` — add:
```dart
@riverpod
Future<MatchupResult> fetchMatchupResult(Ref ref, String roundId, String matchupId)
```
Fetches round → finds matchup → fetches league (for teams) → fetches members → calls calculator.

### `lib/league/league_providers.dart` — add:
```dart
@riverpod
Future<List<TeamStanding>> fetchStandings(Ref ref, String leagueId)
```
Fetches league + completed rounds + members → calls `calculateStandings`.

---

## Step 5 — Fake data updates

### `lib/user/infrastructure/fake_user_repository.dart`
Update `getCurrentUser()` to include `memberId: 'member-1'`.

### `lib/league/infrastructure/fake_league_repository.dart`
- Expand league-1 `memberIds` to all 14 (`member-1` through `member-14`)
- Add 7 teams of 2 (pairing by interesting handicap combos for varied A/B results):

```
team-1: member-14 (Ben, hdcp 1)   + member-13 (Joel, hdcp 17)  → "Casciano / Bremer"
team-2: member-6  (Brady, hdcp 2) + member-10 (Matt, hdcp 12)  → "Greenman / Ayers"
team-3: member-4  (Aaron, hdcp 3) + member-8  (Brett, hdcp 15) → "Greenman / Knaus"
team-4: member-7  (Ryan C, hdcp 5)+ member-9  (Ryan A, hdcp 12)→ "Confer / Ayers"
team-5: member-11 (Andrew, hdcp 6)+ member-3  (Mike, hdcp 8)   → "Dunscombe / Mike"
team-6: member-2  (Brandon, hdcp 9)+ member-12 (Jake, hdcp 11) → "Ayers / Steggles"
team-7: member-1  (AJ, hdcp 10)   + member-5  (Adam, hdcp 10)  → "Greenman / Boelkins"
```

Note: team-7 has matching handicaps (10/10) — good edge case, tiebreaker = list order (AJ = A).

- league-2 gets `teams: const []` (not in scope this phase)

### `lib/round/infrastructure/fake_round_repository.dart`
- Add `matchups` to all 6 rounds (3 matchups each; 7 teams = 1 bye per round, rotate byes)
- Expand scores for rounds 1–4 to cover all 12 playing members per round (not just the current 4)
- Round 5 (in-progress): partial scores for active matchup members
- Round 6 (upcoming): no scores, matchups defined

Matchup ID pattern: `'matchup-{roundNum}-{index}'`

Matchup schedule (byes rotate, team-7 = AJ's team, shown in most rounds for demo):
- Round 1: team-1 vs team-2, team-3 vs team-4, team-5 vs team-6 (bye: team-7)
- Round 2: team-1 vs team-3, team-2 vs team-5, team-4 vs team-7 (bye: team-6)
- Round 3: team-1 vs team-4, team-2 vs team-7, team-3 vs team-6 (bye: team-5)
- Round 4: team-1 vs team-5, team-2 vs team-6, team-3 vs team-7 (bye: team-4)
- Round 5: team-1 vs team-6, team-2 vs team-4, team-5 vs team-7 (bye: team-3)
- Round 6: team-1 vs team-7, team-3 vs team-5, team-4 vs team-6 (bye: team-2)

---

## Step 6 — UI: Leaderboard gross/net toggle

**Modify `lib/round/presentation/components/round_leaderboard.dart`**

- Convert from `ConsumerWidget` → `ConsumerStatefulWidget` (add `bool _showNet = false` state)
- Add `SegmentedButton<bool>` above the list: "Gross" / "Net"
- External signature unchanged (`round`, `leagueId`)
- When net mode: compute `_netTotal(ScoreModel score, int handicap, List<int> holeNumbers)` using existing `calculateHandicapStrokes` + `netScore`. Sort by net total. Display net score instead of gross.
- Members fetched internally as before (already a `ConsumerWidget`)

---

## Step 7 — UI: MatchupCard component

**New file: `lib/round/presentation/components/matchup_card.dart`**

```dart
class MatchupCard extends ConsumerWidget {
  const MatchupCard({super.key, required this.matchup, required this.roundId, required this.leagueId});
  final MatchupModel matchup;
  final String roundId;
  final String leagueId;
}
```

Watches `fetchMatchupResultProvider(roundId, matchup.id)`. Displays: team names, current point totals (e.g. "21.5 – 28.5"), outcome chip if complete. Taps → `/league/$leagueId/round/$roundId/matchup/${matchup.id}`.

**Modify `lib/round/presentation/round_detail_screen.dart`**
- Add watch on `fetchLeagueProvider(leagueId)` and `currentUserProvider`
- Find the current user's team from `league.teams` using `currentUser.memberId`
- Find their matchup in `round.matchups`
- Show `MatchupCard` below `RoundInfoSection`, above `RoundLeaderboard` (only when matchup found)

---

## Step 8 — UI: MatchupDetailScreen

**New file: `lib/round/presentation/matchup_detail_screen.dart`**

```dart
class MatchupDetailScreen extends ConsumerWidget {
  const MatchupDetailScreen({super.key, required this.leagueId, required this.roundId, required this.matchupId});
}
```

Watches `fetchMatchupResultProvider(roundId, matchupId)`.

Layout (SingleChildScrollView):
1. **Header card**: Team 1 name vs Team 2 name, grand totals, outcome chip
2. **Per-hole table card**: horizontally scrollable. Columns: Hole | [A1 initials] Net | [A2 initials] Net | A Pts | [B1 initials] Net | [B2 initials] Net | B Pts | T1 Net | T2 Net | Team Pts. Show "—" for incomplete holes.
3. **Bonus section card**: Round total A, B, Team comparisons + bonus points
4. **Grand total row**: total pts each team + W/L/T

Helper: `_formatPts(double pts)` → show as int if whole number ("2" not "2.0"), else 1 decimal.

---

## Step 9 — UI: StandingsScreen

**New file: `lib/league/presentation/standings_screen.dart`**

Watches `fetchStandingsProvider(leagueId)`.

Layout: `ListView.builder` over `List<TeamStanding>`, each row showing rank, team name, W-L-T record, total points. Highlight the current user's team (watch `currentUserProvider`, find their team). Empty state: use existing `EmptyState` widget.

**Wire up dead Standings link:**
In `lib/league/presentation/components/league_quick_links.dart`, update Standings `onTap` to navigate to `/league/$leagueId/standings`.

---

## Step 10 — Routing

**Modify `lib/app/core/routing.dart`:**

```
/league/:leagueId/standings → StandingsScreen
/league/:leagueId/round/:roundId/matchup/:matchupId → MatchupDetailScreen
```

Matchup route nested under `round/:roundId` (alongside existing `scorecard` route).

Run `dart run build_runner build --delete-conflicting-outputs` after.

---

## Step 11 — Tests

**New unit tests:**
- `test/round/infrastructure/league_scoring_calculator_test.dart`
  - A/B assignment (lower hdcp = A, tie → list order)
  - Per-hole: A wins, B wins, tie (0.5pt split)
  - Team net: lower combined wins, tie (0.5pt)
  - Bonus: round total comparison
  - Invariant: `team1GrandTotal + team2GrandTotal == 50.0` for complete 9-hole round
  - Partial round (in-progress): only complete holes counted
  - `calculateStandings`: W/L/T accumulation, ranking
- `test/round/infrastructure/models/matchup_result_test.dart` — computed getters, `MatchupOutcome`
- `test/league/infrastructure/models/team_standing_test.dart` — `roundsPlayed`

**Updated unit tests (add missing required fields):**
- `test/league/infrastructure/models/league_model_test.dart` — add `teams: []`
- `test/round/infrastructure/models/round_model_test.dart` — add `matchups: const []`, test `copyWith` with matchups
- `test/user/user_model_test.dart` — add `memberId`
- `test/user/infrastructure/fake_user_repository_test.dart` — assert `memberId == 'member-1'`
- `test/league/infrastructure/fake_league_repository_test.dart` — assert `teams.length == 7`; also fix stale assertion on line 19 (`'Wednesday Amateur Players (WAP)'` → `'Wednesday Amateur Players'`)
- `test/round/infrastructure/fake_round_repository_test.dart` — assert completed rounds have matchups

**New widget tests:**
- `test/round/presentation/components/round_leaderboard_test.dart` — add group: SegmentedButton visible, net toggle changes displayed scores
- `test/round/presentation/components/matchup_card_test.dart` — shows team names, score, navigates
- `test/round/presentation/matchup_detail_screen_test.dart` — loading/error/data states; per-hole table present
- `test/league/presentation/standings_screen_test.dart` — loading/error/data states; ranked teams shown
- `test/round/presentation/round_detail_screen_test.dart` — MatchupCard present when user in matchup, absent when on bye

---

## Critical files

| File | Change |
|------|--------|
| `lib/league/infrastructure/models/league_model.dart` | Add `teams` field |
| `lib/round/infrastructure/models/round_model.dart` | Add `matchups` field + copyWith |
| `lib/user/user_model.dart` | Add `memberId` field |
| `lib/league/infrastructure/fake_league_repository.dart` | 7 teams, all 14 memberIds |
| `lib/round/infrastructure/fake_round_repository.dart` | Matchups on all rounds, expanded scores |
| `lib/round/infrastructure/league_scoring_calculator.dart` | New — core logic |
| `lib/round/round_providers.dart` | Add `fetchMatchupResult` provider |
| `lib/league/league_providers.dart` | Add `fetchStandings` provider |
| `lib/round/presentation/round_detail_screen.dart` | Integrate MatchupCard |
| `lib/app/core/routing.dart` | 2 new routes |

---

## Verification

1. `flutter analyze` — zero issues
2. `dart format . --set-exit-if-changed`
3. `flutter test` — all tests pass (~230+ expected after additions)
4. Manual walkthrough:
   - League home → Standings → 7 teams ranked by season points with W-L-T
   - Completed round → MatchupCard shows your team's score vs opponent
   - Tap MatchupCard → MatchupDetailScreen with per-hole breakdown table
   - Leaderboard toggle switches gross ↔ net ranking
   - In-progress round → MatchupCard shows partial score (only complete holes)
   - Round where current user has a bye → no MatchupCard shown
