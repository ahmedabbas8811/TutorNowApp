import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import login screen to navigate

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  // Controllers for getting text input
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // FocusNodes to detect if fields are focused
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

  // Function to check if all fields are filled
  bool _areFieldsFilled() {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  // Method to style text field with dynamic border color and label animation
  InputDecoration _inputDecoration(String label, FocusNode focusNode, TextEditingController controller) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: focusNode.hasFocus || controller.text.isNotEmpty ? Colors.grey[650] : Colors.grey,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:const BorderSide(color: Colors.grey), // Default border color
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:const BorderSide(color: Colors.grey), // Border color when field is focused
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding:const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      hintStyle: const TextStyle(color: Colors.grey), // Makes the hint text grey
    );
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes when not needed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/ali.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),

             const  Text(
                'Register As A Tutor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
             const  SizedBox(height: 20),

              // Full Name Field
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: _inputDecoration('Your Full Name', _nameFocusNode, _nameController),
                onChanged: (text) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),

              // Email Field
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: _inputDecoration('youremail@gmail.com', _emailFocusNode, _emailController),
                onChanged: (text) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),

              // Password Field
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                decoration: _inputDecoration('Choose A Strong Password', _passwordFocusNode, _passwordController).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
                onChanged: (text) {
                  setState(() {});
                },
              ),
             const  SizedBox(height: 10),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                decoration: _inputDecoration('Confirm Your Password', _confirmPasswordFocusNode, _confirmPasswordController).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showConfirmPassword,
                onChanged: (text) {
                  setState(() {});
                },
              ),
             const  SizedBox(height: 10),

              Text(
                'At least 8 characters\nAt least one uppercase character\nAt least one number\nAt least one special character',
                style: TextStyle(fontSize: 12, color: Colors.grey[650]),
              ),
             const  SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Already have an account?', style: TextStyle(color: Colors.grey[650])),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Register Button
              ElevatedButton(
                onPressed: _areFieldsFilled() ? () {
                  // Perform registration action
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _areFieldsFilled()
                      ? const Color(0xff87e64c)
                      : const Color(0xffc3f3a5),
                  padding:const  EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:const  Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
