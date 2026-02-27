import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/league/presentation/league_home_screen.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_model.dart';
import 'package:greenie/user/user_providers.dart';

final _testCourse = CourseModel(
  id: 'course-1',
  name: 'Pine Valley',
  holes: [HoleModel(number: 1, par: 4), HoleModel(number: 2, par: 3)],
);

final _testLeague = LeagueModel(
  id: 'league-1',
  name: 'Sunday Skins',
  course: _testCourse,
  day: DayOfTheWeek.sunday,
  memberIds: const ['member-1'],
  adminId: 'member-1',
  teams: const [],
);

final _testUpcomingRound = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 7, 6),
  status: RoundStatus.upcoming,
  holeNumbers: const [1, 2],
  scores: const [],
  matchups: const [],
);

const _testUser = UserModel(
  id: 'member-1',
  name: 'Test User',
  email: 'test@example.com',
  isAdmin: true,
  memberId: 'member-1',
);

const _testMembers = [MemberModel(id: 'member-1', name: 'Test User', handicap: 10)];

/// Builds the screen with sensible defaults. Any of the overrides can be
/// individually swapped out in specific tests.
Widget _buildScreen({
  bool isAdmin = true,
  List<RoundModel>? rounds,
  List<MemberModel>? members,
}) {
  final user = UserModel(
    id: 'member-1',
    name: 'Test User',
    email: 'test@example.com',
    isAdmin: isAdmin,
    memberId: 'member-1',
  );
  return ProviderScope(
    overrides: [
      fetchLeagueProvider('league-1').overrideWith((ref) async => _testLeague),
      fetchRoundsForLeagueProvider(
        'league-1',
      ).overrideWith((ref) async => rounds ?? []),
      currentUserProvider.overrideWith((ref) async => user),
      fetchStandingsProvider(
        'league-1',
      ).overrideWith((ref) async => []),
      fetchMembersProvider(
        'league-1',
      ).overrideWith((ref) async => members ?? _testMembers),
    ],
    child: MaterialApp(
      theme: GreenieTheme.light,
      home: const LeagueHomeScreen(leagueId: 'league-1'),
    ),
  );
}

void main() {
  group('LeagueHomeScreen', () {
    testWidgets('shows league name in app bar', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Sunday Skins'), findsOneWidget);
    });

    testWidgets('shows league info header with course and day', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Pine Valley'), findsOneWidget);
      expect(find.text('Sundays'), findsOneWidget);
    });

    testWidgets('shows upcoming round card', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeague),
            fetchRoundsForLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => [_testUpcomingRound]),
            currentUserProvider.overrideWith((ref) async => _testUser),
            fetchStandingsProvider(
              'league-1',
            ).overrideWith((ref) async => []),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => []),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Next Round'), findsOneWidget);
    });

    testWidgets('shows Members section when members loaded', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Members'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => throw Exception('Network error')),
            currentUserProvider.overrideWith((ref) async => _testUser),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets('shows Admin option in gear menu for admin user', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen(isAdmin: true));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('hides Admin option in gear menu for non-admin user', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen(isAdmin: false));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Admin'), findsNothing);
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
