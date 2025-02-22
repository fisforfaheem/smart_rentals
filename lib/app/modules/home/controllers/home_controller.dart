import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/toast_helper.dart';

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
      
      // Get all users from Firebase
      final snapshot = await _database.child('users').get();
      
      if (snapshot.exists) {
        final allUsers = snapshot.value as Map<dynamic, dynamic>;
        final List<CarModel> driversList = [];

        // Filter and map users where role is 'driver'
        allUsers.forEach((key, value) {
          if (value is Map && value['role'] == 'driver') {
            final driverDetails = value['driverDetails'] as Map<dynamic, dynamic>?;
            final vehicleDetails = driverDetails?['vehicleDetails'] as Map<dynamic, dynamic>?;

            if (vehicleDetails != null) {
              driversList.add(CarModel(
                name: value['name'] ?? 'Unknown Driver',
                carModel: 'Vehicle', // You might want to add a vehicle model field in your database
                persons: vehicleDetails['capacity']?.toString() ?? '0',
                price: '\$180/day', // You might want to add a price field in your database
                image: 'assets/car2.png', // Default image for now
                driverImage: 'assets/dri1.png', // Default driver image
                phoneNumber: value['phone'] ?? '',
                vehicleColor: vehicleDetails['color'] ?? '',
                plateNumber: vehicleDetails['plateNumber'] ?? '',
                yearOfManufacture: vehicleDetails['yearOfManufacture'] ?? '',
              ));
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
    
    filteredCars.value = cars.where((car) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              Text(
                'Capacity: ${driver.persons} persons',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A4A4A),
                ),
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
                    onPressed: () => Get.back(),
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
      // Here you would typically:
      // 1. Create a booking record in Firebase
      // 2. Update driver's availability status
      // 3. Send notifications to driver and user
      // For now, we'll just show a success message
      
      ToastHelper.showSuccess(
        'Booking confirmed!\nDriver will contact you shortly.',
      );
      
      // Navigate to booking details or confirmation screen
      Get.toNamed('/car-details', arguments: {
        'name': driver.name,
        'carModel': driver.carModel,
        'persons': driver.persons,
        'price': driver.price,
        'image': driver.image,
        'driverImage': driver.driverImage,
      });
    } catch (e) {
      debugPrint('Error confirming booking: $e');
      ToastHelper.showError('Failed to confirm booking');
    }
  }
}

class CarModel {
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
  final RxBool isBooked = false.obs;

  CarModel({
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
  });
} 