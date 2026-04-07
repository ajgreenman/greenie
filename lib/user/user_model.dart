class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.handicap,
  });

  final String id;
  final String name;
  final String email;
  final int handicap;
}
