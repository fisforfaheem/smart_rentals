import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/utils/toast_helper.dart';
import 'package:get/get_utils/get_utils.dart';
import '../../../core/utils/animation_helper.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          controller.clearLoginFields();
                          Get.offAllNamed('/role-selection');
                        },
                      ),
                    ),
                    const SizedBox(height: 60),
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
                            'Sign In',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                          const Text(
                            'Hello, Welcome Again',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Form Fields
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                // Email Field with animation
                                AnimationHelper.slideInFromBottom(
                                  TextField(
                                    controller: controller.loginEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'E-mail',
                                      labelStyle: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black38,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Password Field with animation
                                AnimationHelper.slideInFromBottom(
                                  Obx(
                                    () => TextField(
                                      controller: controller.passwordController,
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black38,
                                              ),
                                            ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.brown,
                                              ),
                                            ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            controller.isPasswordVisible.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.black54,
                                          ),
                                          onPressed:
                                              controller
                                                  .togglePasswordVisibility,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Forgot Password with fade animation
                                AnimationHelper.fadeIn(
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed:
                                          () =>
                                              controller
                                                  .showResetPasswordDialog(),
                                      child: const Text(
                                        'Forgot your password?',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Login Button with scale animation
                                AnimationHelper.scaleIn(
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () => controller.handleLogin(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFBE9B7B,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Obx(
                                        () =>
                                            controller.isLoading.value
                                                ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                                : const Text(
                                                  'SIGN IN',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Sign Up Button with fade animation
                                AnimationHelper.fadeIn(
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: TextButton(
                                      onPressed: () => Get.toNamed('/signup'),
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'SIGN UP',
                                        style: TextStyle(
                                          color: Color(0xFF4A4A4A),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
