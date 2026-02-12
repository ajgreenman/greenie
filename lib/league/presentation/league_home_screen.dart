import 'package:flutter/material.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';

class LeagueHomeScreen extends StatelessWidget {
  const LeagueHomeScreen({super.key, required this.league});

  final LeagueModel league;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [Text(league.name), Text(league.day.displayName)],
    );
  }
}
