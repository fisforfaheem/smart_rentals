import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import 'package:intl/intl.dart';

class DriverController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for profile fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final plateNumberController = TextEditingController();
  final vehicleColorController = TextEditingController();
  final vehicleCapacityController = TextEditingController();
  final yearOfManufactureController = TextEditingController();

  final isEditing = false.obs;
  final isLoading = false.obs;
  final RxBool isBooked = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDriverProfile();
    _listenToBookingStatus();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    pinController.dispose();
    licenseNumberController.dispose();
    plateNumberController.dispose();
    vehicleColorController.dispose();
    vehicleCapacityController.dispose();
    yearOfManufactureController.dispose();
    super.onClose();
  }

  Future<void> loadDriverProfile() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final snapshot = await _database.child('users').child(userId).get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;

        // Basic user data
        nameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        pinController.text = userData['pin'] ?? '';

        // Driver specific data
        if (userData['driverDetails'] != null) {
          final driverDetails =
              userData['driverDetails'] as Map<dynamic, dynamic>;
          licenseNumberController.text = driverDetails['licenseNumber'] ?? '';

          if (driverDetails['vehicleDetails'] != null) {
            final vehicleDetails =
                driverDetails['vehicleDetails'] as Map<dynamic, dynamic>;
            plateNumberController.text = vehicleDetails['plateNumber'] ?? '';
            vehicleColorController.text = vehicleDetails['color'] ?? '';
            vehicleCapacityController.text =
                vehicleDetails['capacity']?.toString() ?? '';
            yearOfManufactureController.text =
                vehicleDetails['yearOfManufacture'] ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      ToastHelper.showError('Failed to load profile data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        ToastHelper.showError('User not authenticated');
        return;
      }

      final updates = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'driverDetails': {
          'licenseNumber': licenseNumberController.text.trim(),
          'vehicleDetails': {
            'plateNumber': plateNumberController.text.trim(),
            'color': vehicleColorController.text.trim(),
            'capacity': vehicleCapacityController.text.trim(),
            'yearOfManufacture': yearOfManufactureController.text.trim(),
          },
        },
      };

      await _database.child('users').child(userId).update(updates);

      isEditing.value = false;
      ToastHelper.showSuccess('Profile updated successfully');
    } catch (e) {
      debugPrint('Error updating profile: $e');
      ToastHelper.showError('Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToBookingStatus() {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _database.child('users').child(userId).child('isBooked').onValue.listen((
        event,
      ) {
        isBooked.value = (event.snapshot.value as bool?) ?? false;
      });
    }
  }

  Future<void> cancelCurrentBooking() async {
    try {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF5E6D3),
          title: const Text(
            'Cancel Current Booking',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 64),
              SizedBox(height: 16),
              Text(
                'Are you sure you want to cancel your current booking?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
              ),
              SizedBox(height: 8),
              Text(
                'This will make you available for new bookings.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.closeAllDialogs(),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    child: const Text(
                      'Keep Booking',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmCancelCurrentBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancel Booking',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      debugPrint('Error showing cancel dialog: $e');
      ToastHelper.showError('Failed to show cancel dialog');
    }
  }

  Future<void> _confirmCancelCurrentBooking() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;

      if (userId == null) {
        ToastHelper.showError('User not authenticated');
        return;
      }

      // Update driver's booking status
      await _database.child('users').child(userId).child('isBooked').set(false);

      Get.closeAllDialogs();
      ToastHelper.showSuccess('Booking cancelled successfully');
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      ToastHelper.showError('Failed to cancel booking');
    } finally {
      isLoading.value = false;
    }
  }
}
