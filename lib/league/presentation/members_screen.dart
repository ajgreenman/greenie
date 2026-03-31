import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/app/presentation/components/components.dart';
import 'package:greenie/league/presentation/components/components.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';
import 'package:greenie/user/user_providers.dart';

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  bool _sortByHandicap = false;

  List<MemberModel> _sorted(List<MemberModel> members) {
    final copy = [...members];
    if (_sortByHandicap) {
      copy.sort(
        (a, b) => a.handicap != b.handicap
            ? a.handicap.compareTo(b.handicap)
            : a.name.compareTo(b.name),
      );
    } else {
      copy.sort((a, b) => a.name.compareTo(b.name));
    }
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    final membersState = ref.watch(fetchMembersProvider(widget.leagueId));

    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: switch (membersState) {
        AsyncData(:final value) when value.isEmpty => const EmptyState(
          icon: Icons.people_outline,
          message: 'No members yet',
        ),
        AsyncData(:final value) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(GreenieSizes.large),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Name')),
                  ButtonSegment(value: true, label: Text('Handicap')),
                ],
                selected: {_sortByHandicap},
                onSelectionChanged: (s) =>
                    setState(() => _sortByHandicap = s.first),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) => MemberListTile(
                  member: _sorted(value)[index],
                  emphasizeHandicap: _sortByHandicap,
                ),
              ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
