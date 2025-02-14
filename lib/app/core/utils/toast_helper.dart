import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToastHelper {
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.top,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      borderRadius: 10,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.top,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      borderRadius: 10,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.top,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      borderRadius: 10,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }
}
