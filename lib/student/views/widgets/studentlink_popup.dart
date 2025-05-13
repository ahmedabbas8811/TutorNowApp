import 'package:flutter/material.dart';
import 'package:newifchaly/student/controllers/progress_controller.dart';

class StudentLink extends StatelessWidget {
  final String bookingId;
  final ProgressReportController controller;
  final TextEditingController studentIdController = TextEditingController();

  StudentLink({
    super.key,
    required this.bookingId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Link Student Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: studentIdController,
            decoration: const InputDecoration(
              labelText: 'Student Email',
              hintText: 'Enter student user Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ask the student for their user email to link their account',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (studentIdController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter student Email')),
              );
              return;
            }

            try {
              await controller.linkStudent(
                bookingId,
                studentIdController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student linked successfully!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
