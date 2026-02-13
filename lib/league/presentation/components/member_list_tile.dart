import 'package:flutter/material.dart';
import 'package:greenie/app/core/design_constants.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

class MemberListTile extends StatelessWidget {
  const MemberListTile({super.key, required this.member});

  final MemberModel member;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(radius: avatarRadius, child: Text(member.initials)),
      title: Text(member.name),
      trailing: Text(
        'HC ${member.handicap}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
