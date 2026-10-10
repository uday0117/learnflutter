import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/analytics_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => user.value != null;
  String get displayName => user.value?.displayName ?? 'Flutter Developer';
  String get email => user.value?.email ?? '';
  String? get photoURL => user.value?.photoURL;
  String get uid => user.value?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    if (user.value != null) {
      AnalyticsService().setUserId(user.value!.uid);
    }
    _auth.authStateChanges().listen((User? u) {
      user.value = u;
      AnalyticsService().setUserId(u?.uid);
    });
  }

  /// Initiates Google Sign-In flow and links with Firebase Authentication.
  Future<UserCredential?> signInWithGoogle({bool showFeedback = true}) async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in prompt
        isLoading.value = false;
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? loggedInUser = userCredential.user;
      if (loggedInUser != null) {
        await AnalyticsService().setUserId(loggedInUser.uid);
        await AnalyticsService().logLogin(method: 'google');

        if (showFeedback) {
          Get.snackbar(
            'welcome_back'.tr.isNotEmpty ? 'welcome_back'.tr : 'Welcome!',
            '${'signed_in_as'.tr.isNotEmpty ? 'signed_in_as'.tr : 'Signed in as'} ${loggedInUser.displayName ?? loggedInUser.email ?? ''}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primaryContainer,
            colorText: Get.theme.colorScheme.onPrimaryContainer,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            icon: const Icon(Icons.check_circle_rounded, color: Colors.green),
            duration: const Duration(seconds: 3),
          );
        }
      }

      isLoading.value = false;
      return userCredential;
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint('[AuthController] Sign in failed: $e');
      AnalyticsService().recordError(
        e,
        stack,
        reason: 'Google Sign In Error',
      );

      if (showFeedback) {
        Get.snackbar(
          'sign_in_failed'.tr.isNotEmpty ? 'sign_in_failed'.tr : 'Sign In Failed',
          e.toString().contains('network')
              ? 'Please check your internet connection.'
              : 'Could not complete sign in. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade900,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
          duration: const Duration(seconds: 4),
        );
      }
      return null;
    }
  }

  /// Signs the user out from both Firebase and Google.
  Future<void> signOut({bool showFeedback = true}) async {
    try {
      isLoading.value = true;
      await _googleSignIn.signOut();
      await _auth.signOut();
      await AnalyticsService().logLogout();
      await AnalyticsService().setUserId(null);

      isLoading.value = false;

      if (showFeedback) {
        Get.snackbar(
          'signed_out'.tr.isNotEmpty ? 'signed_out'.tr : 'Signed Out',
          'You have been logged out successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.surfaceContainerHighest,
          colorText: Get.theme.colorScheme.onSurface,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.info_outline_rounded),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint('[AuthController] Sign out failed: $e');
      AnalyticsService().recordError(e, stack, reason: 'Sign Out Error');
    }
  }
}
