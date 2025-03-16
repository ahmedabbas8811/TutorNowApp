class BookingModel {
  final String bookingId;
  final String userId;
  final String packageId;
  final String tutorId;

  // Fields to be updated after fetching related data
  String tutorName;
  String tutorImage;
  String packageName;
  String minutesPerSession;
  String sessionsPerWeek;
  String numberOfWeeks;
  String price;
  Map<String, dynamic> timeSlots;

  BookingModel({
    required this.bookingId,
    required this.userId,
    required this.packageId,
    required this.tutorId,
    this.tutorName = 'Unknown Tutor',
    this.tutorImage = '',
    this.packageName = 'Unknown Package',
    this.minutesPerSession = '0',
    this.sessionsPerWeek = '0',
    this.numberOfWeeks = '0',
    this.price = '0',
    this.timeSlots = const {}, 
  });

  // Factory method to create BookingModel from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['id'].toString(),
      userId: json['user_id'] ?? '',
      packageId:
          json['package_id'] != null ? json['package_id'].toString() : '',
      tutorId: json['tutor_id'] ?? '',
      timeSlots: json['time_slots'] != null 
    ? Map<String, dynamic>.from(json['time_slots'])  // Convert JSONB to Map
    : {},
    );
  }

  // Method to update tutor info
  void updateTutorInfo(String name, String imageUrl) {
    tutorName = name.isNotEmpty ? name : 'Unknown Tutor';
    tutorImage = imageUrl.isNotEmpty ? imageUrl : '';
  }

  // Method to update package info
  void updatePackageInfo(String name, String minutes, String sessions,
      String weeks, String price) {
    packageName = name.isNotEmpty ? name : 'Unknown Package';
    minutesPerSession = minutes.isNotEmpty ? minutes : '0';
    sessionsPerWeek = sessions.isNotEmpty ? sessions : '0';
    numberOfWeeks = weeks.isNotEmpty ? weeks : '0';
    this.price = price.isNotEmpty ? price : '0';
  }
}
