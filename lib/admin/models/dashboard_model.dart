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

class TutorExperience {
  final int zeroToTwo;
  final int threeToFour;
  final int fiveToSix;
  final int sevenToEight;
  final int nineToTen;
  final int underFifteen;
  final int underTwenty;
  final int overTwentyFive;

  const TutorExperience({
    required this.zeroToTwo,
    required this.threeToFour,
    required this.fiveToSix,
    required this.sevenToEight,
    required this.nineToTen,
    required this.underFifteen,
    required this.underTwenty,
    required this.overTwentyFive,
  });

  factory TutorExperience.empty() {
    return const TutorExperience(
      zeroToTwo: 0,
      threeToFour: 0,
      fiveToSix: 0,
      sevenToEight: 0,
      nineToTen: 0,
      underFifteen: 0,
      underTwenty: 0,
      overTwentyFive: 0,
    );
  }

  List<int> toList() {
    return [
      zeroToTwo,
      threeToFour,
      fiveToSix,
      sevenToEight,
      nineToTen,
      underFifteen,
      underTwenty,
      overTwentyFive,
    ];
  }
}
class Booking {
  final String tutorName;
  final String studentName;
  final DateTime createdAt;

  Booking({
    required this.tutorName,
    required this.studentName,
    required this.createdAt,
  });

  String get formattedDate {
    return "${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year}";
  }

  String get formattedTime {
    return "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";
  }
}

class BookingStats {
  final int totalRequests;
  final int inProgress;
  final int completed;
  final int rejected;

  const BookingStats({
    required this.totalRequests,
    required this.inProgress,
    required this.completed,
    required this.rejected,
  });

  factory BookingStats.empty() {
    return const BookingStats(
      totalRequests: 0,
      inProgress: 0,
      completed: 0,
      rejected: 0,
    );
  }

  // Calculate percentages for each status
  double get inProgressPercentage => totalRequests > 0 ? inProgress / totalRequests : 0;
  double get completedPercentage => totalRequests > 0 ? completed / totalRequests : 0;
  double get rejectedPercentage => totalRequests > 0 ? rejected / totalRequests : 0;
}