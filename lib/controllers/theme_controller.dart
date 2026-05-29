import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable for theme mode
  var isDarkMode = false.obs;

  // Observable for primary color
  final Rx<Color> primaryColor = Colors.deepPurple.obs;

  // Predefined color options
  final List<Color> availableColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.red,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
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
