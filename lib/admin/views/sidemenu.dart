import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/ali.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            color: const Color(0xfffafafa),
            child: const ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: Text('Home'),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            color: Colors.black,
            child: const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.white),
              title: Text(
                'Approve Tutors',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
