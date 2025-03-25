import 'package:flutter/material.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

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
                const SizedBox(height: 10),
                // Logo Image
                Image.asset(
                  'assets/ali.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                // Home Button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xff87e64c),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const ListTile(
                    leading: Icon(Icons.home, color: Colors.black),
                    title: Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Approve Tutors Button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
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
                        MaterialPageRoute(builder: (context) => ApproveTutorsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard title moved up with minimal padding
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 5.0),
                  child: Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // Three boxes in a row directly under the title
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 5.0, right: 16.0),
                  child: Row(
                    children: [
                      // Platform Engagement Box
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 350,
                        height: 342,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Platform Engagement',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _EngagementCard(
                                  icon: Icons.person,
                                  color: Color(0xff87e64c),
                                  value: '47',
                                  label: 'New User Sign Ups',
                                    iconSize: 45,
                                  
                                  
                                ),
                                _EngagementCard(
                                  icon: Icons.check_circle,
                                  color: Colors.blue,
                                  value: '344',
                                  label: 'Sessions Completed',
                                    iconSize: 45,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _EngagementCard(
                                  icon: Icons.school,
                                  color: Colors.yellow,
                                  value: '132',
                                  label: 'Active Tutors',
                                    iconSize: 45,
                                ),
                                _EngagementCard(
                                  icon: Icons.person_outline,
                                  color: Colors.purple,
                                  value: '285',
                                  label: 'Active Students',
                                    iconSize: 45,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Profile Requests Box
                    Container(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey, width: 2.0),
    borderRadius: BorderRadius.circular(10),
  ),
  width: 350,
  height: 342,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
   const   SizedBox(height: 10),
   const   Text(
        'Profile Requests',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
   const    SizedBox(height: 15),
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              '75%',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 1,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profiles',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'Reviewed',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(height: 12, width: 80, decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10))),
                  const   SizedBox(height: 5),
                 const    Text('32%', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(height: 12, width: 80, decoration: BoxDecoration(color:const Color(0xff87e64c), borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 5),
                    const Text('41%', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(height: 12, width: 80,  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10))),
                  const  SizedBox(height: 5),
                  const   Text('24%', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
     const  SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100,
            height: 130,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: const Column(
              children: [
                CircleAvatar(backgroundColor: Colors.orange,child: Icon(Icons.access_time, color: Colors.black, size: 30)),
                Text('12', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Pending', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 130,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child:const  Column(
              children: [
                CircleAvatar(backgroundColor: const Color(0xff87e64c),child: Icon(Icons.check_circle, color: Colors.black, size: 30)),
                Text('16', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Approved', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 130,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: const Column(
              children: [
                CircleAvatar
                
                (backgroundColor: Colors.red,child: Icon(Icons.cancel, color: Colors.white, size: 30)),
                Text('8', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Rejected', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    ],
  ),
),
                      const SizedBox(width: 20),
                                                                                                 // Booking Requests Box
                        Container(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey, width: 2.0),
    borderRadius: BorderRadius.circular(10),
  ),
  width: 350,
  height: 342,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
   const   SizedBox(height: 10),
   const   Text(
        'Booking Requests',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
   const    SizedBox(height: 15),
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              '192%',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 1,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Booking',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'Requests',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(height: 12, width: 80, decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10))),
                  const   SizedBox(height: 5),
                 const    Text('32%', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(height: 12, width: 80, decoration: BoxDecoration(color:const Color(0xff87e64c), borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 5),
                    const Text('41%', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(height: 12, width: 80,  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10))),
                  const  SizedBox(height: 5),
                  const   Text('24%', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
     const  SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100,
            height: 130,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: const Column(
              children: [
                CircleAvatar(backgroundColor: Colors.orange,child: Icon(Icons.access_time, color: Colors.black, size: 30)),
                Text('76', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('In Progress', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 130,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child:const  Column(
              children: [
                CircleAvatar(backgroundColor: const Color(0xff87e64c),child: Icon(Icons.check_circle, color: Colors.black, size: 30)),
                Text('104', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Completed', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 130,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: const Column(
              children: [
                CircleAvatar
                
                (backgroundColor: Colors.red,child: Icon(Icons.cancel, color: Colors.white, size: 30)),
                Text('2', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Rejected', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    ],
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

class _EngagementCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final double iconSize;

  const _EngagementCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
     this.iconSize = 45, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 173,
      height: 140,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 15),
              ),
              SizedBox(height: 10),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}