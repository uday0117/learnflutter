import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  static const String _themeColorKey = 'theme_color';
  static const String _themeModeKey = 'theme_mode';

  // Default Flutter blue
  final Rx<Color> primaryColor = const Color(0xFF02569B).obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeSettings();
  }

  void _loadThemeSettings() {
    // Load saved color
    final savedColor = _storage.read(_themeColorKey);
    if (savedColor != null) {
      primaryColor.value = Color(savedColor);
    }

    // Load saved theme mode
    final savedMode = _storage.read(_themeModeKey);
    if (savedMode != null) {
      themeMode.value = ThemeMode.values[savedMode];
    }
  }

  void updatePrimaryColor(Color color) {
    primaryColor.value = color;
    _storage.write(_themeColorKey, color.value);
  }

  void updateThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storage.write(_themeModeKey, mode.index);
    Get.changeThemeMode(mode);
  }

  // Predefined color presets
  static final List<Color> colorPresets = [
    const Color(0xFF02569B), // Flutter Blue (default)
    const Color(0xFFF44336), // Red
    const Color(0xFFE91E63), // Pink
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF2196F3), // Blue
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF009688), // Teal
    const Color(0xFF4CAF50), // Green
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFFFF9800), // Orange
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF795548), // Brown
  ];
}
