// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // Import the image_picker package
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'cnic_screen.dart'; // Import the CnicScreen
// import 'dart:io'; // Import for File

// // Step 1: Change Location2Screen to a StatefulWidget
// class Location2Screen extends StatefulWidget {
//   @override
//   _Location2ScreenState createState() => _Location2ScreenState(); // Step 2: Create the state class
// }

// // Step 2: Define the state class
// class _Location2ScreenState extends State<Location2Screen> {
//   File? _image; // To store the selected image

//   // Method to pick an image
//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     // Pick an image from the gallery
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       setState(() {
//         _image = File(image.path); // Update the state with the selected image
//       });
//       final File file = File(image.path);
//       final response = await Supabase.instance.client.storage
//           .from('user_img')
//           .upload('public/${image.name}',file);
//     }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context); // Navigate back to the previous screen
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Select your location',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: InkWell(
//                 onTap: _pickImage, // Call the image picker on tap
//                 borderRadius: BorderRadius.circular(100), // For circular ripple effect
//                 child: Ink(
//                   width: 165,
//                   height: 165,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     shape: BoxShape.circle,
//                   ),
//                   child: ClipOval(
//                     child: _image != null
//                         ? Image.file(
//                             _image!,
//                             fit: BoxFit.cover,
//                             width: 165,
//                             height: 165,
//                           )
//                         : const Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 size: 36,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Tap to upload',
//                                 style: TextStyle(color: Colors.grey, fontSize: 14),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Spacer(),
//             SizedBox(
//               width: 330,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => CnicScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff87e64c),
//                   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Next',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),);
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'cnic_screen.dart'; // Import the CnicScreen
import 'dart:io'; // Import for File
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

// Step 1: Change Location2Screen to a StatefulWidget
class Location2Screen extends StatefulWidget {
  @override
  _Location2ScreenState createState() =>
      _Location2ScreenState(); // Step 2: Create the state class
}

// Step 2: Define the state class
class _Location2ScreenState extends State<Location2Screen> {
  File? _image; // To store the selected image
  String? _imageUrl; // change: To store the image URL after uploading

  // Method to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path); // Update the state with the selected image
      });
    }
  }

  // change: Method to upload image to Supabase storage and get the URL
  Future<void> _uploadImage() async {
    if (_image == null) return; // No image selected

    try {
      final file = _image!; // The selected image file

      // Upload the image to Supabase storage
      final response = await Supabase.instance.client.storage
          .from(
              'user_img') // change: Bucket name, replace with your actual bucket
          .upload('public/${file.path.split('/').last}', file);

      // change: Generate the public URL for the uploaded image
      final imageUrl = Supabase.instance.client.storage
          .from('user_img')
          .getPublicUrl('public/${file.path.split('/').last}');

      setState(() {
        _imageUrl = imageUrl; // Save the image URL in state
      });

      print(
          "Image uploaded successfully: $_imageUrl"); // For testing, print URL to console
    } catch (e) {
      print("Error uploading image: $e"); // Handle errors
    }
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
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your location',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: _pickImage, // Call the image picker on tap
                borderRadius:
                    BorderRadius.circular(100), // For circular ripple effect
                child: Ink(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 165,
                            height: 165,
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 36,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to upload',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Spacer(),
            SizedBox(
              width: 330,
              child: ElevatedButton(
                onPressed: () async {
                  // change: Upload the image when the "Next" button is clicked
                  await _uploadImage();

                  // Navigate to the next screen after uploading
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CnicScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff87e64c),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
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
  }
}
