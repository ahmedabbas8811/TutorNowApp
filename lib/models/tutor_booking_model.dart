class BookingModel {
  final String bookingId;
  final String userId;
  final String packageId;
  final String tutorId;
  String studentName;
  String studentImage;
  String packageName;
  String minutesPerSession;
  String sessionsPerWeek;
  String numberOfWeeks;
  String price;
  DateTime accepted_at;
  Map<String, dynamic> timeSlots;

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
    required this.accepted_at,
    this.timeSlots = const {},
  });

  // factory method to create BookingModel from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['id'].toString(),
      userId: json['user_id'] ?? '',
      packageId:
          json['package_id'] != null ? json['package_id'].toString() : '',
      tutorId: json['tutor_id'] ?? '',
      timeSlots: json['time_slots'] != null
          ? Map<String, dynamic>.from(
              json['time_slots']) // Convert JSONB to Map
          : {},
      accepted_at: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : DateTime.now(), // fallback if accepted_at is null
    );
  }

  // method to update student info
  void updateStudentInfo(String name, String imageUrl) {
    studentName = name.isNotEmpty ? name : 'Unknown Student';
    studentImage = imageUrl.isNotEmpty ? imageUrl : '';
  }

  // method to update package info
  void updatePackageInfo(String name, String minutes, String sessions,
      String weeks, String price) {
    packageName = name.isNotEmpty ? name : 'Unknown Package';
    minutesPerSession = minutes.isNotEmpty ? minutes : '0';
    sessionsPerWeek = sessions.isNotEmpty ? sessions : '0';
    numberOfWeeks = weeks.isNotEmpty ? weeks : '0';
    this.price = price.isNotEmpty ? price : '0';
  }
}
