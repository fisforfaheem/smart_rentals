import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> currentUser = Rx<User?>(null);
  final Rx<UserRole> currentUserRole = Rx<UserRole>(UserRole.user);

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  void _initializeAuth() {
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _handleUserChanged);
  }

  Future<void> _handleUserChanged(User? user) async {
    if (user != null) {
      try {
        final userSnapshot =
            await FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(user.uid)
                .get();

        if (userSnapshot.exists && userSnapshot.value != null) {
          final Map<String, dynamic> userData = Map<String, dynamic>.from(
            userSnapshot.value as Map,
          );
          final userModel = UserModel.fromJson(userData);
          currentUserRole.value = userModel.role;
        } else {
          currentUserRole.value = UserRole.user; // Default role
        }
      } catch (e) {
        debugPrint('Error fetching user role: $e');
        currentUserRole.value = UserRole.user; // Default role on error
      }
    } else {
      currentUserRole.value =
          UserRole.user; // Reset to default role when user is null
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw FirebaseAuthException(
          code: 'wrong-password',
          message:
              'The password is invalid or the user does not have a password.',
        );
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUserRole.value = UserRole.user; // Reset role on sign out
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  Future<AuthService> init() async {
    return this;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      rethrow;
    }
  }
}
