import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/driver_controller.dart';
import '../../../data/models/driver_model.dart';

class DriverProfileView extends GetView<DriverController> {
  const DriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2B48C),
      body: SafeArea(
        child: Obx(
          () =>
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: _getGenderColor(
                                  controller.gender.value,
                                ).withOpacity(0.1),
                                child: Icon(
                                  _getGenderIcon(controller.gender.value),
                                  size: 60,
                                  color: _getGenderColor(
                                    controller.gender.value,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.brown,
                                      width: 2,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: controller.toggleAvailability,
                                    child: Icon(
                                      controller.isAvailable.value
                                          ? Icons.check_circle
                                          : Icons.do_not_disturb,
                                      color:
                                          controller.isAvailable.value
                                              ? Colors.green
                                              : Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            controller.name.value,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.email.value,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Rest of the profile view...
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  IconData _getGenderIcon(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Icons.face;
      case Gender.female:
        return Icons.face_3;
      case Gender.other:
        return Icons.person_outline;
    }
  }

  Color _getGenderColor(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Colors.blue;
      case Gender.female:
        return Colors.pink;
      case Gender.other:
        return Colors.grey;
    }
  }
}
