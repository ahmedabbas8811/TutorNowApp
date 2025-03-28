import 'package:flutter/material.dart';

class SessionRow extends StatelessWidget {
  final String tutorName;
  final String studentName;
  final String date;
  final String time;

  const SessionRow({
    super.key,
    required this.tutorName,
    required this.studentName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(tutorName),
          ),
          Expanded(
            flex: 2,
            child: Text(studentName),
          ),
          Expanded(
            child: Text(date),
          ),
          Expanded(
            child: Text(time),
          ),
        ],
      ),
    );
  }
}