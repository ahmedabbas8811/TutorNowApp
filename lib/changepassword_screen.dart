import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/controllers/profile_controller.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';
import 'package:newifchaly/utils/features/auth/auth_controller.dart';
import 'package:newifchaly/views/setpakages_screen.dart';
import 'package:newifchaly/views/widgets/nav_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
  bool _isPasswordValid = false;
  String _passwordError = '';

  int _selectedIndex = 4;

  final AuthController _authController = Get.find<AuthController>();

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

  void _validatePassword(String password) {
    // Check for at least 8 characters
    if (password.length < 8) {
      _isPasswordValid = false;
      _passwordError = 'Password must be at least 8 characters';
      return;
    }

    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _isPasswordValid = false;
      _passwordError = 'Password must contain at least one uppercase letter';
      return;
    }

    // Check for at least one number
    if (!password.contains(RegExp(r'[0-9]'))) {
      _isPasswordValid = false;
      _passwordError = 'Password must contain at least one number';
      return;
    }

    // Check for at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _isPasswordValid = false;
      _passwordError = 'Password must contain at least one special character';
      return;
    }

    // If all checks pass
    _isPasswordValid = true;
    _passwordError = '';
  }

  void _onItemTapped(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = ProfileScreen();
        break;
      case 1:
        screen = AvailabilityScreen();
        break;
      case 2:
        screen = SessionScreen();
        break;
      case 3:
        screen = SetpakagesScreen();
        break;
      case 4:
        screen = PersonScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profilecontroller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Add this
        padding: const EdgeInsets.all(16.0), // Move padding here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
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
              onChanged: (value) {
                _validatePassword(value);
                setState(() {});
              },
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
                errorText:
                    _newPasswordController.text.isNotEmpty && !_isPasswordValid
                        ? _passwordError
                        : null,
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
            // Password requirements
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password must contain:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _newPasswordController.text.length >= 8
                          ? Icons.check_circle
                          : Icons.circle,
                      size: 16,
                      color: _newPasswordController.text.length >= 8
                          ? Colors.green
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('At least 8 characters'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _newPasswordController.text.contains(RegExp(r'[A-Z]'))
                          ? Icons.check_circle
                          : Icons.circle,
                      size: 16,
                      color:
                          _newPasswordController.text.contains(RegExp(r'[A-Z]'))
                              ? Colors.green
                              : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('At least one uppercase letter'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _newPasswordController.text.contains(RegExp(r'[0-9]'))
                          ? Icons.check_circle
                          : Icons.circle,
                      size: 16,
                      color:
                          _newPasswordController.text.contains(RegExp(r'[0-9]'))
                              ? Colors.green
                              : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('At least one number'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _newPasswordController.text
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                          ? Icons.check_circle
                          : Icons.circle,
                      size: 16,
                      color: _newPasswordController.text
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                          ? Colors.green
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('At least one special character'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: () async {
                if (!_isPasswordValid) {
                  Get.snackbar("Invalid Password",
                      "Please meet all password requirements.");
                  return;
                }

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
                      context);
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
      bottomNavigationBar: Obx(() => TutorBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          pendingBookingsCount: profilecontroller.pendingBookingsCount.value)),
    );
  }
}
