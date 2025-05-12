import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TutorBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final int pendingBookingsCount; // New parameter to check pending bookings

  const TutorBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.pendingBookingsCount, // Initialize in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      onTap: onItemTapped,
      items: [
        _buildNavBarItem('assets/home_icon.svg', 'Home', 0),
        _buildNavBarItem('assets/availability.svg', 'Availability', 1),
        _buildNavBarItem('assets/bookings.svg', 'Bookings', 2),
        _buildNavBarItem('assets/earning.svg', 'Packages', 3),
        _buildNavBarItem('assets/profile_icon.svg', 'Profile', 4),
      ],
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      String icon, String label, int index) {
    String updatedLabel = label;

    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          //icon and background
          Container(
            decoration: BoxDecoration(
              color: selectedIndex == index ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              icon,
              color: selectedIndex == index
                  ? const Color(0xFF87E64B)
                  : Colors.black,
              width: 22,
              height: 22,
            ),
          ),
          //badge showing the count of pending bookings
          if (label == 'Bookings' && pendingBookingsCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                constraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    pendingBookingsCount.toString(),
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      label: updatedLabel,
    );
  }
}
