import 'package:flutter/material.dart';
import 'package:newifchaly/messagescreen.dart';
import 'package:newifchaly/student/views/bookings.dart';
import 'package:newifchaly/student/views/search_results.dart';
import 'package:newifchaly/student/views/student_profile.dart';
import 'package:newifchaly/student/views/tutor_detail.dart';
import 'package:newifchaly/student/views/widgets/nav_bar.dart';
import '../controllers/student_home_controller.dart';
import '../models/student_home_model.dart';
import 'package:get/get.dart';

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
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHomeScreen(),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResults(),
            ),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookingsScreen(), // Replace with your bookings screen
            ),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfileScreen(),
            ),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _educationLevels.asMap().entries.map((entry) {
                        int index = entry.key;
                        String level = entry.value;
                        return buildSection(
                            level, index == 0); // Only show icon for the first
                      }).toList(),
                    ),
                  ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: 0, onItemTapped: _onItemTapped));
  }

  Widget buildSection(String educationLevel, bool showChatIcon) {
    final tutors = _tutorsByEducationLevel[educationLevel] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tutors For $educationLevel',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (showChatIcon)
              IconButton(
                icon: const Icon(Icons.message_outlined, color: Colors.black),
                onPressed: () => Get.to(() => TutorChatListScreen()),
              ),
          ],
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorDetailScreen(userId: tutor.userId),
          ),
        );
      },
      child: Container(
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
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tutor.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                tutor.subjects,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FutureBuilder<UserRating>(
                future: StudentHomeController().fetchUserRatings(tutor.userId),
                builder: (context, snapshot) {
                  // Default to 0 rating while loading
                  final rating =
                      snapshot.hasData ? snapshot.data!.averageRating : 0.0;
                  final filledStars = rating.floor();
                  final hasHalfStar = (rating - filledStars) >= 0.5;

                  return Row(
                    children: List.generate(5, (index) {
                      if (index < filledStars) {
                        // Filled star
                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.star,
                            size: 16.78,
                            color: const Color(0xFFFFA31E),
                          ),
                        );
                      } else if (index == filledStars && hasHalfStar) {
                        // Half star
                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.star_half,
                            size: 16.78,
                            color: const Color(0xFFFFA31E),
                          ),
                        );
                      } else {
                        // Empty star
                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.star_border,
                            size: 16.78,
                            color: const Color(0xFFFFA31E),
                          ),
                        );
                      }
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
