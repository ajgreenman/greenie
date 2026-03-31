import 'package:greenie/round/infrastructure/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'round_repository.g.dart';

@riverpod
RoundRepository roundRepository(Ref ref) {
  throw UnimplementedError(
    'roundRepositoryProvider must be overridden via ProviderScope. '
    'Launch the app via main.dart or main_development.dart.',
  );
}

abstract class RoundRepository {
  Future<List<RoundModel>> fetchRoundsForLeague(String leagueId);
  Future<RoundModel?> fetchRound(String roundId);
  Future<void> updateScore(
    String roundId,
    String memberId,
    Map<int, int> holeScores,
  );
  Future<RoundModel> startRound(String roundId);
  Future<RoundModel> updateRoundSchedule(
    String roundId, {
    List<int>? holeNumbers,
    DateTime? startTime,
    Map<String, DateTime>? teamTeeTimes,
  });
}
