import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    debugPrint('🔧 SplashBinding.dependencies() called');
    Get.lazyPut<SplashController>(() {
      debugPrint('🎯 Creating SplashController instance');
      return SplashController();
    });
    debugPrint('✅ SplashBinding.dependencies() complete');
  }
}
