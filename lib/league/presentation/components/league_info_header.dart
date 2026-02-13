import 'package:flutter/material.dart';
import 'package:greenie/app/core/design_constants.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';

class LeagueInfoHeader extends StatelessWidget {
  const LeagueInfoHeader({super.key, required this.league});

  final LeagueModel league;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: extraSmall,
        children: [
          Text(league.name, style: theme.textTheme.headlineMedium),
          Row(
            children: [
              Icon(
                Icons.golf_course,
                size: 16,
                color: theme.colorScheme.outline,
              ),
              Padding(
                padding: const EdgeInsets.only(left: extraSmall),
                child: Text(
                  league.course.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: medium),
                child: Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: extraSmall),
                child: Text(
                  '${league.day.displayName}s',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
