import 'dart:io';
import 'package:get/get.dart';

class TeachToModel {
  // Reactive variables for real-time updates
  RxString educationLevel = ''.obs; // For education level input
  RxString subject = ''.obs; // For institute name input

  TeachToModel({
    String? educationLevel,
    String? subject,
  }) {
    this.educationLevel.value = educationLevel ?? '';
    this.subject.value = subject ?? '';
  
  }
}
