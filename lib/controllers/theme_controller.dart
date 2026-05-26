import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/constants.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    _isDarkMode.value = _storage.read(AppConstants.themeKey) ?? false;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.write(AppConstants.themeKey, _isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }

  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    _storage.write(AppConstants.themeKey, isDark);
    Get.changeThemeMode(themeMode);
  }
}
