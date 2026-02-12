enum RoundStatus {
  upcoming,
  inProgress,
  completed;

  String get displayName {
    switch (this) {
      case RoundStatus.upcoming:
        return 'Upcoming';
      case RoundStatus.inProgress:
        return 'In Progress';
      case RoundStatus.completed:
        return 'Completed';
    }
  }
}
