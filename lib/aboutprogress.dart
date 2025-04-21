// import 'package:flutter/material.dart';
// import 'package:newifchaly/models/tutor_booking_model.dart';
// import 'weekprogress.dart';

// class AboutProgress extends StatefulWidget {
//   final BookingModel booking;

//   const AboutProgress({Key? key, required this.booking}) : super(key: key);

//   @override
//   _AboutProgressState createState() => _AboutProgressState();
// }

// class _AboutProgressState extends State<AboutProgress> {
//   bool isAboutSelected = true;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint('Booking ID: ${widget.booking.bookingId}');
//     debugPrint('Number of Weeks: ${widget.booking.numberOfWeeks}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: widget.booking.studentImage.isNotEmpty
//                   ? NetworkImage(widget.booking.studentImage)
//                   : null,
//               backgroundColor: Colors.grey.shade300,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               widget.booking.studentName,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               widget.booking.packageName,
//               style: const TextStyle(fontSize: 16, color: Colors.black),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildTabButton('About', isAboutSelected),
//                 const SizedBox(width: 10),
//                 _buildTabButton('Progress', !isAboutSelected),
//               ],
//             ),
//             const SizedBox(height: 20),
//             isAboutSelected ? _buildAboutSection() : _buildProgressSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabButton(String label, bool isSelected) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: () {
//           setState(() {
//             isAboutSelected = label == 'About';
//           });
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//               isSelected ? const Color(0xff87e64c) : Colors.grey.shade200,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//             side: BorderSide(color: isSelected ? Colors.black : Colors.grey),
//           ),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.black : Colors.grey,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAboutSection() {
//     return Column(
//       children: [
//         _buildInfoCard([
//           _buildInfoRow(
//               Icons.timer, '${widget.booking.minutesPerSession} Min / Session'),
//           _buildInfoRow(
//               Icons.repeat, '${widget.booking.sessionsPerWeek}X / Week'),
//           _buildInfoRow(
//               Icons.calendar_today, '${widget.booking.numberOfWeeks} Weeks'),
//         ]),
//         const SizedBox(height: 10),
//         _buildTimeSlotsCard(),
//       ],
//     );
//   }

//   Widget _buildProgressSection() {
//     return Expanded(
//       child: GridView.builder(
//         shrinkWrap: true,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 2,
//         ),
//         itemCount: int.tryParse(widget.booking.numberOfWeeks) ?? 1,
//         itemBuilder: (context, index) {
//           int weekNumber = index + 1;
//           return ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => WeekProgress(weekNumber: weekNumber, bookingId: widget.booking.bookingId),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xfff7f7f7),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//               side: const BorderSide(color: Colors.black),
//             ),
//             child: Text('Week ${index + 1}',
//                 style: const TextStyle(color: Colors.black)),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoCard(List<Widget> children) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xffeefbe5),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(children: children),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 20),
//         const SizedBox(width: 8),
//         Text(text,
//             style: const TextStyle(
//                 color: Colors.black, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildTimeSlotsCard() {
//     return Container(
//       width: 330,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xffeefbe5),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widget.booking.timeSlots.entries.map((entry) {
//           final day = entry.value["day"] ?? "N/A"; 
//           final time = entry.value["time"] ?? "N/A"; 

//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0), 
//             child: Row(
//               children: [
//                 Text(
//                   day,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(width: 16.0), 
//                 Text(
//                   time,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    debugPrint('Booking ID: ${widget.booking.bookingId}');
    debugPrint('Number of Weeks: ${widget.booking.numberOfWeeks}');
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemCount: int.tryParse(widget.booking.numberOfWeeks) ?? 1,
      itemBuilder: (context, index) {
        int weekNumber = index + 1;
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeekProgress(
                    weekNumber: weekNumber,
                    bookingId: widget.booking.bookingId),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfff7f7f7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          child: Text('Week $weekNumber',
              style: const TextStyle(color: Colors.black)),
        );
      },
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
          child: ElevatedButton(
            onPressed: () {
              // Complete Booking Action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff87e64c),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            child: const Text('Complete Booking',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Cancel Booking Action
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
      ],
    );
  }
}
