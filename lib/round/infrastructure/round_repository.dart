import 'package:greenie/round/infrastructure/fake_round_repository.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'round_repository.g.dart';

@riverpod
RoundRepository roundRepository(Ref ref) {
  return FakeRoundRepository();
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
}
