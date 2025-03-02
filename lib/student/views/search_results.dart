import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/profile_screen.dart';
import 'package:newifchaly/student/controllers/package_controller.dart';
import 'package:newifchaly/student/controllers/search_controller.dart';
import 'package:newifchaly/student/controllers/tutor_detail_controller.dart';
import 'package:newifchaly/student/models/search_model.dart';
import 'package:newifchaly/student/views/bookings.dart';
import 'package:newifchaly/student/views/filtered_tutor.dart';
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
//  List<Tutor> tutors = []; // Holds all tutors fetched from the backend
  List<Tutor> displayedTutors = []; // Tutors to be displayed (filtered or all)
  String? selectedLevel;

  @override
  void initState() {
    super.initState();
  }

  // // Fetch all tutors to display initially
  // void _fetchAllTutors() async {
  //   try {
  //     final results = await _controller.getAllTutors(); // Fetch all tutors
  //     setState(() {
  //       tutors = results;
  //       displayedTutors = tutors; // Initially display all tutors
  //     });
  //   } catch (e) {
  //     print('Error fetching all tutors: $e');
  //   }
  // }

  // Search tutors based on the keyword
  void _searchTutors() async {
    final keyword = _searchController.text;
    if (keyword.isEmpty) {
      setState(() =>
          // displayedTutors = tutors
          print("searhc tutors")); // Reset to all tutors if search is empty
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
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: buildFilterTabsForLevel(),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: buildFilterTabsForQualification(),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: buildFilterTabsForPrice(context),
                        ),
                      ],
                    )
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

  Widget buildFilterTabsForLevel() {
    final levels = ['Intermediate', 'Matric', 'Bachelors', 'Masters', 'PhD'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(
            'I want a tutor for',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            children: levels.map((level) {
              final isSelected = selectedLevel == level;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLevel = level;
                  });
                  print('Selected Filter: $level');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredTutor(
                          level: level,
                          filter_name: "level_pref",
                          minPrice: 0,
                          maxPrice: 0,
                        ),
                      ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildFilterTabsForQualification() {
    final levels = ['Intermediate', 'Matric', 'Bachelors', 'Masters', 'PhD'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(
            'I want tutor with qualification',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            children: levels.map((level) {
              final isSelected = selectedLevel == level;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLevel = level;
                  });
                  print('Selected Filter: $level');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredTutor(
                          level: level,
                          filter_name: "qualification",
                          minPrice: 0,
                          maxPrice: 0,
                        ),
                      ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

Widget buildFilterTabsForPrice(BuildContext context) {
  final priceRanges = [
    {'label': 'Under 5K', 'min': 0, 'max': 5000},
    {'label': '5K - 10K', 'min': 5000, 'max': 10000},
    {'label': '10K - 20K', 'min': 10000, 'max': 20000},
    {'label': '20K - 50K', 'min': 20000, 'max': 50000},
    {'label': 'Above 50K', 'min': 50000, 'max': 1000000},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          'Select Price Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 12,
          children: priceRanges.map((range) {
            return GestureDetector(
              onTap: () {
                int minPrice = range['min']! as int;
                int maxPrice = range['max']! as int;

                print('Selected Price Range: ${range['label']}');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilteredTutor(
                      level: "",
                      filter_name: "price_range",
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                    ),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  range['label']! as String,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}
