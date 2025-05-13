import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/package_controller.dart';
import 'package:newifchaly/student/controllers/tutor_availability_controller.dart';
import 'package:newifchaly/student/views/bookings.dart';

class TutorAvailabilityScreen extends StatelessWidget {
  final int packageId;
  final int sessions;

  TutorAvailabilityScreen(
      {Key? key, required this.packageId, required this.sessions})
      : super(key: key) {
    print("Sessions Per Week (Passed): $sessions");
  }

  final PackagesController _packagesController =
      Get.put(PackagesController(UserId: "someUserId"));

  @override
  Widget build(BuildContext context) {
    print("Package ID passed to this screen: $packageId");

    // fetch sessions per week from the package details
    final int sessionsPerWeek = sessions;

    // initialize TutorAvailabilityController with the sessions per week
    final TutorAvailabilityController _controller =
        Get.put(TutorAvailabilityController(
      totalSessions: sessionsPerWeek,
      packageId: packageId,
    ));

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
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  _controller.totalSessions,
                  (index) {
                    final isCurrentOrPast =
                        index < _controller.currentSession.value;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${ordinal(index + 1)} Session",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isCurrentOrPast
                                ? FontWeight.w600
                                : FontWeight.normal,
                            height: 1.36,
                            color: isCurrentOrPast
                                ? Colors.black
                                : const Color(0xffa6a6a6),
                          ),
                        ),
                        if (index < _controller.totalSessions - 1) ...[
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: Color(0xffa6a6a6),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 24),

            Obx(() {
              if (_controller.selectedSlots.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selected Slots:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _controller.selectedSlots.values.map((slot) {
                        return Chip(
                          label: Text("${slot["day"]} ${slot["time"]}"),
                          backgroundColor: const Color(0xff87e64c),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }
              return const SizedBox();
            }),
            const SizedBox(height: 24),

            // select day section
            const Text(
              "Select Day",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (_controller.availabilityList.isEmpty) {
                return const Center(
                  child: Text("No available days."),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _controller.availabilityList.map((availability) {
                    final isDaySelected =
                        _controller.isDayAlreadySelected(availability.day);

                    return GestureDetector(
                      onTap: isDaySelected
                          ? () {
                              Get.defaultDialog(
                                title: "Day Already Selected",
                                middleText:
                                    "You can only book one slot per ${availability.day}.",
                              );
                            }
                          : () async {
                              _controller.selectedDay.value = availability.day;
                              await _controller
                                  .processSlots(availability.slots);
                              _controller.filterAvailableSlots();
                            },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDaySelected
                              ? Colors.grey[400] // Gray out if already selected
                              : _controller.selectedDay.value ==
                                      availability.day
                                  ? const Color(0xff87e64c)
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          availability.day,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDaySelected
                                ? Colors.grey[700]
                                : _controller.selectedDay.value ==
                                        availability.day
                                    ? Colors.black
                                    : Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),

            const SizedBox(height: 24),

            // available slots section
            const Text(
              "Available Slots",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (_controller
                  .isDayAlreadySelected(_controller.selectedDay.value)) {
                return const Center(
                  child: Text(
                    "You've already selected a slot for this day.",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                );
              } else if (_controller.availableSlots.isEmpty) {
                return const Center(
                    child: Text("No slots available for the selected day."));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _controller.availableSlots.map((slot) {
                    return GestureDetector(
                      onTap: () {
                        _controller.selectedTime.value = slot;
                        // Validate slot selection
                        if (_controller.areConsecutiveSlotsAvailable(slot)) {
                          print("Slot $slot is valid for booking.");
                        } else {
                          print("Slot $slot is NOT valid for booking.");
                          // Get.snackbar(
                          //   "Slot Unavailable",
                          //   "The tutor is not available for the required duration.",
                          //   snackPosition: SnackPosition.BOTTOM,
                          // );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _controller.selectedTime.value == slot
                              ? const Color(0xff87e64c)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _controller.selectedTime.value == slot
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),

            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text(
                "If you can't find slots for a desired day, please contact the tutor",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            // confirm booking button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: double.infinity,
                height: 54,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Obx(() {
                  final isLastSession = _controller.isLastSession();
                  return ElevatedButton(
                    onPressed: () {
                      if (isLastSession) {
                        _controller.confirmAvailability();
                        Get.off(() => BookingsScreen());
                      } else {
                        _controller.nextSession();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff87e64b),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isLastSession ? 'Confirm Booking' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
