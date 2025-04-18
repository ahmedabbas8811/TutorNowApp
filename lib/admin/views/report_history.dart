import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';
import 'package:newifchaly/admin/views/home_admin.dart';
import 'package:newifchaly/admin/views/manageusers.dart';

class ReportHistory extends StatelessWidget {
  const ReportHistory({super.key});

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
                          MaterialPageRoute(builder: (context) => const HomeAdmin()));
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
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.userTie,
                        color: Colors.black),
                    title: const Text('Manage Users',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Manageusers()));
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
                    leading: const Icon(Icons.insert_drive_file, color: Colors.black),
                    title: const Text('Reports',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
  // Continue inside the Expanded widget
Expanded(
   child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Text('Report 1723891',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      Spacer(),
                      InkWell(
                        child: Icon(Icons.message, size: 28, color: Colors.black),
                      ),
                    ],
                  ),
                ),
   SingleChildScrollView(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
           const  Text('Status:'),
           const SizedBox(width: 5
           ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff87e64c),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: 
              
              const Text('Open',
                  style: TextStyle(color: Colors.black,)),
            ),
            const SizedBox(width: 16),
           
          ],
        ),
        const SizedBox(height: 7),
         const Text('Submitted:  3 Days Ago'),
          const SizedBox(height: 7),
        const  Row(
  children: [
   Text('Reported By:  Ali (Student)'
   ),
     SizedBox(width: 8),
     Icon(Icons.message, color: Colors.black, size: 15,), 
   ],
),
         const SizedBox(height: 7),
         
       const  Row(
  children: [
   Text('Reported User:  Kashif (Tutor)'
   ),
     SizedBox(width: 8),
     Icon(Icons.message, color: Colors.black, size: 15,), 
   ],
),

         const SizedBox(height: 7),
        const Text('Comments:  Foul Language'),
        const SizedBox(height: 15),
        const Text('User Report History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
const SizedBox(height: 5),
        // Tabs
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, right: 8),
              decoration: BoxDecoration(
                color: const Color(0xff87e64c),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text('Ali(5)', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text('Kashif(0)'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Report Cards
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(5, (index) {
            final isClosed = index > 1;
            return Container(
              width: 280,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      spreadRadius: 1)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Status:'),
                     const SizedBox(width: 5,),
                      Container(
  decoration: BoxDecoration(
    color: isClosed ? const Color(0xff87e64c) : const Color(0xffe64b4b),
    borderRadius: BorderRadius.circular(12),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  child: Text(
    isClosed ? 'Closed' : 'Open',
    style: TextStyle(
      color: isClosed ? Colors.black : Colors.white,
    ),
  ),
),

                      const Spacer(),
                     
                    ],
                  ),
                  const SizedBox(height: 8),
                   const Text('Submitted: 3 Days Ago'),
                  const Text('Reported By: Ali (Student)'),
                  const Text('Comments: Foul Language'),
                  Text('Action Taken: ${isClosed ? "Warned User" : ""}'),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 15),

        // Take Action Section
        const Text('Take Action', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
       Wrap(
  spacing: 12,
  children: [
    ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.block, color: Colors.white),
      label: const Text('Block User', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffe64b4b),
      ),
    ),
    ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.black),
      label: const Text('Warn User', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffffa21e),
      ),
    ),
    ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.remove_circle_outline, color: Colors.black),
      label: const Text('Mark As Spam', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffe6e14b),
      ),
    ),
    ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.check_circle_outline, color: Colors.black,),
      label: const Text('Mark As Resolved', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff87e64c),
      ),
    ),
  ],
)

      ],
    ),
  ),
        ],),),
],
      ),
    );
  }
}