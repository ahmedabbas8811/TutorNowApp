import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
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
                _buildTabButton('About', false, Colors.grey),
                const SizedBox(width: 8),
                _buildTabButton('Progress', true, Colors.black),
              ],
            ),
            const SizedBox(height: 16),
            _buildPerformanceRow('Overall Performance', 'Average', Colors.black),
            const SizedBox(height: 16),
            _buildWeekProgress('Week 1', 'Struggling', const Color(0xffe64b4b), '😟'),
            _buildWeekProgress('Week 2', 'Excellent', const Color(0xff87e64c), '😃'),
            _buildWeekProgress('Week 3', 'Good', const Color(0xffdbf8c9), '🙂'),
            _buildWeekProgress('Week 4', 'Struggling', const Color(0xffe64b4b), '😟'),
            _buildWeekProgress('Week 5', 'Average', const Color.fromARGB(255, 157, 149, 75), '😐'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff87e64c) : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
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

  Widget _buildWeekProgress(String week, String status, Color color, String emoji) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), // Increased height by 3 points
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Text(
            '$week: $status $emoji',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          const Text(
            'See More →',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
