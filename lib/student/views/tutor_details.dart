import 'package:flutter/material.dart';

class TutorDetailScreen extends StatelessWidget {
  final String tutorId;

  final String tutorname;

  const TutorDetailScreen(
      {Key? key, required this.tutorId, required this.tutorname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tutor Details')),
      body: Center(
        child: Text('Details for Tutor ID: $tutorId  -  $tutorname'),
      ),
    );
  }
}
