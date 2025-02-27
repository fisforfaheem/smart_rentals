import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/driver_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/biometric_service.dart';
import 'package:flutter/services.dart'; // Add this import for TextInputFormatters
import 'package:flutter/foundation.dart'; // Add this import for debugPrint
import 'package:intl/intl.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final BiometricService _biometricService = Get.find<BiometricService>();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isDriverRegistration = false.obs;
  final Rx<Gender> selectedGender = Gender.male.obs;

  // Form validation
  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString pinError = ''.obs;

  // Login controllers
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetEmailController = TextEditingController();

  // Signup controllers
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPhoneController = TextEditingController();
  final TextEditingController signupPasswordController =
      TextEditingController();
  final TextEditingController signupPinController = TextEditingController();

  // Driver-specific controllers
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController vehicleColorController = TextEditingController();
  final TextEditingController vehicleCapacityController =
      TextEditingController();
  final TextEditingController vehicleModelController = TextEditingController();
  final Rx<DateTime?> vehicleYearOfManufacture = Rx<DateTime?>(null);

  // Driver-specific error states
  final RxString licenseNumberError = ''.obs;
  final RxString plateNumberError = ''.obs;
  final RxString vehicleColorError = ''.obs;
  final RxString vehicleCapacityError = ''.obs;
  final RxString vehicleYomError = ''.obs;

  @override
  void onClose() {
    clearLoginFields();
    clearSignupFields();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please login or use a different email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many password reset attempts. Please try again later.';
      case 'missing-email':
        return 'Please enter your email address.';
      case 'auth/network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return null;
    }
  }

  bool validateFields() {
    bool isValid = true;

    // Reset previous errors
    nameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    pinError.value = '';

    // Name validation
    if (signupNameController.text.trim().isEmpty) {
      nameError.value = 'Name is required';
      ToastHelper.showError('Please enter your name');
      isValid = false;
    }

    // Email validation
    if (signupEmailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      ToastHelper.showError('Please enter your email');
      isValid = false;
    } else if (!GetUtils.isEmail(signupEmailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      ToastHelper.showError('Please enter a valid email address');
      isValid = false;
    }

    // Phone validation
    if (signupPhoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      ToastHelper.showError('Please enter your phone number');
      isValid = false;
    } else if (!GetUtils.isPhoneNumber(signupPhoneController.text.trim())) {
      phoneError.value = 'Please enter a valid phone number';
      ToastHelper.showError('Please enter a valid phone number');
      isValid = false;
    }

    // Password validation
    if (signupPasswordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      ToastHelper.showError('Please enter a password');
      isValid = false;
    } else if (signupPasswordController.text.length < 4) {
      passwordError.value = 'Password must be at least 4 characters';
      ToastHelper.showError('Password must be at least 4 characters long');
      isValid = false;
    }

    // PIN validation
    if (signupPinController.text.isEmpty) {
      pinError.value = 'PIN is required';
      ToastHelper.showError('Please enter a 4-digit PIN');
      isValid = false;
    } else if (signupPinController.text.length != 4) {
      pinError.value = 'PIN must be 4 digits';
      ToastHelper.showError('PIN must be exactly 4 digits');
      isValid = false;
    }

    // Driver-specific validations
    if (isDriverRegistration.value) {
      if (licenseNumberController.text.trim().isEmpty) {
        licenseNumberError.value = 'License number is required';
        ToastHelper.showError('Please enter your license number');
        isValid = false;
      }

      if (plateNumberController.text.trim().isEmpty) {
        plateNumberError.value = 'Plate number is required';
        ToastHelper.showError('Please enter your vehicle plate number');
        isValid = false;
      }

      if (vehicleColorController.text.trim().isEmpty) {
        vehicleColorError.value = 'Vehicle color is required';
        ToastHelper.showError('Please enter your vehicle color');
        isValid = false;
      }

      if (vehicleCapacityController.text.trim().isEmpty) {
        vehicleCapacityError.value = 'Vehicle capacity is required';
        ToastHelper.showError('Please enter your vehicle capacity');
        isValid = false;
      }

      if (vehicleYearOfManufacture.value == null) {
        vehicleYomError.value = 'Year of manufacture is required';
        ToastHelper.showError('Please select vehicle year of manufacture');
        isValid = false;
      }
    }

    return isValid;
  }

  void clearSignupFields() {
    signupNameController.clear();
    signupEmailController.clear();
    signupPhoneController.clear();
    signupPasswordController.clear();
    signupPinController.clear();
    licenseNumberController.clear();
    plateNumberController.clear();
    vehicleColorController.clear();
    vehicleCapacityController.clear();
    vehicleYearOfManufacture.value = null;
    isPasswordVisible.value = false;
    isLoading.value = false;
    isDriverRegistration.value = false;
    selectedGender.value = Gender.male;

    // Clear all error states
    nameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    pinError.value = '';
    licenseNumberError.value = '';
    plateNumberError.value = '';
    vehicleColorError.value = '';
    vehicleCapacityError.value = '';
    vehicleYomError.value = '';
  }

  void handleSignupError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          ToastHelper.showError('Email is already registered');
          break;
        case 'invalid-email':
          ToastHelper.showError('Invalid email format');
          break;
        case 'weak-password':
          ToastHelper.showError('Password is too weak');
          break;
        default:
          ToastHelper.showError('Signup failed: ${e.message}');
      }
    } else {
      ToastHelper.showError('An unexpected error occurred');
    }
  }

  Future<void> handleSignup() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      final credential = await _authService.createUserWithEmailAndPassword(
        signupEmailController.text.trim(),
        signupPasswordController.text,
      );

      if (credential?.user != null) {
        final userId = credential!.user!.uid;
        final userRole = isDriverRegistration.value ? 'driver' : 'user';

        final userData = {
          'name': signupNameController.text.trim(),
          'email': signupEmailController.text.trim(),
          'phone': signupPhoneController.text.trim(),
          'pin': signupPinController.text,
          'createdAt': ServerValue.timestamp,
          'role': userRole,
          'gender': selectedGender.value.toString().split('.').last,
        };

        if (isDriverRegistration.value) {
          // Add driver-specific data
          userData['vehicleDetails'] = {
            'plateNumber': plateNumberController.text.trim(),
            'color': vehicleColorController.text.trim(),
            'capacity': int.parse(vehicleCapacityController.text.trim()),
            'yearOfManufacture':
                vehicleYearOfManufacture.value?.toIso8601String(),
            'licenseNumber': licenseNumberController.text.trim(),
          };
          userData['isAvailable'] = true;
          userData['isBooked'] = false;
        }

        await _database.child('users').child(userId).set(userData);

        clearSignupFields();
        ToastHelper.showSuccess('Account created successfully');

        // Route based on role
        if (userRole == 'driver') {
          Get.offAllNamed('/driver-home');
        } else {
          Get.offAllNamed('/home');
        }
      }
    } catch (e) {
      handleSignupError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleLogin() async {
    try {
      isLoading.value = true;

      final credential = await _authService.signInWithEmailAndPassword(
        loginEmailController.text.trim(),
        passwordController.text,
      );

      if (credential?.user != null) {
        final userId = credential!.user!.uid;
        final userSnapshot = await _database.child('users').child(userId).get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<dynamic, dynamic>;
          final userRole = userData['role'] as String?;

          clearLoginFields();
          ToastHelper.showSuccess('Login successful');

          // Route based on role
          if (userRole == 'driver') {
            Get.offAllNamed('/driver-home');
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          ToastHelper.showError('User data not found');
        }
      }
    } catch (e) {
      handleLoginError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/login'); // Navigate to login after logout
    } catch (e) {
      ToastHelper.showError('Error signing out: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      ToastHelper.showError('Please enter your email');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      ToastHelper.showError('Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;
      debugPrint('Starting password reset for email: $email');

      final trimmedEmail = email.trim().toLowerCase();
      await _authService.sendPasswordResetEmail(trimmedEmail);

      Get.closeAllDialogs();

      ToastHelper.showSuccess(
        'Password reset link sent to $trimmedEmail\nPlease check your email inbox and spam folder.',
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email address';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later';
          break;
        default:
          message =
              _getFirebaseErrorMessage(e.code) ??
              'Failed to send reset link. Please try again.';
      }
      ToastHelper.showError(message);
    } catch (e) {
      debugPrint('Unexpected error: $e');
      ToastHelper.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear login fields
  void clearLoginFields() {
    loginEmailController.clear();
    passwordController.clear();
    isPasswordVisible.value = false;
    isLoading.value = false;
    isDriverRegistration.value = false;
  }

  // Add method to clear driver fields
  void clearDriverFields() {
    licenseNumberController.clear();
    plateNumberController.clear();
    vehicleColorController.clear();
    vehicleCapacityController.clear();
    vehicleYearOfManufacture.value = null;
  }

  // Add method to pick year of manufacture
  Future<void> pickYearOfManufacture(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      vehicleYearOfManufacture.value = picked;
    }
  }

  // Update the PIN verification method to handle roles
  Future<void> verifyPinAndNavigate(String enteredPin, String uid) async {
    try {
      isLoading.value = true;

      // Get user data from Firebase
      final userSnapshot = await _database.child('users').child(uid).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.value as Map<dynamic, dynamic>;
        final storedPin = userData['pin'] as String;
        final userRole = userData['role'] as String?;

        if (storedPin == enteredPin) {
          Get.closeAllDialogs(); // Close PIN dialog

          // Route based on role
          if (userRole == 'driver') {
            Get.offAllNamed('/driver-home');
          } else {
            Get.offAllNamed('/home');
          }

          ToastHelper.showSuccess('Welcome back!');
        } else {
          ToastHelper.showError('Incorrect PIN');
        }
      } else {
        ToastHelper.showError('User data not found');
      }
    } catch (e) {
      ToastHelper.showError('Error verifying PIN');
    } finally {
      isLoading.value = false;
    }
  }

  // Update the showPinVerificationDialog to handle roles
  void showPinVerificationDialog(String uid) {
    final TextEditingController pinController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF5E6D3),
        title: const Text(
          'Enter PIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please enter your 4-digit PIN to continue',
              style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                color: Color(0xFF4A4A4A),
              ),
              decoration: InputDecoration(
                labelText: 'PIN',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFBE9B7B)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFBE9B7B),
                    width: 2,
                  ),
                ),
                counterText: '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onSubmitted: (_) => verifyPinAndNavigate(pinController.text, uid),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    signOut();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
              ),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        isLoading.value
                            ? null
                            : () =>
                                verifyPinAndNavigate(pinController.text, uid),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBE9B7B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child:
                        isLoading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Add these methods to AuthController
  void validateName(String value) {
    if (value.trim().isEmpty) {
      nameError.value = 'Name is required';
    } else {
      nameError.value = '';
    }
  }

  void validateEmail(String value) {
    if (value.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value.trim())) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }

  void validatePhone(String value) {
    if (value.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
    } else if (!GetUtils.isPhoneNumber(value.trim())) {
      phoneError.value = 'Please enter a valid phone number';
    } else {
      phoneError.value = '';
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 4) {
      passwordError.value = 'Password must be at least 4 characters';
    } else {
      passwordError.value = '';
    }
  }

  void validatePin(String value) {
    if (value.isEmpty) {
      pinError.value = 'PIN is required';
    } else if (value.length != 4) {
      pinError.value = 'PIN must be 4 digits';
    } else {
      pinError.value = '';
    }
  }

  void setGender(Gender gender) {
    selectedGender.value = gender;
  }

  void handleLoginError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          ToastHelper.showError('No user found with this email');
          break;
        case 'wrong-password':
          ToastHelper.showError('Invalid password');
          break;
        case 'invalid-email':
          ToastHelper.showError('Invalid email format');
          break;
        case 'user-disabled':
          ToastHelper.showError('This account has been disabled');
          break;
        case 'too-many-requests':
          ToastHelper.showError(
            'Too many login attempts. Please try again later',
          );
          break;
        default:
          ToastHelper.showError('Login failed: ${e.message}');
      }
    } else {
      ToastHelper.showError('An unexpected error occurred');
    }
  }

  void showResetPasswordDialog() {
    resetEmailController.clear();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF5E6D3),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address to receive a password reset link.',
              style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFBE9B7B)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFBE9B7B),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFFBE9B7B),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
              ),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        isLoading.value
                            ? null
                            : () => forgotPassword(
                              resetEmailController.text.trim(),
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBE9B7B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child:
                        isLoading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Send Reset Link',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
