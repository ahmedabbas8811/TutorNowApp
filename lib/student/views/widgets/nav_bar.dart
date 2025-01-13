import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black, // Black color for selected state
      unselectedItemColor: Colors.black, // Black color for unselected state
      onTap: onItemTapped,
      items: [
        _buildNavBarItem(Icons.home, 'Home', 0),
        _buildNavBarItem(Icons.search, 'Search', 1),
        _buildNavBarItem(Icons.calendar_today, 'Bookings', 2),
        _buildNavBarItem(Icons.person, 'Profile', 3),
      ],
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: selectedIndex == index ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color:
              selectedIndex == index ? const Color(0xFF87E64B) : Colors.black,
        ),
      ),
      label: label,
    );
  }
}
