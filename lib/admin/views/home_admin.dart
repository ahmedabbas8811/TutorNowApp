import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:newifchaly/admin/views/approve_tutors.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String selectedTimeFrame = 'In 24 Hours'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: LayoutBuilder(
        builder: (context, constraints) {
          
          return Row(
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
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 15),
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
                      child: const ListTile(                                 //Home
                        leading: Icon(Icons.home, color: Colors.black),
                        title: Text(
                          'Home',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                        leading: const Icon(Icons.home, color: Colors.black),
                        title: const Text(                                            // Approve Tutor
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
                                                                                    // Main content - flexible
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 5.0),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      
                     
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 5.0, right: 16.0),
                          child: Row(
                            children: [
                              _buildPlatformEngagementCard(),
                              const SizedBox(width: 20),
                              _buildProfileRequestsCard(),
                              const SizedBox(width: 20),
                              _buildBookingRequestsCard(),
                            ],
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildQualificationChart(),
                                  const SizedBox(width: 20),
                                  _buildExperienceChart(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                                                                                        // Upcoming sessions
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Upcoming Sessions',
                                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _SessionCard(
                                          timeFrame: 'In 24 Hours', 
                                          count: '3',
                                          isSelected: selectedTimeFrame == 'In 24 Hours',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 24 Hours'),
                                        ),
                                        _SessionCard(
                                          timeFrame: 'In 7 Days', 
                                          count: '16',
                                          isSelected: selectedTimeFrame == 'In 7 Days',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 7 Days'),
                                        ),
                                        _SessionCard(
                                          timeFrame: 'In 15 Days', 
                                          count: '25',
                                          isSelected: selectedTimeFrame == 'In 15 Days',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 15 Days'),
                                        ),
                                        _SessionCard(
                                          timeFrame: 'In 30 Days', 
                                          count: '45',
                                          isSelected: selectedTimeFrame == 'In 30 Days',
                                          onTap: () => setState(() => selectedTimeFrame = 'In 30 Days'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff87e64c),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text('Tutor Name', 
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text('Student Name', 
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          child: Text('Date', 
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          child: Text('Time', 
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _SessionRow(
                                    tutorName: 'Muhammad Ali', 
                                    studentName: 'Bilal Jan', 
                                    date: '24-05-2025', 
                                    time: '1:00 PM'
                                  ),
                                  _SessionRow(
                                    tutorName: 'Kashif Sarwar', 
                                    studentName: 'Hanzala Khan', 
                                    date: '24-5-2025', 
                                    time: '3:00 PM'
                                  ),
                                  _SessionRow(
                                    tutorName: 'Sami Ullah', 
                                    studentName: 'Akif Imtiaz', 
                                    date: '25-5-2025', 
                                    time: '9:00 PM'
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
              ),
            ],
          );
        },
      ),
    );
  }
                                                          // 'Platform Engagement',            
  Widget _buildPlatformEngagementCard() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            'Platform Engagement',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
              ),
              _EngagementCard(
                icon: Icons.check_circle,
                color: Colors.blue,
                value: '344',
                label: 'Session done',
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
              ),
              _EngagementCard(
                icon: Icons.person_outline,
                color: Colors.purple,
                value: '285',
                label: 'Active Students',
              ),
            ],
          ),
        ],
      ),
    );
  }
//                                                                         'Profile Requests',
  Widget _buildProfileRequestsCard() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Profile Requests',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
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
              SizedBox(width: 1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profiles', style: TextStyle(fontSize: 10)),
                  Text('Reviewed', style: TextStyle(fontSize: 10))
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
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('32%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xff87e64c),
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('41%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('24%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatusCard(
                color: Colors.orange,
                icon: Icons.access_time,
                value: '12',
                label: 'Pending',
              ),
              _StatusCard(
                color: Color(0xff87e64c),
                icon: Icons.check_circle,
                value: '16',
                label: 'Approved',
              ),
              _StatusCard(
                color: Colors.red,
                icon: Icons.cancel,
                value: '8',
                label: 'Rejected',
              ),
            ],
          ),
        ],
      ),
    );
  }
                                                                          // 'Booking Requests',

  Widget _buildBookingRequestsCard() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Booking Requests',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  '192',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Booking', style: TextStyle(fontSize: 10)),
                  Text('Requests', style: TextStyle(fontSize: 10))
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
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('32%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xff87e64c),
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('41%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 5),
                        const Text('24%', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatusCard(
                color: Colors.orange,
                icon: Icons.access_time,
                value: '76',
                label: 'In Progress',
              ),
              _StatusCard(
                color: Color(0xff87e64c),
                icon: Icons.check_circle,
                value: '104',
                label: 'Completed',
              ),
              _StatusCard(
                color: Colors.red,
                icon: Icons.cancel,
                value: '2',
                label: 'Rejected',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationChart() {                                       //'Tutors Qualification',
    return Container( 
      width: 300,
      height: 310,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tutors Qualification',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(),
                          style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontSize: 10);
                        String text;
                        switch (value.toInt()) {
                          case 0: text = 'Under Matric'; break;
                          case 1: text = 'Matric'; break;
                          case 2: text = 'FSc'; break;
                          case 3: text = 'PhD'; break;
                          default: text = '';
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [BarChartRodData(toY: 15, color: Colors.black)],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: 75, color: const Color(0xff87e64c))],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [BarChartRodData(toY: 50, color: Colors.black)],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [BarChartRodData(toY: 70, color: const Color(0xff87e64c))],
                  ),
                ],
                gridData: FlGridData(show: true),
                alignment: BarChartAlignment.spaceAround,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceChart() {
    return Container(                                                //'Tutors Experience', 
      width: 620,
      height: 310,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tutors Experience',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(),
                          style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontSize: 10);
                        String text;
                        switch (value.toInt()) {
                          case 0: text = '0 Y'; break;
                          case 1: text = '1-2 Y'; break;
                          case 2: text = '3-4 Y'; break;
                          case 3: text = '5-6 Y'; break;
                          case 4: text = '7-8 Y'; break;
                          case 5: text = '9-10 Y'; break;
                          case 6: text = '<15 Y'; break;
                          case 7: text = '<20 Y'; break;
                          case 8: text = '>25 Y'; break;
                          default: text = '';
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.black)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 75, color: const Color(0xff87e64c))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 50, color: Colors.black)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 70, color: const Color(0xff87e64c))]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 45, color: Colors.black)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 30, color: const Color(0xff87e64c))]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 40, color: Colors.black)]),
                  BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 25, color: const Color(0xff87e64c))]),
                  BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 5, color: Colors.black)]),
                ],
                gridData: FlGridData(show: true),
              ),
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

  const _EngagementCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 120,
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 15),
              ),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(label, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final String label;

  const _StatusCard({
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 15,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String timeFrame;
  final String count;
  final bool isSelected;
  final VoidCallback onTap;

  const _SessionCard({
    required this.timeFrame,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xff87e64c) : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              timeFrame,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final String tutorName;
  final String studentName;
  final String date;
  final String time;

  const _SessionRow({
    required this.tutorName,
    required this.studentName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(tutorName),
          ),
          Expanded(
            flex: 2,
            child: Text(studentName),
          ),
          Expanded(
            child: Text(date),
          ),
          Expanded(
            child: Text(time),
          ),
        ],
      ),
    );
  }
}