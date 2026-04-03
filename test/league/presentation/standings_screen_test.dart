// ignore_for_file: scoped_providers_should_specify_dependencies
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/league/infrastructure/models/team_standing.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/league/presentation/standings_screen.dart';
import 'package:greenie/user/user_model.dart';
import 'package:greenie/user/user_providers.dart';

const _course = CourseModel(id: 'c1', name: 'Test Course', holes: []);

const _team1 = TeamModel(
  id: 'team-1',
  leagueId: 'league-1',
  memberIds: ['m1', 'm2'],
  name: 'Alpha Squad',
);

const _team2 = TeamModel(
  id: 'team-2',
  leagueId: 'league-1',
  memberIds: ['m3', 'm4'],
  name: 'Beta Squad',
);

const _testLeague = LeagueModel(
  id: 'league-1',
  name: 'Test League',
  course: _course,
  day: DayOfTheWeek.wednesday,
  memberIds: ['m1', 'm2', 'm3', 'm4'],
  adminId: 'user-1',
  teams: [_team1, _team2],
);

final _standings = [
  const TeamStanding(
    team: _team1,
    wins: 3,
    losses: 1,
    ties: 0,
    totalPoints: 145.5,
    rank: 1,
  ),
  const TeamStanding(
    team: _team2,
    wins: 1,
    losses: 3,
    ties: 0,
    totalPoints: 54.5,
    rank: 2,
  ),
];

const _testUser = UserModel(
  id: 'user-1',
  name: 'Test User',
  email: 'test@test.com',
  isAdmin: false,
  memberId: 'm1',
);

Widget _buildScreen({List<TeamStanding>? standings, bool throwError = false}) {
  return ProviderScope(
    overrides: [
      fetchStandingsProvider('league-1').overrideWith((ref) async {
        if (throwError) throw Exception('network error');
        return standings ?? _standings;
      }),
      fetchLeagueProvider('league-1').overrideWith((ref) async => _testLeague),
      currentUserProvider.overrideWith((ref) async => _testUser),
    ],
    child: MaterialApp(
      theme: GreenieTheme.light,
      home: const StandingsScreen(leagueId: 'league-1'),
    ),
  );
}

void main() {
  group('StandingsScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows Standings in app bar', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Standings'), findsOneWidget);
    });

    testWidgets('shows team names', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Alpha Squad'), findsOneWidget);
      expect(find.text('Beta Squad'), findsOneWidget);
    });

    testWidgets('shows ranks', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
    });

    testWidgets('shows W-L-T record', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('3-1-0'), findsOneWidget);
      expect(find.text('1-3-0'), findsOneWidget);
    });

    testWidgets('highlights current user team with You badge', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      // _testUser has memberId m1 which is in team-1 (Alpha Squad)
      expect(find.text('You'), findsOneWidget);
    });

    testWidgets('shows empty state when no standings', (tester) async {
      await tester.pumpWidget(_buildScreen(standings: []));
      await tester.pumpAndSettle();
      expect(find.text('No standings yet'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await tester.pumpWidget(_buildScreen(throwError: true));
      await tester.pumpAndSettle();
      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}
