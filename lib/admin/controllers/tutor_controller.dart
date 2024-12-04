// controllers/tutor_controller.dart
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
      final response = await _supabase
          .from('users')
          .select('id, metadata, is_verified')
          .match({'user_type': 'Tutor', 'is_verified': false});

      if (response != null) {
        tutors.value =
            List<Tutor>.from(response.map((data) => Tutor.fromJson(data)));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tutors: $e');
    } finally {
      isLoading(false);
    }
  }
}
