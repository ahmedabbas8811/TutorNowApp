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

  // Factory method to create a Tutor object from a map
  factory Tutor.fromMap(Map<String, dynamic> data) {
    return Tutor(
      id: data['id'] as int,
      userId: data['user_id'],
      educationLevel: data['education_level'],
      subject: data['subject'],
      name: data['users'] != null
          ? data['users']['metadata']['name']
          : 'Unknown', // Handle null case for 'users'
      imgurl: data['users'] != "null" ? data['users']['image_url'] : '',
    );
  }
}
