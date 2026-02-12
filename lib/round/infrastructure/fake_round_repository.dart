import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/infrastructure/round_repository.dart';

class FakeRoundRepository extends RoundRepository {
  final List<RoundModel> _rounds = List.of(_initialRounds);

  @override
  Future<List<RoundModel>> fetchRoundsForLeague(String leagueId) async {
    return _rounds.where((r) => r.leagueId == leagueId).toList();
  }

  @override
  Future<RoundModel?> fetchRound(String roundId) async {
    return _rounds.where((r) => r.id == roundId).firstOrNull;
  }

  @override
  Future<void> updateScore(
    String roundId,
    String memberId,
    Map<int, int> holeScores,
  ) async {
    final index = _rounds.indexWhere((r) => r.id == roundId);
    if (index == -1) return;
    final round = _rounds[index];
    final updatedScores = round.scores.map((s) {
      if (s.memberId == memberId) {
        return ScoreModel(memberId: memberId, holeScores: holeScores);
      }
      return s;
    }).toList();
    _rounds[index] = round.copyWith(scores: updatedScores);
  }

  @override
  Future<RoundModel> startRound(String roundId) async {
    final index = _rounds.indexWhere((r) => r.id == roundId);
    if (index == -1) throw StateError('Round not found: $roundId');
    final round = _rounds[index];
    final started = round.copyWith(status: RoundStatus.inProgress);
    _rounds[index] = started;
    return started;
  }

  static final _initialRounds = [
    // Completed rounds with full scores
    RoundModel(
      id: 'round-1',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 4),
      status: RoundStatus.completed,
      holeNumbers: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      scores: [
        const ScoreModel(
          memberId: 'member-1',
          holeScores: {1: 6, 2: 4, 3: 3, 4: 5, 5: 5, 6: 4, 7: 4, 8: 5, 9: 3},
        ),
        const ScoreModel(
          memberId: 'member-2',
          holeScores: {1: 5, 2: 5, 3: 4, 4: 6, 5: 4, 6: 3, 7: 5, 8: 4, 9: 4},
        ),
        const ScoreModel(
          memberId: 'member-3',
          holeScores: {1: 7, 2: 4, 3: 2, 4: 5, 5: 4, 6: 5, 7: 4, 8: 4, 9: 3},
        ),
        const ScoreModel(
          memberId: 'member-4',
          holeScores: {1: 5, 2: 3, 3: 3, 4: 6, 5: 5, 6: 4, 7: 5, 8: 5, 9: 4},
        ),
      ],
    ),
    RoundModel(
      id: 'round-2',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 11),
      status: RoundStatus.completed,
      holeNumbers: [10, 11, 12, 13, 14, 15, 16, 17, 18],
      scores: [
        const ScoreModel(
          memberId: 'member-1',
          holeScores: {
            10: 4,
            11: 5,
            12: 3,
            13: 4,
            14: 6,
            15: 4,
            16: 3,
            17: 5,
            18: 4,
          },
        ),
        const ScoreModel(
          memberId: 'member-2',
          holeScores: {
            10: 5,
            11: 4,
            12: 4,
            13: 5,
            14: 5,
            15: 3,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
        const ScoreModel(
          memberId: 'member-3',
          holeScores: {
            10: 4,
            11: 4,
            12: 3,
            13: 3,
            14: 5,
            15: 5,
            16: 3,
            17: 5,
            18: 4,
          },
        ),
        const ScoreModel(
          memberId: 'member-5',
          holeScores: {
            10: 5,
            11: 5,
            12: 4,
            13: 4,
            14: 7,
            15: 4,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
      ],
    ),
    RoundModel(
      id: 'round-3',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 18),
      status: RoundStatus.completed,
      holeNumbers: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      scores: [
        const ScoreModel(
          memberId: 'member-1',
          holeScores: {1: 5, 2: 4, 3: 3, 4: 5, 5: 4, 6: 3, 7: 4, 8: 4, 9: 3},
        ),
        const ScoreModel(
          memberId: 'member-2',
          holeScores: {1: 6, 2: 4, 3: 3, 4: 5, 5: 5, 6: 5, 7: 4, 8: 5, 9: 4},
        ),
        const ScoreModel(
          memberId: 'member-3',
          holeScores: {1: 5, 2: 5, 3: 4, 4: 6, 5: 4, 6: 4, 7: 5, 8: 4, 9: 3},
        ),
        const ScoreModel(
          memberId: 'member-6',
          holeScores: {1: 7, 2: 5, 3: 4, 4: 7, 5: 5, 6: 5, 7: 6, 8: 5, 9: 4},
        ),
      ],
    ),
    RoundModel(
      id: 'round-4',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 25),
      status: RoundStatus.completed,
      holeNumbers: [10, 11, 12, 13, 14, 15, 16, 17, 18],
      scores: [
        const ScoreModel(
          memberId: 'member-1',
          holeScores: {
            10: 4,
            11: 4,
            12: 2,
            13: 4,
            14: 5,
            15: 4,
            16: 3,
            17: 5,
            18: 4,
          },
        ),
        const ScoreModel(
          memberId: 'member-2',
          holeScores: {
            10: 5,
            11: 5,
            12: 3,
            13: 5,
            14: 6,
            15: 4,
            16: 4,
            17: 5,
            18: 5,
          },
        ),
        const ScoreModel(
          memberId: 'member-4',
          holeScores: {
            10: 4,
            11: 4,
            12: 3,
            13: 4,
            14: 5,
            15: 5,
            16: 3,
            17: 6,
            18: 4,
          },
        ),
        const ScoreModel(
          memberId: 'member-5',
          holeScores: {
            10: 5,
            11: 5,
            12: 4,
            13: 5,
            14: 6,
            15: 5,
            16: 4,
            17: 7,
            18: 5,
          },
        ),
      ],
    ),
    // In-progress round
    RoundModel(
      id: 'round-5',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 7, 2),
      status: RoundStatus.inProgress,
      holeNumbers: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      scores: [
        const ScoreModel(
          memberId: 'member-1',
          holeScores: {1: 5, 2: 4, 3: 3, 4: 5},
        ),
        const ScoreModel(
          memberId: 'member-2',
          holeScores: {1: 6, 2: 4, 3: 4, 4: 6},
        ),
        const ScoreModel(
          memberId: 'member-3',
          holeScores: {1: 5, 2: 5, 3: 3, 4: 5},
        ),
      ],
    ),
    // Upcoming round
    RoundModel(
      id: 'round-6',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 7, 9),
      status: RoundStatus.upcoming,
      holeNumbers: [10, 11, 12, 13, 14, 15, 16, 17, 18],
      scores: [],
    ),
  ];
}
