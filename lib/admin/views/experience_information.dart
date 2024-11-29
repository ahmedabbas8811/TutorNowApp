import 'package:flutter/material.dart';

class ExperienceInformation extends StatelessWidget {
  final String tutorId;
  const ExperienceInformation({super.key, required this.tutorId});

  @override
  Widget build(BuildContext context) {
    return _buildSectionContainer(
      title: 'Experience Information',
      child: _buildExperienceDetails(),
    );
  }

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

  Widget _buildExperienceDetails() {
    return Column(
      children: [
        _buildExperienceCard(),
        const SizedBox(height: 8),
        _buildExperienceCard(),
        const SizedBox(height: 8),
        _buildExperienceCard(),
      ],
    );
  }

  Widget _buildExperienceCard() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Education Level of Students', tutorId),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildInfoRow('Start Date', '09/09/2022')),
              const SizedBox(width: 10),
              Expanded(child: _buildInfoRow('End Date', '09/09/2023')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Proof of Experience:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
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
    );
  }

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