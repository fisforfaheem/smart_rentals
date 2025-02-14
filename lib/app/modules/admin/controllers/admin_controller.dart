import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class AdminController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Add admin-specific methods here
} 