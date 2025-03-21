import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/utils/features/auth/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_screen.dart'; // Import register screen to navigate
import 'package:form_validator/form_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  bool _isPasswordVisible = false; // To toggle password visibility
  final AuthController controller = Get.put(AuthController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust the width based on screen size
            double contentWidth = constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.9;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: contentWidth,
                      child: Column(
                        children: [
                          // Logo
                          Center(
                            child: Image.asset(
                              'assets/ali.png', // Ensure the image is available in assets
                              height: 100,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Welcome Text
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Email TextField
                          TextFormField(
                            controller: _emailController,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                            validator: ValidationBuilder().email().build(), // Email validation
                            onChanged: (value) => setState(() {}), // Trigger rebuild on change
                          ),
                          const SizedBox(height: 10),

                          // Password TextField
                          TextFormField(
                            controller: _passwordController,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible, // Toggle the text visibility
                            validator: ValidationBuilder()
                                .minLength(8, 'Password must be at least 8 characters long')
                                .build(), // Password validation
                            onChanged: (value) => setState(() {}), // Trigger rebuild on change
                          ),
                          const SizedBox(height: 20),

                          // "Don't have an account?" and "Register" button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()),
                                  );
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Login Button
                          Obx(
                            () => SizedBox(
                              width: contentWidth,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      controller.loginLoading.value == false) {
                                    // Perform login action if validation passes
                                    controller.login(
                                        _emailController.text, _passwordController.text, context);
                                    final user = Supabase.instance.client.auth.currentUser;
                                    if (user != null) {
                                      print("User UUID: ${user.id}");
                                    } else {
                                      print("No user is currently logged in.");
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (_emailController.text.isNotEmpty &&
                                          _passwordController.text.isNotEmpty)
                                      ? const Color(0xff87e64c) // Active button color
                                      : const Color(0xffc3f3a5), // Inactive button color
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  controller.loginLoading.value ? "Loading..." : "Login",
                                  style: const TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
