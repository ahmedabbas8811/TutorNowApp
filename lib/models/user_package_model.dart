class UserPackageModel {
  final int id;
  final String packageName;
  final int sessionsPerWeek;
  final int numberOfWeeks;
  final int price;
  final String? packageDescription;
  final int? hoursPerSession;
  final int? minutesPerSession;

  UserPackageModel({
    required this.id,
    required this.packageName,
    required this.sessionsPerWeek,
    required this.numberOfWeeks,
    required this.price,
    this.packageDescription,
    this.hoursPerSession,
    this.minutesPerSession,
  });

  factory UserPackageModel.fromJson(Map<String, dynamic> json) {
    return UserPackageModel(
      id: json['id'],
      packageName: json['package_name'],
      sessionsPerWeek: json['sessions_per_week'],
      numberOfWeeks: json['number_of_weeks'],
      price: json['price'],
      packageDescription: json['package_description'],
      hoursPerSession: json['hours_per_session'],
      minutesPerSession: json['minutes_per_session'],
    );
  }
}
