class Report {
  final int id;
  final String? reportedUserId;
  final String reportedUserName;
  final String? reporterId;
  final String reporterName;
  final String comments;
  final DateTime createdAt;
  final String status;
  final Map<String, dynamic>? images;

  Report({
    required this.id,
    this.reportedUserId,
    required this.reportedUserName,
    this.reporterId,
    required this.reporterName,
    required this.comments,
    required this.createdAt,
    required this.status,
    this.images,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      reportedUserId: json['reported_user_id']?.toString(),
      reportedUserName: _extractUserName(json['reported_user_metadata']),
      reporterId: json['reporter_id']?.toString(),
      reporterName: _extractUserName(json['reporter_metadata']),
      comments: json['comments']?.toString() ?? '', // Fallback for null comments
      createdAt: DateTime.parse(json['created_at']?.toString() ?? DateTime.now().toString()),
      status: json['status']?.toString() ?? 'open', // Fallback for null status
      images: json['images'] != null ? Map<String, dynamic>.from(json['images']) : null,
    );
  }

  static String _extractUserName(dynamic metadata) {
    try {
      if (metadata is Map<String, dynamic>) {
        return metadata['name']?.toString().trim() ?? 'Unknown User';
      }
      return 'Unknown User';
    } catch (e) {
      return 'Unknown User';
    }
  }
}