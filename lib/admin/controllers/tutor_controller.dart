import 'package:get/get.dart';
import 'package:newifchaly/admin/models/tutor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TutorController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  var tutors = <Tutor>[].obs; 
  var isLoading = true.obs; 
  var approvedCount = 0.obs;
  var pendingCount = 0.obs;
  var rejectedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTutors();
  }

  Future<void> fetchTutors() async {
    try {
      isLoading(true);
      approvedCount.value = 0;
      pendingCount.value = 0;
      rejectedCount.value = 0;

      final response = await _supabase
          .from('users')
          .select('id, metadata, is_verified')
          .match({'user_type': 'Tutor'});

      if (response != null) {
        var fetchedTutors = List<Tutor>.from(response.map((data) => Tutor.fromJson(data)));

        for (var tutor in fetchedTutors) {
          final qualificationResponse = await _supabase
              .from('qualification')
              .select('education_level')
              .eq('user_id', tutor.id);

          if (qualificationResponse != null && qualificationResponse.isNotEmpty) {
            tutor.qualifications = qualificationResponse
                .map<String>((data) => data['education_level']?.toString() ?? '')
                .where((qual) => qual.isNotEmpty)
                .toList();
          }

          final profileCompletionResponse = await _supabase
              .from('profile_completion_steps')
              .select('*')
              .eq('user_id', tutor.id)
              .maybeSingle();

          if (profileCompletionResponse != null) {
            tutor.rejectionReason = profileCompletionResponse['rejection_reason']?.toString();
            tutor.profileCompletedSteps = Map<String, dynamic>.from(
                profileCompletionResponse..remove('rejection_reason'));
          }

          tutor.status = _determineTutorStatus(tutor);
          
          // Update counts based on status
          switch (tutor.status) {
            case 'approved':
              approvedCount.value++;
              break;
            case 'pending':
              pendingCount.value++;
              break;
            case 'rejected':
              rejectedCount.value++;
              break;
          }
        }

        tutors.value = fetchedTutors.where((t) => t.name != 'Unknown Name').toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tutors: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  // Calculate percentage of reviewed profiles
  double get reviewedPercentage {
    if (tutors.isEmpty) return 0.0;
    return ((approvedCount.value + rejectedCount.value) / tutors.length) * 100;
  }

  // Calculate percentage for each status
  double get approvedPercentage {
    if (tutors.isEmpty) return 0.0;
    return (approvedCount.value / tutors.length) * 100;
  }

  double get pendingPercentage {
    if (tutors.isEmpty) return 0.0;
    return (pendingCount.value / tutors.length) * 100;
  }

  double get rejectedPercentage {
    if (tutors.isEmpty) return 0.0;
    return (rejectedCount.value / tutors.length) * 100;
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
