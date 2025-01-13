import 'package:flutter/material.dart';
import 'package:newifchaly/models/person_model.dart';

// class AboutTutor extends StatelessWidget {
//   final String bio;
//   final List<Map<String, String>> qualifications;
//   final List<Map<String, String>> experiences;

//   const AboutTutor({
//     Key? key,
//     required this.bio,
//     required this.qualifications,
//     required this.experiences,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             bio,
//             style: const TextStyle(fontSize: 16),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Qualification',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: _buildQualifications(),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Experience',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: _buildExperience(),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildQualifications() {
//     return qualifications.map((qualification) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               qualification['educationLevel']!,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//                 height: 1.36,
//                 color: Colors.black,
//               ),
//             ),
//             Text(
//               qualification['instituteName']!,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 12,
//                 height: 1.37,
//                 color: Color(0x99000000),
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }

//   List<Widget> _buildExperience() {
//     return experiences.map((experience) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               experience['title']!,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//                 height: 1.36,
//                 color: Colors.black,
//               ),
//             ),
//             Text(
//               experience['duration']!,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 12,
//                 height: 1.37,
//                 color: Color(0x99000000),
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }
// }
class AboutTutor extends StatelessWidget {
  final String bio;
  final String subjects;
  final List<Qualification> qualifications;
  final List<Experience> experiences;

  const AboutTutor({
    Key? key,
    required this.bio,
    required this.subjects,
    required this.qualifications,
    required this.experiences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bio,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Subjects I master in $subjects",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Qualification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildQualifications(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Experience',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildExperience(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQualifications() {
    return qualifications.map((qualification) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qualification.educationLevel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.36,
                color: Colors.black,
              ),
            ),
            Text(
              qualification.instituteName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.37,
                color: Color(0x99000000),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildExperience() {
    return experiences.map((experience) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.studentEducationLevel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.36,
                color: Colors.black,
              ),
            ),
            Text(
              experience.startDate + experience.endDate,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.37,
                color: Color(0x99000000),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
