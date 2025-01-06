import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  TextEditingController _searchController = TextEditingController();
  List<String> tutors = [
    'Shehdad Ali - Matric, O Levels, Fsc',
    'Ali Raza - O Levels, Fsc',
    'Sarah Khan - Matric, Fsc',
    'Sana Yousaf - O Levels',
  ];
  List<String> filteredTutors = [];

  @override
  void initState() {
    super.initState();
    filteredTutors = tutors; // Initially show all tutors
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      filteredTutors = tutors
          .where((tutor) =>
              tutor.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
                        hintText: 'Matric',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
             const    SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
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
            child: filteredTutors.isEmpty
                ?const  Center(child: Text('No tutors found'))
                : GridView.builder(
                    padding:const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: filteredTutors.length,
                    itemBuilder: (context, index) {
                      return TutorCard(tutorInfo: filteredTutors[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: 1,
        selectedItemColor: const Color(0xff87e64c),
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class TutorCard extends StatelessWidget {
  final String tutorInfo;

  TutorCard({required this.tutorInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
        const  Center(
            child: CircleAvatar(
              radius: 60, // Reduced radius to prevent overflow
              backgroundImage: AssetImage('assets/Ellipse 1.png'), // Placeholder image
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tutorInfo.split(' - ')[0],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  tutorInfo.split(' - ')[1],
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
               const  SizedBox(height: 4),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: starIndex < 4 ? Colors.orange : Colors.grey,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
