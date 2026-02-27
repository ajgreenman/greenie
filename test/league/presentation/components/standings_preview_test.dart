import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/league/infrastructure/models/team_standing.dart';
import 'package:greenie/league/presentation/components/standings_preview.dart';

const _course = CourseModel(id: 'c1', name: 'Test Course', holes: []);

const _team1 = TeamModel(id: 'team-1', leagueId: 'league-1', memberIds: ['member-1', 'member-2'], name: 'Alpha / Beta');
const _team2 = TeamModel(id: 'team-2', leagueId: 'league-1', memberIds: ['member-3', 'member-4'], name: 'Gamma / Delta');
const _team3 = TeamModel(id: 'team-3', leagueId: 'league-1', memberIds: ['member-5', 'member-6'], name: 'Epsilon / Zeta');
const _team4 = TeamModel(id: 'team-4', leagueId: 'league-1', memberIds: ['member-7', 'member-8'], name: 'Eta / Theta');
const _team5 = TeamModel(id: 'team-5', leagueId: 'league-1', memberIds: ['member-9', 'member-10'], name: 'Iota / Kappa');

const _league = LeagueModel(
  id: 'league-1',
  name: 'Test League',
  course: _course,
  day: DayOfTheWeek.wednesday,
  memberIds: ['member-1', 'member-2', 'member-3', 'member-4', 'member-5', 'member-6', 'member-7', 'member-8', 'member-9', 'member-10'],
  adminId: 'user-1',
  teams: [_team1, _team2, _team3, _team4, _team5],
);

List<TeamStanding> _standings() => const [
  TeamStanding(team: _team1, wins: 4, losses: 1, ties: 0, totalPoints: 180, rank: 1),
  TeamStanding(team: _team2, wins: 3, losses: 2, ties: 0, totalPoints: 160, rank: 2),
  TeamStanding(team: _team3, wins: 3, losses: 2, ties: 0, totalPoints: 150, rank: 3),
  TeamStanding(team: _team4, wins: 1, losses: 3, ties: 1, totalPoints: 120, rank: 4),
  TeamStanding(team: _team5, wins: 0, losses: 5, ties: 0, totalPoints: 90, rank: 5),
];

Widget _buildWidget({
  required List<TeamStanding> standings,
  required String userMemberId,
}) {
  return MaterialApp(
    theme: GreenieTheme.light,
    home: Scaffold(
      body: StandingsPreview(
        standings: standings,
        userMemberId: userMemberId,
        league: _league,
        leagueId: 'league-1',
      ),
    ),
  );
}

void main() {
  group('StandingsPreview', () {
    testWidgets('shows column headers', (tester) async {
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'member-1'));
      expect(find.text('#'), findsOneWidget);
      expect(find.text('Team'), findsOneWidget);
      expect(find.text('W-L-T'), findsOneWidget);
      expect(find.text('Pts'), findsOneWidget);
    });

    testWidgets('shows Full Standings link', (tester) async {
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'member-1'));
      expect(find.text('Full Standings'), findsOneWidget);
    });

    testWidgets('user in middle — shows surrounding teams', (tester) async {
      // member-5 is on team-3 (rank 3, middle). Should show ranks 2, 3, 4.
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'member-5'));
      expect(find.text('Gamma / Delta'), findsOneWidget);   // rank 2
      expect(find.text('Epsilon / Zeta'), findsOneWidget);  // rank 3 (user)
      expect(find.text('Eta / Theta'), findsOneWidget);     // rank 4
      expect(find.text('Alpha / Beta'), findsNothing);      // rank 1 — not shown
      expect(find.text('Iota / Kappa'), findsNothing);      // rank 5 — not shown
    });

    testWidgets('user in first — shows top 3', (tester) async {
      // member-1 is on team-1 (rank 1). Should show ranks 1, 2, 3.
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'member-1'));
      expect(find.text('Alpha / Beta'), findsOneWidget);    // rank 1 (user)
      expect(find.text('Gamma / Delta'), findsOneWidget);   // rank 2
      expect(find.text('Epsilon / Zeta'), findsOneWidget);  // rank 3
      expect(find.text('Eta / Theta'), findsNothing);
    });

    testWidgets('user in last — shows bottom 3', (tester) async {
      // member-9 is on team-5 (rank 5, last). Should show ranks 3, 4, 5.
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'member-9'));
      expect(find.text('Epsilon / Zeta'), findsOneWidget);  // rank 3
      expect(find.text('Eta / Theta'), findsOneWidget);     // rank 4
      expect(find.text('Iota / Kappa'), findsOneWidget);    // rank 5 (user)
      expect(find.text('Gamma / Delta'), findsNothing);     // rank 2 — not shown
    });

    testWidgets('shows W-L-T record for displayed rows', (tester) async {
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'member-1'));
      expect(find.text('4-1-0'), findsOneWidget); // team-1 record
    });

    testWidgets('shows points for displayed rows', (tester) async {
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'member-1'));
      expect(find.text('180'), findsOneWidget);
    });

    testWidgets('shows all rows when standings has 3 or fewer teams', (tester) async {
      final short = _standings().take(3).toList();
      await tester.pumpWidget(_buildWidget(standings: short, userMemberId: 'member-9'));
      expect(find.text('Alpha / Beta'), findsOneWidget);
      expect(find.text('Gamma / Delta'), findsOneWidget);
      expect(find.text('Epsilon / Zeta'), findsOneWidget);
    });

    testWidgets('unknown user shows top 3', (tester) async {
      await tester.pumpWidget(_buildWidget(standings: _standings(), userMemberId: 'unknown'));
      expect(find.text('Alpha / Beta'), findsOneWidget);
      expect(find.text('Gamma / Delta'), findsOneWidget);
      expect(find.text('Epsilon / Zeta'), findsOneWidget);
    });
  });
}
