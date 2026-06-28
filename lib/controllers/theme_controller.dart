import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends GetxController {
  static const _darkKey = 'dark_mode';
  static const _colorKey = 'primary_color_index';
  static const _langCodeKey = 'lang_code';
  static const _langCountryKey = 'lang_country';
  static const _fontScaleKey = 'font_scale_index';
  static const _hapticsKey = 'haptics_enabled';

  final _box = GetStorage();

  late var isDarkMode = false.obs;
  late final Rx<Color> primaryColor;
  late final Rx<Locale> currentLocale;
  var fontScaleIndex = 1.obs; // 0=small, 1=medium, 2=large
  var hapticsEnabled = true.obs;

  static const List<double> fontScales = [0.85, 1.0, 1.15];
  static const List<String> fontScaleLabels = ['Small', 'Medium', 'Large'];

  double get fontScale => fontScales[fontScaleIndex.value];

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

  @override
  void onInit() {
    super.onInit();
    final savedDark = _box.read<bool>(_darkKey) ?? false;
    isDarkMode = savedDark.obs;

    final colorIndex = _box.read<int>(_colorKey) ?? 0;
    final safeIndex = colorIndex.clamp(0, availableColors.length - 1);
    primaryColor = availableColors[safeIndex].obs;

    fontScaleIndex.value = (_box.read<int>(_fontScaleKey) ?? 1).clamp(0, 2);
    hapticsEnabled.value = _box.read<bool>(_hapticsKey) ?? true;

    final savedLocale = getSavedLocale();
    currentLocale =
        (savedLocale ?? Get.deviceLocale ?? const Locale('en', 'US')).obs;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _box.write(_darkKey, isDarkMode.value);
    triggerHaptic();
  }

  void changeColor(Color color) {
    primaryColor.value = color;
    final index = availableColors.indexOf(color);
    if (index >= 0) _box.write(_colorKey, index);
    triggerHaptic();
  }

  void setFontScale(int index) {
    fontScaleIndex.value = index.clamp(0, 2);
    _box.write(_fontScaleKey, fontScaleIndex.value);
    triggerHaptic();
  }

  void toggleHaptics() {
    hapticsEnabled.value = !hapticsEnabled.value;
    _box.write(_hapticsKey, hapticsEnabled.value);
    if (hapticsEnabled.value) HapticFeedback.lightImpact();
  }

  void triggerHaptic() {
    if (hapticsEnabled.value) HapticFeedback.selectionClick();
  }

  Locale? getSavedLocale() {
    final code = _box.read<String>(_langCodeKey);
    final country = _box.read<String>(_langCountryKey);
    if (code != null) return Locale(code, country ?? '');
    return null;
  }

  void saveLocale(Locale locale) {
    currentLocale.value = locale;
    _box.write(_langCodeKey, locale.languageCode);
    _box.write(_langCountryKey, locale.countryCode ?? '');
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor.value,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme(),
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
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
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
