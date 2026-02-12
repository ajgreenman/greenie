import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/presentation/components/empty_state.dart';
import 'package:greenie/round/presentation/components/round_list_tile.dart';
import 'package:greenie/round/round_providers.dart';

class RoundListScreen extends ConsumerWidget {
  const RoundListScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roundsAsync = ref.watch(fetchRoundsForLeagueProvider(leagueId));
    return Scaffold(
      appBar: AppBar(title: const Text('Rounds')),
      body: switch (roundsAsync) {
        AsyncData(:final value) when value.isEmpty => const EmptyState(
          icon: Icons.sports_golf,
          message: 'No rounds yet.',
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: (value..sort((a, b) => b.date.compareTo(a.date))).length,
          itemBuilder: (context, index) =>
              RoundListTile(round: value[index], leagueId: leagueId),
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
