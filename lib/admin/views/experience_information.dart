import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExperienceInformation extends StatefulWidget {
  final String tutorId; // Pass tutorId from parent widget

  const ExperienceInformation(
      {super.key, required this.tutorId}); // Update constructor

  @override
  _ExperienceInformationState createState() => _ExperienceInformationState();
}

class _ExperienceInformationState extends State<ExperienceInformation> {
  List<Map<String, dynamic>> experienceList =
      []; // List to hold experience data
  bool isLoading = true; // Loading state flag

  @override
  void initState() {
    super.initState();
    fetchExperienceDetails(); // Fetch experience data when the widget is initialized
  }

  // Function to fetch experience details from the Supabase experience table
  Future<void> fetchExperienceDetails() async {
    try {
      // Fetch experience data for the tutor
      final response = await Supabase.instance.client
          .from('experience') // Your experience table name
          .select('*') // Select all columns
          .eq('user_id', widget.tutorId); // Filter by tutorId

      // Directly assign the fetched data to experienceList
      setState(() {
        experienceList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching experience details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Widget to display the experience details dynamically
  @override
  Widget build(BuildContext context) {
    return _buildSectionContainer(
      title: 'Experience Information',
      child: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : experienceList.isEmpty
              ? const Center(
                  child: Text(
                      'No experience found.')) // If no experience data exists
              : _buildExperienceDetails(), // Otherwise, build the experience cards
    );
  }

  // Create a container with title and experience details
  Widget _buildSectionContainer(
      {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  // Build the experience details cards
  Widget _buildExperienceDetails() {
    return ListView.builder(
      shrinkWrap: true,
      physics:
          NeverScrollableScrollPhysics(), // Prevent scrolling in this section
      itemCount: experienceList
          .length, // Number of cards to display (based on the fetched data)
      itemBuilder: (context, index) {
        final experience = experienceList[index];
        final educationLevel =
            experience['education_level'] ?? 'Not provided'; // Example field
        final startDate = experience['start_date'] ?? 'Unknown start date';
        final endDate = experience['end_date'] ?? 'Unknown end date';
        final proofUrl = experience['proof_url']; // Example field

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(16),
            decoration: _boxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Education Level of Students', widget.tutorId),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildInfoRow('Start Date', startDate)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInfoRow('End Date', endDate)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Proof of Experience:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to open proof URL or handle download
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Download',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build a single info row
  Widget _buildInfoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Box decoration for each experience card
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    );
  }
}
