class BookingModel {
  final String bookingId;
  final String userId; // Student ID
  final String packageId;
  final String tutorId;

  // Fields to be updated after fetching related data
  String studentName;
  String studentImage;
  String packageName;
  String minutesPerSession;
  String sessionsPerWeek;
  String numberOfWeeks;
  String price;

  BookingModel({
    required this.bookingId,
    required this.userId,
    required this.packageId,
    required this.tutorId,
    this.studentName = 'Unknown Student',
    this.studentImage = '',
    this.packageName = 'Unknown Package',
    this.minutesPerSession = '0',
    this.sessionsPerWeek = '0',
    this.numberOfWeeks = '0',
    this.price = '0',
  });

  // Factory method to create BookingModel from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['id'].toString(), // Fetching the booking ID
      userId: json['user_id'] ?? '',
      packageId: json['package_id'] != null ? json['package_id'].toString() : '',
      tutorId: json['tutor_id'] ?? '',
    );
  }

  // Method to update student info (instead of tutor info)
  void updateStudentInfo(String name, String imageUrl) {
    studentName = name.isNotEmpty ? name : 'Unknown Student';
    studentImage = imageUrl.isNotEmpty ? imageUrl : '';
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

