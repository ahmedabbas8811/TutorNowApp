import 'package:flutter/material.dart';
import 'package:newifchaly/student/models/booking_model.dart';
import 'package:newifchaly/student/views/progressreport_stu.dart';

class ProgressScreen extends StatefulWidget {
  final BookingModel booking;

  const ProgressScreen({super.key, required this.booking});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isProgressSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.booking.tutorImage.isNotEmpty &&
                      Uri.tryParse(widget.booking.tutorImage)?.hasAbsolutePath == true
                  ? NetworkImage(widget.booking.tutorImage)
                  : const AssetImage('assets/Ellipse1.png') as ImageProvider,
            ),
            const SizedBox(height: 8),
            Text(
              widget.booking.tutorName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.booking.packageName,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('About', !isProgressSelected, () {
                  setState(() {
                    isProgressSelected = false;
                  });
                }),
                const SizedBox(width: 8),
                _buildTabButton('Progress', isProgressSelected, () {
                  setState(() {
                    isProgressSelected = true;
                  });
                }),
              ],
            ),
            const SizedBox(height: 16),
            if (!isProgressSelected) _buildAboutContent(),
            if (isProgressSelected) _buildProgressContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff87e64c) : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.black) : Border.all(color: Colors.transparent),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Column(
      children: [
        _buildInfoCard([
          _buildInfoRow(Icons.timer, '${widget.booking.minutesPerSession} Min / Session'),
          _buildInfoRow(Icons.repeat, '${widget.booking.sessionsPerWeek}X / Week'),
          _buildInfoRow(Icons.calendar_today, '${widget.booking.numberOfWeeks} Weeks'),
        ]),
        const SizedBox(height: 20),
        _buildTimeSlotsCard(),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffeefbe5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTimeSlotsCard() {
    return Container(
      width: 330,
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

  Widget _buildProgressContent() {
    return Column(
      children: [
        _buildPerformanceRow('Overall Performance', 'Average', Colors.black),
        const SizedBox(height: 16),
        _buildWeekProgress('Week 1', 'Struggling', const Color(0xffe64b4b), '😟', Colors.white),
        _buildWeekProgress('Week 2', 'Excellent', const Color(0xff87e64c), '😃', Colors.black),
        _buildWeekProgress('Week 3', 'Good', const Color(0xffdbf8c9), '🙂', Colors.black),
        _buildWeekProgress('Week 4', 'Struggling', const Color(0xffe64b4b), '😟', Colors.white),
        _buildWeekProgress('Week 5', 'Average', const Color(0xfffdfdfd), '😐', Colors.black),
      ],
    );
  }

  Widget _buildPerformanceRow(String title, String status, Color textColor) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                status,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(width: 4),
              const Text('😐'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekProgress(String week, String status, Color color, String emoji, Color textColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProgressReportStu()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Text(
              '$week: $status $emoji',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
            ),
            const Spacer(),
            Text(
              'See More →',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
                decoration: TextDecoration.underline,
                decorationColor: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}