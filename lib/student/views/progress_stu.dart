import 'package:flutter/material.dart';
import 'package:newifchaly/student/controllers/progress_controller.dart';
import 'package:newifchaly/student/models/booking_model.dart';
import 'package:newifchaly/student/models/progress_model.dart';
import 'package:newifchaly/student/views/progressreport_stu.dart';

class ProgressScreen extends StatefulWidget {
  final BookingModel booking;

  const ProgressScreen({super.key, required this.booking});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isProgressSelected = true;
  late Future<List<ProgressReportModel>> _progressReportsFuture;
  final ProgressReportController _progressReportController = ProgressReportController();

  @override
  void initState() {
    super.initState();
    // Fetch progress reports when the screen is initialized
    _progressReportsFuture = _progressReportController.fetchProgressReports(widget.booking.bookingId);
  }

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
    return FutureBuilder<List<ProgressReportModel>>(
      future: _progressReportsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No progress reports available.'));
        } else {
          final progressReports = snapshot.data!;
          final overallPerformance = _calculateOverallPerformance(progressReports);

          // Debug: Print extracted performance categories
          for (var report in progressReports) {
            final performance = _extractPerformanceCategory(report.overallPerformance);
            print('Week ${report.week}: $performance');
          }

          return Column(
            children: [
              _buildPerformanceRow('Overall Performance', overallPerformance, Colors.black),
              const SizedBox(height: 16),
              ...progressReports.map((report) => _buildWeekProgress(
                'Week ${report.week}',
                report.overallPerformance,
                _getPerformanceColor(report.overallPerformance),
                _getPerformanceEmoji(report.overallPerformance),
                _getPerformanceTextColor(report.overallPerformance),
                report.comments,

              )).toList(),
            ],
          );
        }
      },
    );
  }

  String _calculateOverallPerformance(List<ProgressReportModel> reports) {
    if (reports.isEmpty) return 'No Data';

    // Map performance categories to numerical values
    final performanceValues = reports.map((report) {
      final performance = _extractPerformanceCategory(report.overallPerformance);
      switch (performance.toLowerCase()) {
        case 'excellent':
          return 4;
        case 'good':
          return 3;
        case 'average':
          return 2;
        case 'struggling':
          return 1;
        default:
          return 0; // Unknown performance
      }
    }).toList();

    // Calculate the average performance value
    final average = performanceValues.reduce((a, b) => a + b) / performanceValues.length;

    // Map the average back to a performance category
    if (average >= 3.5) {
      return 'Excellent';
    } else if (average >= 2.5) {
      return 'Good';
    } else if (average >= 1.5) {
      return 'Average';
    } else {
      return 'Struggling';
    }
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
              Text(_getPerformanceEmoji(status)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekProgress(String week, String performanceWithEmoji, Color color, String emoji, Color textColor, String comments) {
    final performance = _extractPerformanceCategory(performanceWithEmoji);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProgressReportStu(
            week: week,
            performance: performance,
            comments: comments,
          )),
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
              '$week: ${_extractPerformanceCategory(performanceWithEmoji)} $emoji',
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

  String _extractPerformanceCategory(String performanceWithEmoji) {
    // Split the string by spaces and take the last part (e.g., "😃 Excellent" → "Excellent")
    final parts = performanceWithEmoji.split(' ');
    return parts.last;
  }

  Color _getPerformanceColor(String performanceWithEmoji) {
    final performance = _extractPerformanceCategory(performanceWithEmoji);
    switch (performance.toLowerCase()) {
      case 'excellent':
        return const Color(0xff87e64c); // Green
      case 'good':
        return const Color(0xffdbf8c9); // Light Green
      case 'average':
        return const Color(0xfffdfdfd); // White
      case 'struggling':
        return const Color(0xffe64b4b); // Red
      default:
        return Colors.grey; // Default for unknown values
    }
  }

  String _getPerformanceEmoji(String performanceWithEmoji) {
  final performance = _extractPerformanceCategory(performanceWithEmoji);
  switch (performance.toLowerCase()) {
    case 'excellent':
      return '😃'; // Smiling face with open mouth
    case 'good':
      return '🙂'; // Slightly smiling face
    case 'average':
      return '😐'; // Neutral face
    case 'struggling':
      return '😟'; // Worried face
    default:
      return '😐'; // Default to neutral face
  }
}

  Color _getPerformanceTextColor(String performanceWithEmoji) {
    final performance = _extractPerformanceCategory(performanceWithEmoji);
    switch (performance.toLowerCase()) {
      case 'excellent':
      case 'good':
      case 'average':
        return Colors.black;
      case 'struggling':
        return Colors.white;
      default:
        return Colors.black;
    }
  }
}