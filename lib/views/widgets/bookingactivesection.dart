import 'package:flutter/material.dart';
import 'package:newifchaly/aboutprogress.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';
import 'package:newifchaly/views/widgets/booking_card_shimmer.dart';

import '../../sessionscreen.dart';

Widget buildBookingActiveSection(
  BuildContext context, {
  required List<BookingModel> activeBookings,
  required bool isLoading,
}) {
  return buildBookingSection(
    context: context,
    title: 'Upcoming Bookings',
    bookings: activeBookings,
    isLoading: isLoading,
    onTap: (booking) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AboutProgress(booking: booking),
        ),
      );
    },
    statusColor: Colors.green,
  );
}

Widget buildBookingSection({
  required BuildContext context,
  required String title,
  required List<BookingModel> bookings,
  required bool isLoading,
  required Function(BookingModel) onTap,
  required Color statusColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Tap to see details',
          style: TextStyle(fontSize: 14, color: Colors.grey)),
      const SizedBox(height: 8),
      SizedBox(
        height: 170,
        width: double.infinity,
        child: isLoading
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) => BookingCardShimmer(),
              )
            : bookings.isEmpty
                ? Center(child: Text("No $title found."))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      var booking = bookings[index];
                      return GestureDetector(
                        onTap: () => onTap(booking),
                        child: SwipeableSessionCard(
                          name: booking.studentName,
                          imageUrl: booking.studentImage,
                          package: booking.packageName,
                          time: "${booking.minutesPerSession} Min / Session",
                          frequency: "${booking.sessionsPerWeek}X / Week",
                          duration: "${booking.numberOfWeeks} Weeks",
                          price: "${booking.price}/- PKR",
                          statusColor: statusColor,
                        ),
                      );
                    },
                  ),
      ),
    ],
  );
}
