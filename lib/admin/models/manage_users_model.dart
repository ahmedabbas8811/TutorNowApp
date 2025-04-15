class UserModel {
  final String id;
  final String email;
  final String name;
  final String userType;
  final String status; // Added status field

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: (json['metadata'] as Map<String, dynamic>?)?['name'] ?? '',
      userType: json['user_type'] ?? '',
      status: json['status'] ?? 'unblocked', // Default to 'unblocked'
    );
  }
}