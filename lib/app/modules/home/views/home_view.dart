import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/utils/animation_helper.dart';
import '../../car_details/views/car_details_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2B48C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 25),
              _buildSearchBar(controller),
              const SizedBox(height: 25),
              _buildSectionHeader(),
              const SizedBox(height: 15),
              _buildCarList(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return AnimationHelper.fadeIn(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Find your perfect ride',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              // Use Get.find() to get AuthController instance
              final authController = Get.find<AuthController>();
              authController.signOut();
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(HomeController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: controller.searchBarHeight.value,
      curve: Curves.easeInOut,
      child: Hero(
        tag: 'searchBar',
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    onChanged: controller.searchCars,
                    decoration: const InputDecoration(
                      hintText: 'Search for cars...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.white70),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  width: 1,
                  color: Colors.white30,
                ),
                IconButton(
                  onPressed: controller.toggleSearch,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      controller.isSearching.value ? Icons.close : Icons.tune,
                      key: ValueKey(controller.isSearching.value),
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Available Cars',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              // Show all cars
            },
            child: const Text(
              'View All',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarList(HomeController controller) {
    return Expanded(
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            key: ValueKey(controller.filteredCars.length),
            itemCount: controller.filteredCars.length,
            itemBuilder: (context, index) {
              final car = controller.filteredCars[index];
              return _buildCarCard(car);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCarCard(CarModel car) {
    return Hero(
      tag: 'car_${car.name}',
      child: Material(
        color: Colors.transparent,
        child: AnimationHelper.slideInFromBottom(
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.95, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: GestureDetector(
                  onTap: () => _navigateToDetails(car),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(car.driverImage),
                          radius: 25,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                car.carModel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${car.persons} Person',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    car.price,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            car.image,
                            width: 90,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(CarModel car) {
    Get.to(
      () => CarDetailsView(
        name: car.name,
        carModel: car.carModel,
        persons: car.persons,
        price: car.price,
        image: car.image,
        driverImage: car.driverImage,
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
