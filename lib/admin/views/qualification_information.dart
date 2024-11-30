import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QualificationInformation extends StatefulWidget {
  final String tutorId; // Pass tutorId from parent widget

  const QualificationInformation({super.key, required this.tutorId});

  @override
  _QualificationInformationState createState() =>
      _QualificationInformationState();
}

class _QualificationInformationState extends State<QualificationInformation> {
  List<Map<String, dynamic>> qualificationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQualificationDetails(); // Fetch qualification data when the widget is initialized
  }

  // Function to fetch qualification details from the Supabase qualification table
  Future<void> fetchQualificationDetails() async {
    try {
      // Fetch qualification data for the tutor
      final response = await Supabase.instance.client
          .from('qualification') // Your qualification table name
          .select('*') // Select all columns
          .eq('user_id', widget.tutorId); // Filter by tutorId

      // Directly assign the fetched data to qualificationList
      setState(() {
        qualificationList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching qualification details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Widget to display the qualification details dynamically
  @override
  Widget build(BuildContext context) {
    return _buildSectionContainer(
      title: 'Qualification Information',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : qualificationList.isEmpty
              ? const Center(child: Text('No qualifications found.'))
              : _buildQualificationDetails(),
    );
  }

  // Create a container with title and qualification details
  Widget _buildSectionContainer({required String title, required Widget child}) {
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

  // Build the qualification details cards
  Widget _buildQualificationDetails() {
    return Column(
      children: [
        for (var qualification in qualificationList) 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Original spacing between cards
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Education Level', widget.tutorId), // Display tutor ID
                  _buildInfoRow('Institute Name', qualification['institute_name'] ?? 'Unknown institute'),
                  const SizedBox(height: 8), // Original spacing inside the card
                  const Text(
                    'Proof of Qualification:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8), // Original spacing before the button
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
          ),
      ],
    );
  }

  // Build a single info row for education level, institute name, etc.
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
        const SizedBox(height: 8), // Original spacing inside the card
      ],
    );
  }

  // Box decoration for each qualification card
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
