import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/package_controller.dart';
import 'package:newifchaly/student/controllers/tutor_availability_controller.dart';

class TutorAvailabilityScreen extends StatelessWidget {
  final PackagesController _packagesController = Get.put(
      PackagesController(UserId: "someUserId")); // Replace with actual UserId

  @override
  Widget build(BuildContext context) {
    // Fetch the sessions per week from the package details
    final int sessionsPerWeek = _packagesController.packages.first.sessions;

    // Initialize TutorAvailabilityController with the sessions per week
    final TutorAvailabilityController _controller =
        Get.put(TutorAvailabilityController(totalSessions: sessionsPerWeek));

    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final timeSlots = [
      "12:00 PM",
      "12:30 PM",
      "01:00 PM",
      "01:30 PM",
      "02:00 PM"
    ];

    // Top or bottom of tutor_availability_screen.dart
    String ordinal(int number) {
      switch (number) {
        case 1:
          return "First";
        case 2:
          return "Second";
        case 3:
          return "Third";
        case 4:
          return "Fourth";
        case 5:
          return "Fifth";
        case 6:
          return "Sixth";
        case 7:
          return "Seventh";
        case 8:
          return "Eighth";
        case 9:
          return "Ninth";
        case 10:
          return "Tenth";
        default:
          return "$number";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Time Slots",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              return Wrap(
                spacing: 8, // Horizontal gap between items
                runSpacing: 8, // Vertical gap for wrapped lines
                children: List.generate(
                  _controller.totalSessions,
                  (index) {
                    final isCurrentOrPast =
                        index < _controller.currentSession.value;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${ordinal(index + 1)} Session", // Updated text format
                          style: TextStyle(
                            fontSize: 10, // Font size as per design
                            fontWeight: isCurrentOrPast
                                ? FontWeight.w600
                                : FontWeight.normal,
                            height: 1.36, // Line height adjustment
                            color: isCurrentOrPast
                                ? Colors.black
                                : const Color(0xffa6a6a6),
                          ),
                        ),
                        if (index < _controller.totalSessions - 1) ...[
                          const SizedBox(
                            width: 8, // Space between text and arrow
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 12, // Arrow size as per design
                            color: Color(0xffa6a6a6), // Arrow color
                          ),
                          const SizedBox(
                            width: 8, // Space between arrow and next text
                          ),
                        ],
                      ],
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 24),
            const Text(
              "Select Day",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffa6a6a6),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days.map((day) {
                  return GestureDetector(
                    onTap: () {
                      _controller.selectedDay.value = day;
                    },
                    child: Obx(() {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _controller.selectedDay.value == day
                              ? const Color(0xff87e64c)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _controller.selectedDay.value == day
                                ? Colors.green
                                : Colors.grey[400]!,
                          ),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _controller.selectedDay.value == day
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      );
                    }),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Time Slot",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffa6a6a6),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timeSlots.map((slot) {
                  final parts = slot.split(" ");
                  return GestureDetector(
                    onTap: () {
                      _controller.selectedTime.value = slot;
                    },
                    child: Obx(() {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 14),
                        decoration: BoxDecoration(
                          color: _controller.selectedTime.value == slot
                              ? const Color(0xff87e64c)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _controller.selectedTime.value == slot
                                ? Colors.green
                                : Colors.grey[400]!,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              parts[0],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _controller.selectedTime.value == slot
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                            Text(
                              parts[1],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _controller.selectedTime.value == slot
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Other widgets like Select Day, Select Time Slot, etc.
                  const Spacer(),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20), // Adjust spacing
                    child: Container(
                      width: double.infinity,
                      height: 54, // Match the design height
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black, // Border color from the design
                          width: 1, // Match border width
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black, // Match shadow color
                            offset: Offset(4, 4), // Shadow offset
                            blurRadius: 0, // Match shadow blur radius
                            spreadRadius: 0, // Match shadow spread radius
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final isLastSession = _controller.isLastSession();
                        return ElevatedButton(
                          onPressed: () {
                            if (isLastSession) {
                              _controller.confirmAvailability();
                              Navigator.pop(
                                  context); // Finalize booking and navigate back
                            } else {
                              _controller
                                  .nextSession(); // Move to the next session
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xff87e64b), // Button background color
                            elevation: 0, // No additional elevation
                            padding: const EdgeInsets.symmetric(
                                vertical: 16), // Match padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Match border radius
                            ),
                          ),
                          child: Text(
                            isLastSession ? 'Confirm Booking' : 'Next',
                            style: const TextStyle(
                              fontSize: 16, // Match font size
                              color: Colors.black, // Match text color
                              fontWeight: FontWeight.w500, // Match font weight
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
