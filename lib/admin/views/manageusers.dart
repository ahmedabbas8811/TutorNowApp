import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newifchaly/admin/controllers/manage_users_controller.dart';
import 'package:newifchaly/admin/models/manage_users_model.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/messagescreen.dart';
import 'package:newifchaly/student/views/chat_screen.dart';

class Manageusers extends StatefulWidget {
  const Manageusers({super.key});

  @override
  State<Manageusers> createState() => _ManageusersState();
}

class _ManageusersState extends State<Manageusers> {
  final UserController _userController = UserController();
  List<UserModel> users = [];
  List<bool> switchStates = []; // This will track the toggle states
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final fetchedUsers = await _userController.fetchUsers();
      setState(() {
        users = fetchedUsers;
        // Initialize switch states based on current status
        switchStates = users.map((user) => user.status == 'blocked').toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }

  Future<void> _toggleUserStatus(int index) async {
    try {
      final user = users[index];
      final newStatus = !switchStates[index];

      // Update in Supabase
      await _userController.updateUserStatus(user.id, newStatus);

      // Update local state
      setState(() {
        switchStates[index] = newStatus;
        users[index] = UserModel(
          id: user.id,
          email: user.email,
          name: user.name,
          userType: user.userType,
          status: newStatus ? 'blocked' : 'unblocked',
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'User ${newStatus ? 'blocked' : 'unblocked'} successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: Row(
        children: [
          // Sidebar (unchanged)
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Image.asset('assets/ali.png', width: 50, height: 50),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0,
                          spreadRadius: 1),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text('Home',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeAdmin()));
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.black),
                    title: const Text('Approve Tutors',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApproveTutorsScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xff87e64c),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.userTie,
                        color: Colors.black),
                    title: const Text('Manage Users',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
                  child: Row(
                    children: [
                      const Text('Manage Users',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      Spacer(),
                      InkWell(
                        // Changed from Icon to InkWell
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorChatListScreen(),
                            ),
                          );
                        },
                        child:
                            const Icon(Icons.message, size: 28, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                // Card
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xffe0e0e0)),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),

                            // Header Row (Green)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xff87e64c),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Center(
                                          child: Text('User Name',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Center(
                                          child: Text('User ID',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Center(
                                          child: Text('Email',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Center(
                                          child: Text('User Type',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Center(
                                          child: Text('Block User',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child:
                                          SizedBox(), // For message icon header
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // User Rows
                            ListView.builder(
                              itemCount: users.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    child: Row(
                                      children: [
                                        // Name Column (wider)
                                        Flexible(
                                          flex: 3,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              user.name,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        // ID Column (wider)
                                        Flexible(
                                          flex: 3,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              user.id,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        // Email Column (wider)
                                        Flexible(
                                          flex: 3,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              user.email,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        // User Type Column (narrower)
                                        Flexible(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              user.userType,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        // Block User Column (narrower)
                                        Flexible(
                                          flex: 1,
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _toggleUserStatus(index),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                width: 50,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: switchStates[index]
                                                      ? const Color(0xffe64b4b)
                                                      : const Color(0xffe9e9ea),
                                                ),
                                                child: AnimatedAlign(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  alignment: switchStates[index]
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(4),
                                                    width: 20,
                                                    height: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Message Icon Column (narrower) - Modified section
                                        Flexible(
                                          flex: 1,
                                          child: Center(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                      receiverId: user.id,
                                                      receiverName: user.name,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Icon(Icons.message),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
