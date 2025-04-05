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
    // Directly query the qualification table
    final response = await supabase
        .from('qualification')
        .select('education_level');

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

    // Count each education level
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
}
