class Tutor {
  final String id;
  final String name;
  final bool isVerified;
  List<String> qualifications; 
  String? rejectionReason;
  String status;
  Map<String, dynamic>? profileCompletedSteps;

  Tutor({
    required this.id,
    required this.name,
    required this.isVerified,
    this.qualifications = const [], 
    this.rejectionReason,
    this.status = 'pending',
    this.profileCompletedSteps,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'] ?? '',
      qualifications: json['education_level'] is List 
          ? List<String>.from(json['education_level'].map((e) => e.toString()))
          : json['education_level'] != null 
              ? [json['education_level'].toString()]
              : [],
      name: json['metadata']?['name'] ?? 'Unknown Name',
      isVerified: json['is_verified'] ?? false,
      rejectionReason: json['rejection_reason']?.toString(),
      profileCompletedSteps: json['profile_completed_steps'] is Map 
          ? Map<String, dynamic>.from(json['profile_completed_steps'])
          : null,
    );
  }

  // Helper method to get qualifications as comma-separated string
  String get qualificationsString => qualifications.join(', ');
}