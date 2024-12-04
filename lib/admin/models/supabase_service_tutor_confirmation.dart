import 'package:supabase_flutter/supabase_flutter.dart';
import 'tutor_confirmation_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Tutor> fetchTutorDetails(String tutorId) async {
    try {
      final response = await _client
          .from('users')
          .select('metadata, email, cnic_url, image_url')
          .eq('id', tutorId)
          .single();
      print('Tutor ID: $tutorId');
      print('API Response for Tutor Details: $response');
      return Tutor.fromMap(response);
      
    } catch (e) {
      throw Exception('Error fetching tutor details: $e');
    }
  }

  Future<Map<String, String>> fetchLocation(String tutorId) async {
    try {
      final response = await _client
          .from('location')
          .select('country, state, city')
          .eq('user_id', tutorId)
          .single();
      return {
        'country': response['country'] ?? '',
        'state': response['state'] ?? '',
        'city': response['city'] ?? '',
      };
    } catch (e) {
      throw Exception('Error fetching location details: $e');
    }
  }

  Future<void> updateTutorVerification(String tutorId) async {
    try {
      await _client
          .from('users')
          .update({'is_verified': true})
          .eq('id', tutorId)
          .select();
    } catch (e) {
      throw Exception('Error updating tutor verification: $e');
    }
  }
}
