import 'package:flutter/material.dart';

class EngagementCard extends StatelessWidget {
  final IconData icon;
  final Color circleColor;
  final Color iconColor;
  final String value;
  final String label;
  final double iconSize;

  const EngagementCard({
    super.key,
    required this.icon,
    required this.circleColor,
    required this.iconColor,
    required this.value,
    required this.label,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 120,
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: circleColor,
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}