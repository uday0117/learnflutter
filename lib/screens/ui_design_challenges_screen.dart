import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class UIDesignChallengeItem {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String description;
  final List<String> keyWidgets;
  final Widget Function(BuildContext context, bool isDark) previewWidget;
  final String sourceCode;

  const UIDesignChallengeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.keyWidgets,
    required this.previewWidget,
    required this.sourceCode,
  });
}

class UIDesignChallengesScreen extends StatefulWidget {
  const UIDesignChallengesScreen({super.key});

  @override
  State<UIDesignChallengesScreen> createState() =>
      _UIDesignChallengesScreenState();
}

class _UIDesignChallengesScreenState extends State<UIDesignChallengesScreen> {
  int _selectedChallengeIndex = 0;
  bool _isPlayingAudio = false;
  bool _isFavorite = false;

  late final List<UIDesignChallengeItem> _challenges;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('UIDesignChallengesScreen');

    _challenges = [
      // 1. Glassmorphic Crypto Card
      UIDesignChallengeItem(
        id: 'glassmorphism_card',
        title: 'Glassmorphic Crypto Card',
        category: 'Modern Visuals',
        difficulty: 'Intermediate',
        description:
            'A translucent frosted glass card utilizing BackdropFilter, ImageFilter.blur, dual linear gradients, and soft border highlights.',
        keyWidgets: ['BackdropFilter', 'ImageFilter.blur', 'ClipRRect', 'LinearGradient'],
        previewWidget: (context, isDark) {
          return Center(
            child: Container(
              height: 200,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5E62),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ethereum Core',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(Icons.currency_bitcoin_rounded, color: Colors.white),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              'Balance',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$24,850.75',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('•••• 8824', style: TextStyle(color: Colors.white70)),
                                Text('09/28', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        sourceCode: '''// 🎨 Glassmorphic Frosted Card
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ethereum Core', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Spacer(),
          Text('\$24,850.75', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  ),
);''',
      ),

      // 2. Neumorphic Audio Player
      UIDesignChallengeItem(
        id: 'neumorphic_controller',
        title: 'Neumorphic Audio Controller',
        category: 'Tactile UI',
        difficulty: 'Intermediate',
        description:
            'Tactile soft-UI extruded surfaces created using dual offset BoxShadows (bright top-left highlight and dark bottom-right shadow).',
        keyWidgets: ['BoxShadow', 'AnimatedContainer', 'InkWell'],
        previewWidget: (context, isDark) {
          final bg = isDark ? const Color(0xFF24273A) : const Color(0xFFE0E5EC);
          final shadowDark = isDark ? const Color(0xFF181A27) : const Color(0xFFA3B1C6);
          final shadowLight = isDark ? const Color(0xFF30344D) : Colors.white;

          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNeumorphicButton(
                    icon: Icons.skip_previous_rounded,
                    bg: bg,
                    dark: shadowDark,
                    light: shadowLight,
                    onTap: () {},
                  ),
                  const SizedBox(width: 20),
                  _buildNeumorphicButton(
                    icon: _isPlayingAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    bg: bg,
                    dark: shadowDark,
                    light: shadowLight,
                    isPrimary: true,
                    onTap: () => setState(() => _isPlayingAudio = !_isPlayingAudio),
                  ),
                  const SizedBox(width: 20),
                  _buildNeumorphicButton(
                    icon: Icons.skip_next_rounded,
                    bg: bg,
                    dark: shadowDark,
                    light: shadowLight,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        },
        sourceCode: '''// 🎧 Neumorphic Dual-Shadow Button
Container(
  width: 56,
  height: 56,
  decoration: BoxDecoration(
    color: Color(0xFFE0E5EC),
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Color(0xFFA3B1C6),
        offset: Offset(5, 5),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-5, -5),
        blurRadius: 10,
      ),
    ],
  ),
  child: Icon(Icons.play_arrow_rounded, color: Colors.blue),
);''',
      ),

      // 3. Animated Story Avatar Ring
      UIDesignChallengeItem(
        id: 'story_avatar_ring',
        title: 'Story Avatar Gradient Ring',
        category: 'Social UI',
        difficulty: 'Beginner',
        description:
            'Multi-color animated gradient ring around profile avatars with unread indicator and live tap ripple.',
        keyWidgets: ['SweepGradient', 'Container', 'CircleAvatar'],
        previewWidget: (context, isDark) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0xFF833AB4),
                    Color(0xFFFD1D1D),
                    Color(0xFFFCB045),
                    Color(0xFF833AB4),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF0072FF),
                  child: Icon(Icons.person_rounded, size: 48, color: Colors.white),
                ),
              ),
            ),
          );
        },
        sourceCode: '''// 📸 Instagram/WhatsApp Story Ring
Container(
  padding: EdgeInsets.all(3.5),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: SweepGradient(
      colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045), Color(0xFF833AB4)],
    ),
  ),
  child: Container(
    padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: CircleAvatar(
      radius: 36,
      backgroundImage: NetworkImage('https://...'),
    ),
  ),
);''',
      ),

      // 4. Restaurant Food Card
      UIDesignChallengeItem(
        id: 'food_delivery_card',
        title: 'Food Delivery Product Card',
        category: 'E-Commerce',
        difficulty: 'Beginner',
        description:
            'A clean restaurant item card featuring floating pricing tags, discount badge, star rating, and interactive favorite heart toggle.',
        keyWidgets: ['Stack', 'Positioned', 'ClipRRect', 'BoxShadow'],
        previewWidget: (context, isDark) {
          return Center(
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 140,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.fastfood_rounded, size: 64, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => setState(() => _isFavorite = !_isFavorite),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: Icon(
                              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            const Text('4.9 (1.2k)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Free Delivery', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Truffle Smash Burger',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Angus beef, truffle aioli & brioche',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$14.99',
                              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('Add +'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        sourceCode: '''// 🍔 Restaurant Delivery Card
Container(
  width: 280,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          Container(height: 140, decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20)))),
          Positioned(top: 10, right: 10, child: Icon(Icons.favorite, color: Colors.red)),
        ],
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Truffle Smash Burger', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [Text('\$14.99'), Spacer(), ElevatedButton(onPressed: (){}, child: Text('Add +'))]),
          ],
        ),
      ),
    ],
  ),
);''',
      ),
    ];
  }

  Widget _buildNeumorphicButton({
    required IconData icon,
    required Color bg,
    required Color dark,
    required Color light,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isPrimary ? 64 : 52,
        height: isPrimary ? 64 : 52,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: dark,
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: light,
              offset: const Offset(-4, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isPrimary ? const Color(0xFF0072FF) : Colors.grey.shade700,
          size: isPrimary ? 32 : 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = theme.primaryColor.value;

    final challenge = _challenges[_selectedChallengeIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.brush_rounded, color: Color(0xFFF857A6), size: 22),
            const SizedBox(width: 8),
            Text(
              'UI Design Challenges',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Challenge Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_challenges.length, (i) {
                final c = _challenges[i];
                final isSel = i == _selectedChallengeIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(c.title),
                    selected: isSel,
                    selectedColor: primary.withValues(alpha: 0.2),
                    checkmarkColor: primary,
                    onSelected: (_) => setState(() => _selectedChallengeIndex = i),
                  ),
                );
              }),
            ),
          ),

          // Main content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        challenge.category,
                        style: const TextStyle(color: Colors.purple, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        challenge.difficulty,
                        style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  challenge.title,
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.description,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 16),

                // Interactive Live Preview Box
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF14141E) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.touch_app_rounded, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            'Interactive Live Preview (Tap to test)',
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      challenge.previewWidget(context, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Key Widgets Chips
                Text(
                  'Key Widgets Used',
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: challenge.keyWidgets.map((w) {
                    return Chip(
                      backgroundColor: primary.withValues(alpha: 0.1),
                      label: Text(w, style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Source Code Section
                Row(
                  children: [
                    Text(
                      'Production Source Code',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      tooltip: 'Copy Code',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: challenge.sourceCode));
                        Get.snackbar('Copied', 'Widget source code copied', snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFF2B2D42),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SelectableText(
                    challenge.sourceCode,
                    style: GoogleFonts.firaCode(
                      fontSize: 12,
                      color: const Color(0xFF80FFDB),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
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
}
