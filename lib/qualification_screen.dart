import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/teach_to.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import 'package:newifchaly/views/widgets/snackbar.dart';
import '../controllers/qualification_controller.dart';
import 'teaching_detail.dart';

class QualificationScreen extends StatefulWidget {
  @override
  State<QualificationScreen> createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
  // Access the QualificationController
  final QualificationController controller = Get.put(QualificationController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await controller.isQualificationCompleted()) {
        final completionData =
            await ProfileCompletionHelper.fetchCompletionData();
        final incompleteSteps =
            ProfileCompletionHelper.getIncompleteSteps(completionData);
        ProfileCompletionHelper.navigateToNextScreen(context, incompleteSteps);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: const Text(
                          'Add Qualification',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeachTo(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.green.shade100;
                                }
                                return null; // Default behavior
                              },
                            ),
                          ),
                          child: const Text(
                            "Skip For Now",
                            style: TextStyle(
                                color: Colors.grey,
                                //  decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.underline),
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Education Level Input
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Education Level',
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: 'Ex. Matric',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        dropdownColor: Colors.grey[100],
                        value: controller
                                .qualification.educationLevel.value.isNotEmpty
                            ? controller.qualification.educationLevel.value
                            : null,
                        items: [
                          'Matric',
                          'Intermediate',
                          'Bachelors',
                          'Masters',
                          'PhD'
                        ].map((level) {
                          return DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.qualification.educationLevel.value =
                                value;
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Institute Name Input
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Institute Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Ex. IMCB',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardAppearance: Brightness.light,
                    onChanged: (value) =>
                        controller.qualification.instituteName.value = value,
                  ),
                  const SizedBox(height: 40),

                  // Upload Proof Of Qualification Section
                  Container(
                    width: 330,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            'Upload Proof Of Qualification',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            'Degree/Marksheet/Certificate',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 7),

                        // File Picker Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: () =>
                                controller.pickQualificationFile(context),
                            child: Container(
                              width: double.infinity,
                              height: 140,
                              child: CustomPaint(
                                painter: DashedBorderPainter(),
                                child: Obx(() => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.cloud_upload,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          controller
                                                  .qualification
                                                  .qualificationFileName
                                                  .value
                                                  .isEmpty
                                              ? 'Tap to upload'
                                              : controller.qualification
                                                  .qualificationFileName.value,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          controller
                                                      .qualification
                                                      .qualificationFileName
                                                      .value ==
                                                  null
                                              ? '*pdf accepted'
                                              : 'Tap to upload another document',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70),

                  SizedBox(
                    width: double.infinity,
                    // Add Another Qualification Button
                    child: ElevatedButton(
                      onPressed: () async {
                        // Check if fields are filled but no file is attached
                        if (controller.qualification.educationLevel.value
                                .isNotEmpty &&
                            controller
                                .qualification.instituteName.value.isNotEmpty &&
                            controller.qualification.qualificationFile.value ==
                                null) {
                          showCustomSnackBar(context,
                              'Please attach your qualification document (PDF only)');
                          return;
                        }

                        // Check if file is attached but not PDF
                        if (controller.qualification.qualificationFile.value !=
                                null &&
                            !controller
                                .qualification.qualificationFileName.value
                                .toLowerCase()
                                .endsWith('.pdf')) {
                          showCustomSnackBar(
                              context, 'Only PDF files are allowed');
                          return;
                        }

                        // Only proceed if either:
                        // 1. Both fields are empty (skip case)
                        // 2. All fields including PDF file are filled
                        if (controller.qualification.educationLevel.value
                                .isNotEmpty ||
                            controller
                                .qualification.instituteName.value.isNotEmpty) {
                          final qualificationId =
                              await controller.storeQualification(context);
                          if (qualificationId != null &&
                              controller
                                      .qualification.qualificationFile.value !=
                                  null) {
                            await controller.uploadFileToSupabase(
                              controller.qualification.qualificationFile.value!,
                              qualificationId,
                            );
                          }
                        }

                        // Clear fields
                        controller.qualification.educationLevel.value = '';
                        controller.qualification.instituteName.value = '';
                        controller.qualification.qualificationFileName.value =
                            '';
                        controller.qualification.qualificationFile.value = null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add Another +',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    // Next button
                    child: ElevatedButton(
                      onPressed: () async {
                        // Check if fields are filled but no file is attached
                        if (controller.qualification.educationLevel.value
                                .isNotEmpty &&
                            controller
                                .qualification.instituteName.value.isNotEmpty &&
                            controller.qualification.qualificationFile.value ==
                                null) {
                          showCustomSnackBar(context,
                              'Please attach your qualification document (PDF only)');
                          return;
                        }

                        // Check if file is attached but not PDF
                        if (controller.qualification.qualificationFile.value !=
                                null &&
                            !controller
                                .qualification.qualificationFileName.value
                                .toLowerCase()
                                .endsWith('.pdf')) {
                          showCustomSnackBar(
                              context, 'Only PDF files are allowed');
                          return;
                        }

                        // Only proceed if either:
                        // 1. Both fields are empty (skip case)
                        // 2. All fields including PDF file are filled
                        if (controller
                                .qualification.educationLevel.value.isEmpty &&
                            controller
                                .qualification.instituteName.value.isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeachTo(),
                            ),
                          );
                          return;
                        }

                        final qualificationId =
                            await controller.storeQualification(context);
                        if (qualificationId != null &&
                            controller.qualification.qualificationFile.value !=
                                null) {
                          await controller.uploadFileToSupabase(
                            controller.qualification.qualificationFile.value!,
                            qualificationId,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeachingDetail(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff87e64c),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 7.0;
    const dashSpace = 4.0;
    double startX = 0.0;

    // Draw top border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw right border
    double startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw bottom border
    startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw left border
    startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
