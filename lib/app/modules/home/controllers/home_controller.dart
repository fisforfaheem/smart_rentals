import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/toast_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final RxList<CarModel> cars = <CarModel>[].obs;
  final RxList<CarModel> filteredCars = <CarModel>[].obs;
  final RxBool isSearching = false.obs;
  final RxDouble searchBarHeight = 56.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDrivers();
  }

  Future<void> loadDrivers() async {
    try {
      isLoading.value = true;
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      // Get all users from Firebase
      final snapshot = await _database.child('users').get();
      final bookingsSnapshot = await _database.child('bookings').get();

      Map<String, String> driverBookings = {};
      if (bookingsSnapshot.exists) {
        final bookings = bookingsSnapshot.value as Map<dynamic, dynamic>;
        bookings.forEach((key, value) {
          if (value is Map && value['status'] == 'pending') {
            driverBookings[value['driverId'] as String] =
                value['userId'] as String;
          }
        });
      }

      if (snapshot.exists) {
        final allUsers = snapshot.value as Map<dynamic, dynamic>;
        final List<CarModel> driversList = [];

        allUsers.forEach((key, value) {
          if (value is Map && value['role'] == 'driver') {
            final driverDetails =
                value['driverDetails'] as Map<dynamic, dynamic>?;
            final vehicleDetails =
                driverDetails?['vehicleDetails'] as Map<dynamic, dynamic>?;

            if (vehicleDetails != null) {
              final isBooked = value['isBooked'] ?? false;
              final bookedByUserId = driverBookings[key];

              driversList.add(
                CarModel(
                  driverId: key as String,
                  name: value['name'] ?? 'Unknown Driver',
                  carModel: 'Vehicle',
                  persons: vehicleDetails['capacity']?.toString() ?? '0',
                  price: '\$180/day',
                  image: 'assets/car2.png',
                  driverImage: 'assets/dri1.png',
                  phoneNumber: value['phone'] ?? '',
                  vehicleColor: vehicleDetails['color'] ?? '',
                  plateNumber: vehicleDetails['plateNumber'] ?? '',
                  yearOfManufacture: vehicleDetails['yearOfManufacture'] ?? '',
                  isBooked: isBooked,
                  isBookedByCurrentUser:
                      isBooked && bookedByUserId == currentUserId,
                ),
              );
            }
          }
        });

        cars.value = driversList;
        filteredCars.value = driversList;

        debugPrint('Loaded ${driversList.length} drivers');
      }
    } catch (e) {
      debugPrint('Error loading drivers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchCars(String query) {
    if (query.isEmpty) {
      filteredCars.value = cars;
      return;
    }

    filteredCars.value =
        cars.where((car) {
          return car.name.toLowerCase().contains(query.toLowerCase()) ||
              car.carModel.toLowerCase().contains(query.toLowerCase()) ||
              car.plateNumber.toLowerCase().contains(query.toLowerCase());
        }).toList();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (isSearching.value) {
      searchBarHeight.value = 80.0;
    } else {
      searchBarHeight.value = 56.0;
      filteredCars.value = cars;
    }
  }

  Future<void> bookDriver(CarModel driver) async {
    try {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF5E6D3),
          title: const Text(
            'Confirm Booking',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(driver.driverImage),
              ),
              const SizedBox(height: 16),
              Text(
                driver.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vehicle: ${driver.vehicleColor} (${driver.plateNumber})',
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
              ),
              Text(
                'Capacity: ${driver.persons} persons',
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
              ),
              const SizedBox(height: 16),
              Text(
                'Price: ${driver.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBE9B7B),
                ),
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
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _confirmBooking(driver);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBE9B7B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Book Now',
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
      debugPrint('Error booking driver: $e');
      ToastHelper.showError('Failed to book driver');
    }
  }

  Future<void> _confirmBooking(CarModel driver) async {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ToastHelper.showError('Please login to book a driver');
        return;
      }

      // Create a booking record
      final bookingData = {
        'userId': userId,
        'driverId': driver.driverId,
        'status': 'pending',
        'bookedAt': ServerValue.timestamp,
        'driverName': driver.name,
        'vehicleDetails': {
          'color': driver.vehicleColor,
          'plateNumber': driver.plateNumber,
          'capacity': driver.persons,
        },
        'price': driver.price,
      };

      // Add booking to database
      final bookingRef = _database.child('bookings').push();
      await bookingRef.set(bookingData);

      // Update driver's status
      await _database
          .child('users')
          .child(driver.driverId)
          .child('isBooked')
          .set(true);

      Get.closeAllDialogs();
      ToastHelper.showSuccess(
        'Booking confirmed!\nDriver will contact you shortly.',
      );

      // Refresh the drivers list
      loadDrivers();
    } catch (e) {
      debugPrint('Error confirming booking: $e');
      ToastHelper.showError('Failed to confirm booking');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(CarModel driver) async {
    try {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF5E6D3),
          title: const Text(
            'Cancel Booking',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to cancel this booking?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
              ),
              const SizedBox(height: 8),
              Text(
                'Driver: ${driver.name}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
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
                    onPressed: () => _confirmCancelBooking(driver),
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

  Future<void> _confirmCancelBooking(CarModel driver) async {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ToastHelper.showError('User not authenticated');
        return;
      }

      // Update driver's status
      await _database
          .child('users')
          .child(driver.driverId)
          .child('isBooked')
          .set(false);

      // You might want to update the booking status in the bookings node as well
      // await _database.child('bookings').child(bookingId).update({'status': 'cancelled'});

      Get.closeAllDialogs();
      ToastHelper.showSuccess('Booking cancelled successfully');

      // Refresh the drivers list
      loadDrivers();
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      ToastHelper.showError('Failed to cancel booking');
    } finally {
      isLoading.value = false;
    }
  }
}

class CarModel {
  final String driverId;
  final String name;
  final String carModel;
  final String persons;
  final String price;
  final String image;
  final String driverImage;
  final String phoneNumber;
  final String vehicleColor;
  final String plateNumber;
  final String yearOfManufacture;
  final bool isBooked;
  final bool isBookedByCurrentUser;

  CarModel({
    required this.driverId,
    required this.name,
    required this.carModel,
    required this.persons,
    required this.price,
    required this.image,
    required this.driverImage,
    required this.phoneNumber,
    required this.vehicleColor,
    required this.plateNumber,
    required this.yearOfManufacture,
    this.isBooked = false,
    this.isBookedByCurrentUser = false,
  });
}
