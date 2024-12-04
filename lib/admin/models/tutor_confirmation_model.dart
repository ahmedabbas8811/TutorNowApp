class Tutor {
  final String id;
  final String name;
  final String email;
  final String cnicUrl;
  final String imageUrl;
    String location;

  Tutor({
    required this.id,
    required this.name,
    required this.email,
    required this.cnicUrl,
    required this.imageUrl,
    required this.location,
  });

  factory Tutor.fromMap(Map<String, dynamic> map) {
    final metadata = map['metadata'] ?? {};
    return Tutor(
      id: map['id'] ?? 'unknown id',
      name: metadata['name'] ?? 'Unknown Tutor',
      email: map['email'] ?? 'No Email Found',
      cnicUrl: map['cnic_url'] ?? '',
      imageUrl: map['image_url'] ?? '',
      location: '', // Populate location in controller if necessary
    );
  }
}
