import 'package:get/get.dart';
import '../controllers/driver_controller.dart';
import '../../car_details/controllers/car_details_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DriverController());
    Get.put(CarDetailsController());
    
    // Check if AuthController exists, if not create it
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
  }
} 
