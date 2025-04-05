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

class TutorQualifications {
  final int underMatric;
  final int matric;
  final int fsc;
  final int bachelors;
  final int masters;
  final int phd;

  const TutorQualifications({
    required this.underMatric,
    required this.matric,
    required this.fsc,
    required this.bachelors,
    required this.masters,
    required this.phd,
  });

  factory TutorQualifications.empty() {
    return const TutorQualifications(
      underMatric: 0,
      matric: 0,
      fsc: 0,
      bachelors: 0,
      masters: 0,
      phd: 0,
    );
  }

  List<int> toList() {
    return [underMatric, matric, fsc, bachelors, masters, phd];
  }
}