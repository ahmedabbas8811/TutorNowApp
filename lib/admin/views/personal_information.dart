import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/admin/controllers/tutor_confirmation_controller.dart';

class PersonalInformation extends StatefulWidget {
  final String userId;
  final String userName;
  final String userMail;
  final String img_Url;
  final String userLocation;
  final VoidCallback onDownloadPressed;
  final VoidCallback onApprovePressed;

  const PersonalInformation({
    super.key,
    required this.userId,
    required this.userName,
    required this.userMail,
    required this.img_Url,
    required this.userLocation,
    required this.onDownloadPressed,
    required this.onApprovePressed,
  });

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}



class _PersonalInformationState extends State<PersonalInformation> {
  final TextEditingController reasonController = TextEditingController();
  String? selectedChip; // Tracks selected chip
  bool isReasonFocused = false;

  @override
  Widget build(BuildContext context) {
    return _buildSectionContainer(
      title: 'Personal Information',
      child: _buildPersonalInfo(context),
    );
  }

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

  Widget _buildPersonalInfo(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.img_Url),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Name', widget.userName),
          _buildInfoRow('Email', widget.userMail),
          _buildInfoRow('Location', widget.userLocation),
          const Text(
            'CNIC:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: widget.onDownloadPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'View',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          _buildApprovalButtons(),
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

  Widget _buildApprovalButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: widget.onApprovePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff87e64c),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          label: const Text(
            'Approve Tutor',
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            Icons.check,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => _showRejectDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          label: const Text(
            'Reject Tutor',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
  

  void _showRejectDialog(BuildContext context) {
    List<String> selectedSteps = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(16),
              title: const Text(
                "Add Reason For Rejection",
                style: TextStyle(fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Your profile was rejected due to ",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            setStateDialog(() {
                              isReasonFocused = hasFocus;
                            });
                          },
                          child: TextField(
                            cursorColor: Colors.grey.shade400,
                            controller: reasonController,
                            decoration: InputDecoration(
                              hintText: selectedChip != null
                                  ? "Invalid $selectedChip"
                                  : "Invalid CNIC",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color:
                                      (isReasonFocused || selectedChip != null)
                                          ? Colors.black
                                          : Colors.grey.shade400,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color:
                                      (isReasonFocused || selectedChip != null)
                                          ? Colors.black
                                          : Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Select steps for user to redo",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildChip(
                            "Profile image", selectedSteps, setStateDialog),
                        const SizedBox(width: 10),
                        _buildChip("Location", selectedSteps, setStateDialog),
                        const SizedBox(width: 10),
                        _buildChip("CNIC", selectedSteps, setStateDialog),
                        const SizedBox(width: 10),
                        _buildChip(
                            "Qualification", selectedSteps, setStateDialog),
                        const SizedBox(width: 10),
                        _buildChip("Experience", selectedSteps, setStateDialog),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final controller =
                          Get.find<TutorConfirmationController>();

                      // Reject the tutor with selected steps
                      await controller.rejectTutor(widget.userId,
                          reasonController.text, selectedSteps, context);

                      // Close dialog safely
                      if (mounted && Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Reject Profile",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChip(String label, List<String> selectedSteps,
      void Function(void Function()) setStateDialog) {
    final bool isSelected = selectedSteps.contains(label);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey.shade400,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setStateDialog(() {
          if (selected) {
            selectedSteps.add(label);
          } else {
            selectedSteps.remove(label);
          }
        });
      },
      selectedColor: const Color(0xff87e64c),
      showCheckmark: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    );
  }
}
