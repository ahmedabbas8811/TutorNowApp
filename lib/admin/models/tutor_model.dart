// models/tutor.dart
class Tutor {
  final String id;
  final String name;
  final bool isVerified;

  Tutor({required this.id, required this.name, required this.isVerified});

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'] ?? '',
      name: json['metadata']?['name'] ?? 'Unknown Name',
      isVerified: json['is_verified'] ?? false,
    );
  }
}