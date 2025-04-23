import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewsSection extends StatefulWidget {
  final String tutorId;

  const ReviewsSection({Key? key, required this.tutorId}) : super(key: key);

  @override
  _ReviewsSectionState createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      // Fetch reviews for this tutor
      final reviewsResponse = await supabase
          .from('feedback')
          .select('*')
          .eq('tutor_id', widget.tutorId)
          .order('created_at', ascending: false);

      // Calculate average rating
      if (reviewsResponse.isNotEmpty) {
        final totalRating = reviewsResponse.fold(0, (sum, review) => sum + (review['rating'] as int));
        averageRating = totalRating / reviewsResponse.length;
      }

      // Fetch student details for each review
      for (var review in reviewsResponse) {
        final studentResponse = await supabase
            .from('users')
            .select('image_url, metadata')
            .eq('id', review['student_id'])
            .single();

        reviews.add({
          ...review,
          'student_name': studentResponse['metadata']['name'] ?? 'Anonymous',
          'student_image': studentResponse['image_url'],
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (reviews.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' (${reviews.length})',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : reviews.isEmpty
                ? const Center(
                    child: Text(
                      'No reviews yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      final dateTime = DateTime.parse(review['created_at']).toLocal();
                      final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                      final formattedTime = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: review['student_image'] != null
                                        ? NetworkImage(review['student_image'])
                                        : null,
                                    child: review['student_image'] == null
                                        ? Icon(Icons.person, size: 20)
                                        : null,
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review['student_name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: List.generate(5, (starIndex) {
                                          return Icon(
                                            starIndex < review['rating']
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                review['review'] ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$formattedDate at $formattedTime',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ],
    );
  }
}