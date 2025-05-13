class Tutor {
  final String userId; // Add userId
  final String name;
  final String imageUrl;
  final String educationLevels;
  final String subjects;
  final String location;

  Tutor(
      {required this.userId, // Add userId
      required this.name,
      required this.imageUrl,
      required this.educationLevels,
      required this.subjects,
      required this.location});

  // Update factory constructor
  factory Tutor.fromJson(Map<String, dynamic> json, String userId,
      String educationLevels, String subjects) {
    return Tutor(
        userId: userId, // Assign userId
        name: json['name'] ?? 'Unknown',
        imageUrl: json['image_url'] ?? '',
        educationLevels: educationLevels,
        subjects: subjects,
        location: json['location'] ?? 'Islamabad');
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

class Location {
  final String location;
  Location({
    required this.location,
  });
}
