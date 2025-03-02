class Tutor {
  final int id;
  final String userId;
  final String educationLevel;
  final String subject;
  final String name;
  final String imgurl;

  Tutor(
      {required this.id,
      required this.userId,
      required this.educationLevel,
      required this.subject,
      required this.name,
      required this.imgurl});

  factory Tutor.fromMap(Map<String, dynamic> data) {
    return Tutor(
      id: data['id'] as int ?? 0,
      userId: data['user_id'] ?? "",
      educationLevel: data['education_level'] ?? "unknown",
      subject: data['subject'] ?? "unknown",
      name:
          data['users'] != null ? data['users']['metadata']['name'] : 'Unknown',
      imgurl: data['users'] != "null" ? data['users']['image_url'] : '',
    );
  }
}
