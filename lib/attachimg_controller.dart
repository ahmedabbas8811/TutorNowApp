import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttachImageController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final RxList<File> selectedImages = <File>[].obs; // Store selected images
  final RxString comments = ''.obs; // Store user comments
  final ImagePicker _picker = ImagePicker();
  final String bookingId;
  final int week;

  AttachImageController({required this.bookingId, required this.week});

  // Pick images from gallery
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
    }
  }

  // Capture image from Camera
  Future<void> captureImage() async {
    final XFile? capturedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      selectedImages.add(File(capturedFile.path));
    }
  }

  // Save images and comments
  Future<void> saveProgress() async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image.');
      return;
    }

    try {
      // Upload all images and collect their URLs
      final Map<String, String> imageUrls = {};
      for (int i = 0; i < selectedImages.length; i++) {
        final String fileName =
            'progress_img/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

        // Upload to Supabase Storage
        await supabase.storage
            .from('progress_report_images')
            .upload(fileName, selectedImages[i]);

        final String imageUrl = supabase.storage
            .from('progress_report_images')
            .getPublicUrl(fileName);

        // Add the image URL to the map
        imageUrls[(i + 1).toString()] = imageUrl;
      }

      // Save to Database
      await supabase.from('progress_report_images').insert({
        'booking_id': bookingId,
        'week': week,
        'comment': comments.value, // Save comments
        'images': imageUrls, // Save image URLs as JSONB
      });

      Get.snackbar('Success', 'Progress saved successfully!');
      selectedImages.clear(); // Clear selected images after saving
      comments.value = ''; // Clear comments after saving
    } catch (e) {
      Get.snackbar('Error', 'Failed to save progress: $e');
    }
  }
}