import 'package:flutter/material.dart';

class WeekProgress extends StatefulWidget {
  const WeekProgress({Key? key}) : super(key: key);

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
    double screenWidth = MediaQuery.of(context).size.width;

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
              "Week 1 -Progress Report",
              style: TextStyle(fontSize: 28,fontWeight:FontWeight.bold),
            ),
              const Text(
              "Report",
              style: TextStyle(fontSize: 28,fontWeight:FontWeight.bold),
            ),
            const Text(
              "Weekly Progress Report",
              style: TextStyle(fontSize: 18,),
            ),
            const SizedBox(height: 10),

            const Text("Overall performance", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8.0,
              children: performanceOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedPerformance == option,
                  selectedColor: Colors.green.shade100,
                  onSelected: (selected) {
                    setState(() {
                      selectedPerformance = option;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Additional comments (if any)", style: TextStyle(fontSize: 16)),
            ),
            
            Container(
              width: 370,
              height: 70,
               child: const Padding(
                  padding:   EdgeInsets.all(8.0),
                  child: Text('Write your comment here and or select a template from below to get started',style: TextStyle(color: Colors.grey),),
                ),
               decoration: BoxDecoration(
                color: const Color(0xfff3f3f3),
                borderRadius: BorderRadius.circular(12),
                
              ),
              
            ),
            
            const SizedBox(height: 10),

            Wrap(
              spacing: 8.0,
              children: tags.map((tag) {
                return FilterChip(
                  label: Text(tag),
                  selected: selectedTags.contains(tag),
                  selectedColor: Colors.green.shade100,
                  onSelected: (selected) {
                    setState(() {
                      selected ? selectedTags.add(tag) : selectedTags.remove(tag);
                    });
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text("Attach Images +", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text("Save", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
