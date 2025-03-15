import 'package:flutter/material.dart';
import 'package:newifchaly/student/views/progress_stu.dart';

class AboutScreenStu extends StatelessWidget {
  const AboutScreenStu({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 10),
            const Text(
              'Student Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Package Name',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('About', true, () {}),
                const SizedBox(width: 8),
                _buildTabButton('Progress', false, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProgressScreen()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffeefbe5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children:  [
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 10),
                      Text('1 Hour 30 Min / Session'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.sync),
                      SizedBox(width: 10),
                      Text('3X / Week'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 10),
                      Text('8 Weeks'),
                    ],
                  ),
                ],
              ),
            ),
           const SizedBox(height: 20),
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xffeefbe5),
    borderRadius: BorderRadius.circular(10),
  ),
  child: const Column(
    children: [
      Row(
        children: [
          Text('Monday',style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(width: 20), 
          Text('8:30 - 10'),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Text('Tuesday',style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(width: 20), 
          Text('8:30 - 10'),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Text('Wednesday',style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(width: 20), 
          Text('8:30 - 10'),
        ],
      ),
    ],
  ),
)
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
}
