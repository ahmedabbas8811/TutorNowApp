import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeachingDetail extends StatefulWidget {
  @override
  _TeachingDetailState createState() => _TeachingDetailState();
}

class _TeachingDetailState extends State<TeachingDetail> {
DateTime? _startDate;
DateTime? _endDate;

  bool _switchValue = false;                                       // Checks whether switch is on or off
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _educationLevelController = TextEditingController();

  // Function to show a date picker and set the selected date in  TextEditingController
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // ((Format)) the picked date and set it in the controller
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);                       
      });
    }
  }
   Future<void> _storeExperiencen() async {
    final user = Supabase.instance.client.auth.currentUser;
    final educationLevel = _educationLevelController.text;
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final stillWorking = _switchValue;
  

    if (user != null && _educationLevelController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty) {
      try {
        final response = await Supabase.instance.client
            .from('experience') 
            .insert({
              'student_education_level': educationLevel,
              'start_date': startDate,
              'end_date': endDate.isEmpty ? null : endDate,
              'user_id': user.id,
              'still_working': stillWorking,
            })
            .select();

        
      } catch (e) {
        print("Error storing experience: $e");
      }
    } else {
      print("Please fill all fields.");
    }
  }

  


  @override
  void dispose() {
    //  TextEditingControllers when this widget is destroyed(DISPOSED)
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
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
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Teaching Experience',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // TextField education level
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Education Level of Students',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Ex. Matric',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                       enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardAppearance: Brightness.light,
                  ),
                  const SizedBox(height: 15),

                  // TextField selecting start date 
                  TextField(
                    controller: _startDateController,
                    readOnly: true, // Read-only to restrict manual typing
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Select Start Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.grey),
                        onPressed: () => _selectDate(context, _startDateController),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                       enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardAppearance: Brightness.light,
                  ),
                  const SizedBox(height: 20),

                  // TextField for selecting end date, disabled if "I Still Work Here" is active
                  TextField(
                    controller: _endDateController,
                    readOnly: true, // Read-only to open only the date picker
                    enabled: !_switchValue, // Disable when "I Still Work Here" is active
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Select End Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.grey),
                        onPressed: !_switchValue
                            ? () => _selectDate(context, _endDateController)
                            : null,
                      ),
                      filled: _switchValue,
                      fillColor: _switchValue ? const Color(0xff87e64c).withOpacity(0.4) : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                       enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: TextStyle(
                      color: _switchValue ? Colors.grey.withOpacity(0.5) : Colors.black,
                    ),
                    keyboardAppearance: Brightness.light,
                  ),
                  const SizedBox(height: 5),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("I Still Work Here",style: TextStyle(fontWeight: FontWeight.bold),),
                        CupertinoSwitch(
                          value: _switchValue,
                          activeColor: const Color(0xff87e64c),
                          onChanged: (value) {
                            setState(() {
                              _switchValue = value;
                              if (value) _endDateController.clear(); // Clear end date if switch is on
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Container for uploading proof of qualification
                  Container(
                    width: 330,
                    height: 210,
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
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

                        // Inner container for upload PDF
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: () {
                              print('Inner container clicked');
                            },
                            child: Container(
                              width: double.infinity,
                              height: 130,
                              child: CustomPaint(
                                painter: DashedBorderPainter(), // Custom painter for dashed border
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Tap to upload',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '*pdf accepted',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // "Add Another +" button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TeachingDetail()),
                        );
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
                  const SizedBox(height: 5),

                  // "Submit For Verification" 
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _storeExperiencen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff87e64c),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit For Verification',
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

// Custom painter class for creating a dashed border
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
    return false; // No repainting needed as border properties are static
  }
}
