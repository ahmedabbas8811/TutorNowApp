class ProgressModel {
  final int week;
  final String overallPerformance;
  final String comments;
  final String bookingId;

  ProgressModel({
    required this.week,
    required this.overallPerformance,
    required this.comments,
    required this.bookingId,
  });

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'overall_performance': overallPerformance,
      'comments': comments,
      'booking_id': bookingId,
    };
  }
}
