import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  // Form validation
  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetEmailController = TextEditingController();

  @override
  void onClose() {
    loginEmailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
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

  bool validateForm(String name, String email, String phone, String password) {
    bool isValid = true;

    // Reset errors
    nameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';

    // Name validation
    if (name.isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    } else if (name.length < 2) {
      nameError.value = 'Name must be at least 2 characters';
      isValid = false;
    }

    // Email validation
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    // Phone validation
    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (!GetUtils.isPhoneNumber(phone)) {
      phoneError.value = 'Please enter a valid phone number';
      isValid = false;
    }

    // Password validation
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    return isValid;
  }

  Future<void> signUp(
      String name, String email, String phone, String password) async {
    if (!validateForm(name, email, phone, password)) {
      ToastHelper.showError('Please fix the errors in the form');
      return;
    }

    try {
      isLoading.value = true;

      final UserCredential? userCredential =
          await _authService.createUserWithEmailAndPassword(email, password);

      if (userCredential?.user != null) {
        final UserModel user = UserModel(
          uid: userCredential!.user!.uid,
          name: name,
          email: email,
          phoneNumber: phone,
          createdAt: DateTime.now(),
        );

        await _database
            .child('users')
            .child(userCredential.user!.uid)
            .set(user.toJson());

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

      final UserCredential? result =
          await _authService.signInWithEmailAndPassword(email, password);

      if (result?.user != null) {
        ToastHelper.showSuccess('Welcome back!');
        Get.offAllNamed('/home');
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
      ToastHelper.showSuccess('Logged out successfully');
      Get.offAllNamed('/login');
    } catch (e) {
      ToastHelper.showError('Failed to log out');
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
      String message = _getFirebaseErrorMessage(e.code) ??
          'Failed to send reset link. Please try again.';
      ToastHelper.showError(message);
    } catch (e) {
      ToastHelper.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void handleLogin() {
    signIn(
      loginEmailController.text.trim(),
      passwordController.text,
    );
  }

  void showResetPasswordDialog() {
    resetEmailController.clear(); // Clear previous input
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Obx(() => TextButton(
                onPressed: isLoading.value
                    ? null
                    : () => forgotPassword(resetEmailController.text.trim()),
                child: isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Send Reset Link',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              )),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
