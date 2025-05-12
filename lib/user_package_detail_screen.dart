import 'package:flutter/material.dart';
import 'package:newifchaly/models/user_package_model.dart';

class UserPackageDetailScreen extends StatelessWidget {
  final UserPackageModel package;

  const UserPackageDetailScreen({Key? key, required this.package})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Package Details",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight( // Wrap to make height adapt to content
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(135, 230, 75, 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.packageName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (package.packageDescription != null &&
                    package.packageDescription!.isNotEmpty)
                  Text(
                    package.packageDescription!,
                    style: const TextStyle(fontSize: 14),
                  ),
                const SizedBox(height: 16),
                if (package.hoursPerSession != null &&
                    package.minutesPerSession != null)
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18),
                      const SizedBox(width: 8),
                      Text(
                          '${package.hoursPerSession} Hours : ${package.minutesPerSession} Minutes / Session'),
                    ],
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.repeat, size: 18),
                    const SizedBox(width: 8),
                    Text('${package.sessionsPerWeek}X / Week'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text('${package.numberOfWeeks} Weeks'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.money, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${package.price} PKR',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
