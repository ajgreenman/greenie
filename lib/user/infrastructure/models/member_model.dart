class MemberModel {
  const MemberModel({
    required this.id,
    required this.name,
    required this.handicap,
  });

  final String id;
  final String name;
  final int handicap;

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }
}
