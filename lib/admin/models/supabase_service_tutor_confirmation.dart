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
          .eq('id', tutorId);
    } catch (e) {
      throw Exception('Error updating tutor verification: $e');
    }
  }

  Future<void> insertRejectionReason(String tutorId, String reason) async {
    try {
      final response = await _client
          .from('profile_completion_steps')
          .select('rejection_reason')
          .eq('user_id', tutorId)
          .maybeSingle();

      List<dynamic> existingRejections = response?['rejection_reason'] ?? [];

      existingRejections.add({
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String()
      });

      if (response == null) {
        await _client.from('profile_completion_steps').insert({
          'user_id': tutorId,
          'rejection_reason': existingRejections,
        });
      } else {
        await _client
            .from('profile_completion_steps')
            .update({'rejection_reason': existingRejections})
            .eq('user_id', tutorId);
      }
    } catch (e) {
      throw Exception('Error inserting rejection reason: $e');
    }
  }

  Future<void> updateProfileCompletionSteps(
      String tutorId, List<String> selectedSteps) async {
    try {
      Map<String, dynamic> updates = {};

      if (selectedSteps.contains("Profile image")) updates["image"] = false;
      if (selectedSteps.contains("Location")) updates["location"] = false;
      if (selectedSteps.contains("CNIC")) updates["cnic"] = false;
      if (selectedSteps.contains("Qualification")) updates["qualification"] = false;
      if (selectedSteps.contains("Experience")) updates["exp"] = false;

      if (updates.isNotEmpty) {
        await _client
            .from('profile_completion_steps')
            .update(updates)
            .eq('user_id', tutorId);
      }
    } catch (e) {
      throw Exception('Error updating profile completion steps: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllRejectionReasons(String tutorId) async {
    try {
      final response = await _client
          .from('profile_completion_steps')
          .select('rejection_reason')
          .eq('user_id', tutorId)
          .maybeSingle();

      if (response == null || response['rejection_reason'] == null) {
        return [];
      }

      List<dynamic> rejectionReasons = response['rejection_reason'];

      return rejectionReasons.map((item) => {
        'reason': item['reason'] ?? 'Unknown reason',
        'timestamp': item['timestamp'] ?? 'No timestamp'
      }).toList();
      
    } catch (e) {
      throw Exception('Error fetching rejection reasons: $e');
    }
  }
}
