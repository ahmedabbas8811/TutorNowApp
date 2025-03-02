import 'package:flutter/material.dart';
import 'weekprogress.dart'; // Ensure this file exists

class AboutProgress extends StatefulWidget {
  const AboutProgress({Key? key}) : super(key: key);

  @override
  _AboutProgressState createState() => _AboutProgressState();
}

class _AboutProgressState extends State<AboutProgress> {
  bool isAboutSelected = false; // Default: Progress selected

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
            CircleAvatar(radius: 50, backgroundColor: Colors.grey.shade300),
            const SizedBox(height: 10),
            const Text('Student Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Package Name', style: TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAboutSelected = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAboutSelected ? const Color(0xff87e64c) : Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isAboutSelected ? Colors.black : Colors.grey),
                      ),
                    ),
                    child: Text(
                      'About',
                      style: TextStyle(
                        color: isAboutSelected ? Colors.black : Colors.grey,
                        fontWeight: isAboutSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAboutSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isAboutSelected ? const Color(0xff87e64c) : Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: !isAboutSelected ? Colors.black : Colors.grey),
                      ),
                    ),
                    child: Text(
                      'Progress',
                      style: TextStyle(
                        color: !isAboutSelected ? Colors.black : Colors.grey,
                        fontWeight: !isAboutSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isAboutSelected
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffeefbe5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer, size: 20),
                                SizedBox(width: 8),
                                Text('1 Hour 30 Min / Session', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.repeat, size: 20),
                                SizedBox(width: 8),
                                Text('3X / Week', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 20),
                                SizedBox(width: 8),
                                Text('8 Weeks', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 330,
                        height: 100,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffeefbe5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Monday    8:30 - 10', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Tuesday    8:30 - 10', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Wednesday  8:30 - 10', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2,
                      ),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeekProgress(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xfff7f7f7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            side: const BorderSide(color: Colors.black),
                          ),
                          child: Text('Week ${index + 1}', style: const TextStyle(color: Colors.black)),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
