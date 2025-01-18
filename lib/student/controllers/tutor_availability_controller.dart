import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/student/models/tutor_availability_model.dart';
import 'package:intl/intl.dart'; // For time formatting

class TutorAvailabilityController extends GetxController {
  final int totalSessions;
  final int packageId;

  var currentSession = 1.obs;
  var selectedDay = "Mon".obs;
  var selectedTime = "".obs;
  var availabilityList = <TutorAvailabilityModel>[].obs;
  var userId = ''.obs;
  var availableSlots = <String>[].obs;

  TutorAvailabilityController({required this.totalSessions, required this.packageId});

  @override
  void onInit() {
    super.onInit();
    fetchUserId();
  }

  // Fetch user_id based on packageId
  Future<void> fetchUserId() async {
    try {
      final response = await Supabase.instance.client
          .from('packages')
          .select('user_id')
          .eq('id', packageId)
          .single();

      if (response != null) {
        userId.value = response['user_id'];
        print("Fetched user_id: ${userId.value}");
        fetchAvailability();
      } else {
        print("No user found for packageId: $packageId");
      }
    } catch (e) {
      print("Error fetching user_id for packageId: $e");
    }
  }

  // Fetch availability data from the availability table
  Future<void> fetchAvailability() async {
  if (userId.value.isEmpty) {
    print("User ID is empty. Cannot fetch availability.");
    return;
  }

  try {
    final List<dynamic> response = await Supabase.instance.client
        .from('availability')
        .select('day, is_available, slots')
        .eq('user_id', userId.value);

    print("Raw response from availability table: $response");

    if (response.isNotEmpty) {
      final filteredData = response.where((item) => item['is_available'] == true).toList();
      print("Filtered availability data: $filteredData");

      availabilityList.value = filteredData
          .map((item) => TutorAvailabilityModel(
                day: item['day'], // Extract day
                slots: item['slots'], // Extract slots
              ))
          .toList();

      // Debugging: Print each day and its processed slots
      for (var availability in availabilityList) {
        print("Day: ${availability.day}");
        processSlots(availability.slots); // Process slots for debugging
        print("Processed Slots for ${availability.day}: $availableSlots");
      }
    } else {
      print("No availability found for user_id: ${userId.value}");
    }
  } catch (e) {
    print("Error fetching availability: $e");
  }
}



  // Process slots for a specific day
  void processSlots(List<dynamic> slotsJson) {
  availableSlots.clear();
  for (var slot in slotsJson) {
    final startTime = _parseTime(slot['start']); // Extract start time
    final endTime = _parseTime(slot['end']); // Extract end time

    var current = startTime;
    while (current.isBefore(endTime) || current == endTime) {
      availableSlots.add(DateFormat('h:mm a').format(current)); // Format to 12-hour
      current = current.add(const Duration(minutes: 30)); // Add 30-minute intervals
    }
  }
  print("Processed slots: $availableSlots");
}


  // Helper method to parse time strings (e.g., "8:0") into DateTime objects
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(0, 0, 0, hour, minute);
  }



  // Move to the next session
  void nextSession() {
  if (currentSession.value < totalSessions) {
    // Add the current selection to the availability list
    availabilityList.add(TutorAvailabilityModel(
      day: selectedDay.value,
      slots: [], // Leave slots empty if not required here
      selectedTime: selectedTime.value, // Store the selected time
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
    slots: [], // Leave slots empty if no slots are required here
    selectedTime: selectedTime.value, // Store the selected time
  ));
  print("Final Availability List:");
  for (var availability in availabilityList) {
    print("Day: ${availability.day}, Selected Time: ${availability.selectedTime}");
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
