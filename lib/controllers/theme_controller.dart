import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable for theme mode
  var isDarkMode = false.obs;

  // Observable for primary color
  final Rx<Color> primaryColor = const Color(0xFF1E88E5).obs; // Electric Blue

  // Predefined color options - Vibrant car-inspired palette
  final List<Color> availableColors = [
    const Color(0xFF1E88E5), // Electric Blue
    const Color(0xFFE53935), // Racing Red
    const Color(0xFF43A047), // Racing Green
    const Color(0xFFFF6F00), // Sunset Orange
    const Color(0xFF8E24AA), // Royal Purple
    const Color(0xFF00ACC1), // Turquoise
    const Color(0xFFFFB300), // Gold
    const Color(0xFFD81B60), // Magenta
    const Color(0xFF00897B), // Teal
    const Color(0xFF5E35B1), // Deep Purple
    const Color(0xFFF4511E), // Flame Red
    const Color(0xFF039BE5), // Sky Blue
    const Color(0xFF7CB342), // Lime Green
    const Color(0xFFFFD600), // Yellow
    const Color(0xFFE91E63), // Pink
  ];

  // Toggle dark mode
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  // Change primary color
  void changeColor(Color color) {
    primaryColor.value = color;
  }

  // Get current theme data
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor.value,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: primaryColor.value,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor.value,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor.value,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor.value,
      ),
    );
  }
}
