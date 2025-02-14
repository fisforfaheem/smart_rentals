import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/animation_helper.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bac1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Title
                AnimationHelper.fadeIn(
                  const Text(
                    'Choose Your Role',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Admin Option
                AnimationHelper.slideInFromBottom(
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed('/login');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            size: 60,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Manage rentals and users',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // User Option
                AnimationHelper.slideInFromBottom(
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed('/login');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBE9B7B).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFBE9B7B).withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'User',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Rent cars and manage bookings',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
