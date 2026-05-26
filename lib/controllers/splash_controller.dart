import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/constants.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 SplashController onInit called');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('✅ SplashController onReady called');
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    debugPrint('⏳ Starting 2-second delay...');
    await Future.delayed(AppConstants.splashDuration);
    debugPrint('⏰ Delay complete. Current route: ${Get.currentRoute}');

    if (Get.currentRoute == AppRoutes.splash) {
      debugPrint('🏠 Navigating to home screen...');
      Get.offAllNamed(AppRoutes.home);
      debugPrint('✅ Navigation command sent');
    } else {
      debugPrint('⚠️ Already left splash screen, route: ${Get.currentRoute}');
    }
  }
}
