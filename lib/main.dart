import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/biometric_service.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'app/core/services/notification_service.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firebase Database with the URL
    FirebaseDatabase.instance.databaseURL =
        'https://carrental-343fb-default-rtdb.firebaseio.com'; // Make sure this matches your Firebase URL

    // Put AuthService as permanent
    Get.put(AuthService(), permanent: true);
    Get.put(BiometricService());

    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();
    Get.put(notificationService);

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Car Rental App',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
