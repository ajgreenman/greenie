import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/presentation/components/empty_state.dart';
import 'package:greenie/league/presentation/components/member_list_tile.dart';
import 'package:greenie/user/user_providers.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(fetchMembersProvider(leagueId));
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: switch (membersAsync) {
        AsyncData(:final value) when value.isEmpty => const EmptyState(
          icon: Icons.people_outline,
          message: 'No members yet.',
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) => MemberListTile(member: value[index]),
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
