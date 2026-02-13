import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/design_constants.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/league/presentation/components/league_info_header.dart';
import 'package:greenie/league/presentation/components/league_quick_links.dart';
import 'package:greenie/league/presentation/components/upcoming_round_card.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/user_providers.dart';

class LeagueHomeScreen extends ConsumerWidget {
  const LeagueHomeScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(fetchLeagueProvider(leagueId));
    final roundsAsync = ref.watch(fetchRoundsForLeagueProvider(leagueId));
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (leagueAsync) {
          AsyncData(:final value) when value != null => value.name,
          _ => 'League',
        }),
      ),
      body: switch (leagueAsync) {
        AsyncData(:final value) when value != null => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: large,
            children: [
              LeagueInfoHeader(league: value),
              if (roundsAsync case AsyncData(:final value))
                ...() {
                  final upcoming =
                      value
                          .where(
                            (r) =>
                                r.status == RoundStatus.upcoming ||
                                r.status == RoundStatus.inProgress,
                          )
                          .toList()
                        ..sort((a, b) => a.date.compareTo(b.date));
                  if (upcoming.isNotEmpty) {
                    return [
                      UpcomingRoundCard(
                        round: upcoming.first,
                        leagueId: leagueId,
                      ),
                    ];
                  }
                  return <Widget>[];
                }(),
              LeagueQuickLinks(
                leagueId: leagueId,
                isAdmin: switch (userAsync) {
                  AsyncData(:final value) => value.isAdmin,
                  _ => false,
                },
              ),
            ],
          ),
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
