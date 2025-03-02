import 'package:flutter/material.dart';

class WeekProgress extends StatefulWidget {
  const WeekProgress({Key? key}) : super(key: key);

  @override
  _WeekProgressState createState() => _WeekProgressState();
}

class _WeekProgressState extends State<WeekProgress> {
  String? selectedPerformance;
  String commentText = "Write your comment here or select a template from below to get started";

  final List<String> performanceOptions = [
    "😃 Excellent",
    "😊 Good",
    "😐 Average",
    "😕 Struggling",
  ];

  final List<Map<String, dynamic>> tags = [
    {"text": "✅ Grasped the concepts", "color": const Color(0xffefffe7)},
    {"text": "💡 Getting There! Needs Support", "color": const Color(0xffffe7e7)},
    {"text": "😟 Not performing well, needs improvement", "color": const Color(0xfffeffd3)},
    {"text": "📘 Revision week", "color": const Color(0xffe7f3ff)},
    {"text": "🏆 Excellent Progress!", "color": const Color(0xffffe7fc)},
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
                  label: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.normal), // Removed bold styling
                  ),
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
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xfff3f3f3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      commentText,
                      style: TextStyle(
                        color: commentText.contains("Write your comment") ? Colors.grey : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: tags.map((tag) => _buildTag(tag)).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black, width: 1,
                    ),
                  ),
                ),
                child: const Text("Attach Images +", style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff87e64c),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 144),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black, width: 1,
                    ),
                  ),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 17, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(Map<String, dynamic> tag) {
    return GestureDetector(
      onTap: () {
        setState(() {
          commentText = tag["text"];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: tag["color"],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          tag["text"],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
