// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/progress_model.dart';

// class AttachImageController extends GetxController {
//   final SupabaseClient supabase = Supabase.instance.client;
//   final RxList<ProgressModel> images = <ProgressModel>[].obs;
//   final ImagePicker _picker = ImagePicker();
//   final String bookingId;
//   final int week;

//   AttachImageController({required this.bookingId, required this.week});

//   @override
//   void onInit() {
//     fetchImages(); // Load images when controller initializes
//     super.onInit();
//   }

//   // Pick images from gallery
//   Future<void> pickImages() async {
//     final List<XFile>? pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles != null) {
//       for (XFile file in pickedFiles) {
//         await uploadImage(File(file.path));
//       }
//     }
//   }

//   // Capture image from Camera
//   Future<void> captureImage() async {
//     final XFile? capturedFile =
//         await _picker.pickImage(source: ImageSource.camera);
//     if (capturedFile != null) {
//       await uploadImage(File(capturedFile.path));
//     }
//   }

//   // Upload image to Supabase Storage & save URL in DB
//   Future<void> uploadImage(File image) async {
//     try {
//       final String fileName =
//           'progress_img/${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // Upload to Supabase Storage
//       final storageResponse = await supabase.storage
//           .from('progress_report_images')
//           .upload(fileName, image);

//       if (storageResponse.isNotEmpty) {
//         final String imageUrl = supabase.storage
//             .from('progress_report_images')
//             .getPublicUrl(fileName);

//         // Save to Database
//         final response = await supabase
//             .from('progress_report_images')
//             .insert(
//                 {'image_url': imageUrl, 'booking_id': bookingId, 'week': week})
//             .select()
//             .single();

//         if (response != null) {
//           images.add(ProgressModel.fromMap(response));
//         }
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//     }
//   }

//   // Fetch Images from Database
//   Future<void> fetchImages() async {
//     final response = await supabase.from('progress_report_images').select();
//     images.assignAll(response
//         .map<ProgressModel>((data) => ProgressModel.fromMap(data))
//         .toList());
//   }
// }
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/progress_model.dart';

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
      // Upload each image
      for (File image in selectedImages) {
        final String fileName =
            'progress_img/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Upload to Supabase Storage
        await supabase.storage
            .from('progress_report_images')
            .upload(fileName, image);

        final String imageUrl = supabase.storage
            .from('progress_report_images')
            .getPublicUrl(fileName);

        // Save to Database
        await supabase.from('progress_report_images').insert({
          'image_url': imageUrl,
          'booking_id': bookingId,
          'week': week,
          'comment': comments.value, // Save comments
        });
      }

      Get.snackbar('Success', 'Progress saved successfully!');
      selectedImages.clear(); // Clear selected images after saving
      comments.value = ''; // Clear comments after saving
    } catch (e) {
      Get.snackbar('Error', 'Failed to save progress: $e');
    }
  }
}
