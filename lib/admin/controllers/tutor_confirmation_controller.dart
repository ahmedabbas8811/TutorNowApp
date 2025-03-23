import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
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

  Future<void> verifyTutor(String tutorId, BuildContext context) async {
    try {
      await _service.updateTutorVerification(tutorId);
      showCustomSnackBar(context, "Tutor Successfully Approved");
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
        await launchUrl(Uri.parse(publicUrl),
            mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $publicUrl';
      }
    } catch (e) {
      Get.snackbar('Error', 'Error opening CNIC: $e');
    }
  }

  Future<void> rejectTutor(String tutorId, String reason,
      List<String> selectedSteps, BuildContext context) async {
    try {
      // Check if tutor exists in the profile_completion_steps table
      final existingRecord = await _service.getTutorProfileStep(tutorId);

      if (existingRecord == null) {
        await _service.insertRejectionReason(tutorId, reason);
      } else {
        await _service.updateRejectionReason(tutorId, reason);
      }

      // Update profile completion steps
      await _service.updateProfileCompletionSteps(tutorId, selectedSteps);

      showCustomSnackBar(context, "Tutor Rejected Successfully");
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
