import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsView extends GetView {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String name = args['name'] ?? 'Car Name';
    final String carModel = args['carModel'] ?? 'Model';
    final String persons = args['persons'] ?? '4';
    final String price = args['price'] ?? '\$50/day';
    final String image = args['image'] ?? 'assets/car1.jpg';
    final String driverImage = args['driverImage'] ?? 'assets/dri1.png';

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
                      // Car Image
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Car Details
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Model: $carModel\nSeats: $persons\nPrice: $price',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Get.toNamed(
                                '/car-details',
                                arguments: {
                                  'name': name,
                                  'carModel': carModel,
                                  'persons': persons,
                                  'price': price,
                                  'image': image,
                                  'driverImage': driverImage,
                                },
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBE9B7B),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'View Stats/Sensors',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
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
} 