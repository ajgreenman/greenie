import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/round_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'round_providers.g.dart';

@riverpod
Future<List<RoundModel>> fetchRoundsForLeague(Ref ref, String leagueId) async {
  final repository = ref.watch(roundRepositoryProvider);
  return repository.fetchRoundsForLeague(leagueId);
}

@riverpod
Future<RoundModel?> fetchRound(Ref ref, String roundId) async {
  final repository = ref.watch(roundRepositoryProvider);
  return repository.fetchRound(roundId);
}
