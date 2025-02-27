import 'package:flutter/material.dart';
import '../../../data/models/driver_model.dart';

class CarModel {
  final String driverId;
  final String name;
  final String carModel;
  final String persons;
  final String image;
  final IconData driverIcon;
  final Color driverIconColor;
  final String phoneNumber;
  final String vehicleColor;
  final String plateNumber;
  final String yearOfManufacture;
  final bool isBooked;
  final bool isBookedByCurrentUser;
  final Gender gender;
  final double pricePerHour;

  CarModel({
    required this.driverId,
    required this.name,
    required this.carModel,
    required this.persons,
    required this.image,
    String? driverImage,
    required this.phoneNumber,
    required this.vehicleColor,
    required this.plateNumber,
    required this.yearOfManufacture,
    this.isBooked = false,
    this.isBookedByCurrentUser = false,
    required this.gender,
    required this.pricePerHour,
  }) : driverIcon = _getDriverIcon(gender),
       driverIconColor = _getDriverIconColor(gender);

  static IconData _getDriverIcon(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Icons.face;
      case Gender.female:
        return Icons.face_3;
      case Gender.other:
        return Icons.person_outline;
    }
  }

  static Color _getDriverIconColor(Gender gender) {
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
