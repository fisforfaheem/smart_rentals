import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/car1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),

            const Spacer(),
            const Spacer(),
            const Spacer(),

            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),

            // Welcome Text
            Container(
              // color: const Color(0xFFBE9B7B).withOpacity(0.4),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: const Text(
                'Welcome To Our App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Start Button
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFBE9B7B).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'START',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
