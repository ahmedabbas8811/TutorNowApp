import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import '../models/tutor_confirmation_model.dart';
import '../models/supabase_service_tutor_confirmation.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorConfirmationController extends GetxController {
  final SupabaseService _service = SupabaseService();

  var tutor = Rxn<Tutor>();
  var isLoading = false.obs;
  var rejectionReasons = <Map<String, dynamic>>[].obs; // Add this line

  Future<void> fetchTutorDetails(String tutorId) async {
    try {
      isLoading.value = true;
      final fetchedTutor = await _service.fetchTutorDetails(tutorId);
      final location = await _service.fetchLocation(tutorId);
      final formattedLocation = '${location['city']}, ${location['state']}, ${location['country']}';

      fetchedTutor.location = formattedLocation;
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
        await launchUrl(Uri.parse(publicUrl), mode: LaunchMode.externalApplication);
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
      await _service.insertRejectionReason(tutorId, reason);
      await _service.updateProfileCompletionSteps(tutorId, selectedSteps);
      showCustomSnackBar(context, "Tutor Rejected Successfully");
      await fetchRejectionReasons(tutorId); // Refresh the list after rejection
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> fetchRejectionReasons(String tutorId) async {
    try {
      final reasons = await _service.getAllRejectionReasons(tutorId);
      rejectionReasons.assignAll(reasons); // Update the observable list
    } catch (e) {
      rejectionReasons.clear();
      Get.snackbar('Error', e.toString());
    }
  }
}