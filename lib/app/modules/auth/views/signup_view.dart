import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/utils/animation_helper.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

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
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.black54),
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
                            'Registration',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                          const Text(
                            'Create Your Account',
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
                                AnimationHelper.slideInFromBottom(
                                  TextField(
                                    controller: controller.signupNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black38),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.brown),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AnimationHelper.slideInFromBottom(
                                  TextField(
                                    controller:
                                        controller.signupEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'E-mail',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black38),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.brown),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AnimationHelper.slideInFromBottom(
                                  TextField(
                                    controller:
                                        controller.signupPhoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black38),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.brown),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AnimationHelper.slideInFromBottom(
                                  Obx(() => TextField(
                                        controller:
                                            controller.signupPasswordController,
                                        obscureText:
                                            !controller.isPasswordVisible.value,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(
                                              color: Colors.black54),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.brown),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.isPasswordVisible.value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.black54,
                                            ),
                                            onPressed: controller
                                                .togglePasswordVisibility,
                                          ),
                                        ),
                                      )),
                                ),
                                const SizedBox(height: 20),
                                AnimationHelper.slideInFromBottom(
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller:
                                            controller.signupPinController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'PIN (4 digits)',
                                          labelStyle: const TextStyle(
                                              color: Colors.black54),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.brown),
                                          ),
                                          errorText:
                                              controller.pinError.value.isEmpty
                                                  ? null
                                                  : controller.pinError.value,
                                          counterText: '',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'This PIN will be used for quick access',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Colors.black54.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                AnimationHelper.scaleIn(
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.signUp(
                                          controller.signupNameController.text,
                                          controller.signupEmailController.text
                                              .trim(),
                                          controller.signupPhoneController.text,
                                          controller
                                              .signupPasswordController.text,
                                          controller.signupPinController.text,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFBE9B7B),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Obx(
                                        () => controller.isLoading.value
                                            ? const CircularProgressIndicator(
                                                color: Colors.white)
                                            : const Text(
                                                'SIGN UP',
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
