import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/league/presentation/league_home_screen.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/round_providers.dart';
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
);

final _testUpcomingRound = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 7, 6),
  status: RoundStatus.upcoming,
  holeNumbers: const [1, 2],
  scores: const [],
);

const _testUser = UserModel(
  id: 'member-1',
  name: 'Test User',
  email: 'test@example.com',
  isAdmin: true,
);

void main() {
  group('LeagueHomeScreen', () {
    testWidgets('shows league name in app bar', (tester) async {
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
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // League name appears in both AppBar and LeagueInfoHeader
      expect(find.text('Sunday Skins'), findsNWidgets(2));
    });

    testWidgets('shows league info header with course and day', (
      tester,
    ) async {
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
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
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
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Next Round'), findsOneWidget);
    });

    testWidgets('shows quick links', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeague),
            fetchRoundsForLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => <RoundModel>[]),
            currentUserProvider.overrideWith((ref) async => _testUser),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Members'), findsOneWidget);
      expect(find.text('Past Rounds'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: buildLightTheme(),
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
            theme: buildLightTheme(),
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets('shows admin quick link for admin user', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeague),
            fetchRoundsForLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => <RoundModel>[]),
            currentUserProvider.overrideWith((ref) async => _testUser),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('hides admin quick link for non-admin user', (tester) async {
      const nonAdmin = UserModel(
        id: 'member-2',
        name: 'Regular User',
        email: 'regular@example.com',
        isAdmin: false,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => _testLeague),
            fetchRoundsForLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => <RoundModel>[]),
            currentUserProvider.overrideWith((ref) async => nonAdmin),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const LeagueHomeScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin'), findsNothing);
    });
  });
}
