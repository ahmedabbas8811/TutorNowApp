import 'package:flutter/material.dart';
import '../controllers/student_home_controller.dart';
import '../models/student_home_model.dart';
import 'search_screen.dart'; // Import the SearchScreen

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late StudentHomeController _controller;
  List<String> _educationLevels = [];
  Map<String, List<Tutor>> _tutorsByEducationLevel = {};
  bool _isLoading = true;
  int _selectedIndex = 0; // Track the selected tab

  @override
  void initState() {
    super.initState();
    _controller = StudentHomeController();
    _loadUniqueEducationLevels();
  }

  Future<void> _loadUniqueEducationLevels() async {
    try {
      final levels = await _controller.fetchUniqueEducationLevels();
      setState(() {
        _educationLevels = levels;
      });

      // Fetch tutors for each education level
      for (String level in levels) {
        final tutors = await _controller.fetchTutorsForEducationLevel(level);
        setState(() {
          _tutorsByEducationLevel[level] = tutors;
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading education levels: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to handle bottom navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to SearchScreen when the Search tab is tapped
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _educationLevels.map((level) {
                      return buildSection(level);
                    }).toList(),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: const Color(0xff87e64c),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped, // Call _onItemTapped on tap
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget buildSection(String educationLevel) {
    final tutors = _tutorsByEducationLevel[educationLevel] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tutors For $educationLevel',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        buildHorizontalTutorList(tutors),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildHorizontalTutorList(List<Tutor> tutors) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tutors.map((tutor) => buildTutorCard(tutor)).toList(),
      ),
    );
  }

  Widget buildTutorCard(Tutor tutor) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tutor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              tutor.imageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          // Tutor Name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tutor.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Subjects Taught by the Tutor
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              tutor.subjects, // Display subjects instead of education levels
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 4),
          // Star Ratings Row
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.orange),
                Icon(Icons.star, size: 16, color: Colors.orange),
                Icon(Icons.star, size: 16, color: Colors.orange),
                Icon(Icons.star, size: 16, color: Colors.orange),
                Icon(Icons.star, size: 16, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
