// import 'package:flutter/material.dart';
// import 'package:newifchaly/availabilityscreen.dart';
// import 'package:newifchaly/earningscreen.dart';
// import 'package:newifchaly/personscreen.dart';
// import 'package:newifchaly/profile_screen.dart';
// import 'package:newifchaly/sessionscreen.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   @override
//   _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   // Controllers and Focus Nodes
//   final TextEditingController _currentPasswordController =
//       TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _retypePasswordController =
//       TextEditingController();

//   final FocusNode _currentPasswordFocusNode = FocusNode();
//   final FocusNode _newPasswordFocusNode = FocusNode();
//   final FocusNode _retypePasswordFocusNode = FocusNode();

//   bool _isCurrentPasswordVisible = false;
//   bool _isNewPasswordVisible = false;
//   bool _isRetypePasswordVisible = false;

//   int _selectedIndex = 4; // Set default to 'Profile' tab (index 4)

//   var _onItemTapped;

//   @override
//   void dispose() {
//     _currentPasswordController.dispose();
//     _newPasswordController.dispose();
//     _retypePasswordController.dispose();
//     _currentPasswordFocusNode.dispose();
//     _newPasswordFocusNode.dispose();
//     _retypePasswordFocusNode.dispose();
//     super.dispose();
//   }

//   void _onBottomNavTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => ProfileScreen()));
//         break;
//       case 1:
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => AvailabilityScreen()));
//         break;
//       case 2:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => SessionsScreen()));
//         break;
//       case 3:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => EarningsScreen()));
//         break;
//       case 4:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => PersonScreen()));
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Text('Change Password',
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//             ),
//             const Text('Confirm Current Password',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
//             const SizedBox(height: 10),
//             // Current Password Field
//             TextField(
//               controller: _currentPasswordController,
//               focusNode: _currentPasswordFocusNode,
//               obscureText: !_isCurrentPasswordVisible,
//               cursorColor: Colors.grey,
//               decoration: InputDecoration(
//                 labelText: 'Current Password',
//                 hintText: 'AliyanRizvi123.',
//                 labelStyle: TextStyle(
//                   color: _currentPasswordController.text.isNotEmpty
//                       ? Colors.grey
//                       : (_currentPasswordFocusNode.hasFocus
//                           ? Colors.grey
//                           : Colors.black),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isCurrentPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                     color: Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   "Forgot Password",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text("Enter New Password",
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // New Password Field
//             TextField(
//               controller: _newPasswordController,
//               focusNode: _newPasswordFocusNode,
//               obscureText: !_isNewPasswordVisible,
//               cursorColor: Colors.grey,
//               decoration: InputDecoration(
//                 labelText: 'New Password',
//                 hintText: 'AliyanRizvi123.',
//                 labelStyle: TextStyle(
//                   color: _newPasswordController.text.isNotEmpty
//                       ? Colors.grey
//                       : (_newPasswordFocusNode.hasFocus
//                           ? Colors.grey
//                           : Colors.black),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isNewPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                     color: Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isNewPasswordVisible = !_isNewPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Re-Type New Password Field
//             TextField(
//               controller: _retypePasswordController,
//               focusNode: _retypePasswordFocusNode,
//               obscureText: !_isRetypePasswordVisible,
//               cursorColor: Colors.grey,
//               decoration: InputDecoration(
//                 labelText: 'Re-Type New Password',
//                 hintText: 'AliyanRizvi123.',
//                 labelStyle: TextStyle(
//                   color: _retypePasswordController.text.isNotEmpty
//                       ? Colors.grey
//                       : (_retypePasswordFocusNode.hasFocus
//                           ? Colors.grey
//                           : Colors.black),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isRetypePasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                     color: Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isRetypePasswordVisible = !_isRetypePasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Submit Button
//             ElevatedButton(
//               onPressed: () {
//                 // Add logic to handle form submission
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xff87e64c),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 142),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Save',
//                 style: TextStyle(fontSize: 18, color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: const Color(0xff87e64c),
//         unselectedItemColor: Colors.black,
//         showUnselectedLabels: true,
//         currentIndex: 4, // Current active index
//         onTap: _onBottomNavTap, // Handle tap
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_today), label: 'Availability'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sessions'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.attach_money), label: 'Earnings'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/utils/features/auth/auth_controller.dart';
import 'package:newifchaly/api/auth_api.dart';
// Import your controller

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Controllers and Focus Nodes
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _retypePasswordFocusNode = FocusNode();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isRetypePasswordVisible = false;

  int _selectedIndex = 4; // Set default to 'Profile' tab (index 4)

  final AuthController _authController =
      Get.find<AuthController>(); // Using GetX to fetch the controller

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _retypePasswordController.dispose();
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _retypePasswordFocusNode.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AvailabilityScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SessionsScreen()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EarningsScreen()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PersonScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Change Password',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            const Text('Confirm Current Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 10),
            // Current Password Field
            TextField(
              controller: _currentPasswordController,
              focusNode: _currentPasswordFocusNode,
              obscureText: !_isCurrentPasswordVisible,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                labelText: 'Current Password',
                hintText: 'AliyanRizvi123.',
                labelStyle: TextStyle(
                  color: _currentPasswordController.text.isNotEmpty
                      ? Colors.grey
                      : (_currentPasswordFocusNode.hasFocus
                          ? Colors.grey
                          : Colors.black),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isCurrentPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   "Forgot Password",
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       decoration: TextDecoration.underline),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Enter New Password",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ],
            ),
            const SizedBox(height: 20),
            // New Password Field
            TextField(
              controller: _newPasswordController,
              focusNode: _newPasswordFocusNode,
              obscureText: !_isNewPasswordVisible,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'AliyanRizvi123.',
                labelStyle: TextStyle(
                  color: _newPasswordController.text.isNotEmpty
                      ? Colors.grey
                      : (_newPasswordFocusNode.hasFocus
                          ? Colors.grey
                          : Colors.black),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Re-Type New Password Field
            TextField(
              controller: _retypePasswordController,
              focusNode: _retypePasswordFocusNode,
              obscureText: !_isRetypePasswordVisible,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                labelText: 'Re-Type New Password',
                hintText: 'AliyanRizvi123.',
                labelStyle: TextStyle(
                  color: _retypePasswordController.text.isNotEmpty
                      ? Colors.grey
                      : (_retypePasswordFocusNode.hasFocus
                          ? Colors.grey
                          : Colors.black),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isRetypePasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isRetypePasswordVisible = !_isRetypePasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: () async {
                if (_newPasswordController.text !=
                    _retypePasswordController.text) {
                  Get.snackbar(
                      "Password Mismatch", "The new passwords do not match.");
                  return;
                }

                try {
                  // Call the changePassword method from AuthController
                  await _authController.changePassword(
                    _currentPasswordController.text,
                    _newPasswordController.text,
                    context
                  );
                  Get.snackbar("Password Changed",
                      "Your password has been successfully updated.");
                } catch (e) {
                  Get.snackbar("Error",
                      "An error occurred while changing the password.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff87e64c),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 142),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xff87e64c),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: 4, // Current active index
        onTap: _onBottomNavTap, // Handle tap
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Availability'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sessions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
