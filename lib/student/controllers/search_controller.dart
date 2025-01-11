import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_model.dart';

class TutorController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all tutors
  Future<List<Tutor>> getAllTutors() async {
    try {
      final response = await _supabase.from('teachto').select(
          'id, user_id, education_level, subject, users!inner(image_url, metadata)');
      print(response);

      return response.map((data) => Tutor.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching all tutors: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  Future<List<Map<String, dynamic>>> fetchTutors(String keyword) async {
    try {
      // Perform the initial text search on the combined `search_vector` column
      final response = await _supabase
          .from('teachto')
          .select(
              'id, user_id, education_level, subject, users!inner(image_url, metadata)')
          .textSearch('search_vector', keyword);

      print('Supabase response: $response');

      // If no results are found, perform a fallback search in the users table metadata
      if (response.isEmpty) {
        final fallbackResponse = await _supabase
            .from('teachto')
            .select(
                'id, user_id, education_level, subject, users!inner(image_url, metadata)')
            .ilike('users.metadata->>name',
                '%$keyword%'); // Fallback search in metadata column

        print('****************Fallback response: $fallbackResponse');
        return fallbackResponse;
      }

      return response;
    } catch (e) {
      print('Error fetching tutors: $e');
      return [];
    }
  }

  // Search tutors and convert to objects
  Future<List<Tutor>> searchTutors(String keyword) async {
    try {
      final results = await fetchTutors(keyword);
      return results.map((data) => Tutor.fromMap(data)).toList();
    } catch (e) {
      print('Error searching tutors: $e');
      return [];
    }
  }
}
