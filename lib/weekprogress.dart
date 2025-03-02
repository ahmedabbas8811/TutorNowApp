import 'package:flutter/material.dart';

class WeekProgress extends StatefulWidget {
  const WeekProgress({Key? key}) : super(key: key);

  @override
  _WeekProgressState createState() => _WeekProgressState();
}

class _WeekProgressState extends State<WeekProgress> {
  String? selectedPerformance;
  List<String> selectedTags = [];
  String commentText = "Write your comment here or select a template from below to get started";

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
            const SizedBox(height: 10),
            const Text("Overall performance", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: performanceOptions.map((option) {
                return ChoiceChip(
                  label: Text(option, overflow: TextOverflow.ellipsis),
                  selected: selectedPerformance == option,
                  selectedColor: Colors.green.shade100,
                  backgroundColor: const Color(0xfff3f3f3),
                  onSelected: (selected) {
                    setState(() {
                      selectedPerformance = option;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text("Additional comments (if any)", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xfff3f3f3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                commentText,
                style: TextStyle(color: commentText.contains("Write your comment") ? Colors.grey : Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTag(tags[0])),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTag(tags[1])),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTag(tags[2])),
                    const SizedBox(width: 8),
                    Expanded(child: _buildTag(tags[3])),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTag(tags[4])),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text("Attach Images +", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return FilterChip(
      label: Text(tag, overflow: TextOverflow.ellipsis),
      selected: selectedTags.contains(tag),
      selectedColor: Colors.green.shade100,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedTags.add(tag);
            commentText = tag; // Set comment box text to selected tag
          } else {
            selectedTags.remove(tag);
            commentText = selectedTags.isNotEmpty ? selectedTags.last : "Write your comment here or select a template from below to get started";
          }
        });
      },
    );
  }
}
