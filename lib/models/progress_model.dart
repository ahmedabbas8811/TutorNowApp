class ProgressModel {
  final int week;
  final String overallPerformance;
  final String comments;
  final String bookingId;
  final String imageId;
  final String imageUrl;

  ProgressModel({
    required this.week,
    required this.overallPerformance,
    required this.comments,
    required this.bookingId,
    required this.imageUrl,
    required this.imageId,
  });

  // Convert Map to ProgressModel (fromMap constructor)
  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      week: map['week'] ?? 0,
      overallPerformance: map['overall_performance'] ?? '',
      comments: map['comments'] ?? '',
      bookingId: map['booking_id'] ?? '',
      imageId: map['image_id'] ?? '',
      imageUrl: map['image_url'] ?? '',
    );
  }

  // Convert ProgressModel to Map (toJson)
  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'overall_performance': overallPerformance,
      'comments': comments,
      'booking_id': bookingId,
      'image_id': imageId,
      'image_url': imageUrl,
    };
  }
}
