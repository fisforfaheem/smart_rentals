import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart'; // Add this for Colors
import '../../../core/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class CarDetailsController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  // Observable values for sensor data
  final RxDouble ambientCelsius = 0.0.obs;
  final RxDouble ambientFahrenheit = 0.0.obs;
  final RxDouble objectCelsius = 0.0.obs;
  final RxDouble objectFahrenheit = 0.0.obs;
  final RxBool isAccidentDetected = false.obs;

  // Update thresholds for body temperature
  static const double highTempThreshold = 37.5; // High fever threshold
  static const double lowTempThreshold = 35.0;  // Hypothermia threshold

  StreamSubscription? _sensorSubscription;

  @override
  void onInit() {
    super.onInit();
    _initSensorDataStream();
  }

  void _initSensorDataStream() {
    debugPrint('Initializing sensor stream...');

    try {
      // Print database URL to verify connection
      debugPrint('Database URL: ${FirebaseDatabase.instance.databaseURL}');

      // Set persistence for offline capability
      FirebaseDatabase.instance.setPersistenceEnabled(true);

      // Keep sensor data synced
      _database.child('sensorData').keepSynced(true);

      _sensorSubscription = _database
          .child('sensorData')
          .onValue
          .listen(
            (event) {
              debugPrint('Connection state: ${_database.ref.key}');
              debugPrint('Raw data received: ${event.snapshot.value}');

              if (event.snapshot.value != null) {
                try {
                  final data = event.snapshot.value as Map<dynamic, dynamic>;
                  debugPrint('Parsed data structure: ${data.keys}');

                  final bodyTemp =
                      data['bodyTemperature'] as Map<dynamic, dynamic>;
                  debugPrint('Temperature data: $bodyTemp');

                  // Update values
                  ambientCelsius.value = _parseDouble(
                    bodyTemp['ambientCelsius'],
                  );
                  ambientFahrenheit.value = _parseDouble(
                    bodyTemp['ambientFahrenheit'],
                  );
                  objectCelsius.value = _parseDouble(bodyTemp['objectCelsius']);
                  objectFahrenheit.value = _parseDouble(
                    bodyTemp['objectFahrenheit'],
                  );
                  isAccidentDetected.value =
                      (data['accidentDetected'] ?? 0) == 1;

                  debugPrint(
                    'Successfully updated values - AC: ${ambientCelsius.value}, OC: ${objectCelsius.value}',
                  );
                  _checkWarnings();
                } catch (e, stack) {
                  debugPrint('Error parsing data: $e');
                  debugPrint('Stack trace: $stack');
                }
              } else {
                debugPrint('Warning: Received null data from Firebase');
              }
            },
            onError: (error) {
              debugPrint('Firebase Error: $error');
            },
            cancelOnError: false,
          );
    } catch (e) {
      debugPrint('Error setting up Firebase stream: $e');
    }
  }

  // Helper method to safely parse doubles
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  void _checkWarnings() {
    if (isAccidentDetected.value) {
      Get.snackbar(
        'Warning!',
        'Accident detected! Emergency services have been notified.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.top,
      );

      _notificationService.showNotification(
        title: '🚨 Emergency Alert!',
        body: 'Accident detected! Emergency services have been notified.',
        priority: Priority.max,
      );
    }

    if (objectCelsius.value > highTempThreshold) {
      Get.snackbar(
        'High Body Temperature Alert',
        'Driver\'s body temperature is above normal levels!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      _notificationService.showNotification(
        title: '🌡️ High Body Temperature Warning',
        body: 'Driver\'s temperature is elevated: ${objectCelsius.value.toStringAsFixed(1)}°C - Please check on driver',
        priority: Priority.high,
      );
    }

    if (objectCelsius.value < lowTempThreshold) {
      Get.snackbar(
        'Low Body Temperature Alert',
        'Driver\'s body temperature is below normal levels!',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      _notificationService.showNotification(
        title: '❄️ Low Body Temperature Warning',
        body: 'Driver\'s temperature has dropped: ${objectCelsius.value.toStringAsFixed(1)}°C - Please check on driver',
        priority: Priority.high,
      );
    }
  }

  @override
  void onClose() {
    _sensorSubscription?.cancel();
    super.onClose();
  }
}
