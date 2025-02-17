import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/biometric_service.dart';
import 'package:flutter/services.dart'; // Add this import for TextInputFormatters

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final BiometricService _biometricService = Get.find<BiometricService>();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isDriverRegistration = false.obs;

  // Form validation
  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString pinError = ''.obs;

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetEmailController = TextEditingController();

  // Add these controllers
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPhoneController = TextEditingController();
  final TextEditingController signupPasswordController =
      TextEditingController();
  final TextEditingController signupPinController = TextEditingController();

  // Add driver-specific controllers
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController vehicleColorController = TextEditingController();
  final TextEditingController vehicleCapacityController =
      TextEditingController();
  final Rx<DateTime?> vehicleYearOfManufacture = Rx<DateTime?>(null);

  // Add driver-specific error states
  final RxString licenseNumberError = ''.obs;
  final RxString plateNumberError = ''.obs;
  final RxString vehicleColorError = ''.obs;
  final RxString vehicleCapacityError = ''.obs;
  final RxString vehicleYomError = ''.obs;

  @override
  void onClose() {
    // Dispose all controllers
    loginEmailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPhoneController.dispose();
    signupPasswordController.dispose();
    signupPinController.dispose();
    licenseNumberController.dispose();
    plateNumberController.dispose();
    vehicleColorController.dispose();
    vehicleCapacityController.dispose();
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

    // Reset all errors
    nameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    pinError.value = '';

    // Validate name
    if (signupNameController.text.isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    }

    // Validate email
    if (signupEmailController.text.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(signupEmailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    // Validate phone
    if (signupPhoneController.text.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (!GetUtils.isPhoneNumber(signupPhoneController.text)) {
      phoneError.value = 'Please enter a valid phone number';
      isValid = false;
    }

    // Simplified password validation
    if (signupPasswordController.text.length < 4) {
      passwordError.value = 'Password must be at least 4 characters';
      isValid = false;
    }

    // Validate PIN (simple 4-digit check)
    if (signupPinController.text.length != 4) {
      pinError.value = 'PIN must be 4 digits';
      isValid = false;
    }

    // Only validate driver fields if user is registering as a driver
    if (isDriverRegistration.value) {
      // Validate license number
      if (licenseNumberController.text.isEmpty) {
        licenseNumberError.value = 'License number is required';
        isValid = false;
      }

      // Validate plate number
      if (plateNumberController.text.isEmpty) {
        plateNumberError.value = 'Plate number is required';
        isValid = false;
      }

      // Validate vehicle color
      if (vehicleColorController.text.isEmpty) {
        vehicleColorError.value = 'Vehicle color is required';
        isValid = false;
      }

      // Validate vehicle capacity
      if (vehicleCapacityController.text.isEmpty) {
        vehicleCapacityError.value = 'Vehicle capacity is required';
        isValid = false;
      } else if (!RegExp(
        r'^[0-9]+$',
      ).hasMatch(vehicleCapacityController.text)) {
        vehicleCapacityError.value = 'Please enter a valid number';
        isValid = false;
      }

      // Validate year of manufacture
      if (vehicleYearOfManufacture.value == null) {
        vehicleYomError.value = 'Year of manufacture is required';
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> signUp(
    String name,
    String email,
    String phone,
    String password,
    String pin,
  ) async {
    if (!validateFields()) {
      return;
    }

    try {
      isLoading.value = true;

      final UserCredential? userCredential = await _authService
          .createUserWithEmailAndPassword(email, password);

      if (userCredential?.user != null) {
        final UserModel user = UserModel(
          uid: userCredential!.user!.uid,
          name: name,
          email: email,
          phoneNumber: phone,
          pin: pin,
          createdAt: DateTime.now(),
        );

        await _database
            .child('users')
            .child(userCredential.user!.uid)
            .set(user.toJson());

        clearSignupFields(); // Clear fields after successful signup
        ToastHelper.showSuccess('Account created successfully');
        Get.offAllNamed('/home');
      } else {
        ToastHelper.showError('Failed to create account');
      }
    } on FirebaseAuthException catch (e) {
      String message =
          _getFirebaseErrorMessage(e.code) ?? e.message ?? 'An error occurred';
      ToastHelper.showError(message);
    } catch (e) {
      ToastHelper.showError('An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ToastHelper.showError('Please enter both email and password');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      ToastHelper.showError('Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;
      final UserCredential? result = await _authService
          .signInWithEmailAndPassword(email, password);

      if (result?.user != null) {
        clearLoginFields();
        // Show PIN verification dialog instead of direct navigation
        showPinVerificationDialog(result!.user!.uid);
      } else {
        ToastHelper.showError('Login failed');
      }
    } on FirebaseAuthException catch (e) {
      String message =
          _getFirebaseErrorMessage(e.code) ?? e.message ?? 'An error occurred';
      ToastHelper.showError(message);
    } catch (e) {
      ToastHelper.showError('An unexpected error occurred');
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
      await _authService.sendPasswordResetEmail(email);

      // Close all dialogs first
      // Get.closeAllDialogs();
      Get.back();

      // Then show success message
      ToastHelper.showSuccess(
        'Password reset link sent to $email.\nPlease check your email inbox.',
      );
    } on FirebaseAuthException catch (e) {
      String message =
          _getFirebaseErrorMessage(e.code) ??
          'Failed to send reset link. Please try again.';
      ToastHelper.showError(message);
    } catch (e) {
      ToastHelper.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void handleLogin() {
    signIn(loginEmailController.text.trim(), passwordController.text);
  }

  void showResetPasswordDialog() {
    resetEmailController.clear(); // Clear previous input
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Reset Password',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email address to receive a password reset link.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          Obx(
            () => TextButton(
              onPressed:
                  isLoading.value
                      ? null
                      : () => forgotPassword(resetEmailController.text.trim()),
              child:
                  isLoading.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text(
                        'Send Reset Link',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Clear form fields after successful signup
  void clearSignupFields() {
    signupNameController.clear();
    signupEmailController.clear();
    signupPhoneController.clear();
    signupPasswordController.clear();
    signupPinController.clear();
    clearDriverFields();
  }

  // Clear login fields
  void clearLoginFields() {
    loginEmailController.clear();
    passwordController.clear();
    isDriverRegistration.value = false; // Reset the driver registration state
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

  // Add this method to verify PIN
  Future<void> verifyPinAndNavigate(String enteredPin, String uid) async {
    try {
      isLoading.value = true;

      // Get user data from Firebase
      final userSnapshot = await _database.child('users').child(uid).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.value as Map<dynamic, dynamic>;
        final storedPin = userData['pin'] as String;

        if (storedPin == enteredPin) {
          Get.back(); // Close PIN dialog
          Get.offAllNamed('/home');
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

  // Add method to show PIN verification dialog
  void showPinVerificationDialog(String uid) {
    final TextEditingController pinController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Enter PIN',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please enter your 4-digit PIN to continue',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              signOut(); // Sign out if user cancels PIN verification
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          Obx(
            () => TextButton(
              onPressed:
                  isLoading.value
                      ? null
                      : () => verifyPinAndNavigate(pinController.text, uid),
              child:
                  isLoading.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text(
                        'Verify',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
