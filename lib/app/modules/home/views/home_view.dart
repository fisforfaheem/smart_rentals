import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/driver_model.dart';
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
                '🚗 Available Drivers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Find your ride now! 🌟',
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
    return Obx(
      () => Row(
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
      ),
    );
  }

  Widget _buildDriversList(HomeController controller) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.filteredCars.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.no_transfer_rounded,
                  size: 64,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Drivers Available 😞',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check back later',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.filteredCars.length,
          itemBuilder: (context, index) {
            final driver = controller.filteredCars[index];
            return AnimationHelper.slideInFromBottom(
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: 'driver_${driver.driverId}',
                          child: CircleAvatar(
                            backgroundColor:
                                driver.gender == Gender.male
                                    ? const Color(0xFF4A90E2).withOpacity(0.1)
                                    : driver.gender == Gender.female
                                    ? const Color(0xFFE91E63).withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                            radius: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          driver.gender == Gender.male
                                              ? const Color(0xFF4A90E2)
                                              : driver.gender == Gender.female
                                              ? const Color(0xFFE91E63)
                                              : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                      driver.gender == Gender.male
                                          ? 'assets/dri1.png'
                                          : driver.gender == Gender.female
                                          ? 'assets/dri2.png'
                                          : 'assets/dri3.png',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (driver.vehicleColor.isNotEmpty)
                                Text(
                                  '🚙 Vehicle: ${driver.vehicleColor}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              if (driver.plateNumber.isNotEmpty)
                                Text(
                                  '🔖 Plate: ${driver.plateNumber}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              Text(
                                '💲 Price: \$${driver.pricePerHour}/hr',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event_seat,
                                    size: 18,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${driver.persons} Seats',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            driver.isBooked
                                ? driver.isBookedByCurrentUser
                                    ? () => controller.cancelBooking(driver)
                                    : null
                                : () => controller.bookDriver(driver),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              driver.isBooked
                                  ? driver.isBookedByCurrentUser
                                      ? Colors.red
                                      : Colors.grey
                                  : const Color(0xFFBE9B7B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              driver.isBooked
                                  ? driver.isBookedByCurrentUser
                                      ? 'Cancel Booking'
                                      : 'Not Available'
                                  : 'Book Now',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              delay: index * 0.1,
            );
          },
        );
      }),
    );
  }
}
