class Tutor {
  final int id;
  final String userId;
  final String educationLevel;
  final String subject;

  Tutor({
    required this.id,
    required this.userId,
    required this.educationLevel,
    required this.subject,
  });

  // Factory method to create a Tutor object from a map
  factory Tutor.fromMap(Map<String, dynamic> data) {
    return Tutor(
      id: data['id'] as int,
      userId: data['user_id'],
      educationLevel: data['education_level'],
      subject: data['subject'],
    );
  }
}
