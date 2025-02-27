enum Gender { male, female, other }

class DriverModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String pin;
  final DateTime createdAt;
  final String licenseNumber;
  final String plateNumber;
  final String vehicleColor;
  final int vehicleCapacity;
  final DateTime vehicleYearOfManufacture;
  final Gender gender;
  final bool isAvailable;
  final double rating;
  final int totalRides;

  DriverModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.pin,
    required this.createdAt,
    required this.licenseNumber,
    required this.plateNumber,
    required this.vehicleColor,
    required this.vehicleCapacity,
    required this.vehicleYearOfManufacture,
    required this.gender,
    this.isAvailable = true,
    this.rating = 0.0,
    this.totalRides = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'pin': pin,
      'createdAt': createdAt.toIso8601String(),
      'licenseNumber': licenseNumber,
      'plateNumber': plateNumber,
      'vehicleColor': vehicleColor,
      'vehicleCapacity': vehicleCapacity,
      'vehicleYearOfManufacture': vehicleYearOfManufacture.toIso8601String(),
      'gender': gender.toString(),
      'isAvailable': isAvailable,
      'rating': rating,
      'totalRides': totalRides,
    };
  }

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      pin: json['pin'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      licenseNumber: json['licenseNumber'] as String,
      plateNumber: json['plateNumber'] as String,
      vehicleColor: json['vehicleColor'] as String,
      vehicleCapacity: json['vehicleCapacity'] as int,
      vehicleYearOfManufacture: DateTime.parse(
        json['vehicleYearOfManufacture'] as String,
      ),
      gender: Gender.values.firstWhere(
        (e) => e.toString() == json['gender'],
        orElse: () => Gender.other,
      ),
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRides: json['totalRides'] as int? ?? 0,
    );
  }
}
