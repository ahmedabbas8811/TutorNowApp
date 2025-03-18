import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/student/models/progress_images_model.dart';

class ProgressImagesController {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProgressImagesModel>> fetchProgressImages({
    required int bookingId,
    required int week,
  }) async {
    try {
      final response = await _supabase
          .from('progress_report_images')
          .select()
          .eq('booking_id', bookingId)
          .eq('week', week)
          .order('created_at', ascending: true);

      // Convert PostgrestList to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> data = [];
      for (var item in response) {
        data.add(item);
            }

      if (data.isEmpty) return [];

      return data.map((json) => ProgressImagesModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch progress images: $e');
    }
  }
}