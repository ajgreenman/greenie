import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/presentation/components/scorecard.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/infrastructure/round_repository.dart';
import 'package:greenie/round/presentation/components/score_input_bottom_sheet.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/user_providers.dart';

class ScoreEntryScreen extends ConsumerStatefulWidget {
  const ScoreEntryScreen({
    super.key,
    required this.leagueId,
    required this.roundId,
  });

  final String leagueId;
  final String roundId;

  @override
  ConsumerState<ScoreEntryScreen> createState() => _ScoreEntryScreenState();
}

class _ScoreEntryScreenState extends ConsumerState<ScoreEntryScreen> {
  Map<String, Map<int, int>> _localScores = {};
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final roundAsync = ref.watch(fetchRoundProvider(widget.roundId));
    final membersAsync = ref.watch(fetchMembersProvider(widget.leagueId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Entry'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: () => _save(ref)),
        ],
      ),
      body: switch (roundAsync) {
        AsyncData(:final value) when value != null => Builder(
          builder: (context) {
            if (!_initialized) {
              _localScores = {
                for (final s in value.scores) s.memberId: Map.of(s.holeScores),
              };
              _initialized = true;
            }

            final localRound = value.copyWith(
              scores: value.scores.map((s) {
                final local = _localScores[s.memberId];
                if (local != null) {
                  return ScoreModel(memberId: s.memberId, holeScores: local);
                }
                return s;
              }).toList(),
            );

            final courseAsync = ref.watch(fetchCourseProvider(value.courseId));

            return switch ((courseAsync, membersAsync)) {
              (AsyncData(:final value), AsyncData(value: final members))
                  when value != null =>
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Scorecard(
                    round: localRound,
                    course: value,
                    members: members,
                    isEditable: true,
                    onScoreTap: _onScoreTap,
                  ),
                ),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  void _onScoreTap(String memberId, int holeNumber) {
    final currentScore = _localScores[memberId]?[holeNumber];
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => ScoreInputBottomSheet(
        holeNumber: holeNumber,
        currentScore: currentScore,
        onScoreSelected: (score) {
          setState(() {
            _localScores.putIfAbsent(memberId, () => {});
            _localScores[memberId]![holeNumber] = score;
          });
        },
      ),
    );
  }

  Future<void> _save(WidgetRef ref) async {
    final repo = ref.read(roundRepositoryProvider);
    for (final entry in _localScores.entries) {
      await repo.updateScore(widget.roundId, entry.key, entry.value);
    }
    ref.invalidate(fetchRoundProvider(widget.roundId));
    ref.invalidate(fetchRoundsForLeagueProvider(widget.leagueId));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Scores saved')));
      Navigator.of(context).pop();
    }
  }
}
