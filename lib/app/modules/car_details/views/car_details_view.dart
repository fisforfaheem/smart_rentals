import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/car_details_controller.dart';

class CarDetailsView extends GetView<CarDetailsController> {
  final String name;
  final String carModel;
  final String persons;
  final String price;
  final String image;
  final String driverImage;

  const CarDetailsView({
    required this.name,
    required this.carModel,
    required this.persons,
    required this.price,
    required this.image,
    required this.driverImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2B48C),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black54),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Live Sensor Data for $name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Live Status Indicator
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(height: 30),

                      // Live Sensor Data
                      Obx(
                        () => Column(
                          children: [
                            // Accident Detection Status
                            _buildStatusCard(),
                            const SizedBox(height: 20),

                            // Temperature Readings
                            _buildTemperatureCard(
                              'Ambient Temperature',
                              controller.ambientCelsius.value,
                              controller.ambientFahrenheit.value,
                            ),
                            const SizedBox(height: 15),
                            _buildTemperatureCard(
                              'Body Temperature',
                              controller.objectCelsius.value,
                              controller.objectFahrenheit.value,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:
              controller.isAccidentDetected.value
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.isAccidentDetected.value
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle,
              color:
                  controller.isAccidentDetected.value
                      ? Colors.red
                      : Colors.green,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              controller.isAccidentDetected.value
                  ? 'Accident Detected!'
                  : 'Vehicle Status: Normal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    controller.isAccidentDetected.value
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
              color: Color(0xFF4A4A4A),
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
          style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
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
