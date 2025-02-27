import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/driver_model.dart';

class DriverController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final RxBool isLoading = false.obs;
  final RxBool isAvailable = true.obs;
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final Rx<Gender> gender = Gender.other.obs;

  @override
  void onInit() {
    super.onInit();
    loadDriverProfile();
  }

  Future<void> loadDriverProfile() async {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        Get.offAllNamed('/login');
        return;
      }

      final snapshot = await _database.child('drivers').child(userId).get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        name.value = data['name'] ?? '';
        email.value = data['email'] ?? '';
        isAvailable.value = data['isAvailable'] ?? true;

        // Parse gender from the stored string
        gender.value = Gender.values.firstWhere(
          (e) => e.toString() == data['gender'],
          orElse: () => Gender.other,
        );
      }
    } catch (e) {
      print('Error loading driver profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAvailability() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      isAvailable.value = !isAvailable.value;
      await _database
          .child('drivers')
          .child(userId)
          .child('isAvailable')
          .set(isAvailable.value);
    } catch (e) {
      print('Error toggling availability: $e');
      // Revert the value if the update failed
      isAvailable.value = !isAvailable.value;
    }
  }
}
