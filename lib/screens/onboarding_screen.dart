import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/engagement_controller.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/progress_controller.dart';
import '../controllers/streak_controller.dart';
import '../controllers/theme_controller.dart';
import '../services/analytics_service.dart';
import '../services/notification_service.dart';
import '../services/deep_link_service.dart';
import '../services/home_widget_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ThemeController _theme = Get.find<ThemeController>();
  int _page = 0;

  static const _pages = [
    _OnboardingPage(
      emoji: '🧩',
      titleKey: 'onboarding_title_1',
      bodyKey: 'onboarding_body_1',
    ),
    _OnboardingPage(
      emoji: '🧠',
      titleKey: 'onboarding_title_2',
      bodyKey: 'onboarding_body_2',
    ),
    _OnboardingPage(
      emoji: '🔥',
      titleKey: 'onboarding_title_3',
      bodyKey: 'onboarding_body_3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService().logEvent('onboarding_start');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish({bool enableReminder = false}) async {
    if (enableReminder) {
      final granted = await NotificationService().requestPermission();
      if (granted) {
        await NotificationService().scheduleDailyReminder();
        Get.find<EngagementController>().setDailyReminder(true);
      }
      AnalyticsService().logEvent('onboarding_reminder_enabled');
    }

    Get.find<OnboardingController>().complete();
    Get.off(
      () => const HomeScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
    );
    DeepLinkService().handlePendingLink();
    if (Get.isRegistered<StreakController>() &&
        Get.isRegistered<ProgressController>()) {
      HomeWidgetService().update(
        streak: Get.find<StreakController>().currentStreak.value,
        progressPercent:
            (Get.find<ProgressController>().progressPercent * 100).round(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final primary = _theme.primaryColor.value;

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _finish(),
                  child: Text(
                    'onboarding_skip'.tr,
                    style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primary,
                                  primary.withValues(alpha: 0.7),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.35),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                page.emoji,
                                style: const TextStyle(fontSize: 52),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            page.titleKey.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page.bodyKey.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: isDark ? Colors.white60 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? primary
                          : primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    if (_page == _pages.length - 1) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => _finish(enableReminder: true),
                          icon: const Icon(Icons.notifications_active_rounded),
                          label: Text('onboarding_enable_reminder'.tr),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_page < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                            );
                          } else {
                            _finish();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _page == _pages.length - 1
                              ? 'onboarding_get_started'.tr
                              : 'onboarding_next'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _OnboardingPage {
  final String emoji;
  final String titleKey;
  final String bodyKey;

  const _OnboardingPage({
    required this.emoji,
    required this.titleKey,
    required this.bodyKey,
  });
}
