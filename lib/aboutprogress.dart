import 'package:flutter/material.dart';
import 'package:newifchaly/controllers/booking_controller.dart';
import 'package:newifchaly/controllers/progress_controller.dart';
import 'package:newifchaly/models/tutor_booking_model.dart';
import 'weekprogress.dart';

class AboutProgress extends StatefulWidget {
  final BookingModel booking;

  const AboutProgress({Key? key, required this.booking}) : super(key: key);

  @override
  _AboutProgressState createState() => _AboutProgressState();
}

class _AboutProgressState extends State<AboutProgress> {
  bool isAboutSelected = true;
  TutorBookingsController controller = TutorBookingsController();

  @override
  void initState() {
    super.initState();
    debugPrint('Booking ID: ${widget.booking.bookingId}');
    debugPrint('Number of Weeks: ${widget.booking.numberOfWeeks}');

    debugPrint('Accepted at: ${widget.booking.accepted_at}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: widget.booking.studentImage.isNotEmpty
                        ? NetworkImage(widget.booking.studentImage)
                        : null,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.booking.studentName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.booking.packageName,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildTabButton('About', isAboutSelected),
                      const SizedBox(width: 10),
                      _buildTabButton('Progress', !isAboutSelected),
                    ],
                  ),
                  const SizedBox(height: 20),
                  isAboutSelected
                      ? _buildAboutSection()
                      : _buildProgressSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isAboutSelected = label == 'About';
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xff87e64c) : Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black), // black border
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        _buildInfoCard([
          _buildInfoRow(
              Icons.timer, '${widget.booking.minutesPerSession} Min / Session'),
          _buildInfoRow(
              Icons.repeat, '${widget.booking.sessionsPerWeek}X / Week'),
          _buildInfoRow(
              Icons.calendar_today, '${widget.booking.numberOfWeeks} Weeks'),
        ]),
        const SizedBox(height: 10),
        _buildTimeSlotsCard(),
      ],
    );
  }

  Widget _buildProgressSection() {
    final totalWeeks = int.tryParse(widget.booking.numberOfWeeks) ?? 1;
    final currentWeek = _calculateCurrentWeek();
    final weeksToShow = currentWeek.clamp(1, totalWeeks);

    return Column(
      children: [
        // Progress header
        currentWeek < totalWeeks
            ? Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Week $currentWeek of $totalWeeks',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              )
            : const SizedBox
                .shrink(), // returns an empty widget when condition is false

        // Weeks grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemCount: weeksToShow,
          itemBuilder: (context, index) {
            final weekNumber = index + 1;
            final isCurrent = weekNumber == currentWeek;
            final isCompleted = weekNumber < currentWeek;

            return ElevatedButton(
              onPressed: () => _navigateToWeekProgress(weekNumber),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent
                    ? const Color(0xff87e64c) // Current week - bright green
                    : isCompleted
                        ? const Color(
                            0xffc8e6b5) // Completed weeks - light green
                        : const Color(0xfff7f7f7), // Future weeks - gray
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isCurrent ? Colors.black : Colors.grey.shade400,
                    width: isCurrent ? 1.5 : 1.0,
                  ),
                ),
              ),
              child: Text(
                'Week $weekNumber',
                style: TextStyle(
                  color: isCurrent ? Colors.black : Colors.black87,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  int _calculateCurrentWeek() {
    final now = DateTime.now();
    final difference = now.difference(widget.booking.accepted_at).inDays;
    return (difference / 7).floor() + 1; // Week starts at 1 immediately
  }

  void _navigateToWeekProgress(int weekNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeekProgress(
          weekNumber: weekNumber,
          bookingId: widget.booking.bookingId,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffeefbe5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffeefbe5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.booking.timeSlots.entries.map((entry) {
          final day = entry.value["day"] ?? "N/A";
          final time = entry.value["time"] ?? "N/A";

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Text(
                  day,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 16.0),
                Text(
                  time,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                controller.cancelBooking(widget.booking.bookingId, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe64b4b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text('Cancel Booking',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
