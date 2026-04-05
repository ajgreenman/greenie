import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/presentation/home_screen.dart';
import 'package:greenie/app/presentation/login_screen.dart';
import 'package:greenie/app/presentation/settings_screen.dart';
import 'package:greenie/auth/auth_providers.dart';
import 'package:greenie/auth/auth_repository.dart';
import 'package:greenie/auth/auth_user.dart';
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

/// Bridges auth state changes into a [ChangeNotifier] so GoRouter
/// re-evaluates [redirect] whenever the user signs in or out.
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(AuthRepository authRepo) {
    _sub = authRepo.authStateChanges.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthUser?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final notifier = _AuthNotifier(ref.read(authRepositoryProvider));
  ref.onDispose(notifier.dispose);

  return GoRouter(
    refreshListenable: notifier,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepositoryProvider).currentUser != null;
      final isOnLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && isOnLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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
