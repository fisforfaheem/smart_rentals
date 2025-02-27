import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Show splash for 2 seconds

    final currentUser = _authService.currentUser.value;
    if (currentUser != null) {
      try {
        // Get user data from Firebase
        final userSnapshot =
            await _database.child('users').child(currentUser.uid).get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<dynamic, dynamic>;
          final userRole = userData['role'] as String?;

          // Route based on role
          if (userRole == 'driver') {
            Get.offAllNamed('/driver-home');
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          Get.offAllNamed('/onboarding');
        }
      } catch (e) {
        debugPrint('Error checking user role: $e');
        Get.offAllNamed('/onboarding');
      }
    } else {
      Get.offAllNamed('/onboarding');
    }
  }
}
