import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class PaletteColor {
  Color color;
  bool isLocked;
  final String role;

  PaletteColor({
    required this.color,
    this.isLocked = false,
    required this.role,
  });
}

class ColorPaletteGeneratorScreen extends StatefulWidget {
  const ColorPaletteGeneratorScreen({super.key});

  @override
  State<ColorPaletteGeneratorScreen> createState() =>
      _ColorPaletteGeneratorScreenState();
}

class _ColorPaletteGeneratorScreenState
    extends State<ColorPaletteGeneratorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Random _random = Random();

  late List<PaletteColor> _currentPalette;

  static const List<Map<String, dynamic>> _presets = [
    {
      'name': 'Flutter Sky',
      'colors': [
        Color(0xFF02569B),
        Color(0xFF0175C2),
        Color(0xFF13B9FD),
        Color(0xFFE1F5FE),
        Color(0xFFF0F4F8),
      ],
    },
    {
      'name': 'Cyberpunk Neon',
      'colors': [
        Color(0xFFF72585),
        Color(0xFF7209B7),
        Color(0xFF3A0CA3),
        Color(0xFF4361EE),
        Color(0xFF4CC9F0),
      ],
    },
    {
      'name': 'Emerald Forest',
      'colors': [
        Color(0xFF2D6A4F),
        Color(0xFF40916C),
        Color(0xFF52B788),
        Color(0xFF74C69D),
        Color(0xFFD8F3DC),
      ],
    },
    {
      'name': 'Sunset Glow',
      'colors': [
        Color(0xFFD00000),
        Color(0xFFDC2F02),
        Color(0xFFE85D04),
        Color(0xFFF48C06),
        Color(0xFFFFBA08),
      ],
    },
    {
      'name': 'Midnight Purple',
      'colors': [
        Color(0xFF3B185F),
        Color(0xFF2A0944),
        Color(0xFFA12568),
        Color(0xFFFEC260),
        Color(0xFFF5F5F5),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    AnalyticsService().logScreenView('ColorPaletteGeneratorScreen');

    _currentPalette = [
      PaletteColor(color: const Color(0xFF02569B), role: 'Primary'),
      PaletteColor(color: const Color(0xFF0175C2), role: 'Secondary'),
      PaletteColor(color: const Color(0xFF13B9FD), role: 'Accent'),
      PaletteColor(color: const Color(0xFFE1F5FE), role: 'Surface'),
      PaletteColor(color: const Color(0xFFF8FAFC), role: 'Background'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateRandom() {
    setState(() {
      for (var item in _currentPalette) {
        if (!item.isLocked) {
          item.color = Color.fromARGB(
            255,
            _random.nextInt(256),
            _random.nextInt(256),
            _random.nextInt(256),
          );
        }
      }
    });
  }

  void _loadPreset(List<Color> colors) {
    setState(() {
      for (int i = 0; i < _currentPalette.length && i < colors.length; i++) {
        if (!_currentPalette[i].isLocked) {
          _currentPalette[i].color = colors[i];
        }
      }
    });
    Get.snackbar(
      'Preset Applied',
      'Colors updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  String _colorToHex(Color c) {
    return '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  String _generateDartThemeCode() {
    final c0 = _colorToHex(_currentPalette[0].color);
    final c1 = _colorToHex(_currentPalette[1].color);
    final c2 = _colorToHex(_currentPalette[2].color);
    final c3 = _colorToHex(_currentPalette[3].color);
    final c4 = _colorToHex(_currentPalette[4].color);

    return '''import 'package:flutter/material.dart';

// 🎨 Custom Generated Flutter ColorScheme
class AppTheme {
  static final ThemeData customTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF${c0.replaceAll('#', '')}),
      onPrimary: Colors.white,
      secondary: Color(0xFF${c1.replaceAll('#', '')}),
      onSecondary: Colors.white,
      tertiary: Color(0xFF${c2.replaceAll('#', '')}),
      onTertiary: Colors.black,
      surface: Color(0xFF${c3.replaceAll('#', '')}),
      onSurface: Colors.black87,
      error: Colors.red,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF${c4.replaceAll('#', '')}),
  );
}''';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = theme.primaryColor.value;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.palette_rounded, color: Color(0xFFFF8008), size: 22),
            const SizedBox(width: 8),
            Text(
              'Color Palette Generator',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle_rounded),
            tooltip: 'Randomize (Unchecked)',
            onPressed: _generateRandom,
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy Theme Code',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _generateDartThemeCode()));
              Get.snackbar('Copied', 'Theme Dart code copied to clipboard', snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.palette_outlined), text: 'Palette'),
            Tab(icon: Icon(Icons.widgets_rounded), text: 'Live Preview'),
            Tab(icon: Icon(Icons.code_rounded), text: 'Dart Code'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPaletteTab(isDark, primary),
                _buildLivePreviewTab(isDark),
                _buildCodeExportTab(isDark),
              ],
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _generateRandom,
                      icon: const Icon(Icons.casino_rounded),
                      label: const Text('Generate Random Palette'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // AdMob banner
          Obx(() {
            if (AdService().isAdFree) return const SizedBox.shrink();
            return const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Center(child: BannerAdWidget()),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaletteTab(bool isDark, Color primary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Presets Chips
        Text(
          'Popular Color Palettes',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _presets.map((preset) {
              final colors = preset['colors'] as List<Color>;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: CircleAvatar(backgroundColor: colors[0], radius: 8),
                  label: Text(preset['name'] as String),
                  onPressed: () => _loadPreset(colors),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Color Swatches
        Text(
          'Active Color Roles (Tap lock to preserve during shuffle)',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const SizedBox(height: 12),

        ...List.generate(_currentPalette.length, (i) {
          final p = _currentPalette[i];
          final hex = _colorToHex(p.color);
          final luminance = p.color.computeLuminance();
          final textColor = luminance > 0.5 ? Colors.black87 : Colors.white;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 72,
            decoration: BoxDecoration(
              color: p.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: p.color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.role,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        hex,
                        style: GoogleFonts.firaCode(
                          color: textColor.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      p.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: textColor,
                    ),
                    tooltip: p.isLocked ? 'Unlock color' : 'Lock color',
                    onPressed: () => setState(() => p.isLocked = !p.isLocked),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy_rounded, color: textColor),
                    tooltip: 'Copy HEX',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: hex));
                      Get.snackbar('Copied', 'HEX $hex copied', snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLivePreviewTab(bool isDark) {
    final p0 = _currentPalette[0].color; // Primary
    final p1 = _currentPalette[1].color; // Secondary
    final p2 = _currentPalette[2].color; // Accent
    final p3 = _currentPalette[3].color; // Surface
    final p4 = _currentPalette[4].color; // Background

    return Container(
      color: p4,
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Text(
            'Live Material 3 Preview',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: p4.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Sample Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: p3,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: p0, shape: BoxShape.circle),
                      child: const Icon(Icons.bolt_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Card Component',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Styled automatically with your palette',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p0,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Primary Button'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: p1,
                          side: BorderSide(color: p1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Secondary'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Chip(
                      backgroundColor: p2.withValues(alpha: 0.2),
                      label: Text('Accent Tag', style: TextStyle(color: p2, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      backgroundColor: p1.withValues(alpha: 0.15),
                      label: Text('Active Chip', style: TextStyle(color: p1)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExportTab(bool isDark) {
    final code = _generateDartThemeCode();

    return Container(
      color: isDark ? const Color(0xFF14141E) : const Color(0xFFF8F9FA),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ThemeData Export',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  Get.snackbar('Copied', 'Theme code copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy Code'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  code,
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    color: isDark ? const Color(0xFFE0E6ED) : const Color(0xFF1E293B),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
