import 'package:greenie/round/infrastructure/models/models.dart';
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
      if (s.userId == memberId) {
        return ScoreModel(userId: memberId, holeScores: holeScores);
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

  @override
  Future<RoundModel> updateRoundSchedule(
    String roundId, {
    List<int>? holeNumbers,
    DateTime? startTime,
    Map<String, DateTime>? teamTeeTimes,
  }) async {
    final index = _rounds.indexWhere((r) => r.id == roundId);
    if (index == -1) throw StateError('Round not found: $roundId');
    _rounds[index] = _rounds[index].copyWith(
      holeNumbers: holeNumbers,
      startTime: startTime,
      teamTeeTimes: teamTeeTimes,
    );
    return _rounds[index];
  }

  static final _initialRounds = [
    // ─── Round 1: front 9 ───────────────────────────────────────────────────
    // Matchups: team-1 vs team-2, team-3 vs team-4, team-5 vs team-6
    // Bye: team-7 (AJ + Adam)
    RoundModel(
      id: 'round-1',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 4),
      status: RoundStatus.completed,
      holeNumbers: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      matchups: const [
        MatchupModel(
          id: 'matchup-1-1',
          roundId: 'round-1',
          team1Id: 'team-1',
          team2Id: 'team-2',
        ),
        MatchupModel(
          id: 'matchup-1-2',
          roundId: 'round-1',
          team1Id: 'team-3',
          team2Id: 'team-4',
        ),
        MatchupModel(
          id: 'matchup-1-3',
          roundId: 'round-1',
          team1Id: 'team-5',
          team2Id: 'team-6',
        ),
      ],
      scores: const [
        // team-1: Ben (hdcp 1, A), Joel (hdcp 17, B)
        ScoreModel(
          userId: 'user-14',
          holeScores: {1: 4, 2: 3, 3: 4, 4: 4, 5: 3, 6: 4, 7: 4, 8: 3, 9: 4},
        ),
        ScoreModel(
          userId: 'user-13',
          holeScores: {1: 6, 2: 5, 3: 5, 4: 6, 5: 5, 6: 5, 7: 6, 8: 5, 9: 5},
        ),
        // team-2: Brady (hdcp 2, A), Matt (hdcp 12, B)
        ScoreModel(
          userId: 'user-6',
          holeScores: {1: 4, 2: 3, 3: 4, 4: 4, 5: 4, 6: 3, 7: 4, 8: 4, 9: 4},
        ),
        ScoreModel(
          userId: 'user-10',
          holeScores: {1: 5, 2: 4, 3: 5, 4: 5, 5: 4, 6: 5, 7: 5, 8: 4, 9: 5},
        ),
        // team-3: Aaron (hdcp 3, A), Brett (hdcp 15, B)
        ScoreModel(
          userId: 'user-4',
          holeScores: {1: 4, 2: 3, 3: 4, 4: 5, 5: 4, 6: 4, 7: 4, 8: 4, 9: 4},
        ),
        ScoreModel(
          userId: 'user-8',
          holeScores: {1: 6, 2: 5, 3: 5, 4: 6, 5: 5, 6: 5, 7: 6, 8: 5, 9: 5},
        ),
        // team-4: Ryan C (hdcp 5, A), Ryan A (hdcp 12, B)
        ScoreModel(
          userId: 'user-7',
          holeScores: {1: 5, 2: 4, 3: 4, 4: 5, 5: 4, 6: 4, 7: 5, 8: 4, 9: 5},
        ),
        ScoreModel(
          userId: 'user-9',
          holeScores: {1: 5, 2: 4, 3: 5, 4: 6, 5: 4, 6: 5, 7: 5, 8: 5, 9: 5},
        ),
        // team-5: Andrew (hdcp 6, A), Mike (hdcp 8, B)
        ScoreModel(
          userId: 'user-11',
          holeScores: {1: 5, 2: 4, 3: 4, 4: 5, 5: 4, 6: 5, 7: 5, 8: 4, 9: 4},
        ),
        ScoreModel(
          userId: 'user-3',
          holeScores: {1: 5, 2: 4, 3: 5, 4: 5, 5: 5, 6: 4, 7: 5, 8: 4, 9: 5},
        ),
        // team-6: Brandon (hdcp 9, A), Jake (hdcp 11, B)
        ScoreModel(
          userId: 'user-2',
          holeScores: {1: 5, 2: 4, 3: 5, 4: 5, 5: 5, 6: 4, 7: 5, 8: 5, 9: 4},
        ),
        ScoreModel(
          userId: 'user-12',
          holeScores: {1: 5, 2: 5, 3: 5, 4: 5, 5: 4, 6: 5, 7: 5, 8: 5, 9: 5},
        ),
      ],
    ),

    // ─── Round 2: back 9 ────────────────────────────────────────────────────
    // Matchups: team-1 vs team-3, team-2 vs team-5, team-4 vs team-7
    // Bye: team-6 (Brandon + Jake)
    RoundModel(
      id: 'round-2',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 11),
      status: RoundStatus.completed,
      holeNumbers: [10, 11, 12, 13, 14, 15, 16, 17, 18],
      matchups: const [
        MatchupModel(
          id: 'matchup-2-1',
          roundId: 'round-2',
          team1Id: 'team-1',
          team2Id: 'team-3',
        ),
        MatchupModel(
          id: 'matchup-2-2',
          roundId: 'round-2',
          team1Id: 'team-2',
          team2Id: 'team-5',
        ),
        MatchupModel(
          id: 'matchup-2-3',
          roundId: 'round-2',
          team1Id: 'team-4',
          team2Id: 'team-7',
        ),
      ],
      scores: const [
        // team-1: Ben (hdcp 1, A), Joel (hdcp 17, B)
        ScoreModel(
          userId: 'user-14',
          holeScores: {
            10: 4,
            11: 3,
            12: 3,
            13: 4,
            14: 5,
            15: 3,
            16: 3,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-13',
          holeScores: {
            10: 5,
            11: 5,
            12: 5,
            13: 5,
            14: 6,
            15: 5,
            16: 5,
            17: 6,
            18: 5,
          },
        ),
        // team-3: Aaron (hdcp 3, A), Brett (hdcp 15, B)
        ScoreModel(
          userId: 'user-4',
          holeScores: {
            10: 4,
            11: 4,
            12: 3,
            13: 4,
            14: 5,
            15: 4,
            16: 3,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-8',
          holeScores: {
            10: 6,
            11: 5,
            12: 5,
            13: 5,
            14: 7,
            15: 5,
            16: 5,
            17: 6,
            18: 5,
          },
        ),
        // team-2: Brady (hdcp 2, A), Matt (hdcp 12, B)
        ScoreModel(
          userId: 'user-6',
          holeScores: {
            10: 3,
            11: 4,
            12: 3,
            13: 4,
            14: 5,
            15: 3,
            16: 3,
            17: 4,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-10',
          holeScores: {
            10: 5,
            11: 5,
            12: 4,
            13: 5,
            14: 6,
            15: 4,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
        // team-5: Andrew (hdcp 6, A), Mike (hdcp 8, B)
        ScoreModel(
          userId: 'user-11',
          holeScores: {
            10: 4,
            11: 4,
            12: 4,
            13: 5,
            14: 5,
            15: 4,
            16: 4,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-3',
          holeScores: {
            10: 5,
            11: 4,
            12: 4,
            13: 5,
            14: 6,
            15: 5,
            16: 4,
            17: 5,
            18: 4,
          },
        ),
        // team-4: Ryan C (hdcp 5, A), Ryan A (hdcp 12, B)
        ScoreModel(
          userId: 'user-7',
          holeScores: {
            10: 4,
            11: 4,
            12: 3,
            13: 4,
            14: 5,
            15: 4,
            16: 4,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-9',
          holeScores: {
            10: 5,
            11: 5,
            12: 4,
            13: 5,
            14: 6,
            15: 5,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
        // team-7: AJ (hdcp 10, A), Adam (hdcp 10, B) — tied hdcp, list order
        ScoreModel(
          userId: 'user-1',
          holeScores: {
            10: 5,
            11: 4,
            12: 4,
            13: 5,
            14: 5,
            15: 4,
            16: 4,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-5',
          holeScores: {
            10: 5,
            11: 5,
            12: 4,
            13: 5,
            14: 6,
            15: 4,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
      ],
    ),

    // ─── Round 3: front 9 ───────────────────────────────────────────────────
    // Matchups: team-1 vs team-4, team-2 vs team-7, team-3 vs team-6
    // Bye: team-5 (Andrew + Mike)
    RoundModel(
      id: 'round-3',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 18),
      status: RoundStatus.completed,
      holeNumbers: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      matchups: const [
        MatchupModel(
          id: 'matchup-3-1',
          roundId: 'round-3',
          team1Id: 'team-1',
          team2Id: 'team-4',
        ),
        MatchupModel(
          id: 'matchup-3-2',
          roundId: 'round-3',
          team1Id: 'team-2',
          team2Id: 'team-7',
        ),
        MatchupModel(
          id: 'matchup-3-3',
          roundId: 'round-3',
          team1Id: 'team-3',
          team2Id: 'team-6',
        ),
      ],
      scores: const [
        // team-1: Ben (hdcp 1, A), Joel (hdcp 17, B)
        ScoreModel(
          userId: 'user-14',
          holeScores: {1: 3, 2: 3, 3: 4, 4: 4, 5: 3, 6: 4, 7: 4, 8: 3, 9: 4},
        ),
        ScoreModel(
          userId: 'user-13',
          holeScores: {1: 6, 2: 5, 3: 5, 4: 6, 5: 5, 6: 6, 7: 5, 8: 5, 9: 5},
        ),
        // team-4: Ryan C (hdcp 5, A), Ryan A (hdcp 12, B)
        ScoreModel(
          userId: 'user-7',
          holeScores: {1: 5, 2: 4, 3: 4, 4: 5, 5: 4, 6: 4, 7: 5, 8: 4, 9: 4},
        ),
        ScoreModel(
          userId: 'user-9',
          holeScores: {1: 5, 2: 4, 3: 5, 4: 6, 5: 5, 6: 5, 7: 5, 8: 5, 9: 5},
        ),
        // team-2: Brady (hdcp 2, A), Matt (hdcp 12, B)
        ScoreModel(
          userId: 'user-6',
          holeScores: {1: 4, 2: 3, 3: 3, 4: 4, 5: 4, 6: 3, 7: 4, 8: 3, 9: 4},
        ),
        ScoreModel(
          userId: 'user-10',
          holeScores: {1: 5, 2: 4, 3: 5, 4: 5, 5: 5, 6: 5, 7: 5, 8: 5, 9: 5},
        ),
        // team-7: AJ (hdcp 10, A), Adam (hdcp 10, B)
        ScoreModel(
          userId: 'user-1',
          holeScores: {1: 5, 2: 4, 3: 4, 4: 5, 5: 5, 6: 4, 7: 5, 8: 4, 9: 4},
        ),
        ScoreModel(
          userId: 'user-5',
          holeScores: {1: 5, 2: 5, 3: 5, 4: 6, 5: 5, 6: 5, 7: 5, 8: 5, 9: 5},
        ),
        // team-3: Aaron (hdcp 3, A), Brett (hdcp 15, B)
        ScoreModel(
          userId: 'user-4',
          holeScores: {1: 4, 2: 4, 3: 3, 4: 5, 5: 4, 6: 4, 7: 4, 8: 4, 9: 4},
        ),
        ScoreModel(
          userId: 'user-8',
          holeScores: {1: 6, 2: 5, 3: 5, 4: 6, 5: 6, 6: 5, 7: 6, 8: 5, 9: 5},
        ),
        // team-6: Brandon (hdcp 9, A), Jake (hdcp 11, B)
        ScoreModel(
          userId: 'user-2',
          holeScores: {1: 5, 2: 4, 3: 5, 4: 5, 5: 5, 6: 5, 7: 5, 8: 5, 9: 4},
        ),
        ScoreModel(
          userId: 'user-12',
          holeScores: {1: 5, 2: 5, 3: 5, 4: 6, 5: 5, 6: 5, 7: 6, 8: 5, 9: 5},
        ),
      ],
    ),

    // ─── Round 4: back 9 ────────────────────────────────────────────────────
    // Matchups: team-1 vs team-5, team-2 vs team-6, team-3 vs team-7
    // Bye: team-4 (Ryan C + Ryan A)
    RoundModel(
      id: 'round-4',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 6, 25),
      status: RoundStatus.completed,
      holeNumbers: [10, 11, 12, 13, 14, 15, 16, 17, 18],
      matchups: const [
        MatchupModel(
          id: 'matchup-4-1',
          roundId: 'round-4',
          team1Id: 'team-1',
          team2Id: 'team-5',
        ),
        MatchupModel(
          id: 'matchup-4-2',
          roundId: 'round-4',
          team1Id: 'team-2',
          team2Id: 'team-6',
        ),
        MatchupModel(
          id: 'matchup-4-3',
          roundId: 'round-4',
          team1Id: 'team-3',
          team2Id: 'team-7',
        ),
      ],
      scores: const [
        // team-1: Ben (hdcp 1, A), Joel (hdcp 17, B)
        ScoreModel(
          userId: 'user-14',
          holeScores: {
            10: 4,
            11: 3,
            12: 3,
            13: 4,
            14: 4,
            15: 3,
            16: 3,
            17: 4,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-13',
          holeScores: {
            10: 5,
            11: 5,
            12: 5,
            13: 5,
            14: 6,
            15: 5,
            16: 6,
            17: 6,
            18: 5,
          },
        ),
        // team-5: Andrew (hdcp 6, A), Mike (hdcp 8, B)
        ScoreModel(
          userId: 'user-11',
          holeScores: {
            10: 4,
            11: 4,
            12: 4,
            13: 4,
            14: 5,
            15: 4,
            16: 4,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-3',
          holeScores: {
            10: 5,
            11: 4,
            12: 4,
            13: 5,
            14: 6,
            15: 4,
            16: 5,
            17: 5,
            18: 5,
          },
        ),
        // team-2: Brady (hdcp 2, A), Matt (hdcp 12, B)
        ScoreModel(
          userId: 'user-6',
          holeScores: {
            10: 3,
            11: 3,
            12: 3,
            13: 4,
            14: 5,
            15: 3,
            16: 3,
            17: 4,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-10',
          holeScores: {
            10: 5,
            11: 4,
            12: 4,
            13: 5,
            14: 6,
            15: 5,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
        // team-6: Brandon (hdcp 9, A), Jake (hdcp 11, B)
        ScoreModel(
          userId: 'user-2',
          holeScores: {
            10: 5,
            11: 4,
            12: 5,
            13: 5,
            14: 5,
            15: 5,
            16: 4,
            17: 5,
            18: 5,
          },
        ),
        ScoreModel(
          userId: 'user-12',
          holeScores: {
            10: 5,
            11: 5,
            12: 4,
            13: 5,
            14: 6,
            15: 5,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
        // team-3: Aaron (hdcp 3, A), Brett (hdcp 15, B)
        ScoreModel(
          userId: 'user-4',
          holeScores: {
            10: 4,
            11: 3,
            12: 3,
            13: 4,
            14: 5,
            15: 4,
            16: 3,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-8',
          holeScores: {
            10: 6,
            11: 5,
            12: 5,
            13: 6,
            14: 7,
            15: 5,
            16: 5,
            17: 6,
            18: 5,
          },
        ),
        // team-7: AJ (hdcp 10, A), Adam (hdcp 10, B)
        ScoreModel(
          userId: 'user-1',
          holeScores: {
            10: 4,
            11: 4,
            12: 4,
            13: 5,
            14: 5,
            15: 4,
            16: 4,
            17: 5,
            18: 4,
          },
        ),
        ScoreModel(
          userId: 'user-5',
          holeScores: {
            10: 5,
            11: 5,
            12: 4,
            13: 5,
            14: 6,
            15: 5,
            16: 4,
            17: 6,
            18: 5,
          },
        ),
      ],
    ),

    // ─── Round 5: front 9, in-progress ──────────────────────────────────────
    // Matchups: team-1 vs team-6, team-2 vs team-4, team-5 vs team-7
    // Bye: team-3 (Aaron + Brett)
    // Partial scores: 4 holes completed for all 12 active members
    RoundModel(
      id: 'round-5',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 7, 2),
      status: RoundStatus.inProgress,
      holeNumbers: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      matchups: const [
        MatchupModel(
          id: 'matchup-5-1',
          roundId: 'round-5',
          team1Id: 'team-1',
          team2Id: 'team-6',
        ),
        MatchupModel(
          id: 'matchup-5-2',
          roundId: 'round-5',
          team1Id: 'team-2',
          team2Id: 'team-4',
        ),
        MatchupModel(
          id: 'matchup-5-3',
          roundId: 'round-5',
          team1Id: 'team-5',
          team2Id: 'team-7',
        ),
      ],
      scores: const [
        // team-1: Ben (hdcp 1, A), Joel (hdcp 17, B)
        ScoreModel(userId: 'user-14', holeScores: {1: 4, 2: 3, 3: 4, 4: 4}),
        ScoreModel(userId: 'user-13', holeScores: {1: 6, 2: 5, 3: 5, 4: 6}),
        // team-6: Brandon (hdcp 9, A), Jake (hdcp 11, B)
        ScoreModel(userId: 'user-2', holeScores: {1: 5, 2: 4, 3: 5, 4: 5}),
        ScoreModel(userId: 'user-12', holeScores: {1: 5, 2: 5, 3: 5, 4: 5}),
        // team-2: Brady (hdcp 2, A), Matt (hdcp 12, B)
        ScoreModel(userId: 'user-6', holeScores: {1: 4, 2: 3, 3: 3, 4: 4}),
        ScoreModel(userId: 'user-10', holeScores: {1: 5, 2: 4, 3: 5, 4: 5}),
        // team-4: Ryan C (hdcp 5, A), Ryan A (hdcp 12, B)
        ScoreModel(userId: 'user-7', holeScores: {1: 5, 2: 4, 3: 4, 4: 5}),
        ScoreModel(userId: 'user-9', holeScores: {1: 5, 2: 4, 3: 5, 4: 6}),
        // team-5: Andrew (hdcp 6, A), Mike (hdcp 8, B)
        ScoreModel(userId: 'user-11', holeScores: {1: 5, 2: 4, 3: 4, 4: 5}),
        ScoreModel(userId: 'user-3', holeScores: {1: 5, 2: 5, 3: 5, 4: 5}),
        // team-7: AJ (hdcp 10, A), Adam (hdcp 10, B)
        ScoreModel(userId: 'user-1', holeScores: {1: 5, 2: 4, 3: 4, 4: 5}),
        ScoreModel(userId: 'user-5', holeScores: {1: 5, 2: 5, 3: 5, 4: 6}),
      ],
    ),

    // ─── Round 6: back 9, upcoming ──────────────────────────────────────────
    // Matchups: team-1 vs team-7, team-3 vs team-5, team-4 vs team-6
    // Bye: team-2 (Brady + Matt)
    RoundModel(
      id: 'round-6',
      leagueId: 'league-1',
      courseId: 'course-1',
      date: DateTime(2025, 7, 9),
      status: RoundStatus.upcoming,
      holeNumbers: [10, 11, 12, 13, 14, 15, 16, 17, 18],
      matchups: const [
        MatchupModel(
          id: 'matchup-6-1',
          roundId: 'round-6',
          team1Id: 'team-1',
          team2Id: 'team-7',
        ),
        MatchupModel(
          id: 'matchup-6-2',
          roundId: 'round-6',
          team1Id: 'team-3',
          team2Id: 'team-5',
        ),
        MatchupModel(
          id: 'matchup-6-3',
          roundId: 'round-6',
          team1Id: 'team-4',
          team2Id: 'team-6',
        ),
      ],
      scores: const [],
    ),
  ];
}
