import 'package:flutter/material.dart';
import 'package:newifchaly/changepassword_screen.dart';
import 'package:newifchaly/availabilityscreen.dart';
import 'package:newifchaly/earningscreen.dart';
import 'package:newifchaly/personscreen.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/sessionscreen.dart';

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
  void _onBottomNavTap(int index) {
  switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()), // Replace with actual HomeScreen widget
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AvailabilityScreen()), // Replace with actual AvailabilityScreen widget
      );
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SessionsScreen()), // Replace with actual SessionsScreen widget
      );
      break;
    case 3:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EarningsScreen()), // Your existing EarningsScreen widget
      );
      break;
    case 4:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PersonScreen()), // Profile screen (current screen)
      );
      break;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Add "Edit Profile" text here
            const  Padding(
                padding:  EdgeInsets.all(18.0),
                child:  Text(
                  'Edit Profile',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/Ellipse 1.png'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: const Color(0xff87e64c),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit, color: Colors.black),
                          iconSize: 18,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete, color: Colors.white),
                          iconSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            
              TextField(
                controller: _fullNameController,
                focusNode: _fullNameFocusNode,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Aliyan Rizvi',
                  labelStyle: TextStyle(
                    color: _fullNameController.text.isNotEmpty
                        ? Colors.grey
                        : (_fullNameFocusNode.hasFocus
                            ? Colors.grey
                            : Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: _fullNameController.text.isNotEmpty
                          ? Colors.grey
                          : (_fullNameFocusNode.hasFocus
                              ? Colors.grey
                              : Colors.grey),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'aliyanrizvi@gmail.com',
                  labelStyle: TextStyle(
                    color: _emailController.text.isNotEmpty
                        ? Colors.grey
                        : (_emailFocusNode.hasFocus
                            ? Colors.grey
                            : Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: _emailController.text.isNotEmpty
                          ? Colors.grey
                          : (_emailFocusNode.hasFocus
                              ? Colors.grey
                              : Colors.grey),
                    ),
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
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'AliyanRizvi123.',
                  labelStyle: TextStyle(
                    color: _passwordController.text.isNotEmpty
                        ? Colors.grey
                        : (_passwordFocusNode.hasFocus
                            ? Colors.grey
                            : Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: _passwordController.text.isNotEmpty
                          ? Colors.grey
                          : (_passwordFocusNode.hasFocus
                              ? Colors.grey
                              : Colors.grey),
                    ),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
    );
  },
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontWeight: FontWeight.bold,decoration:TextDecoration.underline),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
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
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Availability'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sessions'),
    BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Earnings'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ],
),

    );
  }
}
