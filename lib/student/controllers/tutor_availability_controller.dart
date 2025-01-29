import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newifchaly/student/models/tutor_availability_model.dart';
import 'package:intl/intl.dart'; //for time formatting

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
  var selectedSlots = <String, String>{}.obs; // To store selected time slots

  TutorAvailabilityController(
      {required this.totalSessions, required this.packageId});

  @override
  void onInit() {
    super.onInit();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    try {
      final response = await Supabase.instance.client
          .from('packages')
          .select('user_id, hours_per_session, minutes_per_session')
          .eq('id', packageId)
          .single();

      if (response != null) {
        userId.value = response['user_id'];
        print("Fetched user_id: ${userId.value}");

        //use fetched hours and minutes to calculate total sessions
        calculateRequiredSessions(
          response['hours_per_session'] ?? 0, //default to 0 if null
          response['minutes_per_session'] ?? 0, //default to 0 if null
        );

        fetchAvailability();
      } else {
        print("No user found for packageId: $packageId");
      }
    } catch (e) {
      print("Error fetching user_id for packageId: $e");
    }
  }

  void calculateRequiredSessions(int hours, int minutes) {
    int totalMinutes =
        (hours * 60) + minutes; //convert hours and minutes to total minutes
    required30MinSessions =
        (totalMinutes / 30).ceil(); //calculate 30-minute sessions
    print("Required 30-minute sessions: $required30MinSessions");
  }

  //checking for consecutive slots
  bool areConsecutiveSlotsAvailable(String selectedSlot) {
    final parsedStartTime = _parseTime(selectedSlot); //parse selected slot time
    int consecutiveCount = 0;

    print("Checking availability for slot: $selectedSlot");

    for (int i = 0; i < required30MinSessions; i++) {
      final nextSlotTime = parsedStartTime.add(Duration(minutes: i * 30));
      final formattedTime = DateFormat('h:mm a').format(nextSlotTime);

      //check if slot exists in available slots
      if (availableSlots.contains(formattedTime)) {
        consecutiveCount++;
        print(
            "Consecutive slot found: $formattedTime (Count: $consecutiveCount)");
      } else {
        print("Slot $formattedTime is not consecutive. Stopping check.");
        return false; //stop as soon as a slot is invalid
      }
    }

    //if all required slots are consecutive ensure last slot fits session duration
    final adjustedEndTime =
        parsedStartTime.add(Duration(minutes: required30MinSessions * 30));

    print(
        "Calculated session end time: ${DateFormat('h:mm a').format(adjustedEndTime)}");

    //check if adjusted end time is within original slot's end time
    for (var slot in availabilityList) {
      for (var jsonSlot in slot.slots) {
        final slotEndTime = _parseTime(jsonSlot['end']);
        if (adjustedEndTime
            .isBefore(slotEndTime.add(const Duration(minutes: 30)))) {
          print("Session fits within the available time. Slot is valid.");
          return true; //valid if all conditions pass
        }
      }
    }

    print("Not enough consecutive slots for $selectedSlot.");
    return false;
  }

  void filterAvailableSlots() {
    //create a new list to store valid slots
    List<String> validSlots = [];

    print("Filtering available slots...");

    //iterate over each slot in availableSlots list
    for (var slot in availableSlots) {
      //check if slot has enough consecutive sessions
      if (areConsecutiveSlotsAvailable(slot)) {
        print("Slot $slot is valid.");
        validSlots.add(slot); //add to valid slots list
      } else {
        print("Slot $slot is not valid.");
      }
    }

    //update available slots list with only valid slots
    availableSlots.value = validSlots;
    print("Filtered available slots: $availableSlots");
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

        //clear and update availabilityList
        availabilityList.clear();
        availabilityList.addAll(filteredData.map((item) {
          return TutorAvailabilityModel(
            day: item['day'], //extract day
            slots: item['slots'], //extract slots
          );
        }).toList());

        availabilityList.refresh(); //trigger UI update
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

  //helper method to parse time strings into date time objects
  DateTime _parseTime(String time) {
    try {
      // Ensure time has a consistent format
      if (!time.contains("AM") && !time.contains("PM")) {
        //default to AM if no period is specified
        time += " AM";
      }

      //split hour and minute
      final parts = time.split(':');
      if (parts.length != 2) {
        throw FormatException("Invalid time format: $time");
      }

      //extract hour and minute
      final hour = int.parse(parts[0].trim());
      final minuteAndPeriod = parts[1].split(' '); //split minutes and AM/PM
      if (minuteAndPeriod.length != 2) {
        throw FormatException("Invalid minute format: $time");
      }
      final minute = int.parse(minuteAndPeriod[0].trim());
      final period = minuteAndPeriod[1].trim();

      //validate AM/PM
      if (period != "AM" && period != "PM") {
        throw FormatException("Invalid period: $period in $time");
      }

      //convert to 24-hour format
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

  Future<void> processSlots(List<dynamic> slotsJson) async {
    //clear existing slots before processing
    availableSlots.clear();
    print("Processing slots for selected day...");

    for (var slot in slotsJson) {
      try {
        final startTime = await _parseTime(slot['start']); //await time parsing
        final endTime = await _parseTime(slot['end']);

        //adjust end time to exclude last 30 minutes
        final adjustedEndTime = endTime.subtract(const Duration(minutes: 30));

        var current = startTime;
        while (
            current.isBefore(adjustedEndTime) || current == adjustedEndTime) {
          availableSlots
              .add(DateFormat('h:mm a').format(current)); //format to 12 hour
          current =
              current.add(const Duration(minutes: 30)); //add 30 min intervals
        }
      } catch (e) {
        print("Skipping slot due to parsing error: $e");
      }
    }

    print("Processed slots: $availableSlots");
    availableSlots.refresh();
    await Future.delayed(
        Duration(milliseconds: 100)); // Add a small delay if needed
  }

  void nextSession() {
    if (currentSession.value < totalSessions) {
      // store selected time slot for the current session in the selectedSlots map
      if (selectedTime.value.isNotEmpty) {
        selectedSlots["${currentSession.value}"] = selectedTime.value;
      } else {
        // leave value empty if no slot selected
        selectedSlots["${currentSession.value}"] = "";
      }

      // check if the selected day already exists in the availability list
      bool dayAlreadyExists = availabilityList.any(
        (availability) => availability.day == selectedDay.value,
      );

      // add selected day to the list only if it doesn't exist
      if (!dayAlreadyExists) {
        availabilityList.add(TutorAvailabilityModel(
          day: selectedDay.value,
          slots: [], // Slots can be populated later if needed
          selectedTime: selectedTime.value.isNotEmpty ? selectedTime.value : "",
        ));
      }

      // move to the next session
      currentSession.value++;

      // clear selections for the next session
      resetSelections();
    }
  }

  Future<void> confirmAvailability() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      print("No user is currently logged in.");
      Get.snackbar(
        "Error",
        "You must be logged in to confirm a booking.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // add last sessions selected slot to the selectedSlots map
    if (selectedTime.value.isNotEmpty) {
      selectedSlots["${currentSession.value}"] = selectedTime.value;
    } else {
      // Leave the value empty if no slot is selected
      selectedSlots["${currentSession.value}"] = "";
    }

    // add last sessions details to the availability list
    availabilityList.add(TutorAvailabilityModel(
      day: selectedDay.value,
      slots: [],
      selectedTime: selectedTime.value.isNotEmpty ? selectedTime.value : "",
    ));

    print("Final Availability List:");
    for (var availability in availabilityList) {
      print(
          "Day: ${availability.day}, Selected Time: ${availability.selectedTime}");
    }

    // prepare data to insert into the database
    final bookingData = {
      'user_id': user.id, // Use the authenticated user's ID
      'time slots': selectedSlots, // Store all selected time slots
    };

    try {
      // insert data into the bookings table
      final response = await Supabase.instance.client
          .from('bookings')
          .insert(bookingData)
          .select(); // Ensure .select() is used to fetch inserted data

      if (response != null && response.isNotEmpty) {
        print("Booking confirmed successfully!");
        print("Inserted Data: $response");
        Get.snackbar(
          "Success",
          "Booking has been confirmed.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print("No data returned from insert operation.");
        Get.snackbar(
          "Error",
          "Failed to confirm booking. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Exception during booking: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    // clear the selectedSlots map after confirmation
    selectedSlots.clear();
  }

  // Check if its last session
  bool isLastSession() {
    return currentSession.value == totalSessions;
  }

  //reset day and time
  void resetSelections() {
    selectedDay.value = "Mon"; //default to first day
    selectedTime.value = ""; //default to empty
  }
}
