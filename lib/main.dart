import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shared/themes/app_theme.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const LearnFlutterApp());
}

class LearnFlutterApp extends StatelessWidget {
  const LearnFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LearnFlutter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
