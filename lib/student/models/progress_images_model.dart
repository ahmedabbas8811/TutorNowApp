import 'package:intl/intl.dart';

class ProgressImagesModel {
  final int id;
  final int bookingId;
  final int week;
  final String comment;
  final List<String>? images;
  final DateTime createdAt;

  ProgressImagesModel({
    required this.id,
    required this.bookingId,
    required this.week,
    required this.comment,
    this.images,
    required this.createdAt,
  });

  factory ProgressImagesModel.fromJson(Map<String, dynamic> json) {
    return ProgressImagesModel(
      id: json['id'] as int,
      bookingId: json['booking_id'] as int,
      week: json['week'] as int,
      comment: json['comment'] as String,
      images: json['images'] != null
          ? List<String>.from(json['images'].values)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String get formattedDate => DateFormat('EEEE, d MMM, y').format(createdAt);
  String get dayName => DateFormat('EEEE').format(createdAt);
}