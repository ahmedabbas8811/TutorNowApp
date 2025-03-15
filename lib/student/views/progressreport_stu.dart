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
            const Text(
              "Week 1 - Progress Report",
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
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    children: [
                      Text("😟 Struggling"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Additional comments"),
            const Text(
              "Not performing well, need extra support",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text("\"Test taken on Monday\"",style: TextStyle(fontSize: 17),),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset('assets/progress.jpg', width: 100),
                )),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Uploaded Monday, 16 Feb, 2025",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text("\"Bad handwriting in the assignment\"",style: TextStyle(fontSize: 17),),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset('assets/progress.jpg', width: 100),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}