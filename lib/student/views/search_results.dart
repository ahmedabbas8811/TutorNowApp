import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/student/controllers/package_controller.dart';
import 'package:newifchaly/student/controllers/search_controller.dart';
import 'package:newifchaly/student/controllers/tutor_detail_controller.dart';
import 'package:newifchaly/student/models/search_model.dart';
import 'package:newifchaly/student/views/bookings.dart';
import 'package:newifchaly/student/views/student_home_screen.dart';
import 'package:newifchaly/student/views/student_profile.dart';
import 'package:newifchaly/student/views/tutor_detail.dart';
import 'package:newifchaly/student/views/widgets/nav_bar.dart';

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final TextEditingController _searchController = TextEditingController();
  final TutorController _controller = TutorController();
  List<Tutor> tutors = []; // Holds all tutors fetched from the backend
  List<Tutor> displayedTutors = []; // Tutors to be displayed (filtered or all)

  @override
  void initState() {
    super.initState();
    _fetchAllTutors(); // Fetch all tutors when the screen loads
  }

  // Fetch all tutors to display initially
  void _fetchAllTutors() async {
    try {
      final results = await _controller.getAllTutors(); // Fetch all tutors
      setState(() {
        tutors = results;
        displayedTutors = tutors; // Initially display all tutors
      });
    } catch (e) {
      print('Error fetching all tutors: $e');
    }
  }

  // Search tutors based on the keyword
  void _searchTutors() async {
    final keyword = _searchController.text;
    if (keyword.isEmpty) {
      setState(() =>
          displayedTutors = tutors); // Reset to all tutors if search is empty
      return;
    }

    final results = await _controller.searchTutors(keyword);
    setState(() => displayedTutors = results); // Update to filtered results
  }

  void _navigateToTutorDetail(String tutorId, String tutorname) {
    Get.delete<TutorDetailController>();
    Get.delete<PackagesController>();
    final PackagesController _packagesController =
        Get.put(PackagesController(UserId: tutorId));
    final TutorDetailController _tutcontroller =
        Get.put(TutorDetailController(UserId: tutorId));
    _tutcontroller.resetProfile();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorDetailScreen(
          userId: tutorId,
        ),
      ),
    );
  }

  int _selectedIndex = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              builder: (context) => BookingsScreen(),
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
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Colors.grey,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search by education or subject',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 12.0),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _searchTutors,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(Icons.arrow_forward, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: displayedTutors.isEmpty
                  ? const Center(child: Text('No tutors found'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: displayedTutors.length,
                      itemBuilder: (context, index) {
                        final tutor = displayedTutors[index];
                        return ListTile(
                          onTap: () =>
                              _navigateToTutorDetail(tutor.userId, tutor.name),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(tutor.imgurl),
                            radius: 25,
                          ),
                          title: Text(tutor.name),
                          subtitle: Text(
                              "${tutor.educationLevel} - ${tutor.subject}"),
                        );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: 1, onItemTapped: _onItemTapped));
  }
}
