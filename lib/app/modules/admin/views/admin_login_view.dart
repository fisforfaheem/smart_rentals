import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../../../core/utils/animation_helper.dart';

class AdminLoginView extends GetView<AdminController> {
  const AdminLoginView({super.key});

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
                AnimationHelper.fadeIn(
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () => Get.back(),
                  ),
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
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Admin Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const Text(
                        'Welcome Back Admin',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Form fields here (similar to LoginView)
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