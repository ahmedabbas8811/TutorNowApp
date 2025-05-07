import 'package:flutter/material.dart';
import 'package:newifchaly/student/controllers/progress_controller.dart';

class ParentLink extends StatelessWidget {
  final String bookingId;
  final ProgressReportController controller;
  final TextEditingController parentIdController = TextEditingController();

  ParentLink({
    super.key,
    required this.bookingId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Link Parent Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: parentIdController,
            decoration: const InputDecoration(
              labelText: 'Parent ID',
              hintText: 'Enter parent user ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ask the parent for their user ID to link their account',
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
            if (parentIdController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter parent ID')),
              );
              return;
            }

            try {
              await controller.linkParent(
                bookingId,
                parentIdController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Parent linked successfully!')),
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
