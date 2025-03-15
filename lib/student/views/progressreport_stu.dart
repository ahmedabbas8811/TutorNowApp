import 'package:flutter/material.dart';

class ProgressReportStu extends StatelessWidget {
  const ProgressReportStu({super.key});

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
            const Text("Week 1 - Progress",
             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text("Report",
             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                const Icon(Icons.sentiment_dissatisfied, color: Colors.orange),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text("Struggling"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Additional comments"),
            const Text("Not performing well, need extra support"),
            const SizedBox(height: 10),
            const Text("\"Test taken on Monday\""),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) => Image.asset('assets/progress.jpg', width: 100)),
            ),
            const SizedBox(height: 10),
            const Text("Uploaded Monday, 16 Feb, 2025"),
            const SizedBox(height: 10),
            const Text("\"Bad handwriting in the assignment\""),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) => Image.asset('assets/progress.jpg', width: 100)),
            ),
          ],
        ),
      ),
    );
  }
}
