import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/role_selection/bindings/role_selection_binding.dart';
import '../modules/role_selection/views/role_selection_view.dart';
import '../modules/car_details/views/car_details_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/details/views/details_view.dart';
import '../modules/car_details/bindings/car_details_binding.dart';
import '../modules/driver/views/driver_home_view.dart';
import '../modules/driver/views/driver_profile_view.dart';
import '../modules/driver/bindings/driver_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: '/onboarding',
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: '/role-selection',
      page: () => const RoleSelectionView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/signup',
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: HomeBinding(),
      bindings: [AuthBinding()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/car-details',
      page:
          () => CarDetailsView(
            name: Get.arguments['name'] ?? '',
            carModel: Get.arguments['carModel'] ?? '',
            persons: Get.arguments['persons'] ?? '',
            price: Get.arguments['price'] ?? '',
            image: Get.arguments['image'] ?? '',
            driverImage: Get.arguments['driverImage'] ?? '',
            pricePerHour:
                (Get.arguments['pricePerHour'] as num?)?.toDouble() ?? 0.0,
          ),
      binding: CarDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/details',
      page: () => const DetailsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/driver-home',
      page: () => const DriverHomeView(),
      binding: DriverBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/driver-profile',
      page: () => const DriverProfileView(),
      binding: DriverBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
