class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.memberId,
  });

  final String id;
  final String name;
  final String email;

  /// Links this user to their [MemberModel] in a league.
  final String memberId;
}
