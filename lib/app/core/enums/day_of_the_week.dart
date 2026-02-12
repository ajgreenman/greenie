enum DayOfTheWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get displayName =>
      '${this.name[0].toUpperCase()}${this.name.substring(1)}';
}
