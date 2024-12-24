// models/tutor.dart
class Tutor {
  final String id;
  final String name;
  final bool isVerified;
   String qualification;
  Tutor({required this.id, required this.name, required this.isVerified, this.qualification = ''});

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'] ?? '',
      qualification: json['education_level'] ?? '',
      name: json['metadata']?['name'] ?? 'Unknown Name',
      isVerified: json['is_verified'] ?? false,
    );
  }
}
