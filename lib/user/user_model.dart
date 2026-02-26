class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.memberId,
  });

  final String id;
  final String name;
  final String email;
  final bool isAdmin;

  /// Links this user to their [MemberModel] in a league.
  final String memberId;
}
