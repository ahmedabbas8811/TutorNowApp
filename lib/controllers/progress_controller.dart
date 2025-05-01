import 'package:flutter/material.dart';
import 'package:newifchaly/models/progress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressController {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Save progress report to Supabase with last week check
  Future<String> saveProgressReport(
      ProgressModel report, BuildContext context) async {
    try {
      // 1. First get the package ID from the booking
      final bookingResponse = await supabase
          .from('bookings')
          .select('package_id')
          .eq('id', report.bookingId)
          .single();

      final packageId = bookingResponse['package_id'];

      // 2. Then get the total weeks from the package
      final packageResponse = await supabase
          .from('packages')
          .select('number_of_weeks')
          .eq('id', packageId)
          .single();

      final totalWeeks =
          int.tryParse(packageResponse['number_of_weeks']?.toString() ?? '0') ??
              0;

      // 3. Save the progress report first
      final insertResponse = await supabase.from('progress_reports').insert([
        {
          'week': report.week,
          'overall_performance': report.overallPerformance,
          'comments': report.comments,
          'booking_id': report.bookingId,
        }
      ]).select();

      // 4. Check if this is the last week and update status
      if (report.week == totalWeeks) {
        print('📢 This is the FINAL week of the package!');
        await supabase
            .from('bookings')
            .update({'status': 'completed'}).eq('id', report.bookingId);
      }

      await checkProgressReportExists(report.bookingId, report.week);
      Navigator.of(context).pop();
      return "Progress report saved successfully!";
    } catch (e) {
      return "Error saving progress: $e";
    }
  }

  Future<bool> checkProgressReportExists(
      String bookingId, int weekNumber) async {
    try {
      final response = await supabase
          .from('progress_reports')
          .select()
          .eq('booking_id', bookingId)
          .eq('week', weekNumber)
          .maybeSingle();

      if (response != null) {
        print(
            'Progress report exists for booking $bookingId, week $weekNumber');
        print('Report details: $response');
        return true;
      } else {
        print(
            'No progress report found for booking $bookingId, week $weekNumber');
        return false;
      }
    } catch (e) {
      print('Error checking progress report: $e');
      return false;
    }
  }

  Future<ProgressModel?> fetchProgressReport(
      String bookingId, int weekNumber) async {
    try {
      final response = await supabase
          .from('progress_reports')
          .select()
          .eq('booking_id', bookingId)
          .eq('week', weekNumber)
          .maybeSingle();

      if (response != null) {
        return ProgressModel.fromMap(response);
      }
      return null;
    } catch (e) {
      print('Error fetching progress report: $e');
      return null;
    }
  }
}
