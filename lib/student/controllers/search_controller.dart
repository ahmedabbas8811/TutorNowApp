import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_model.dart';

class TutorController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all tutors
  Future<List<Tutor>> getAllTutors() async {
    try {
      final response = await _supabase.from('teachto').select();
      return response.map((data) => Tutor.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching all tutors: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  Future<List<Map<String, dynamic>>> fetchTutors(String keyword) async {
    try {
      // Perform text search on the combined `search_vector` column
      final response = await _supabase
          .from('teachto')
          .select()
          .textSearch('search_vector', keyword); // Use the combined column

      print('Supabase response: $response');
      if (response.isEmpty) {}
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
