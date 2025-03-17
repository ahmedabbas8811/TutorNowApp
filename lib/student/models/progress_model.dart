class ProgressReportModel {
  final String bookingId;
  final int week;
  final String overallPerformance;
  final String comments;

  ProgressReportModel({
    required this.bookingId,
    required this.week,
    required this.overallPerformance,
    required this.comments, 
  });

  factory ProgressReportModel.fromMap(Map<String, dynamic> data) {
    return ProgressReportModel(
      bookingId: data['booking_id'],
      week: data['week'],
      overallPerformance: data['overall_performance'],
      comments: data['comments'],
    );
  }

  // Map performance to integers
  int get performanceValue {
    switch (overallPerformance.toLowerCase()) {
      case 'excellent':
        return 4;
      case 'good':
        return 3;
      case 'average':
        return 2;
      case 'struggling':
        return 1;
      default:
        return 0; // Default for unknown values
    }
  }
}