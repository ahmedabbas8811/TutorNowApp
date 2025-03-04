import 'package:newifchaly/models/progress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressController {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Save progress report to Supabase
  Future<String> saveProgressReport(ProgressModel report) async {
    try {
      await supabase.from('progress_reports').insert([
        {
          'week': report.week,
          'overall_performance': report.overallPerformance,
          'comments': report.comments,
          'booking_id': report.bookingId, 
        }
      ]);

      return "Progress report saved successfully!";
    } catch (e) {
      return "Error saving progress: $e";
    }
  }
}
