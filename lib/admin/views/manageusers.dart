import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/views/home_admin.dart';

class Manageusers extends StatefulWidget {
  const Manageusers({super.key});

  @override
  State<Manageusers> createState() => _ManageusersState();
}

class _ManageusersState extends State<Manageusers> {
  // Manage switch states for each user
  List<bool> switchStates = List.generate(5, (index) => index % 2 == 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  'assets/ali.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 15),
               Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeAdmin()),
                      );
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
                        leading: const Icon(Icons.check_circle, color: Colors.black),
                        title: const Text(
                          'Approve Tutors',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApproveTutorsScreen()),
                          );
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
                    leading: const Icon(FontAwesomeIcons.userTie, color: Colors.black),
                    title: const Text(
                      'Manage Users',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),

                  child: Row(
                    children: [
                      Text(
                        'Manage Users',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(Icons.message, size: 28, color: Colors.black),
                    ],
                  ),
                ),

                // User List Card
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xffe0e0e0)),
                    boxShadow:const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  
                  child: Column(
                    children: [
                     const  SizedBox(height: 12),
                      // Rounded Green Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xff87e64c),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Row(
                          children: [
                            Expanded(child: Center(child: Text('User Name', style: TextStyle(fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('User ID', style: TextStyle(fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('User Type', style: TextStyle(fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('Block User', style: TextStyle(fontWeight: FontWeight.bold)))),
                            SizedBox(width: 60),
                          ],
                        ),
                      ),

                      // User Rows
                      ListView.builder(
                        itemCount: switchStates.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          child: Row(
                            children: [
                              const Expanded(child: Center(child: Text('Bilal Jan'))),
                              const Expanded(child: Center(child: Text('7982731023091'))),
                              const Expanded(child: Center(child: Text('ahmerbilaljan@gmail.com'))),
                              const Expanded(child: Center(child: Text('Parent'))),
                              Expanded(
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        switchStates[index] = !switchStates[index];
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 50,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: switchStates[index]
                                            ? const Color(0xffe64b4b)
                                            : const Color(0xffe9e9ea),
                                      ),
                                      child: AnimatedAlign(
                                        duration: const Duration(milliseconds: 200),
                                        alignment: switchStates[index] ? Alignment.centerRight : Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(Icons.message_outlined),
                            ],
                          ),
                        ),
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