import 'dart:io';
import 'package:get/get.dart';

class QualificationModel {
  // Reactive variables for real-time updates
  RxString educationLevel = ''.obs; // For education level input
  RxString instituteName = ''.obs; // For institute name input
  RxString qualificationFileName = ''.obs; // To display the selected file name
  Rx<File?> qualificationFile = Rx<File?>(null); // For the selected file

 
  QualificationModel({
    String? educationLevel,
    String? instituteName,
    String? qualificationFileName,
    File? qualificationFile,
  }) {
    this.educationLevel.value = educationLevel ?? '';
    this.instituteName.value = instituteName ?? '';
    this.qualificationFileName.value = qualificationFileName ?? '';
    this.qualificationFile.value = qualificationFile;
  }
}
