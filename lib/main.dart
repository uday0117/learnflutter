import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/controllers/theme_controller.dart';
import 'features/home/home_screen.dart';
import 'shared/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController());
  runApp(const LearnFlutterApp());
}

class LearnFlutterApp extends StatelessWidget {
  const LearnFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'LearnFlutter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(themeController.primaryColor.value),
        darkTheme: AppTheme.darkTheme(themeController.primaryColor.value),
        themeMode: themeController.themeMode.value,
        home: const HomeScreen(),
      ),
    );
  }
}
