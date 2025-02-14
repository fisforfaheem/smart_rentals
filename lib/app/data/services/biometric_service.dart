import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final RxBool canCheckBiometrics = false.obs;
  final RxBool isDeviceSupported = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      canCheckBiometrics.value = await _localAuth.canCheckBiometrics;
      isDeviceSupported.value = await _localAuth.isDeviceSupported();
    } on PlatformException catch (_) {
      canCheckBiometrics.value = false;
      isDeviceSupported.value = false;
    }
  }

  Future<bool> authenticate() async {
    try {
      if (!canCheckBiometrics.value || !isDeviceSupported.value) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        return false;
      }
      if (e.code == auth_error.notEnrolled) {
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return [];
    }
  }

  Future<BiometricService> init() async {
    return this;
  }
}
