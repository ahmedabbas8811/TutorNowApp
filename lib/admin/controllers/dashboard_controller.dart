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
}
