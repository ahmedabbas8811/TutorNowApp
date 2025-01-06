// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newifchaly/services/supabase_service.dart';
// import 'package:newifchaly/admin/views/approve_tutors.dart';
// import 'package:newifchaly/profile_screen.dart';

// class SplashScreen extends StatefulWidget {
//   final String userId;

//   const SplashScreen({required this.userId});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkUserTypeAndRedirect();
//   }

//   Future<void> _checkUserTypeAndRedirect() async {
//     try {
//       // Fetch user type from the database
//       final user = await SupabaseService.supabase
//           .from('users')
//           .select('user_type')
//           .eq('id', widget.userId)
//           .single();

//       if (user != null && user['user_type'] == 'Admin') {
//         // Redirect to Admin screen
//         Get.offAll(() => ApproveTutorsScreen());
//       } else {
//         // Redirect to Profile screen
//         Get.offAll(() => ProfileScreen());
//       }
//     } catch (e) {
//       // Handle errors if fetching user type fails
//       Get.snackbar("Error", "Failed to load user data.");
//       print("Error fetching user type: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/services/supabase_service.dart';
import 'dart:developer';

import 'package:newifchaly/student/views/student_home_screen.dart';

class SplashScreen extends StatefulWidget {
  final String userId;

  const SplashScreen({required this.userId});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    // Start both delay and data fetching in parallel
    final delayFuture = Future.delayed(const Duration(seconds: 3));
    final fetchUserFuture = _fetchUserTypeAndRedirect();

    // Wait for both to complete
    await Future.wait([delayFuture, fetchUserFuture]);
  }

  Future<void> _fetchUserTypeAndRedirect() async {
    try {
      // Fetch user type from the database
      final user = await SupabaseService.supabase
          .from('users')
          .select('user_type')
          .eq('id', widget.userId)
          .single();

      if (user != null && user['user_type'] == 'Admin') {
        // Redirect to Admin screen
        Get.offAll(() => ApproveTutorsScreen());
      } else if (user['user_type'] == 'Student') {
        // Redirect to Profile screen
        Get.offAll(() => StudentScreen());
      } else {
        Get.offAll(() => ProfileScreen());
      }
    } catch (e) {
      // Handle errors if fetching user type fails
      log("Error fetching user type: $e");
      Get.snackbar("Error", "Failed to load user data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/ali.png', // Replace with your actual logo asset path
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
