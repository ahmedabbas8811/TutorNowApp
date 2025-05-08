import 'package:newifchaly/student/models/progress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressReportController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Add this to ProgressReportController
  Future<bool> isCurrentUserStudent() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final response = await _supabase
          .from('users')
          .select('user_type')
          .eq('id', user.id)
          .single();
      print("user type is $response");
      return response['user_type'] == 'Student';
    } catch (e) {
      throw Exception('Failed to check user role: $e');
    }
  }

  Future<void> linkParent(String bookingId, String parent_email) async {
    try {
      await _supabase
          .from('bookings')
          .update({'parent_email': parent_email}).eq('id', bookingId);
    } catch (e) {
      throw Exception('Failed to link parent: $e');
    }
  }

  // Fetch progress reports for a specific booking ID
  Future<List<ProgressReportModel>> fetchProgressReports(
      String bookingId) async {
    try {
      final response = await _supabase
          .from('progress_reports')
          .select()
          .eq('booking_id', bookingId)
          .order('week', ascending: true);

      if (response.isEmpty) {
        return [];
      }

      return response.map((data) => ProgressReportModel.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch progress reports: $e');
    }
  }

  // Calculate overall performance
  String calculateOverallPerformance(List<ProgressReportModel> reports) {
    if (reports.isEmpty) return 'No Data';

    // Calculate the average performance value
    final total = reports
        .map((report) => report.performanceValue)
        .reduce((a, b) => a + b);
    final average = total / reports.length;

    // Map the average to a performance category
    if (average >= 3.5) {
      return 'Excellent';
    } else if (average >= 2.5) {
      return 'Good';
    } else if (average >= 1.5) {
      return 'Average';
    } else {
      return 'Struggling';
    }
  }
}
