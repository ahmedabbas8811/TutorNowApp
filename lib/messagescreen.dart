import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Transform.scale(
            scale: 1.5, // Adjust the scale for a bolder look
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your chats will appear here',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Matches the background color
    );
  }
}