import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'league_providers.g.dart';

@riverpod
Future<List<LeagueModel>> fetchLeagues(Ref ref) {
  final leagueRepository = ref.watch(leagueRepositoryProvider);
  return leagueRepository.fetchLeagues();
}

@riverpod
Future<LeagueModel?> fetchLeague(Ref ref, String leagueId) {
  final leagueRepository = ref.watch(leagueRepositoryProvider);
  return leagueRepository.fetchLeague(leagueId);
}
