import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        _buildNavBarItem('assets/home_icon.svg', 'Home', 0),
        _buildNavBarItem('assets/search_icon.svg', 'Search', 1),
        _buildNavBarItem('assets/bookings.svg', 'Bookings', 2),
        _buildNavBarItem('assets/profile_icon.svg', 'Profile', 3),
      ],
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      dynamic icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: selectedIndex == index ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(8),
        child: icon is String
            ? SvgPicture.asset(
                icon as String,
                color: selectedIndex == index
                    ? const Color(0xFF87E64B)
                    : Colors.black,
                width: 24,
                height: 24,
              )
            : Icon(
                icon,
                color: selectedIndex == index
                    ? const Color(0xFF87E64B)
                    : Colors.black,
              ),
      ),
      label: label,
    );
  }
}
