import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/app/presentation/components/components.dart';
import 'package:greenie/league/infrastructure/infrastructure.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/user/user_providers.dart';

class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(fetchStandingsProvider(leagueId));
    final userAsync = ref.watch(currentUserProvider);
    final leagueAsync = ref.watch(fetchLeagueProvider(leagueId));

    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      body: switch (standingsAsync) {
        AsyncData(:final value) when value.isEmpty => const EmptyState(
          icon: Icons.bar_chart,
          message: 'No standings yet',
        ),
        AsyncData(:final value) => _StandingsList(
          standings: value,
          userMemberId: switch (userAsync) {
            AsyncData(:final value) => value.memberId,
            _ => '',
          },
          league: switch (leagueAsync) {
            AsyncData(:final value) => value,
            _ => null,
          },
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _StandingsList extends StatelessWidget {
  const _StandingsList({
    required this.standings,
    required this.userMemberId,
    required this.league,
  });

  final List<TeamStanding> standings;
  final String userMemberId;
  final LeagueModel? league;

  bool _isUserTeam(TeamStanding standing) {
    if (league == null) return false;
    return league!.teams.any(
      (t) => t.id == standing.team.id && t.memberIds.contains(userMemberId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: GreenieSizes.small),
      itemCount: standings.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final standing = standings[index];
        final isUser = _isUserTeam(standing);
        return Container(
          color: isUser
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
              : null,
          padding: const EdgeInsets.symmetric(
            horizontal: GreenieSizes.large,
            vertical: GreenieSizes.medium,
          ),
          child: Row(
            spacing: GreenieSizes.medium,
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '#${standing.rank}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          standing.team.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isUser
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (isUser) ...[
                          const SizedBox(width: GreenieSizes.extraSmall),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: GreenieSizes.extraSmall,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'You',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${standing.wins}-${standing.losses}-${standing.ties}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmtPts(standing.totalPoints),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'pts',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmtPts(double pts) {
    if (pts == pts.truncateToDouble()) return pts.toInt().toString();
    return pts.toStringAsFixed(1);
  }
}
