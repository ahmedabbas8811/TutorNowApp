import 'package:flutter/material.dart';


class  ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            SideMenu(),
           const  Expanded(
              child: ConfirmationTutorsScreen(),
              
            ),
          ],
        ),
      ),
    );
  }
}

class  SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Container(
  width: 200,
  color: Colors.white,
  child: Column(
   
    children: [
      Container(
        child: ListTile(
          leading: Image.asset(
            'assets/ali.png', // Path to your image
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
      ),
       const SizedBox(height: 5),
      Container(
        color: const Color(0xfffafafa),
        child: const ListTile(
          leading: Icon(Icons.home, color: Colors.black),
          title: Text('Home'),
        ),
      ),
      const SizedBox(height: 5),
      Container(
        color: Colors.black,
        child: const ListTile(
          leading: Icon(Icons.home, color: Colors.white),
          title: Text(
            'Approve Tutors',
            style: TextStyle(color: Colors.white),
          ),
        
        ),
      ),
     
    ],
  ),
);
  }
}





class ConfirmationTutorsScreen extends StatelessWidget {
  const ConfirmationTutorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0), 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              const Text(
                'Approve Tutors',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), 

             
LayoutBuilder(
  builder: (context, constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Information Section
        Expanded(
          flex: 1,
          child: _buildSectionContainer(
            title: 'Personal Information',
            child: _buildPersonalInfo(),
          ),
        ),
        const SizedBox(width: 0), // Reduced spacing

        // Qualification Section
        Expanded(
          flex: 1,
          child: _buildSectionContainer(
            title: 'Qualification',
            child: _buildQualification(),
          ),
        ),
        const SizedBox(width: 0), // Reduced spacing

        // Experience Section
        Expanded(
          flex: 1,
          child: _buildSectionContainer(
            title: 'Experience',
            child: _buildExperience(),
          ),
        ),
      ],
    );
  },
),



            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/Ellipse 1.png'),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Name', 'Imran Khan'),
          _buildInfoRow('Email', 'imrankhan@gmail.com'),
          _buildInfoRow('Location', 'Rawalpindi, Punjab, Pakistan'),
          const Text(
            'CNIC:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'Download',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          _buildApprovalButtons(),
        ],
      ),
    );
  }

  Widget _buildQualification() {
    return Column(
      children: [
        _buildQualificationContainer(),
        const SizedBox(height: 8), // Reduced space
        _buildQualificationContainer(),
      ],
    );
  }

  Widget _buildQualificationContainer() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Education Level', 'Bachelors'),
          _buildInfoRow('Institute Name', 'Riphah International University'),
          const SizedBox(height: 8),
          const Text(
            'Proof of Qualification:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'Download',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperience() {
    return Column(
      children: [
        _buildExperienceContainer(),
        const SizedBox(height: 8), // Reduced space
        _buildExperienceContainer(),
        const SizedBox(height: 8), // Reduced space
        _buildExperienceContainer(),
      ],
    );
  }

  Widget _buildExperienceContainer() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Education Level of Students', 'BS'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildInfoRow('Start Date', '09/09/2022')),
              const SizedBox(width: 10),
              Expanded(child: _buildInfoRow('End Date', '09/09/2022')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Proof of Qualification:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'Download',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8), // Minor space between rows
      ],
    );
  }

  Widget _buildApprovalButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff87e64c),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          label: const Text(
            'Approve Tutor',
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            Icons.check,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          label: const Text(
            'Reject Tutor',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    );
  }
}