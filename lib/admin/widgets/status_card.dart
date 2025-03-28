import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final String label;

  const StatusCard({
    super.key,
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 15,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}