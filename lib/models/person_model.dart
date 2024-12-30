class Qualification {
  final String educationLevel;
  final String instituteName;

  Qualification({required this.educationLevel, required this.instituteName});

  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      educationLevel: json['education_level'] ?? '',
      instituteName: json['institute_name'] ?? '',
    );
  }
}

class Experience {
  final String studentEducationLevel;
  final String startDate;
  final String endDate;
  final bool stillWorking;

  Experience({
    required this.studentEducationLevel,
    required this.startDate,
    required this.endDate,
    required this.stillWorking,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      studentEducationLevel: json['student_education_level'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      stillWorking: json['still_working'] ?? false,
    );
  }
}

class PersonModel {
  String name;
  String profileImage;
  bool isProfileComplete;
  bool isVerified;
  List<Qualification> qualifications;
  List<Experience> experiences; // Add experiences list

  PersonModel({
    required this.name,
    required this.profileImage,
    required this.isProfileComplete,
    required this.isVerified,
    this.qualifications = const [], // Initialize as an empty list by default
    this.experiences = const [],   // Initialize as an empty list by default
  });

  // Create a PersonModel from JSON data
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? 'assets/Ellipse1.png',
      isProfileComplete: json['isProfileComplete'] ?? false,
      isVerified: false,
      qualifications: (json['qualifications'] as List<dynamic>?)
              ?.map((item) => Qualification.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((item) => Experience.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Method to update qualifications dynamically
  void updateQualifications(List<Qualification> newQualifications) {
    qualifications = newQualifications;
  }

  // Method to update experiences dynamically
  void updateExperiences(List<Experience> newExperiences) {
    experiences = newExperiences;
  }
}


