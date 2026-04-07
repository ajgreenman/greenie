import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_result.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/presentation/round_detail_screen.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_model.dart';
import 'package:greenie/user/user_providers.dart';

final _testCourse = CourseModel(
  id: 'course-1',
  name: 'Test Course',
  holes: [
    HoleModel(number: 1, par: 4),
    HoleModel(number: 2, par: 3),
    HoleModel(number: 3, par: 5),
  ],
);

const _testMembers = [
  MemberModel(id: 'user-1', name: 'Alice Smith', handicap: 10),
  MemberModel(id: 'user-2', name: 'Bob Jones', handicap: 18),
];

// Teams and matchup for the user's round
const _team1 = TeamModel(
  id: 'team-1',
  leagueId: 'league-1',
  memberIds: ['user-1', 'user-2'],
  name: 'Alice & Bob',
);

const _team2 = TeamModel(
  id: 'team-2',
  leagueId: 'league-1',
  memberIds: ['user-3', 'user-4'],
  name: 'Carol & Dave',
);

const _matchup1 = MatchupModel(
  id: 'matchup-1',
  roundId: 'round-1',
  team1Id: 'team-1',
  team2Id: 'team-2',
);

final _testLeagueWithTeams = LeagueModel(
  id: 'league-1',
  name: 'Test League',
  course: _testCourse,
  day: DayOfTheWeek.wednesday,
  memberIds: const ['user-1', 'user-2', 'user-3', 'user-4'],
  adminId: 'user-1',
  teams: const [_team1, _team2],
);

final _testLeagueNoTeams = LeagueModel(
  id: 'league-1',
  name: 'Test League',
  course: _testCourse,
  day: DayOfTheWeek.wednesday,
  memberIds: const ['user-1'],
  adminId: 'user-1',
  teams: const [],
);

const _testUser = UserModel(
  id: 'user-1',
  name: 'Alice Smith',
  email: 'alice@test.com',
  handicap: 10,
);

final _testCompletedRound = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 4),
  status: RoundStatus.completed,
  holeNumbers: const [1, 2, 3],
  scores: const [
    ScoreModel(userId: 'user-1', holeScores: {1: 4, 2: 3, 3: 5}),
    ScoreModel(userId: 'user-2', holeScores: {1: 5, 2: 4, 3: 6}),
  ],
  matchups: const [],
);

final _testCompletedRoundWithMatchup = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 4),
  status: RoundStatus.completed,
  holeNumbers: const [1, 2, 3],
  scores: const [
    ScoreModel(userId: 'user-1', holeScores: {1: 4, 2: 3, 3: 5}),
    ScoreModel(userId: 'user-2', holeScores: {1: 5, 2: 4, 3: 6}),
  ],
  matchups: const [_matchup1],
);

final _testUpcomingRound = RoundModel(
  id: 'round-2',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 7, 2),
  status: RoundStatus.upcoming,
  holeNumbers: const [1, 2, 3],
  scores: const [],
  matchups: const [],
);

final _testInProgressRound = RoundModel(
  id: 'round-3',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 25),
  status: RoundStatus.inProgress,
  holeNumbers: const [1, 2, 3],
  scores: const [
    ScoreModel(userId: 'user-1', holeScores: {1: 4}),
  ],
  matchups: const [],
);

MatchupResult _makeMatchupResult() {
  const a1 = MemberModel(id: 'user-1', name: 'Alice Smith', handicap: 10);
  const b1 = MemberModel(id: 'user-2', name: 'Bob Jones', handicap: 18);
  const a2 = MemberModel(id: 'user-3', name: 'Carol', handicap: 8);
  const b2 = MemberModel(id: 'user-4', name: 'Dave', handicap: 15);
  return const MatchupResult(
    matchup: _matchup1,
    team1: _team1,
    team2: _team2,
    team1AMember: a2,
    team2AMember: a1,
    team1BMember: b2,
    team2BMember: b1,
    holeNumbers: [1, 2, 3],
    holeResults: [],
    bonusAPoints: PointResult(team1Points: 1, team2Points: 1),
    bonusBPoints: PointResult(team1Points: 1, team2Points: 1),
    bonusTeamPoints: PointResult(team1Points: 0.5, team2Points: 0.5),
  );
}

void main() {
  group('RoundDetailScreen', () {
    testWidgets('shows round info for completed round', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testCompletedRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeagueNoTeams),
            currentUserProvider.overrideWith((ref) async => _testUser),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Course'), findsWidgets);
      expect(find.text('Leaderboard'), findsOneWidget);
    });

    testWidgets('shows Start Round button for upcoming round', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-2',
            ).overrideWith((ref) async => _testUpcomingRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeagueNoTeams),
            currentUserProvider.overrideWith((ref) async => _testUser),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-2',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Start Round'), findsOneWidget);
    });

    testWidgets('shows Continue Round button for in-progress round', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-3',
            ).overrideWith((ref) async => _testInProgressRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeagueNoTeams),
            currentUserProvider.overrideWith((ref) async => _testUser),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-3',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Continue Round'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      expect(find.text('Round'), findsOneWidget);
    });

    testWidgets('shows MatchupCard when user has a matchup', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testCompletedRoundWithMatchup),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeagueWithTeams),
            currentUserProvider.overrideWith((ref) async => _testUser),
            fetchMatchupResultProvider(
              'round-1',
              'matchup-1',
            ).overrideWith((ref) async => _makeMatchupResult()),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Your Matchup'), findsOneWidget);
    });

    testWidgets('hides MatchupCard when user has a bye', (tester) async {
      // _testUser is in team-1 (member-1), but round has no matchups
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testCompletedRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeagueWithTeams),
            currentUserProvider.overrideWith((ref) async => _testUser),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Your Matchup'), findsNothing);
    });
  });
}
