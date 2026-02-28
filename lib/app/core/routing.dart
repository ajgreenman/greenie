import 'package:go_router/go_router.dart';
import 'package:greenie/app/presentation/home_screen.dart';
import 'package:greenie/app/presentation/settings_screen.dart';
import 'package:greenie/league/presentation/admin_hub_screen.dart';
import 'package:greenie/league/presentation/admin_schedule_screen.dart';
import 'package:greenie/league/presentation/admin_scorecard_screen.dart';
import 'package:greenie/league/presentation/league_home_screen.dart';
import 'package:greenie/league/presentation/members_screen.dart';
import 'package:greenie/league/presentation/standings_screen.dart';
import 'package:greenie/league/presentation/stats_screen.dart';
import 'package:greenie/round/presentation/matchup_detail_screen.dart';
import 'package:greenie/round/presentation/round_detail_screen.dart';
import 'package:greenie/round/presentation/round_list_screen.dart';
import 'package:greenie/round/presentation/score_entry_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/league/:leagueId',
        builder: (context, state) => LeagueHomeScreen(
          leagueId: state.pathParameters['leagueId']!,
        ),
        routes: [
          GoRoute(
            path: 'stats',
            builder: (context, state) =>
                StatsScreen(leagueId: state.pathParameters['leagueId']!),
          ),
          GoRoute(
            path: 'members',
            builder: (context, state) => MembersScreen(
              leagueId: state.pathParameters['leagueId']!,
            ),
          ),
          GoRoute(
            path: 'rounds',
            builder: (context, state) => RoundListScreen(
              leagueId: state.pathParameters['leagueId']!,
            ),
          ),
          GoRoute(
            path: 'standings',
            builder: (context, state) => StandingsScreen(
              leagueId: state.pathParameters['leagueId']!,
            ),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
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
          GoRoute(
            path: 'round/:roundId',
            builder: (context, state) => RoundDetailScreen(
              leagueId: state.pathParameters['leagueId']!,
              roundId: state.pathParameters['roundId']!,
            ),
            routes: [
              GoRoute(
                path: 'scorecard',
                builder: (context, state) => ScoreEntryScreen(
                  leagueId: state.pathParameters['leagueId']!,
                  roundId: state.pathParameters['roundId']!,
                ),
              ),
              GoRoute(
                path: 'matchup/:matchupId',
                builder: (context, state) => MatchupDetailScreen(
                  leagueId: state.pathParameters['leagueId']!,
                  roundId: state.pathParameters['roundId']!,
                  matchupId: state.pathParameters['matchupId']!,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
