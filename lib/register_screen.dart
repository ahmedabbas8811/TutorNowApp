import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:newifchaly/utils/features/auth/auth_controller.dart';
import 'package:newifchaly/utils/form_validators.dart';
import 'login_screen.dart'; // Import login screen to navigate

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final _formKey = GlobalKey<FormState>(); // Key for the Form

  // Controllers for getting text input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController controller = Get.put(AuthController());

  // FocusNodes to detect if fields are focused
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // Method to style text field with dynamic border color and label animation
  InputDecoration _inputDecoration(
      String label, FocusNode focusNode, TextEditingController controller) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: focusNode.hasFocus || controller.text.isNotEmpty
            ? Colors.grey[650]
            : Colors.grey,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      hintStyle: const TextStyle(color: Colors.grey),
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
          child: Form(
            // Wrap your fields in a Form widget
            key: _formKey, // Assign the GlobalKey to the Form
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

                const Text(
                  'Register As A Tutor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Full Name Field
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: _inputDecoration(
                      'Your Full Name', _nameFocusNode, _nameController),
                  validator: ValidationBuilder()
                      .minLength(
                          2, 'Full Name must be at least 2 characters long')
                      .maxLength(50, 'Full Name can’t exceed 50 characters')
                      .build(),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration: _inputDecoration(
                      'youremail@gmail.com', _emailFocusNode, _emailController),
                  validator: ValidationBuilder().email().build(),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  decoration: _inputDecoration('Choose A Strong Password',
                          _passwordFocusNode, _passwordController)
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showPassword,
                  validator: validatePassword,
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  decoration: _inputDecoration('Confirm Your Password',
                          _confirmPasswordFocusNode, _confirmPasswordController)
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showConfirmPassword,
                  validator: (value) {
                    if (_passwordController.text != value) {
                      return "Confirm Password does not match";
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),

                Text(
                  'At least 8 characters\nAt least one uppercase character\nAt least one number\nAt least one special character',
                  style: TextStyle(fontSize: 12, color: Colors.grey[650]),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Already have an account?',
                        style: TextStyle(color: Colors.grey[650])),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: const Text('Login',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Register Button
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? controller.signupLoading.value == false) {
                        // Perform registration action
                        controller.signup(_nameController.text, _emailController.text, _passwordController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff87e64c),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                        controller.signupLoading.value
                            ? "Loading..."
                            : "Signup",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
