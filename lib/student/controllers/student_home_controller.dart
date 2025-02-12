import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_home_model.dart';

class StudentHomeController {
  final SupabaseClient _client;

  StudentHomeController() : _client = Supabase.instance.client;

  // Method to fetch unique education levels
  Future<List<String>> fetchUniqueEducationLevels() async {
    try {
      final response = await _client.from('teachto').select('education_level');

      if (response.isEmpty) {
        return [];
      }

      // Extract unique education levels using Set to remove duplicates
      final uniqueLevels = response
          .map((row) => row['education_level'] as String)
          .toSet()
          .toList();

      return uniqueLevels;
    } catch (e) {
      print('Error fetching education levels: $e');
      return [];
    }
  }

  // Method to fetch tutors for a specific education level with subjects
  Future<List<Tutor>> fetchTutorsForEducationLevel(
      String educationLevel) async {
    try {
      // Fetch rows from teachto table with user details and subjects
      final response = await _client
          .from('teachto')
          .select(
              'user_id, education_level, subject, users(metadata->>name, image_url)')
          .eq('education_level', educationLevel);

      if (response.isEmpty) {
        return [];
      }

      // Use a Map to group tutors by user_id and accumulate their education levels and subjects
      final Map<String, Map<String, dynamic>> tutorData = {};

      for (var row in response) {
        final userId = row['user_id'] as String;
        final level = row['education_level'] as String;
        final subject = row['subject'] as String; // Get subject
        final user = row['users'];

        // Check if tutorData already contains the userId
        if (tutorData.containsKey(userId)) {
          // Safely add the education level and subject if not already present
          final educationLevels =
              tutorData[userId]?['educationLevels'] as List<String>;
          final subjects = tutorData[userId]?['subjects'] as List<String>;

          if (!educationLevels.contains(level)) {
            educationLevels.add(level);
          }
          if (!subjects.contains(subject)) {
            subjects.add(subject);
          }
        } else {
          // Add a new tutor entry
          tutorData[userId] = {
            'user': user,
            'educationLevels': [level],
            'subjects': [subject], // Initialize with the first subject
          };
        }
      }

      // Convert the Map to a list of Tutor objects with concatenated education levels and subjects
      final tutors = tutorData.entries.map((entry) {
        final userId = entry.key; // Extract userId
        final user = entry.value['user'];
        final educationLevels =
            (entry.value['educationLevels'] as List<String>).join(', ');
        final subjects = (entry.value['subjects'] as List<String>).join(', ');

        return Tutor.fromJson(
            user, userId, educationLevels, subjects); // Pass userId
      }).toList();

      return tutors;
    } catch (e) {
      print('Error fetching tutors for $educationLevel: $e');
      return [];
    }
  }
}
