import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/theme.dart';

class LeagueQuickLinks extends StatelessWidget {
  const LeagueQuickLinks({
    super.key,
    required this.leagueId,
    required this.isAdmin,
  });

  final String leagueId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _QuickLinkTile(
        icon: Icons.people,
        label: 'Members',
        onTap: () => context.go('/league/$leagueId/members'),
      ),
      _QuickLinkTile(
        icon: Icons.history,
        label: 'Past Rounds',
        onTap: () => context.go('/league/$leagueId/rounds'),
      ),
      _QuickLinkTile(icon: Icons.leaderboard, label: 'Standings', onTap: () {}),
      if (isAdmin)
        _QuickLinkTile(
          icon: Icons.admin_panel_settings,
          label: 'Admin',
          onTap: () {},
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: large),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 120,
          mainAxisSpacing: small,
          crossAxisSpacing: small,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tiles,
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(small),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: extraSmall,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              Text(label, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
