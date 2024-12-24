// // controllers/tutor_controller.dart
// import 'package:get/get.dart';
// import 'package:newifchaly/admin/models/tutor_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TutorController extends GetxController {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   var tutors = <Tutor>[].obs; // Reactive list of tutors
//   var isLoading = true.obs; // Reactive loading state

//   @override
//   void onInit() {
//     super.onInit();
//     fetchTutors();
//   }

//   Future<void> fetchTutors() async {
//     try {
//       isLoading(true);
//       final response = await _supabase
//           .from('users')
//           .select('id, metadata, is_verified')
//           .match({'user_type': 'Tutor', 'is_verified': false,});

//       if (response != null) {
//         tutors.value =
//             List<Tutor>.from(response.map((data) => Tutor.fromJson(data)));
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch tutors: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
// }
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

  Future<void> fetchTutors() async {
    try {
      isLoading(true);

      // Step 1: Fetch tutors from the 'users' table
      final response = await _supabase
          .from('users')
          .select('id, metadata, is_verified')
          .match({'user_type': 'Tutor', 'is_verified': false});

      if (response != null) {
        // Map users to Tutor objects without qualifications
        var fetchedTutors = List<Tutor>.from(response.map((data) => Tutor.fromJson(data)));

        // Step 2: Fetch qualifications for each tutor
        for (var tutor in fetchedTutors) {
          final qualificationResponse = await _supabase
              .from('qualification')
              .select('education_level')
              .eq('user_id', tutor.id);

          if (qualificationResponse != null) {
            // Map qualifications and join them into a comma-separated string
            tutor.qualification = qualificationResponse
                .map((data) => data['education_level'])
                .join(', ');
          }
        }

        tutors.value = fetchedTutors;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tutors: $e');
    } finally {
      isLoading(false);
    }
  }
}
