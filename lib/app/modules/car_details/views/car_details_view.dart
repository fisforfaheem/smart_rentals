import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/animation_helper.dart';

class CarDetailsView extends GetView {
  final String name;
  final String carModel;
  final String persons;
  final String price;
  final String image;
  final String driverImage;

  const CarDetailsView({
    super.key,
    required this.name,
    required this.carModel,
    required this.persons,
    required this.price,
    required this.image,
    required this.driverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2B48C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              AnimationHelper.fadeIn(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'Sensor Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () => Get.offAllNamed('/login'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Sensor Cards
              AnimationHelper.slideInFromBottom(
                _buildSensorCard(
                  'Temperature Sensor',
                  'Detection: no life / life',
                  'assets/sensor2.png',
                ),
              ),

              const SizedBox(height: 15),

              AnimationHelper.slideInFromBottom(
                _buildSensorCard(
                  'Reflective and through-beam sensors',
                  'Detection: accident or not',
                  'assets/sensor.png',
                ),
              ),

              const SizedBox(height: 15),

              // Car and Driver Info
              AnimationHelper.slideInFromBottom(
                _buildSensorCard(
                  name,
                  '$carModel\nFor $persons persone',
                  driverImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorCard(String title, String subtitle, String image) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 