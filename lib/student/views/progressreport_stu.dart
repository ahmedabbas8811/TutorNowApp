import 'package:flutter/material.dart';
import 'package:newifchaly/student/models/progress_model.dart';
import 'package:newifchaly/student/models/progress_images_model.dart';
import 'package:newifchaly/student/controllers/progress_images_controller.dart';

class ProgressReportStu extends StatelessWidget {
  final ProgressReportModel report;
  final ProgressImagesController _controller = ProgressImagesController();

  ProgressReportStu({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final performance = _extractPerformanceCategory(report.overallPerformance);
    final emoji = _getPerformanceEmoji(performance);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Week ${report.week} - Progress Report",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                "Weekly Progress Report",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Overall performance"),
              const SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "$emoji $performance",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text("Additional comments"),
              Text(
                report.comments,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<ProgressImagesModel>>(
                future: _controller.fetchProgressImages(
                  bookingId:
                      int.parse(report.bookingId), // Convert to int if needed
                  week: report.week,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No progress entries found');
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "\"${entry.comment}\"",
                            style: const TextStyle(fontSize: 17),
                            overflow: TextOverflow
                                .ellipsis, // Truncate if text is too long
                            maxLines: 2, // Limit to 2 lines
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 120, // Fixed height for the image gallery
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: (entry.images ?? []).map((imageUrl) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImageViewer(imageUrl: imageUrl),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      imageUrl,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child; // Image is fully loaded
                                        return Container(
                                          width: 100,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 100,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Uploaded ${entry.formattedDate}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get the emoji for the performance
  String _getPerformanceEmoji(String performance) {
    switch (performance.toLowerCase()) {
      case 'excellent':
        return '😃';
      case 'good':
        return '🙂';
      case 'average':
        return '😐';
      case 'struggling':
        return '😟';
      default:
        return '😐';
    }
  }

  // Helper method to extract the performance category
  String _extractPerformanceCategory(String performanceWithEmoji) {
    final parts = performanceWithEmoji.split(' ');
    return parts.last;
  }
}

class ImageViewer extends StatelessWidget {
  final String imageUrl;

  const ImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
