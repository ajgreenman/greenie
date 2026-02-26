import 'package:greenie/league/league_providers.dart';
import 'package:greenie/round/infrastructure/league_scoring_calculator.dart';
import 'package:greenie/round/infrastructure/models/matchup_result.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/round_repository.dart';
import 'package:greenie/user/user_providers.dart';
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

@riverpod
Future<MatchupResult> fetchMatchupResult(
  Ref ref,
  String roundId,
  String matchupId,
) async {
  final round = await ref.watch(fetchRoundProvider(roundId).future);
  if (round == null) throw StateError('Round not found: $roundId');

  final matchup = round.matchups.where((m) => m.id == matchupId).firstOrNull;
  if (matchup == null) throw StateError('Matchup not found: $matchupId');

  final league = await ref.watch(fetchLeagueProvider(round.leagueId).future);
  final team1 = league.teams.where((t) => t.id == matchup.team1Id).first;
  final team2 = league.teams.where((t) => t.id == matchup.team2Id).first;

  final members = await ref.watch(fetchMembersProvider(round.leagueId).future);

  return calculateMatchupResult(
    matchup: matchup,
    team1: team1,
    team2: team2,
    members: members,
    scores: round.scores,
    holeNumbers: round.holeNumbers,
  );
}
