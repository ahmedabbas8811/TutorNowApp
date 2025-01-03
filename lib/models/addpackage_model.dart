class AddPackageModel {
  final String packageName;
  final String packageDescription;
  final int hoursPerSession;
  final int minutesPerSession;
  final int sessionsPerWeek;
  final int numberOfWeeks;
  final int price;
  final String userId; // Foreign key

  AddPackageModel({
    required this.packageName,
    required this.packageDescription,
    required this.hoursPerSession,
    required this.minutesPerSession,
    required this.sessionsPerWeek,
    required this.numberOfWeeks,
    required this.price,
    required this.userId,
  });

  // Convert model to a map for Supabase insertion
  Map<String, dynamic> toMap() {
    return {
      'package_name': packageName,
      'package_description': packageDescription,
      'hours_per_session': hoursPerSession,
      'minutes_per_session': minutesPerSession,
      'sessions_per_week': sessionsPerWeek,
      'number_of_weeks': numberOfWeeks,
      'price': price,
      'user_id': userId,
    };
  }
}
