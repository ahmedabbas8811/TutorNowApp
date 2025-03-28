class DashboardStats {
  final int newUsers;
  final int completedSessions;
  final int activeTutors;
  final int activeStudents;

  const DashboardStats({
    required this.newUsers,
    required this.completedSessions,
    required this.activeTutors,
    required this.activeStudents,
  });

  factory DashboardStats.empty() {
    return const DashboardStats(
      newUsers: 0,
      completedSessions: 0,
      activeTutors: 0,
      activeStudents: 0,
    );
  }
}