class Tutor {
  final String name;
  final String imageUrl;
  final String educationLevels;
  final String subjects; // New field

  Tutor({
    required this.name,
    required this.imageUrl,
    required this.educationLevels,
    required this.subjects,
  });

  // Updated Factory method to create a Tutor instance from JSON
  factory Tutor.fromJson(
      Map<String, dynamic> json, String educationLevels, String subjects) {
    return Tutor(
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image_url'] ?? '',
      educationLevels: educationLevels,
      subjects: subjects,
    );
  }
}
