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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Driver Profile 🧑‍✈️',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isEditing.value ? Icons.save : Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                if (controller.isEditing.value) {
                  controller.updateProfile();
                } else {
                  controller.isEditing.value = true;
                }
              },
            ),
          ),
        ],
      ),
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
                          // Profile Header with Avatar and Status
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Obx(
                                () => CircleAvatar(
                                  radius: 60,
                                  backgroundColor: _getGenderColor(
                                    controller.gender.value,
                                  ).withOpacity(0.1),
                                  child:
                                      controller.isEditing.value
                                          ? PopupMenuButton<Gender>(
                                            icon: Icon(
                                              _getGenderIcon(
                                                controller.gender.value,
                                              ),
                                              size: 60,
                                              color: _getGenderColor(
                                                controller.gender.value,
                                              ),
                                            ),
                                            onSelected: (Gender gender) {
                                              controller.gender.value = gender;
                                            },
                                            itemBuilder:
                                                (BuildContext context) => [
                                                  PopupMenuItem(
                                                    value: Gender.male,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.face,
                                                          color:
                                                              _getGenderColor(
                                                                Gender.male,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        const Text('Male'),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: Gender.female,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.face_3,
                                                          color:
                                                              _getGenderColor(
                                                                Gender.female,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        const Text('Female'),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: Gender.other,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.person_outline,
                                                          color:
                                                              _getGenderColor(
                                                                Gender.other,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        const Text('Other'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                          )
                                          : Icon(
                                            _getGenderIcon(
                                              controller.gender.value,
                                            ),
                                            size: 60,
                                            color: _getGenderColor(
                                              controller.gender.value,
                                            ),
                                          ),
                                ),
                              ),
                              // Positioned(
                              //   bottom: 0,
                              //   right: 0,
                              //   child: Container(
                              //     padding: const EdgeInsets.all(8),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       shape: BoxShape.circle,
                              //       border: Border.all(
                              //         color: Colors.brown,
                              //         width: 2,
                              //       ),
                              //     ),
                              //     child: InkWell(
                              //       onTap: controller.toggleAvailability,
                              //       child: Icon(
                              //         controller.isAvailable.value
                              //             ? Icons.check_circle
                              //             : Icons.do_not_disturb,
                              //         color:
                              //             controller.isAvailable.value
                              //                 ? Colors.green
                              //                 : Colors.red,
                              //         size: 24,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Basic Information
                          Obx(
                            () =>
                                controller.isEditing.value
                                    ? _buildEditableField(
                                      controller.nameController,
                                      'Name',
                                      TextInputType.name,
                                    )
                                    : Text(
                                      controller.name.value,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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

                          // Contact Information Card
                          _buildInfoCard('Contact Information 📞', [
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? _buildEditableField(
                                        controller.phoneController,
                                        'Phone',
                                        TextInputType.phone,
                                      )
                                      : _buildInfoRow(
                                        'Phone',
                                        controller.phoneController.text,
                                      ),
                            ),
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? _buildEditableField(
                                        controller.pinController,
                                        'PIN',
                                        TextInputType.number,
                                        maxLength: 4,
                                      )
                                      : _buildInfoRow(
                                        'PIN',
                                        controller.pinController.text,
                                      ),
                            ),
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? _buildEditableField(
                                        controller.pricePerHourController,
                                        'Price per Hour',
                                        TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                        prefix: '\$',
                                      )
                                      : _buildInfoRow(
                                        'Price per Hour',
                                        '\$${controller.pricePerHourController.text}/hr',
                                      ),
                            ),
                          ]),
                          const SizedBox(height: 20),

                          // Vehicle Information Card
                          _buildInfoCard('Vehicle Information 🚗', [
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? _buildEditableField(
                                        controller.licenseNumberController,
                                        'License Number',
                                        TextInputType.text,
                                      )
                                      : _buildInfoRow(
                                        'License Number',
                                        controller.licenseNumberController.text,
                                      ),
                            ),
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? _buildEditableField(
                                        controller.plateNumberController,
                                        'Plate Number',
                                        TextInputType.text,
                                      )
                                      : _buildInfoRow(
                                        'Plate Number',
                                        controller.plateNumberController.text,
                                      ),
                            ),
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? _buildEditableField(
                                        controller.vehicleColorController,
                                        'Vehicle Color',
                                        TextInputType.text,
                                      )
                                      : _buildInfoRow(
                                        'Vehicle Color',
                                        controller.vehicleColorController.text,
                                      ),
                            ),
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? _buildEditableField(
                                        controller.vehicleCapacityController,
                                        'Capacity',
                                        TextInputType.number,
                                      )
                                      : _buildInfoRow(
                                        'Capacity',
                                        '${controller.vehicleCapacityController.text} persons',
                                      ),
                            ),
                            Obx(
                              () =>
                                  controller.isEditing.value
                                      ? InkWell(
                                        onTap:
                                            () => controller
                                                .pickYearOfManufacture(context),
                                        child: _buildInfoRow(
                                          'Year of Manufacture',
                                          controller
                                              .yearOfManufactureController
                                              .text,
                                        ),
                                      )
                                      : _buildInfoRow(
                                        'Year of Manufacture',
                                        controller
                                            .yearOfManufactureController
                                            .text,
                                      ),
                            ),
                          ]),
                          const SizedBox(height: 20),

                          // Status Information Card
                          _buildInfoCard('Status 📊', [
                            _buildInfoRow(
                              'Availability',
                              controller.isAvailable.value
                                  ? 'Available ✅'
                                  : 'Not Available ❌',
                              valueColor:
                                  controller.isAvailable.value
                                      ? Colors.green
                                      : Colors.red,
                            ),
                            _buildInfoRow(
                              'Booking Status',
                              controller.isBooked.value
                                  ? 'Currently Booked 🚫'
                                  : 'Not Booked ✅',
                              valueColor:
                                  controller.isBooked.value
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType, {
    int? maxLength,
    String? prefix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white30),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          counterStyle: const TextStyle(color: Colors.white70),
          prefixText: prefix,
          prefixStyle: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.white,
            ),
          ),
        ],
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
