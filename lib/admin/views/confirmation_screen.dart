import 'package:flutter/material.dart';
import 'personal_information.dart';
import 'qualification_information.dart';
import 'experience_information.dart';

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            SideMenu(),
            const Expanded(
              child: ConfirmationTutorsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: ListTile(
              leading: Image.asset(
                'assets/ali.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
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
              leading: Icon(Icons.home, color: Colors.white),
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

class ConfirmationTutorsScreen extends StatelessWidget {
  const ConfirmationTutorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Approve Tutors',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: PersonalInformation(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 1,
                    child: QualificationInformation(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 1,
                    child: ExperienceInformation(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}