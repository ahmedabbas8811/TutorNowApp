class TutorAvailabilityModel {
  final String day; // represents the day 
  final List<dynamic> slots; // represents the list of time slots 
  final String? selectedTime; // represents the user selected time 

  TutorAvailabilityModel({
    required this.day,
    required this.slots,
    this.selectedTime,
  });
}

