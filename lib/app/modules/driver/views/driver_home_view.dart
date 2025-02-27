import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/driver_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../car_details/controllers/car_details_controller.dart';
import '../../../data/services/auth_service.dart';

class DriverHomeView extends GetView<DriverController> {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2B48C),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 25),
                _buildCarStatus(),
                const SizedBox(height: 25),
                _buildSensorStats(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚗 Driver Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Monitor your car status 📊',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Get.toNamed('/driver-profile'),
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  final authService = Get.find<AuthService>();
                  await authService.signOut();
                  Get.offAllNamed(
                    '/role-selection',
                  ); // Navigate to role selection after logout
                } catch (e) {
                  debugPrint('Error during logout: $e');
                  Get.snackbar(
                    'Error',
                    'Failed to logout. Please try again.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Car Status 🚙',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _buildStatusItem(
                    icon: Icons.local_gas_station,
                    title: 'Available',
                    value: controller.isBooked.value ? 'No' : 'Yes',
                    color:
                        controller.isBooked.value ? Colors.red : Colors.green,
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => _buildStatusItem(
                    icon: Icons.person,
                    title: 'Current Bookings',
                    value: controller.isBooked.value ? '1' : '0',
                    color:
                        controller.isBooked.value
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    controller.isBooked.value
                        ? Icons.car_rental
                        : Icons.local_taxi,
                    color:
                        controller.isBooked.value ? Colors.red : Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    controller.isBooked.value
                        ? 'Currently Booked 🚫'
                        : 'Available for Booking ✅',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          controller.isBooked.value ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (controller.isBooked.value)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.cancelCurrentBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text(
                    'Cancel Current Booking',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorStats() {
    final carDetailsController = Get.find<CarDetailsController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Sensor Data 📡',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      color: Colors.green,
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Live Sensor Data
          Obx(
            () => Column(
              children: [
                // Accident Detection Status
                _buildStatusCard(carDetailsController),
                const SizedBox(height: 20),

                // Temperature Readings
                _buildTemperatureCard(
                  'Body Temperature',
                  carDetailsController.objectCelsius.value,
                  carDetailsController.objectFahrenheit.value,
                ),
                const SizedBox(height: 15),
                _buildTemperatureCard(
                  'Environment Temperature',
                  carDetailsController.ambientCelsius.value,
                  carDetailsController.ambientFahrenheit.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(CarDetailsController carDetailsController) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:
              carDetailsController.isAccidentDetected.value
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              carDetailsController.isAccidentDetected.value
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle,
              color:
                  carDetailsController.isAccidentDetected.value
                      ? Colors.red
                      : Colors.green,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              carDetailsController.isAccidentDetected.value
                  ? 'Accident Detected! ⚠️'
                  : 'Vehicle Status: Normal ✅',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    carDetailsController.isAccidentDetected.value
                        ? Colors.red
                        : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureCard(
    String title,
    double celsius,
    double fahrenheit,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _getTemperatureColor(celsius).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTemperatureDisplay('Celsius', celsius, '°C'),
              _buildTemperatureDisplay('Fahrenheit', fahrenheit, '°F'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureDisplay(String label, double value, String unit) {
    final color = _getTemperatureColor(value);
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getTemperatureColor(double celsius) {
    if (celsius > CarDetailsController.highTempThreshold) {
      return Colors.red;
    } else if (celsius < CarDetailsController.lowTempThreshold) {
      return Colors.blue;
    }
    return Colors.green;
  }
}
