class PackageModel {
  final int id;
  final String title;
  final String description;
  final int hours;
  final int minutes;
  final int weeks;
  final int sessions;
  final int price;

  PackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.hours,
    required this.minutes,
    required this.weeks,
    required this.sessions,
    required this.price,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      title: json['package_name'] ?? '',
      description: json['package_description'] ?? '',
      hours: json['hours_per_session'] ?? 0,
      minutes: json['minutes_per_session'] ?? 0,
      weeks: json['number_of_weeks'] ?? 0,
      sessions: json['sessions_per_week'] ?? '',
      price: json['price'] ?? '',
    );
  }
}
