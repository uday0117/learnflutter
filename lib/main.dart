import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/favorites_controller.dart';
import 'controllers/interview_review_controller.dart';
import 'controllers/progress_controller.dart';
import 'controllers/quiz_controller.dart';
import 'controllers/streak_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/splash_screen.dart';
import 'services/ad_service.dart';
import 'translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage
  await GetStorage.init();

  // Initialize AdMob
  await AdService().initialize();

  // Initialize controllers (order matters — ThemeController first for locale)
  final themeController = Get.put(ThemeController());
  Get.put(FavoritesController());
  Get.put(ProgressController());
  Get.put(InterviewReviewController());
  Get.put(StreakController());
  Get.put(QuizController());

  // Restore saved locale (or null = system default)
  final savedLocale = themeController.getSavedLocale();

  runApp(MyApp(initialLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale? initialLocale;
  const MyApp({super.key, this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

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
        locale: initialLocale ?? Get.deviceLocale ?? const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler:
                TextScaler.linear(themeController.fontScale),
          ),
          child: child!,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
