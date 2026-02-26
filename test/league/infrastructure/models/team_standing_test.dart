import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/league/infrastructure/models/team_standing.dart';

const _team = TeamModel(
  id: 'team-1',
  leagueId: 'league-1',
  memberIds: ['m1', 'm2'],
  name: 'Test Team',
);

TeamStanding _standing({
  int wins = 0,
  int losses = 0,
  int ties = 0,
  double totalPoints = 0,
  int rank = 1,
}) {
  return TeamStanding(
    team: _team,
    wins: wins,
    losses: losses,
    ties: ties,
    totalPoints: totalPoints,
    rank: rank,
  );
}

void main() {
  group('TeamStanding', () {
    test('stores all fields', () {
      final standing = _standing(
        wins: 3,
        losses: 1,
        ties: 0,
        totalPoints: 145.5,
        rank: 1,
      );
      expect(standing.team, _team);
      expect(standing.wins, 3);
      expect(standing.losses, 1);
      expect(standing.ties, 0);
      expect(standing.totalPoints, 145.5);
      expect(standing.rank, 1);
    });

    test('roundsPlayed = wins + losses + ties', () {
      expect(_standing(wins: 2, losses: 1, ties: 1).roundsPlayed, 4);
    });

    test('roundsPlayed is 0 when no rounds played', () {
      expect(_standing().roundsPlayed, 0);
    });

    test('roundsPlayed counts ties', () {
      expect(_standing(ties: 3).roundsPlayed, 3);
    });
  });
}
