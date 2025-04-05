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
    // Fixed height to match other cards (same as StatusCard)
    const fixedHeight = 103.0; // Adjusted to match your layout
    
    return SizedBox(
      width: 140,
      height: fixedHeight,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Matches your dashboard style
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 16, // Slightly smaller to prevent overflow
                backgroundColor: circleColor,
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize.clamp(16, 20), // Ensures icon stays within bounds
                ),
              ),
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
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}