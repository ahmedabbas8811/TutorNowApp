import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tutor_confirmation_controller.dart';
import '../views/sidemenu.dart';
import 'personal_information.dart';
import 'qualification_information.dart';
import 'experience_information.dart';

class ConfirmationScreen extends StatelessWidget {
  final String tutorId;

  const ConfirmationScreen({super.key, required this.tutorId});

  @override
  Widget build(BuildContext context) {
    final TutorConfirmationController controller = Get.put(TutorConfirmationController());

    // Fetch tutor details when the screen loads
    controller.fetchTutorDetails(tutorId);

    return Scaffold(
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Obx(() {
              // Display loading indicator while fetching data
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle case where tutor details are not found
              final tutor = controller.tutor.value;
              if (tutor == null) {
                return const Center(child: Text('Tutor not found.'));
              }

              // Display the tutor details
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Approve Tutors',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: PersonalInformation(
                              userId: tutorId,
                              userName: tutor.name,
                              userMail: tutor.email,
                              img_Url: tutor.imageUrl,
                              userLocation: tutor.location, // Location now visible
                              onDownloadPressed: () {
                                if (tutor.cnicUrl.isNotEmpty) {
                                  controller.openCNIC(tutor.cnicUrl);
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'CNIC URL not available',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              onApprovePressed: () {
                                controller.verifyTutor(tutorId);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: QualificationInformation(tutorId: tutorId),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: ExperienceInformation(tutorId: tutorId),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
