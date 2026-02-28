# Commissioner / Admin Features — Implementation Plan

## Context

Every league has a commissioner who handles admin logistics: schedule coordination with the course, and maintaining accurate scorecards. The spec calls out scorecard corrections as the most common need. Regular users should be completely unaware admin functionality exists — it's invisible to them.

The foundation is already partially in place: `LeagueModel.adminId` stores the commissioner's user ID, `UserModel.isAdmin` exists (though it's a global flag — we'll fix the guard to check per-league), and the league home screen already has a conditional "Admin" popup menu item that goes nowhere.

---

## What We're Building

1. Fix the per-league admin role check (one-line change)
2. Wire the "Admin" menu item to a new admin hub screen
3. Admin hub screen — entry point for all admin features
4. Schedule management — set front/back nine and per-team tee times per round
5. Scorecard correction — admin edits any player's scores in any round

Deferred (per spec): messaging/push notifications, proxies, skins.

---

## Part 1 — Fix Per-League Admin Check

**File:** `lib/league/presentation/league_home_screen.dart`

Replace the global `isAdmin` derivation (line 35–38) with a per-league check. Both `userAsync` and `leagueAsync` are already in scope:

```dart
// Before:
final isAdmin = switch (userAsync) {
  AsyncData(value: final u) => u.isAdmin,
  _ => false,
};

// After:
final isAdmin = switch ((userAsync, leagueAsync)) {
  (AsyncData(value: final u), AsyncData(value: final league)) =>
    u.id == league.adminId,
  _ => false,
};
```

Wire the navigation handler (line 54–55):

```dart
case _MenuAction.admin:
  context.go('/league/$leagueId/admin');
```

---

## Part 2 — Extend `RoundModel`

**File:** `lib/round/infrastructure/models/round_model.dart`

Add two nullable schedule fields and expand `copyWith` to include `holeNumbers` (currently missing from `copyWith`) plus the new fields:

```dart
/// Optional tee time for the round (e.g. 5:30 PM on the round's date).
final DateTime? startTime;

/// Per-team tee times keyed by teamId. Teams absent use [startTime].
final Map<String, DateTime>? teamTeeTimes;
```

Both fields are `null` by default — existing fake data `const` constructors require zero changes.

Updated `copyWith`:
```dart
RoundModel copyWith({
  RoundStatus? status,
  List<ScoreModel>? scores,
  List<MatchupModel>? matchups,
  List<int>? holeNumbers,           // add
  DateTime? startTime,              // add
  Map<String, DateTime>? teamTeeTimes, // add
})
```

---

## Part 3 — Repository: New Schedule Method

**File:** `lib/round/infrastructure/round_repository.dart`

Add one abstract method:

```dart
Future<RoundModel> updateRoundSchedule(
  String roundId, {
  List<int>? holeNumbers,
  DateTime? startTime,
  Map<String, DateTime>? teamTeeTimes,
});
```

Note: `updateScore(roundId, memberId, holeScores)` already exists with the right signature — no new method needed for scorecard correction.

**File:** `lib/round/infrastructure/fake_round_repository.dart`

Implement following the existing `startRound` pattern (indexWhere → copyWith → reassign):

```dart
@override
Future<RoundModel> updateRoundSchedule(
  String roundId, {
  List<int>? holeNumbers,
  DateTime? startTime,
  Map<String, DateTime>? teamTeeTimes,
}) async {
  final index = _rounds.indexWhere((r) => r.id == roundId);
  if (index == -1) throw StateError('Round not found: $roundId');
  _rounds[index] = _rounds[index].copyWith(
    holeNumbers: holeNumbers,
    startTime: startTime,
    teamTeeTimes: teamTeeTimes,
  );
  return _rounds[index];
}
```

---

## Part 4 — New Routes

**File:** `lib/app/core/routing.dart`

Add under the existing `/league/:leagueId` GoRoute:

```dart
GoRoute(
  path: 'admin',
  builder: (context, state) => AdminHubScreen(
    leagueId: state.pathParameters['leagueId']!,
  ),
  routes: [
    GoRoute(
      path: 'schedule/:roundId',
      builder: (context, state) => AdminScheduleScreen(
        leagueId: state.pathParameters['leagueId']!,
        roundId: state.pathParameters['roundId']!,
      ),
    ),
    GoRoute(
      path: 'scorecard/:roundId',
      builder: (context, state) => AdminScorecardScreen(
        leagueId: state.pathParameters['leagueId']!,
        roundId: state.pathParameters['roundId']!,
      ),
    ),
  ],
),
```

Full paths:
- `/league/:leagueId/admin`
- `/league/:leagueId/admin/schedule/:roundId`
- `/league/:leagueId/admin/scorecard/:roundId`

---

## Part 5 — Admin Hub Screen

**New file:** `lib/league/presentation/admin_hub_screen.dart`

`ConsumerWidget` receiving `leagueId`. Watches `fetchRoundsForLeagueProvider(leagueId)`.

```
AppBar: "Commissioner"  (GoRouter back arrow navigates to league home)
Body: SingleChildScrollView > Column
  SectionHeader("Schedule")
  [For each round, sorted by date descending:]
    Card
      Row: round date label + nine label ("Front 9" / "Back 9") + status chip
      Row of two OutlinedButton:
        "Set Schedule"  → context.go('/league/$leagueId/admin/schedule/${round.id}')
        "Correct Scores" → context.go('/league/$leagueId/admin/scorecard/${round.id}')
  EmptyState if no rounds
```

Rounds with `RoundStatus.upcoming` or `inProgress` are most relevant for schedule, `completed` rounds for score corrections — show all, no filtering.

---

## Part 6 — Admin Schedule Screen

**New file:** `lib/league/presentation/admin_schedule_screen.dart`

`ConsumerStatefulWidget` receiving `leagueId` and `roundId`.

**Data:**
- `fetchRoundProvider(roundId)` → current `holeNumbers`, `startTime`, `teamTeeTimes`
- `fetchLeagueProvider(leagueId)` → `teams` list for per-team tee time rows

**Local state (initialized once from round data):**
```dart
List<int> _holeNumbers = [];
DateTime? _roundStartTime;
Map<String, DateTime> _teamTeeTimes = {};
bool _initialized = false;
```

Initialize in `build` after both providers resolve (guard with `_initialized`).

**UI:**
```
AppBar: "Schedule" + save IconButton (Icons.check)
Body: SingleChildScrollView > Column
  SectionHeader("Starting Nine")
  SegmentedButton<String>
    Segment("Front Nine", value: 'front')
    Segment("Back Nine", value: 'back')
    selected: _holeNumbers.contains(1) ? {'front'} : {'back'}
    onSelectionChanged: updates _holeNumbers to [1..9] or [10..18]

  SectionHeader("Tee Times")
  ListTile
    title: "Round Start"
    trailing: _roundStartTime formatted ("5:30 PM") or "Not set"
    onTap: showTimePicker → setState _roundStartTime

  [For each team in league.teams:]
  ListTile
    title: team.name
    trailing: _teamTeeTimes[team.id] formatted or "—"
    onTap: showTimePicker → setState _teamTeeTimes[team.id]
```

**Save (`_save`):**
```dart
final repo = ref.read(roundRepositoryProvider);
await repo.updateRoundSchedule(
  roundId,
  holeNumbers: _holeNumbers,
  startTime: _roundStartTime,
  teamTeeTimes: _teamTeeTimes.isEmpty ? null : _teamTeeTimes,
);
ref.invalidate(fetchRoundProvider(roundId));
ref.invalidate(fetchRoundsForLeagueProvider(leagueId));
// snackbar + context.pop()
```

Note: `showTimePicker` returns a `TimeOfDay`; combine with `round.date` to construct a `DateTime`.

---

## Part 7 — Admin Scorecard Screen

**New file:** `lib/league/presentation/admin_scorecard_screen.dart`

`ConsumerStatefulWidget` receiving `leagueId` and `roundId`.

**Key insight:** `Scorecard` renders rows from `round.scores`, not from `members`. Setting `isEditable: true` makes ALL player rows editable. The admin gets a full multi-player scorecard where any cell can be corrected — which is exactly the right UX for "make corrections."

**Data:**
- `fetchRoundProvider(roundId)` + `fetchLeagueProvider(leagueId)` (for course) + `fetchMembersProvider(leagueId)`

**Local state:**
```dart
// memberId → holeNumber → score  (mirrors ScoreEntryScreen pattern)
Map<String, Map<int, int>> _localScores = {};
bool _initialized = false;
```

Initialize from `round.scores` on first build.

**UI:**
```
AppBar: "Correct Scores" + save IconButton
Body: SingleChildScrollView
  Padding
    Scorecard(
      round: _localRound,   // synthetic round built from _localScores
      course: course,
      members: members,     // all members
      isEditable: true,
      onScoreTap: _onScoreTap,
    )
```

`_localRound` is `round.copyWith(scores: /* built from _localScores */)` — same pattern as `ScoreEntryScreen`.

`_onScoreTap(memberId, holeNumber)` → `showModalBottomSheet(ScoreInputBottomSheet)` → updates `_localScores[memberId]![holeNumber]`.

**Save:**
```dart
final repo = ref.read(roundRepositoryProvider);
for (final entry in _localScores.entries) {
  await repo.updateScore(roundId, entry.key, entry.value);
}
ref.invalidate(fetchRoundProvider(roundId));
ref.invalidate(fetchRoundsForLeagueProvider(leagueId));
// snackbar + context.pop()
```

No new repository methods needed — `updateScore(roundId, memberId, holeScores)` already exists.

---

## Files Summary

### New files (3):
- `lib/league/presentation/admin_hub_screen.dart`
- `lib/league/presentation/admin_schedule_screen.dart`
- `lib/league/presentation/admin_scorecard_screen.dart`

### Modified files (5):
| File | Change |
|------|--------|
| `lib/league/presentation/league_home_screen.dart` | Fix isAdmin check (per-league), wire navigation |
| `lib/round/infrastructure/models/round_model.dart` | Add `startTime`, `teamTeeTimes`; expand `copyWith` |
| `lib/round/infrastructure/round_repository.dart` | Add `updateRoundSchedule` abstract method |
| `lib/round/infrastructure/fake_round_repository.dart` | Implement `updateRoundSchedule` |
| `lib/app/core/routing.dart` | Add 3 new GoRoutes under `/league/:leagueId` |

---

## Verification

1. Run `dart run build_runner build --delete-conflicting-outputs` after any model/provider changes
2. Hot reload and navigate to a league as the admin user (AJ Greenman / user-1)
3. Confirm "Admin" item appears in the settings popup menu
4. Confirm non-admin leagues (any league where `adminId != 'user-1'`) show no "Admin" item
5. Tap Admin → hub screen shows all rounds with Schedule / Correct Scores buttons
6. Schedule screen: toggle front/back nine, set tee times, save → round reflects changes
7. Scorecard screen: edit any player's score on any hole, save → round reflects changes
8. Regular user flow: navigate through the entire league home → no admin UI visible anywhere
