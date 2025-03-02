import 'package:flutter/material.dart';

class WeekProgress extends StatefulWidget {
  @override
  _WeekProgressState createState() => _WeekProgressState();
}

class _WeekProgressState extends State<WeekProgress> {
  String? selectedPerformance;
  List<String> selectedTags = [];

  final List<String> performanceOptions = [
    "😃 Excellent",
    "😊 Good",
    "😐 Average",
    "😕 Struggling",
  ];

  final List<String> tags = [
    "✅ Grasped the concepts",
    "💡 Getting There! Needs Support",
    "😟 Not performing well, needs improvement",
    "📘 Revision week",
    "🏆 Excellent Progress!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week 1 - Progress Report'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly Progress Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Overall performance", style: TextStyle(fontSize: 16)),
            Wrap(
              spacing: 8.0,
              children: performanceOptions.map((option) => ChoiceChip(
                label: Text(option),
                selected: selectedPerformance == option,
                onSelected: (selected) {
                  setState(() {
                    selectedPerformance = selected ? option : null;
                  });
                },
              )).toList(),
            ),
            SizedBox(height: 20),
            Text("Additional comments (if any)", style: TextStyle(fontSize: 16)),
            TextField(
              decoration: InputDecoration(
                hintText: "Write your comments here...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) => FilterChip(
                label: Text(tag),
                selected: selectedTags.contains(tag),
                onSelected: (selected) {
                  setState(() {
                    selected ? selectedTags.add(tag) : selectedTags.remove(tag);
                  });
                },
              )).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text("Attach Images +", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
