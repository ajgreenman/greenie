import 'package:flutter/material.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

class MemberListTile extends StatelessWidget {
  const MemberListTile({
    super.key,
    required this.member,
    this.emphasizeHandicap = false,
  });

  final MemberModel member;
  final bool emphasizeHandicap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(child: Text(member.initials)),
      title: Text(member.name),
      trailing: Text(
        '${member.handicap}',
        style: emphasizeHandicap
            ? theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
      ),
    );
  }
}
