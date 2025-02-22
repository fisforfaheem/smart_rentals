import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/driver_controller.dart';

class DriverProfileView extends GetView<DriverController> {
  const DriverProfileView({super.key});

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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFBE9B7B),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Driver Profile',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const Text(
                          'Update Your Information',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 40),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildTextField(
                                'Name',
                                controller.nameController,
                                controller.isEditing.value,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                'Email',
                                controller.emailController,
                                false, // Email should not be editable
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                'Phone Number',
                                controller.phoneController,
                                controller.isEditing.value,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                'License Number',
                                controller.licenseNumberController,
                                controller.isEditing.value,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                'Vehicle Plate Number',
                                controller.plateNumberController,
                                controller.isEditing.value,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                'Vehicle Color',
                                controller.vehicleColorController,
                                controller.isEditing.value,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                'Vehicle Capacity',
                                controller.vehicleCapacityController,
                                controller.isEditing.value,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                'Year of Manufacture',
                                controller.yearOfManufactureController,
                                controller.isEditing.value,
                              ),
                              const SizedBox(height: 40),

                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed:
                                      controller.isLoading.value
                                          ? null
                                          : () {
                                            if (controller.isEditing.value) {
                                              controller.updateProfile();
                                            } else {
                                              controller.isEditing.value = true;
                                            }
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFBE9B7B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child:
                                      controller.isLoading.value
                                          ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : Text(
                                            controller.isEditing.value
                                                ? 'SAVE'
                                                : 'EDIT',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController textController,
    bool isEditing,
  ) {
    return TextField(
      controller: textController,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.brown),
        ),
      ),
    );
  }
}
