import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newifchaly/attachimg_controller.dart';
import 'dart:io';

class WeekAttachImages extends StatelessWidget {
  final String bookingId;
  final int week;

  WeekAttachImages({required this.bookingId, required this.week, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AttachImageController controller =
        Get.put(AttachImageController(bookingId: bookingId, week: week));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Week 1 - Progress',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Report',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Attach images to weekly report',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            GestureDetector(
                onTap: () => _showImageSourceDialog(controller),
                child: CustomPaint(
                  painter: DashedBorderPainter(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                      () => controller.selectedImages.isEmpty
                          ? const SizedBox(
                              height: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('Tap to upload images',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.selectedImages.map((image) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () => controller
                                            .selectedImages
                                            .remove(image),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                )),
            const SizedBox(height: 22),
            const Text(
              'Additional comments (if any)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Write your comments here',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => controller.comments.value =
                  value, //bind comments to controller
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.saveProgress(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff87e64c),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              child: const Text('Save',
                  style: TextStyle(fontSize: 17, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(AttachImageController controller) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () async {
              Navigator.pop(context);
              await controller.captureImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () async {
              Navigator.pop(context);
              await controller.pickImages();
            },
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 8, dashSpace = 5;
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(8),
      ));

    double dashOffset = 0;
    while (dashOffset < path.computeMetrics().first.length) {
      final metric = path.computeMetrics().first;
      canvas.drawPath(
          metric.extractPath(dashOffset, dashOffset + dashWidth), paint);
      dashOffset += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
