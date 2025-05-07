class StudentProfile {
  final String name;
  final String email;
  final String imageUrl;
  final String city;
  final String educationalLevel;
  final String subjects;
  final String learningGoals;

  StudentProfile({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.city,
    required this.educationalLevel,
    required this.subjects,
    required this.learningGoals,
  });

  factory StudentProfile.fromMap(
    Map<String, dynamic> userMap,
    Map<String, dynamic>? locationMap,
    Map<String, dynamic>? studentMap,
  ) {
    final metadata = userMap['metadata'] ?? {};
    return StudentProfile(
      name: metadata['name'] ?? '',
      email: userMap['email'] ?? '',
      imageUrl: userMap['image_url'] ?? '',
      city: locationMap?['city'] ?? '',
      educationalLevel: studentMap?['educational_level'] ?? '',
      subjects: studentMap?['subjects'] ?? '',
      learningGoals: studentMap?['learning_goals'] ?? '',
    );
  }
}
