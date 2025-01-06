import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newifchaly/utils/profile_helper.dart';
import '../controllers/teachto_controller.dart';
import 'teaching_detail.dart';

class TeachTo extends StatefulWidget {
  @override
  State<TeachTo> createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<TeachTo> {
  final TeachToController controller = Get.put(TeachToController());
  final TextEditingController subjectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subjectController.text = controller.teachto.subject.value;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await controller.isTeachToCompleted()) {
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
                                builder: (context) => TeachingDetail(),
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

                        value:
                            controller.teachto.educationLevel.value.isNotEmpty
                                ? controller.teachto.educationLevel.value
                                : null, // Current value or null
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
                            controller.teachto.educationLevel.value = value;
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Institute Name Input
                  TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Bio, Chemistry',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardAppearance: Brightness.light,
                    onChanged: (value) =>
                        controller.teachto.subject.value = value,
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    // Add Another Qualification Button
                    child: ElevatedButton(
                      onPressed: () async {
                        final qualificationId =
                            await controller.storeteachto(context);

                        // Clear fields
                        setState(() {
                          controller.teachto.educationLevel.value = '';
                          controller.teachto.subject.value = '';
                          subjectController.clear();
                        });
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
                    ), //Add another button end
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    //Next button
                    child: ElevatedButton(
                      onPressed: () async {
                        final qualificationId =
                            await controller.storeteachto(context);
                        if (qualificationId != null) {
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
                    ), //Next button end
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
