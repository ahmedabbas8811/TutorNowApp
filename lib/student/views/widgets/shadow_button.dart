import 'package:flutter/material.dart';

class ShadowButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const ShadowButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black, // 100% black color
            offset: Offset(4, 4), // Position (x: 4, y: 4)
            blurRadius: 0, // No blur
            spreadRadius: 0, // No additional spread
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button background color
          elevation: 0, // Disable the default elevation
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white, // Text color
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
