import 'package:get/get.dart';
import 'package:newifchaly/admin/models/tutor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TutorController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var tutors = <Tutor>[].obs; // Reactive list of tutors
  var isLoading = true.obs; // Reactive loading state

  @override
  void onInit() {
    super.onInit();
    fetchTutors();
  }

// Update the fetchTutors method in TutorController
  Future<void> fetchTutors() async {
    try {
      isLoading(true);

      // Fetch tutors from the 'users' table
      final response = await _supabase
          .from('users')
          .select('id, metadata, is_verified')
          .match({'user_type': 'Tutor'});

      if (response != null) {
        // Map users to Tutor objects
        var fetchedTutors =
            List<Tutor>.from(response.map((data) => Tutor.fromJson(data)));

        // Fetch additional data for each tutor
        for (var tutor in fetchedTutors) {
          // Fetch qualifications
          final qualificationResponse = await _supabase
              .from('qualification')
              .select('education_level')
              .eq('user_id', tutor.id);

          if (qualificationResponse != null &&
              qualificationResponse.isNotEmpty) {
            // Handle both single qualification and multiple qualifications
            tutor.qualifications = qualificationResponse
                .map<String>(
                    (data) => data['education_level']?.toString() ?? '')
                .where((qual) => qual.isNotEmpty)
                .toList();
          }

          // Fetch profile completion data
          final profileCompletionResponse = await _supabase
              .from('profile_completion_steps')
              .select('*')
              .eq('user_id', tutor.id)
              .maybeSingle();

          if (profileCompletionResponse != null) {
            tutor.rejectionReason =
                profileCompletionResponse['rejection_reason']?.toString();
            tutor.profileCompletedSteps = Map<String, dynamic>.from(
                profileCompletionResponse..remove('rejection_reason'));
          }

          // Determine status
          tutor.status = _determineTutorStatus(tutor);
        }

        tutors.value =
            fetchedTutors.where((t) => t.name != 'Unknown Name').toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tutors: ${e.toString()}');
      print('Error details: $e');
    } finally {
      isLoading(false);
    }
  }

// Helper method to determine status
  String _determineTutorStatus(Tutor tutor) {
    if (tutor.isVerified) {
      return 'approved';
    } else if (!tutor.isVerified && tutor.rejectionReason == null) {
      return 'pending';
    } else if (!tutor.isVerified &&
        tutor.rejectionReason != null &&
        _hasIncompleteProfileSteps(tutor.profileCompletedSteps)) {
      return 'rejected';
    }
    return 'pending'; 
  }

// Helper method to check if any profile steps are incomplete
  bool _hasIncompleteProfileSteps(Map<String, dynamic>? steps) {
    if (steps == null) return true;

    // Check if any required step is false or null
    return steps.entries.any((entry) =>
        entry.key !=
            'rejection_reason' && 
        (entry.value == false || entry.value == null));
  }
}
