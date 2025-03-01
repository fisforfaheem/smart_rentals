import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import 'package:intl/intl.dart';
import '../../../data/models/driver_model.dart';

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
  final pricePerHourController = TextEditingController();

  final isEditing = false.obs;
  final isLoading = false.obs;
  final RxBool isBooked = false.obs;
  final RxBool isAvailable = true.obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final Rx<Gender> gender = Gender.other.obs;

  // Add a map to store current user details
  final Rx<Map<String, dynamic>> currentUserDetails = Rx<Map<String, dynamic>>(
    {},
  );
  final RxString currentBookingId = ''.obs;

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
    pricePerHourController.dispose();
    super.onClose();
  }

  Future<void> loadDriverProfile() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.offAllNamed('/login');
        return;
      }

      final snapshot = await _database.child('users').child(userId).get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;

        // Set observable values for profile display
        name.value = userData['name'] ?? '';
        email.value = userData['email'] ?? '';
        isAvailable.value = userData['isAvailable'] ?? true;

        // Basic user data
        nameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        pinController.text = userData['pin'] ?? '';
        pricePerHourController.text =
            (userData['pricePerHour'] ?? '0').toString();

        // Driver specific data
        if (userData['vehicleDetails'] != null) {
          final vehicleDetails =
              userData['vehicleDetails'] as Map<dynamic, dynamic>;
          plateNumberController.text = vehicleDetails['plateNumber'] ?? '';
          vehicleColorController.text = vehicleDetails['color'] ?? '';
          vehicleCapacityController.text =
              vehicleDetails['capacity']?.toString() ?? '';

          // Format the year properly
          final yearStr = vehicleDetails['yearOfManufacture'] ?? '';
          if (yearStr.isNotEmpty) {
            try {
              final date = DateTime.parse(yearStr);
              yearOfManufactureController.text = date.year.toString();
            } catch (e) {
              yearOfManufactureController.text = yearStr;
            }
          }

          licenseNumberController.text = vehicleDetails['licenseNumber'] ?? '';
        }

        // Parse gender from the stored string
        final genderStr =
            userData['gender']?.toString().toLowerCase() ?? 'other';
        gender.value = Gender.values.firstWhere(
          (g) => g.toString().split('.').last.toLowerCase() == genderStr,
          orElse: () => Gender.other,
        );
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
        'pricePerHour':
            double.tryParse(pricePerHourController.text.trim()) ?? 0,
        'gender': gender.value.toString().split('.').last.toLowerCase(),
        'vehicleDetails': {
          'plateNumber': plateNumberController.text.trim(),
          'color': vehicleColorController.text.trim(),
          'capacity': vehicleCapacityController.text.trim(),
          'yearOfManufacture': yearOfManufactureController.text.trim(),
          'licenseNumber': licenseNumberController.text.trim(),
        },
      };

      await _database.child('users').child(userId).update(updates);

      // Update observable values
      name.value = nameController.text.trim();
      email.value = emailController.text.trim();

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
        final bool isCurrentlyBooked = (event.snapshot.value as bool?) ?? false;
        isBooked.value = isCurrentlyBooked;

        // If booked, fetch the user details
        if (isCurrentlyBooked) {
          _fetchCurrentBookingDetails(userId);
        } else {
          // Clear user details if not booked
          currentUserDetails.value = {};
          currentBookingId.value = '';
        }
      });
    }
  }

  Future<void> _fetchCurrentBookingDetails(String driverId) async {
    try {
      // Find the booking for this driver with status 'pending'
      final bookingsSnapshot = await _database.child('bookings').get();

      if (bookingsSnapshot.exists) {
        final bookings = bookingsSnapshot.value as Map<dynamic, dynamic>;

        bookings.forEach((key, value) {
          if (value is Map &&
              value['driverId'] == driverId &&
              value['status'] == 'pending') {
            currentBookingId.value = key;

            // Get the user ID from the booking
            final userId = value['userId'] as String;

            // Fetch user details
            _fetchUserDetails(userId);
          }
        });
      }
    } catch (e) {
      debugPrint(
        '[_fetchCurrentBookingDetails] Error fetching booking details: $e',
      );
    }
  }

  Future<void> _fetchUserDetails(String userId) async {
    try {
      final userSnapshot = await _database.child('users').child(userId).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.value as Map<dynamic, dynamic>;
        currentUserDetails.value = {
          'name': userData['name'] ?? 'Unknown User',
          'phone': userData['phone'] ?? 'No phone number',
          'email': userData['email'] ?? 'No email',
          // Add any other user details you want to display
        };

        debugPrint(
          '[_fetchUserDetails] Fetched user details: ${currentUserDetails.value}',
        );
      }
    } catch (e) {
      debugPrint('[_fetchUserDetails] Error fetching user details: $e');
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
                    onPressed: _confirmCancelBooking,
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
      debugPrint('[cancelCurrentBooking] Error showing cancel dialog: $e');
      ToastHelper.showError('Failed to show cancel dialog');
    }
  }

  Future<void> _confirmCancelBooking() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;

      if (userId == null) {
        ToastHelper.showError('User not authenticated');
        return;
      }

      // Update driver's booking status
      await _database.child('users').child(userId).child('isBooked').set(false);

      // Also update the booking status in the bookings node if we have a booking ID
      if (currentBookingId.value.isNotEmpty) {
        await _database.child('bookings').child(currentBookingId.value).update({
          'status': 'cancelled',
        });

        // Clear the current booking details
        currentBookingId.value = '';
        currentUserDetails.value = {};
      }

      Get.closeAllDialogs();
      ToastHelper.showSuccess('Booking cancelled successfully');
    } catch (e) {
      debugPrint('[_confirmCancelBooking] Error cancelling booking: $e');
      ToastHelper.showError('Failed to cancel booking');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAvailability() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      isAvailable.value = !isAvailable.value;
      await _database
          .child('users')
          .child(userId)
          .child('isAvailable')
          .set(isAvailable.value);
    } catch (e) {
      debugPrint('Error toggling availability: $e');
      // Revert the value if the update failed
      isAvailable.value = !isAvailable.value;
      ToastHelper.showError('Failed to update availability');
    }
  }

  Future<void> pickYearOfManufacture(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFBE9B7B),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format to show only the year
      yearOfManufactureController.text = picked.year.toString();
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
