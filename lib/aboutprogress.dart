import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutProgress extends StatefulWidget {
  const AboutProgress({Key? key}) : super(key: key);

  @override
  _AboutProgressState createState() => _AboutProgressState();
}

class _AboutProgressState extends State<AboutProgress> {
  bool isAboutSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, backgroundColor: Colors.grey.shade300),
            SizedBox(height: 10),
            Text('Student Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Package Name', style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 20),
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
                      backgroundColor: isAboutSelected ? Colors.green.shade300 : Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'About',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAboutSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAboutSelected ? Colors.grey.shade200 : Colors.green.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Progress',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            isAboutSelected
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer, size: 20),
                                SizedBox(width: 8),
                                Text('1 Hour 30 Min / Session'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.repeat, size: 20),
                                SizedBox(width: 8),
                                Text('3X / Week'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 20),
                                SizedBox(width: 8),
                                Text('8 Weeks'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
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
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff7f7f7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.black),
                        ),
                        child: Text('Week ${index + 1}', style: TextStyle(color: Colors.black)),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}