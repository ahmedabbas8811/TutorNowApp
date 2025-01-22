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
  late int required30MinSessions;

  TutorAvailabilityController(
      {required this.totalSessions, required this.packageId});

  @override
  void onInit() {
    super.onInit();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    try {
      // Fetch user_id, hours_per_session, and minutes_per_session
      final response = await Supabase.instance.client
          .from('packages')
          .select('user_id, hours_per_session, minutes_per_session')
          .eq('id', packageId)
          .single();

      if (response != null) {
        userId.value = response['user_id'];
        print("Fetched user_id: ${userId.value}");

        // Use the fetched hours and minutes to calculate total sessions
        calculateRequiredSessions(
          response['hours_per_session'] ?? 0, // Default to 0 if null
          response['minutes_per_session'] ?? 0, // Default to 0 if null
        );

        fetchAvailability(); // Proceed to fetch availability
      } else {
        print("No user found for packageId: $packageId");
      }
    } catch (e) {
      print("Error fetching user_id for packageId: $e");
    }
  }

  void calculateRequiredSessions(int hours, int minutes) {
    int totalMinutes =
        (hours * 60) + minutes; // Convert hours and minutes to total minutes
    required30MinSessions =
        (totalMinutes / 30).ceil(); // Calculate 30-minute sessions
    print("Required 30-minute sessions: $required30MinSessions");
  }

  //checking for consecutive slots
  bool areConsecutiveSlotsAvailable(String selectedSlot) {
  final parsedStartTime = _parseTime(selectedSlot); // Parse selected slot time
  int consecutiveCount = 0;

  print("Checking availability for slot: $selectedSlot");

  for (int i = 0; i < required30MinSessions; i++) {
    final nextSlotTime = parsedStartTime.add(Duration(minutes: i * 30));
    final formattedTime = DateFormat('h:mm a').format(nextSlotTime);

    // Check if the slot exists in availableSlots
    if (availableSlots.contains(formattedTime)) {
      consecutiveCount++;
      print("Consecutive slot found: $formattedTime (Count: $consecutiveCount)");
    } else {
      print("Slot $formattedTime is not consecutive. Stopping check.");
      return false; // Stop as soon as a slot is invalid
    }
  }

  // If all required slots are consecutive, ensure the last slot fits the session duration
  final adjustedEndTime =
      parsedStartTime.add(Duration(minutes: required30MinSessions * 30));

  print("Calculated session end time: ${DateFormat('h:mm a').format(adjustedEndTime)}");

  // Check if the adjusted end time is within the original slot's end time
  for (var slot in availabilityList) {
    for (var jsonSlot in slot.slots) {
      final slotEndTime = _parseTime(jsonSlot['end']);
      if (adjustedEndTime.isBefore(slotEndTime.add(const Duration(minutes: 30)))) {
        print("Session fits within the available time. Slot is valid.");
        return true; // Valid if all conditions pass
      }
    }
  }

  print("Not enough consecutive slots for $selectedSlot.");
  return false;
}




  Future<void> fetchAvailability() async {
    if (userId.value.isEmpty) {
      print("User ID is empty. Cannot fetch availability.");
      return;
    }

    try {
      print("Fetching availability for user_id: ${userId.value}");
      final List<dynamic> response = await Supabase.instance.client
          .from('availability')
          .select('day, is_available, slots')
          .eq('user_id', userId.value);

      print("Raw response from availability table: $response");

      if (response.isNotEmpty) {
        final filteredData =
            response.where((item) => item['is_available'] == true).toList();
        print("Filtered availability data: $filteredData");

        // Clear and update availabilityList
        availabilityList.clear();
        availabilityList.addAll(filteredData.map((item) {
          return TutorAvailabilityModel(
            day: item['day'], // Extract day
            slots: item['slots'], // Extract slots
          );
        }).toList());

        availabilityList.refresh(); // Trigger UI update
        print("Updated availabilityList: $availabilityList");
      } else {
        print("No availability found for user_id: ${userId.value}");
        availabilityList.clear();
        availabilityList.refresh();
      }
    } catch (e) {
      print("Error fetching availability: $e");
    }
  }

  // Helper method to parse time strings (e.g., "8:0" or "8:30 AM") into DateTime objects
  DateTime _parseTime(String time) {
    try {
      // Ensure the time has a consistent format
      if (!time.contains("AM") && !time.contains("PM")) {
        // Default to AM if no period is specified
        time += " AM";
      }

      // Split the hour and minute
      final parts = time.split(':');
      if (parts.length != 2) {
        throw FormatException("Invalid time format: $time");
      }

      // Extract hour and minute
      final hour = int.parse(parts[0].trim());
      final minuteAndPeriod = parts[1].split(' '); // Split minutes and AM/PM
      if (minuteAndPeriod.length != 2) {
        throw FormatException("Invalid minute format: $time");
      }
      final minute = int.parse(minuteAndPeriod[0].trim());
      final period = minuteAndPeriod[1].trim();

      // Validate AM/PM
      if (period != "AM" && period != "PM") {
        throw FormatException("Invalid period: $period in $time");
      }

      // Convert to 24-hour format
      final hour24 = period == "PM" && hour != 12
          ? hour + 12
          : period == "AM" && hour == 12
              ? 0
              : hour;

      return DateTime(0, 0, 0, hour24, minute);
    } catch (e) {
      print("Error parsing time: $time. Exception: $e");
      throw FormatException("Invalid time format: $time");
    }
  }

// Process slots for a specific day
void processSlots(List<dynamic> slotsJson) {
  availableSlots.clear();
  print("Processing slots for selected day...");

  for (var slot in slotsJson) {
    try {
      final startTime = _parseTime(slot['start']); // Extract start time
      final endTime = _parseTime(slot['end']); // Extract end time

      // Adjust the end time to exclude the last 30 minutes
      final adjustedEndTime = endTime.subtract(const Duration(minutes: 30));

      var current = startTime;
      while (current.isBefore(adjustedEndTime) || current == adjustedEndTime) {
        availableSlots.add(DateFormat('h:mm a').format(current)); // Format to 12-hour
        current = current.add(const Duration(minutes: 30)); // Add 30-minute intervals
      }
    } catch (e) {
      print("Skipping slot due to parsing error: $e");
    }
  }
  print("Processed slots: $availableSlots");
  availableSlots.refresh(); // Trigger UI update
}



  // Move to the next session
  void nextSession() {
  if (currentSession.value < totalSessions) {
    // Check if the selected day already exists in the availability list
    bool dayAlreadyExists = availabilityList.any(
      (availability) => availability.day == selectedDay.value,
    );

    // Add the selected day to the list only if it doesn't exist
    if (!dayAlreadyExists) {
      availabilityList.add(TutorAvailabilityModel(
        day: selectedDay.value,
        slots: [],
        selectedTime: selectedTime.value, // Store the selected time
      ));
    }

    // Move to the next session
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
      print(
          "Day: ${availability.day}, Selected Time: ${availability.selectedTime}");
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
