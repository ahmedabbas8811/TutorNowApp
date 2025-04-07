import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_model.dart';

class DashboardController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<DashboardStats> fetchPlatformEngagement() async {
    try {
      // Fetch all users
      final response = await supabase.from('users').select('id, user_type, is_verified');
      if (response == null || response.isEmpty) {
        return DashboardStats.empty();
      }

      int newUsers = response.length;
      int activeTutors = response
          .where((user) => user['user_type'] == 'Tutor' && user['is_verified'] == true)
          .length;
      int activeStudents = response
          .where((user) => user['user_type'] == 'Student')
          .length;
      int completedSessions = 99; 

      return DashboardStats(
        newUsers: newUsers,
        completedSessions: completedSessions,
        activeTutors: activeTutors,
        activeStudents: activeStudents,
      );
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return DashboardStats.empty();
    }
  }

  Future<TutorQualifications> fetchTutorQualifications() async {
  try {
    // Join 'qualification' with 'users' and filter where users.is_verified is true
    final response = await supabase
        .from('qualification')
        .select('education_level, users!inner(is_verified)')
        .eq('users.is_verified', true);

    if (response == null || response.isEmpty) {
      return TutorQualifications.empty();
    }

    // Initialize counters
    int underMatric = 0;
    int matric = 0;
    int fsc = 0;
    int bachelors = 0;
    int masters = 0;
    int phd = 0;

    // Count each education level from verified tutors only
    for (var record in response) {
      final level = record['education_level']?.toString().toLowerCase() ?? '';

      if (level.contains('under matric')) {
        underMatric++;
      } else if (level.contains('matric')) {
        matric++;
      } else if (level.contains('fsc') || level.contains('intermediate')) {
        fsc++;
      } else if (level.contains('bachelor')) {
        bachelors++;
      } else if (level.contains('master')) {
        masters++;
      } else if (level.contains('phd') || level.contains('doctorate')) {
        phd++;
      }
    }

    return TutorQualifications(
      underMatric: underMatric,
      matric: matric,
      fsc: fsc,
      bachelors: bachelors,
      masters: masters,
      phd: phd,
    );
  } catch (e) {
    print('Error fetching qualifications: $e');
    return TutorQualifications.empty();
  }
}

Future<TutorExperience> fetchTutorExperience() async {
  try {
    // Join 'experience' with 'users' and filter where users.is_verified is true
    final response = await supabase
        .from('experience')
        .select('start_date, end_date, users!inner(is_verified)')
        .eq('users.is_verified', true);

    if (response == null || response.isEmpty) {
      return TutorExperience.empty();
    }

    // Initialize counters for each experience range
    int zeroToTwo = 0;
    int threeToFour = 0;
    int fiveToSix = 0;
    int sevenToEight = 0;
    int nineToTen = 0;
    int underFifteen = 0;
    int underTwenty = 0;
    int overTwentyFive = 0;

    // Calculate experience for each tutor
    for (var record in response) {
      final startDateStr = record['start_date']?.toString() ?? '';
      final endDateStr = record['end_date']?.toString() ?? '';

      if (startDateStr.isEmpty || endDateStr.isEmpty) continue;

      try {
        // Parse dates (assuming format is DD/MM/YYYY)
        final startParts = startDateStr.split('/');
        final endParts = endDateStr.split('/');
        
        if (startParts.length != 3 || endParts.length != 3) continue;
        
        final startDate = DateTime(
          int.parse(startParts[2]),
          int.parse(startParts[1]),
          int.parse(startParts[0]),
        );
        final endDate = DateTime(
          int.parse(endParts[2]),
          int.parse(endParts[1]),
          int.parse(endParts[0]),
        );

        // Calculate difference in years
        final difference = endDate.difference(startDate);
        final years = difference.inDays / 365;

        // Categorize the experience
        if (years <= 2) {
          zeroToTwo++;
        } else if (years <= 4) {
          threeToFour++;
        } else if (years <= 6) {
          fiveToSix++;
        } else if (years <= 8) {
          sevenToEight++;
        } else if (years <= 10) {
          nineToTen++;
        } else if (years <= 15) {
          underFifteen++;
        } else if (years <= 20) {
          underTwenty++;
        } else {
          overTwentyFive++;
        }
      } catch (e) {
        print('Error parsing date: $e');
        continue;
      }
    }

    return TutorExperience(
      zeroToTwo: zeroToTwo,
      threeToFour: threeToFour,
      fiveToSix: fiveToSix,
      sevenToEight: sevenToEight,
      nineToTen: nineToTen,
      underFifteen: underFifteen,
      underTwenty: underTwenty,
      overTwentyFive: overTwentyFive,
    );
  } catch (e) {
    print('Error fetching experience: $e');
    return TutorExperience.empty();
  }
}
}
