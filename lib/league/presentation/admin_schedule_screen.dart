import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/app/presentation/components/components.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/round/round_providers.dart';

class AdminScheduleScreen extends ConsumerStatefulWidget {
  const AdminScheduleScreen({
    super.key,
    required this.leagueId,
    required this.roundId,
  });

  final String leagueId;
  final String roundId;

  @override
  ConsumerState<AdminScheduleScreen> createState() =>
      _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends ConsumerState<AdminScheduleScreen> {
  List<int> _holeNumbers = [];
  DateTime? _roundStartTime;
  Map<String, DateTime> _teamTeeTimes = {};
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final roundAsync = ref.watch(fetchRoundProvider(widget.roundId));
    final leagueAsync = ref.watch(fetchLeagueProvider(widget.leagueId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _save(ref),
          ),
        ],
      ),
      body: switch ((roundAsync, leagueAsync)) {
        (AsyncData(:final value), AsyncData(value: final league))
            when value != null =>
          Builder(
            builder: (context) {
              if (!_initialized) {
                _holeNumbers = List.of(value.holeNumbers);
                _roundStartTime = value.startTime;
                _teamTeeTimes = Map.of(value.teamTeeTimes ?? {});
                _initialized = true;
              }

              final isFront =
                  _holeNumbers.isEmpty || _holeNumbers.contains(1);

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: GreenieSizes.large,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Starting Nine'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: GreenieSizes.large,
                      ),
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'front',
                            label: Text('Front Nine'),
                          ),
                          ButtonSegment(
                            value: 'back',
                            label: Text('Back Nine'),
                          ),
                        ],
                        selected: {isFront ? 'front' : 'back'},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _holeNumbers = selection.first == 'front'
                                ? List.generate(9, (i) => i + 1)
                                : List.generate(9, (i) => i + 10);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: GreenieSizes.large),
                    const SectionHeader(title: 'Tee Times'),
                    ListTile(
                      title: const Text('Round Start'),
                      trailing: Text(
                        _roundStartTime != null
                            ? _formatTime(_roundStartTime!)
                            : 'Not set',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      onTap: () => _pickTime(context, value.date, null),
                    ),
                    ...league.teams.map(
                      (team) => ListTile(
                        title: Text(team.name),
                        trailing: Text(
                          _teamTeeTimes.containsKey(team.id)
                              ? _formatTime(_teamTeeTimes[team.id]!)
                              : '—',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        onTap: () => _pickTime(context, value.date, team.id),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    DateTime roundDate,
    String? teamId,
  ) async {
    final initial = teamId != null
        ? (_teamTeeTimes[teamId] != null
              ? TimeOfDay.fromDateTime(_teamTeeTimes[teamId]!)
              : (_roundStartTime != null
                    ? TimeOfDay.fromDateTime(_roundStartTime!)
                    : const TimeOfDay(hour: 17, minute: 30)))
        : (_roundStartTime != null
              ? TimeOfDay.fromDateTime(_roundStartTime!)
              : const TimeOfDay(hour: 17, minute: 30));

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    final dt = DateTime(
      roundDate.year,
      roundDate.month,
      roundDate.day,
      picked.hour,
      picked.minute,
    );

    setState(() {
      if (teamId != null) {
        _teamTeeTimes[teamId] = dt;
      } else {
        _roundStartTime = dt;
      }
    });
  }

  Future<void> _save(WidgetRef ref) async {
    final repo = ref.read(roundRepositoryProvider);
    await repo.updateRoundSchedule(
      widget.roundId,
      holeNumbers: _holeNumbers,
      startTime: _roundStartTime,
      teamTeeTimes: _teamTeeTimes.isEmpty ? null : _teamTeeTimes,
    );
    ref.invalidate(fetchRoundProvider(widget.roundId));
    ref.invalidate(fetchRoundsForLeagueProvider(widget.leagueId));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule saved')),
      );
      Navigator.of(context).pop();
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }
}
