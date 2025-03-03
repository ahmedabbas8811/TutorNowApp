import 'package:flutter/material.dart';
import 'package:newifchaly/weekattachimages.dart';

class WeekProgress extends StatefulWidget {
  final int weekNumber;
  const WeekProgress({Key? key, required this.weekNumber}) : super(key: key);

  @override
  _WeekProgressState createState() => _WeekProgressState();
}


class _WeekProgressState extends State<WeekProgress> {
  String? selectedPerformance;
  TextEditingController commentController = TextEditingController();


  final List<String> performanceOptions = [
    "😃 Excellent",
    "😊 Good",
    "😐 Average",
    "😕 Struggling",
  ];

  final List<List<Map<String, dynamic>>> groupedTags = [
    [
      {"text": "✅ Grasped the concepts", "color": const Color(0xffefffe7)},
      {"text": "💡 Getting There! Needs Support", "color": const Color(0xffffe7e7)},
    ],
    [
      {"text": "😟 Not performing well, need studies", "color": const Color(0xfffeffd3)},
      {"text": "🏆 Excellent Progress!", "color": const Color(0xffffe7fc)},
    ],
    [
      {"text": "📘 Revision week", "color": const Color(0xffe7f3ff)},
      {"text": "😕 Struggling needed", "color": const Color(0xffffd3d3)},
    ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Week ${widget.weekNumber} - Progress Report",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              const Text("Weekly Progress Report", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text("Overall performance", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),

              Wrap(
                spacing: 8.0,
                children: performanceOptions.map((option) {
                  return ChoiceChip(
                    label: Text(option, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.normal)),
                    selected: selectedPerformance == option,
                    backgroundColor: const Color(0xfff3f3f3),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedPerformance = selected ? option : null;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),
              const Text("Additional comments (if any)", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),

              Container(
                constraints: const BoxConstraints(minHeight: 50, maxHeight: 150),
                child: TextField(
                  controller: commentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Write your comment here",
                    filled: true,
                    fillColor: const Color(0xfff3f3f3),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupedTags.map((group) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: group.map((tag) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _buildTag(tag),
                    ),
                  )).toList(),
                )).toList(),
              ),

              const SizedBox(height: 14),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const  WeekAttachImages()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("Attach Images +", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),

              const SizedBox(height: 5),

              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff87e64c),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 140),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: const Text("Save", style: TextStyle(fontSize: 17, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(Map<String, dynamic> tag) {
    return GestureDetector(
      onTap: () {
        setState(() {
          commentController.text = tag["text"];
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
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}