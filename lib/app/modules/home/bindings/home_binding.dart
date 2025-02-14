import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    
    // Only put AuthController if it doesn't exist
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
  }
} 