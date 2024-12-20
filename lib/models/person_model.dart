class PersonModel {
  String name;
  String profileImage;
  bool isProfileComplete;
  bool isVerified;

  PersonModel({
    required this.name,
    required this.profileImage,
    required this.isProfileComplete,
    required this.isVerified
  });

  // Create a ProfileModel from JSON data
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? 'assets/Ellipse 1.png',
      isProfileComplete: json['isProfileComplete'] ?? false,
      isVerified: false
    );
  }
}
