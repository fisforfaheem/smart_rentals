import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/utils/animation_helper.dart';

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
              _buildAvailableDriversHeader(),
              const SizedBox(height: 15),
              _buildDriversList(controller),
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
                'Available Drivers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Book your ride now',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: controller.searchCars,
        decoration: const InputDecoration(
          hintText: 'Search drivers...',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildAvailableDriversHeader() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Found ${controller.filteredCars.length} Drivers',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (controller.isLoading.value)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
      ],
    ));
  }

  Widget _buildDriversList(HomeController controller) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.filteredCars.length,
          itemBuilder: (context, index) {
            final driver = controller.filteredCars[index];
            return Container(
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
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(driver.driverImage),
                        radius: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Vehicle: ${driver.vehicleColor}',
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Plate: ${driver.plateNumber}',
                              style: const TextStyle(
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
                                  '${driver.persons} Seats',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  driver.price,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: driver.isBooked
                          ? driver.isBookedByCurrentUser
                              ? () => controller.cancelBooking(driver)
                              : null
                          : () => controller.bookDriver(driver),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: driver.isBooked
                            ? driver.isBookedByCurrentUser
                                ? Colors.red
                                : Colors.grey
                            : const Color(0xFFBE9B7B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            driver.isBooked
                                ? driver.isBookedByCurrentUser
                                    ? Icons.cancel
                                    : Icons.block
                                : Icons.local_taxi,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            driver.isBooked
                                ? driver.isBookedByCurrentUser
                                    ? 'Cancel Booking'
                                    : 'Not Available'
                                : 'Book Now',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
