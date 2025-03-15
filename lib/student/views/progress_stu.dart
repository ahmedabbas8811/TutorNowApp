import 'package:flutter/material.dart';
import 'package:newifchaly/student/views/aboutprogress_stu.dart';
import 'package:newifchaly/student/views/progressreport_stu.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isProgressSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tutor Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Package Name',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('About', false, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreenStu()),
                  );
                }),
                const SizedBox(width: 8),
                _buildTabButton('Progress', true, () {}),
              ],
            ),
            const SizedBox(height: 16),
            _buildPerformanceRow('Overall Performance', 'Average', Colors.black),
            const SizedBox(height: 16),
            _buildWeekProgress('Week 1', 'Struggling', const Color(0xffe64b4b), '😟', Colors.white),
            _buildWeekProgress('Week 2', 'Excellent', const Color(0xff87e64c), '😃', Colors.black),
            _buildWeekProgress('Week 3', 'Good', const Color(0xffdbf8c9), '🙂', Colors.black),
            _buildWeekProgress('Week 4', 'Struggling', const Color(0xffe64b4b), '😟', Colors.white),
            _buildWeekProgress('Week 5', 'Average', const Color.fromARGB(255, 157, 149, 75), '😐', Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff87e64c) : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.black) : Border.all(color: Colors.transparent),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(String title, String status, Color textColor) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                status,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(width: 4),
              const Text('😐'),
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildWeekProgress(String week, String status, Color color, String emoji, Color textColor) {
  // Determine if the underline color should be white
  bool isUnderlineWhite = week == 'Week 1' || week == 'Week 4';

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProgressReportStu()),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Text(
            '$week: $status $emoji',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
          ),
          const Spacer(),
          Text(
            'See More →',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
              decoration: TextDecoration.underline,
              decorationColor: isUnderlineWhite ? Colors.white : textColor, // Set underline color conditionally
            ),
          ),
        ],
      ),
    ),
  );
}
}