import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';
import '../utils/constants.dart';

class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 SplashController onInit called');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('✅ SplashController onReady called');
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    debugPrint('⏳ Starting 2-second delay...');
    await Future.delayed(AppConstants.splashDuration);
    debugPrint('⏰ Delay complete. Current route: ${Get.currentRoute}');

    if (Get.currentRoute == AppRoutes.splash) {
      // Check if onboarding is complete
      final bool onboardingComplete = storage.read('onboarding_complete') ?? false;
      
      if (onboardingComplete) {
        debugPrint('🏠 Navigating to home screen...');
        Get.offAllNamed(AppRoutes.home);
      } else {
        debugPrint('👋 First launch, navigating to onboarding...');
        Get.offAllNamed(AppRoutes.onboarding);
      }
      debugPrint('✅ Navigation command sent');
    } else {
      debugPrint('⚠️ Already left splash screen, route: ${Get.currentRoute}');
    }
  }
}
