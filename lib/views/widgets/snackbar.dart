// import 'package:flutter/material.dart';

// void showCustomSnackBar(BuildContext context, String message) {
//   final overlay = Overlay.of(context);
//   if (overlay != null) {
//     // Create an entry for the overlay
//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).padding.top + 10, // Add padding for the status bar
//         left: 10,
//         right: 10,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 15, 126, 0),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               message,
//               style: TextStyle(color: Colors.white, fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );

//     // Insert the overlay entry
//     overlay.insert(overlayEntry);

//     // Remove it after the duration
//     Future.delayed(Duration(seconds: 3)).then((_) {
//       overlayEntry.remove();
//     });
//   }
// }
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context); // No need for null check

  // Create an entry for the overlay
  final overlayEntry = OverlayEntry(
    builder: (context) => _AnimatedSnackbar(message: message),
  );

  // Insert the overlay entry
  overlay.insert(overlayEntry);

  // Remove the overlay entry after the duration
  Future.delayed(Duration(seconds: 3)).then((_) => overlayEntry.remove());
}

class _AnimatedSnackbar extends StatefulWidget {
  final String message;

  const _AnimatedSnackbar({required this.message});

  @override
  State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<_AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Fade in/out duration
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the fade-in animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10, // Position at the top
      left: 10,
      right: 10,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: const Color.fromARGB(0, 255, 255, 255),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.message,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
