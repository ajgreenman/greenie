import 'package:flutter/material.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';

class LeagueInfoHeader extends StatelessWidget {
  const LeagueInfoHeader({super.key, required this.league});

  final LeagueModel league;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(league.name, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.golf_course,
                size: 16,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Text(
                league.course.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.calendar_today,
                size: 16,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Text(
                '${league.day.displayName}s',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
