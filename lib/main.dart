import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/engagement_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/interview_review_controller.dart';
import 'controllers/progress_controller.dart';
import 'controllers/quiz_controller.dart';
import 'controllers/streak_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/weekly_challenge_controller.dart';
import 'screens/splash_screen.dart';
import 'services/ad_service.dart';
import 'services/analytics_service.dart';
import 'services/notification_service.dart';
import 'translations/app_translations.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize persistent storage
    await GetStorage.init();

    // Firebase Analytics + Crashlytics (free tier)
    await AnalyticsService().initialize();

    // Initialize AdMob
    await AdService().initialize();

    // Daily learning reminders
    await NotificationService().initialize();

    // Initialize controllers (order matters — ThemeController first for locale)
    final themeController = Get.put(ThemeController());
    Get.put(FavoritesController());
    Get.put(ProgressController());
    Get.put(InterviewReviewController());
    Get.put(StreakController());
    Get.put(QuizController());
    Get.put(EngagementController());
    Get.put(WeeklyChallengeController());

    // Restore saved locale (or null = system default)
    final savedLocale = themeController.getSavedLocale();

    AnalyticsService().setUserProperties(
      themeMode: themeController.isDarkMode.value ? 'dark' : 'light',
      locale: savedLocale?.languageCode ?? Get.deviceLocale?.languageCode,
    );

    runApp(MyApp(initialLocale: savedLocale));
  }, (error, stack) {
    AnalyticsService().recordError(error, stack, reason: 'Uncaught async error');
  });
}

class MyApp extends StatefulWidget {
  final Locale? initialLocale;
  const MyApp({super.key, this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AdService().onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      AdService().onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final analyticsObserver = AnalyticsService().navigatorObserver;

    return Obx(
      () => GetMaterialApp(
        title: 'Learn Flutter',
        debugShowCheckedModeBanner: false,
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        // Translations
        translations: AppTranslations(),
        locale: widget.initialLocale ?? Get.deviceLocale ?? const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        navigatorObservers: [
          if (analyticsObserver != null) analyticsObserver,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(themeController.fontScale)),
          child: child!,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
