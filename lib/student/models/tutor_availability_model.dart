class TutorAvailabilityModel {
  final String day; // Represents the day (e.g., "Mon", "Tue", etc.)
  final List<dynamic> slots; // Represents the list of time slots (e.g., [{"start": "8:0", "end": "10:0"}])
  final String? selectedTime; // Represents the user-selected time (optional)

  TutorAvailabilityModel({
    required this.day,
    required this.slots,
    this.selectedTime,
  });
}

