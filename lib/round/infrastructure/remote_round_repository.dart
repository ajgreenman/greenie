import 'package:greenie/data/supabase/supabase_service.dart';
import 'package:greenie/round/infrastructure/models/models.dart';
import 'package:greenie/round/infrastructure/round_repository.dart';

class RemoteRoundRepository extends RoundRepository {
  RemoteRoundRepository(this._service);

  final SupabaseService _service;

  @override
  Future<List<RoundModel>> fetchRoundsForLeague(String leagueId) async {
    final rows = await _service.fetchRoundsForLeague(leagueId);
    return rows.map(_mapRound).toList();
  }

  @override
  Future<RoundModel?> fetchRound(String roundId) async {
    final row = await _service.fetchRound(roundId);
    if (row == null) return null;
    return _mapRound(row);
  }

  @override
  Future<void> updateScore(
    String roundId,
    String memberId,
    Map<int, int> holeScores,
  ) async {
    await _service.upsertScore(roundId, memberId, holeScores);
  }

  @override
  Future<RoundModel> startRound(String roundId) async {
    final row = await _service.updateRoundStatus(roundId, 'inProgress');
    return _mapRound(row);
  }

  @override
  Future<RoundModel> updateRoundSchedule(
    String roundId, {
    List<int>? holeNumbers,
    DateTime? startTime,
    Map<String, DateTime>? teamTeeTimes,
  }) async {
    final updates = <String, dynamic>{};
    if (holeNumbers != null) updates['hole_numbers'] = holeNumbers;
    if (startTime != null) updates['start_time'] = startTime.toIso8601String();
    if (teamTeeTimes != null) {
      updates['team_tee_times'] =
          teamTeeTimes.map((k, v) => MapEntry(k, v.toIso8601String()));
    }
    final row = await _service.updateRoundSchedule(roundId, updates);
    return _mapRound(row);
  }

  RoundModel _mapRound(Map<String, dynamic> row) {
    final scores = (row['scores'] as List<dynamic>).map((s) {
      final rawHoleScores = s['hole_scores'] as Map<String, dynamic>;
      final holeScores = rawHoleScores.map(
        (k, v) => MapEntry(int.parse(k), v as int),
      );
      return ScoreModel(userId: s['user_id'] as String, holeScores: holeScores);
    }).toList();

    final matchups = (row['matchups'] as List<dynamic>).map((m) {
      return MatchupModel(
        id: m['id'] as String,
        roundId: row['id'] as String,
        team1Id: m['team1_id'] as String,
        team2Id: m['team2_id'] as String,
      );
    }).toList();

    final holeNumbers =
        (row['hole_numbers'] as List<dynamic>).map((n) => n as int).toList();

    final startTime = row['start_time'] != null
        ? DateTime.parse(row['start_time'] as String)
        : null;

    final rawTeeTimes = row['team_tee_times'] as Map<String, dynamic>?;
    final teamTeeTimes = rawTeeTimes?.map(
      (k, v) => MapEntry(k, DateTime.parse(v as String)),
    );

    return RoundModel(
      id: row['id'] as String,
      leagueId: row['league_id'] as String,
      courseId: row['course_id'] as String,
      date: DateTime.parse(row['date'] as String),
      status: RoundStatus.values.byName(row['status'] as String),
      holeNumbers: holeNumbers,
      scores: scores,
      matchups: matchups,
      startTime: startTime,
      teamTeeTimes: teamTeeTimes,
    );
  }
}
