class Tutor {
  final String userId; // Add userId
  final String name;
  final String imageUrl;
  final String educationLevels;
  final String subjects;

  Tutor({
    required this.userId, // Add userId
    required this.name,
    required this.imageUrl,
    required this.educationLevels,
    required this.subjects,
  });

  // Update factory constructor
  factory Tutor.fromJson(
      Map<String, dynamic> json, String userId, String educationLevels, String subjects) {
    return Tutor(
      userId: userId, // Assign userId
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image_url'] ?? '',
      educationLevels: educationLevels,
      subjects: subjects,
    );
  }
}
class UserRating {
  final double averageRating;
  final int totalRatings;

  UserRating({
    required this.averageRating,
    required this.totalRatings,
  });
}
