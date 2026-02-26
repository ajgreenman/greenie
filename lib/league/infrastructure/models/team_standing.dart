import 'package:greenie/league/infrastructure/models/team_model.dart';

class TeamStanding {
  const TeamStanding({
    required this.team,
    required this.wins,
    required this.losses,
    required this.ties,
    required this.totalPoints,
    required this.rank,
  });

  final TeamModel team;
  final int wins;
  final int losses;
  final int ties;
  final double totalPoints;
  final int rank;

  int get roundsPlayed => wins + losses + ties;
}
