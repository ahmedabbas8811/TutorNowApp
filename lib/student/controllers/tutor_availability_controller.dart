import 'package:get/get.dart';
import 'package:newifchaly/student/models/tutor_availability_model.dart';

class TutorAvailabilityController extends GetxController {
  final int totalSessions; // Total sessions fetched from package details
  var currentSession = 1.obs; // Tracks the current session
  var selectedDay = "Mon".obs; // Selected day
  var selectedTime = "12:00 PM".obs; // Selected time
  var availabilityList = <TutorAvailabilityModel>[].obs; // Stores all selected availabilities

  TutorAvailabilityController({required this.totalSessions});

  // Move to the next session
  void nextSession() {
    if (currentSession.value < totalSessions) {
      // Add the current selection to the availability list
      availabilityList.add(TutorAvailabilityModel(
        day: selectedDay.value,
        time: selectedTime.value,
      ));
      currentSession.value++;

      // Clear selections for the next session
      resetSelections();
    }
  }

  // Confirm availability
  void confirmAvailability() {
    // Add the last selection to the availability list
    availabilityList.add(TutorAvailabilityModel(
      day: selectedDay.value,
      time: selectedTime.value,
    ));
    print("Final Availability List:");
    for (var availability in availabilityList) {
      print("Day: ${availability.day}, Time: ${availability.time}");
    }
  }

  // Check if it's the last session
  bool isLastSession() {
    return currentSession.value == totalSessions;
  }

  // Reset day and time selections for the next session
  void resetSelections() {
    selectedDay.value = "Mon"; // Default to the first day
    selectedTime.value = "12:00 PM"; // Default to the first time slot
  }
}