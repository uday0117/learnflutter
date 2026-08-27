import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/analytics_service.dart';

/// Tracks first-launch onboarding for retention and notification opt-in.
class OnboardingController extends GetxController {
  static const _completeKey = 'onboarding_complete';

  final _box = GetStorage();

  bool get isComplete => _box.read<bool>(_completeKey) ?? false;

  void complete() {
    _box.write(_completeKey, true);
    AnalyticsService().logEvent('onboarding_complete');
  }
}
