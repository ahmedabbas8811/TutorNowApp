import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutProgress extends StatefulWidget {
  @override
  _AboutProgressState createState() => _AboutProgressState();
}

class _AboutProgressState extends State<AboutProgress> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
            CircleAvatar(radius: 40, backgroundColor: Colors.grey.shade300),
            SizedBox(height: 10),
            Text('Student Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Package Name', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                  ),
                  child: Text('About', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: Text('Progress', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
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
