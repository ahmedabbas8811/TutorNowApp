import 'package:newifchaly/student/models/progress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressReportController {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> linkParent(String bookingId, String parentId) async {
    try {
      await _supabase
          .from('bookings')
          .update({'parent_id': parentId}).eq('id', bookingId);
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
