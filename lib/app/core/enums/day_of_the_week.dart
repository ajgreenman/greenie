enum DayOfTheWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get displayName => '${name[0].toUpperCase()}${name.substring(1)}';
}
