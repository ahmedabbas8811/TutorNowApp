import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/student/controllers/booking_controller.dart';
import 'package:newifchaly/student/controllers/tutor_detail_controller.dart';
import 'package:newifchaly/student/models/booking_model.dart';
import 'package:newifchaly/student/views/progress_stu.dart';
import 'package:newifchaly/student/views/search_results.dart';
import 'package:newifchaly/student/views/student_home_screen.dart';
import 'package:newifchaly/student/views/student_profile.dart';
import 'package:newifchaly/student/views/widgets/nav_bar.dart';
import 'package:newifchaly/views/widgets/booking_card_shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedIndex = 2;
  final BookingController bookingController = Get.put(BookingController());
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    for (var booking in bookingController.pendingBookings) {
      Get.delete<TutorDetailController>(tag: booking.tutorId);
    }
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
            MaterialPageRoute(builder: (context) => StudentHomeScreen()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SearchResults()),
          );
          break;
        case 2:
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentProfileScreen()),
          );
          break;
      }
    }
  }

  void _showReviewDialog(BookingModel booking) {
    int selectedRating = 0;
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Leave a review',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          child: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            size: 32,
                            color: index < selectedRating
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: reviewController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Write your comments here',
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final user = Supabase.instance.client.auth.currentUser;

                        if (user != null &&
                            selectedRating > 0 &&
                            reviewController.text.isNotEmpty) {
                          try {
                            final bookingController =
                                Get.find<BookingController>();
                            await bookingController.submitFeedback(
                              rating: selectedRating,
                              review: reviewController.text,
                              tutorId: booking.tutorId,
                              studentId: booking.userId,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Review submitted!')),
                            );
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select a rating and write a review.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87E64B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Send Feedback',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildShimmerCards(int count) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BookingCardShimmer(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pending Bookings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Your booking request has been sent to the tutor. Please wait for their confirmation!',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (bookingController.isLoading.value) {
                  return _buildShimmerCards(3);
                }
                if (bookingController.pendingBookings.isEmpty) {
                  return const Center(child: Text("No pending bookings."));
                }
                return BookingSwipeView(
                  height: 180,
                  cards: bookingController.pendingBookings.map((booking) {
                    final tutorController = Get.put(
                      TutorDetailController(UserId: booking.tutorId),
                      tag: booking.tutorId,
                    );
                    return BookingCard(
                      name: booking.tutorName,
                      tutorImage: booking.tutorImage,
                      package: booking.packageName,
                      time: "${booking.minutesPerSession} Min / Session",
                      frequency: "${booking.sessionsPerWeek}X / Week",
                      duration: "${booking.numberOfWeeks} Weeks",
                      price: "${booking.price}/- PKR",
                      rating: tutorController.averageRating.value,
                      statusColor: Colors.orange,
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Active Bookings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tap the booking card for more options!',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (bookingController.isLoading.value) {
                  return _buildShimmerCards(3);
                }
                if (bookingController.activeBookings.isEmpty) {
                  return const Center(child: Text("No Active bookings."));
                }
                return BookingSwipeView(
                  height: 180,
                  cards: bookingController.activeBookings.map((booking) {
                    final tutorController = Get.put(
                      TutorDetailController(UserId: booking.tutorId),
                      tag: booking.tutorId,
                    );
                    return BookingCard(
                      name: booking.tutorName,
                      tutorImage: booking.tutorImage,
                      package: booking.packageName,
                      time: "${booking.minutesPerSession} Min / Session",
                      frequency: "${booking.sessionsPerWeek}X / Week",
                      duration: "${booking.numberOfWeeks} Weeks",
                      price: "${booking.price}/- PKR",
                      rating: tutorController.averageRating.value,
                      statusColor: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProgressScreen(booking: booking),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Completed Bookings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tap the booking card for more options!',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (bookingController.isLoading.value) {
                  return _buildShimmerCards(3);
                }
                if (bookingController.completedBookings.isEmpty) {
                  return const Center(child: Text("No Completed bookings."));
                }
                return BookingSwipeView(
                  height: 220,
                  cards: bookingController.completedBookings.map((booking) {
                    final tutorController = Get.put(
                      TutorDetailController(UserId: booking.tutorId),
                      tag: booking.tutorId,
                    );
                    return BookingCard(
                      name: booking.tutorName,
                      package: booking.packageName,
                      tutorImage: booking.tutorImage,
                      time: "${booking.minutesPerSession} Min / Session",
                      frequency: "${booking.sessionsPerWeek}X / Week",
                      duration: "${booking.numberOfWeeks} Weeks",
                      price: "${booking.price}/- PKR",
                      rating: tutorController.averageRating.value,
                      statusColor: Colors.white,
                      backgroundColor: Colors.white,
                      buttonText: "Leave a Review",
                      onButtonTap: () => _showReviewDialog(booking),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProgressScreen(booking: booking),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Declined Bookings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'These bookings were declined by the tutor.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              const BookingSwipeView(
                height: 180,
                cards: [
                  BookingCard(
                    name: 'Shehdad Ali',
                    package: 'Package Name',
                    tutorImage: 'assets/Ellipse1.png',
                    time: '90 Min / Session',
                    frequency: '3X / Week',
                    duration: '8 Weeks',
                    price: '5000/- PKR',
                    rating: 4.8,
                    statusColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class BookingSwipeView extends StatelessWidget {
  final List<Widget> cards;
  final double height;

  const BookingSwipeView({required this.cards, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: cards[index],
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String name;
  final String package;
  final String tutorImage;
  final String time;
  final String frequency;
  final String duration;
  final String price;
  final double rating;
  final Color statusColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const BookingCard({
    required this.name,
    required this.package,
    required this.tutorImage,
    required this.time,
    required this.frequency,
    required this.duration,
    required this.price,
    required this.rating,
    required this.statusColor,
    this.backgroundColor,
    this.onTap,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xfff7f7f7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: tutorImage.isNotEmpty &&
                              Uri.tryParse(tutorImage)?.hasAbsolutePath == true
                          ? NetworkImage(tutorImage)
                          : const AssetImage('assets/Ellipse1.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(package,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                    CircleAvatar(radius: 4, backgroundColor: statusColor),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.timer, size: 18),
                      Text(time)
                    ]),
                    Row(children: [
                      const Icon(Icons.refresh, size: 18),
                      Text(frequency)
                    ]),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.calendar_today, size: 18),
                      Text(duration)
                    ]),
                    Row(children: [
                      const Icon(Icons.attach_money, size: 18),
                      Text(price)
                    ]),
                  ],
                ),
                if (buttonText != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onButtonTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87E64B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(buttonText!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
