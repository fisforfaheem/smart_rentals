import 'package:get/get.dart';
import '../controllers/car_details_controller.dart';

class CarDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CarDetailsController());
  }
} 