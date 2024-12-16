import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isPasswordVisible = false;
  bool _isChangePasswordClicked = false; // Track the click state
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _fullNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _fullNameFocusNode.addListener(() {
      setState(() {});
    });
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 10),
                  // Centered Row for edit and delete buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Edit button with rounded container
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: const Color(0xff87e64c),
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Action for edit button
                          },
                          icon: const Icon(Icons.edit, color: Colors.black),
                          iconSize: 18, // Smaller icon size
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Delete button with rounded container
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Action for delete button
                          },
                          icon: const Icon(Icons.delete, color: Colors.white),
                          iconSize: 18, // Smaller icon size
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Full Name Field
              TextField(
                controller: _fullNameController,
                focusNode: _fullNameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Aliyan Rizvi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Colors.grey), // Always gray for border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Email Field
              TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'aliyanrizvi@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Colors.grey), // Always gray for border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password Field
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'AliyanRizvi123.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Colors.grey), // Always gray for border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isChangePasswordClicked = !_isChangePasswordClicked;
                  });
                },
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Change Password',style: TextStyle(fontWeight: FontWeight.bold),
                    
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
  bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Colors.white,  // This sets the background color to white
  selectedItemColor: const Color(0xff87e64c),
  unselectedItemColor: Colors.black,
  showUnselectedLabels: true,
  currentIndex: 4,
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today), label: 'Availability'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sessions'),
    BottomNavigationBarItem(
        icon: Icon(Icons.attach_money), label: 'Earnings'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ],
)

    );
  }
}
