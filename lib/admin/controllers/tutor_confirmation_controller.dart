import 'package:get/get.dart';
import '../models/tutor_confirmation_model.dart';
import '../models/supabase_service_tutor_confirmation.dart';

import 'package:url_launcher/url_launcher.dart';

class TutorConfirmationController extends GetxController {
  final SupabaseService _service = SupabaseService();

  var tutor = Rxn<Tutor>();
  var isLoading = false.obs;

  Future<void> fetchTutorDetails(String tutorId) async {
  try {
    isLoading.value = true;

    // Fetch tutor details from the 'users' table
    final fetchedTutor = await _service.fetchTutorDetails(tutorId);

    // Fetch location details from the 'location' table
    final location = await _service.fetchLocation(tutorId);

    // Combine location data into a single string
    final formattedLocation =
        '${location['city']}, ${location['state']}, ${location['country']}';

    // Update the tutor object with the location
    fetchedTutor.location = formattedLocation;

    // Update the reactive tutor variable
    tutor.value = fetchedTutor;
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}

  Future<void> verifyTutor(String tutorId) async {
    try {
      await _service.updateTutorVerification(tutorId);
      Get.snackbar('Success', 'Tutor successfully verified!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> openCNIC(String cnicUrl) async {
    if (cnicUrl.isEmpty) {
      Get.snackbar('Error', 'CNIC URL not available');
      return;
    }

    try {
      final publicUrl = cnicUrl;
      if (await canLaunchUrl(Uri.parse(publicUrl))) {
        await launchUrl(Uri.parse(publicUrl), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $publicUrl';
      }
    } catch (e) {
      Get.snackbar('Error', 'Error opening CNIC: $e');
    }
  }
}
