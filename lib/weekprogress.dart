import 'package:flutter/material.dart';

class WeekProgress extends StatelessWidget {
  final int weekNumber;

  const WeekProgress({Key? key, required this.weekNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week $weekNumber Progress'),
      ),
      body: Center(
        child: Text('Details for Week $weekNumber', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
