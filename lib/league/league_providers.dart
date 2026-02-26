import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/infrastructure/models/team_standing.dart';
import 'package:greenie/round/infrastructure/league_scoring_calculator.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/user_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'league_providers.g.dart';

@riverpod
Future<List<LeagueModel>> fetchLeagues(Ref ref) {
  final leagueRepository = ref.watch(leagueRepositoryProvider);
  return leagueRepository.fetchLeagues();
}

@riverpod
Future<LeagueModel> fetchLeague(Ref ref, String leagueId) {
  final leagueRepository = ref.watch(leagueRepositoryProvider);
  return leagueRepository.fetchLeague(leagueId);
}

@riverpod
Future<List<TeamStanding>> fetchStandings(Ref ref, String leagueId) async {
  final league = await ref.watch(fetchLeagueProvider(leagueId).future);
  final rounds = await ref.watch(fetchRoundsForLeagueProvider(leagueId).future);
  final members = await ref.watch(fetchMembersProvider(leagueId).future);

  final completed = rounds
      .where((r) => r.status == RoundStatus.completed)
      .toList();

  return calculateStandings(
    teams: league.teams,
    completedRounds: completed,
    members: members,
  );
}
