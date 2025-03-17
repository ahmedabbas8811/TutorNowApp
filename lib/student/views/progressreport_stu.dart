import 'package:flutter/material.dart';

class ProgressReportStu extends StatelessWidget {
  final String week;
  final String performance;
  final String comments;

  const ProgressReportStu({
    super.key,
    required this.week,
    required this.performance,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$week - Progress Report",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${_getPerformanceEmoji(performance)} $performance",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Additional comments"),
            Text(
              comments,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "\"Test taken on Monday\"",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(imagePath: 'assets/progress.jpg'),
                          ),
                        );
                      },
                      child: Image.asset('assets/progress.jpg', width: 100),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Uploaded Monday, 16 Feb, 2025",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "\"Bad handwriting in the assignment\"",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(imagePath: 'assets/progress.jpg'),
                          ),
                        );
                      },
                      child: Image.asset('assets/progress.jpg', width: 100),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
}

class ImageViewer extends StatelessWidget {
  final String imagePath;

  const ImageViewer({super.key, required this.imagePath});

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
        child: Image.asset(imagePath),
      ),
    );
  }
}