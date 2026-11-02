import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class UICookbookScreen extends StatefulWidget {
  const UICookbookScreen({super.key});

  @override
  State<UICookbookScreen> createState() => _UICookbookScreenState();
}

class _UICookbookScreenState extends State<UICookbookScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreen('UICookbookScreen');
  }

  void _showCodeSheet(BuildContext context, String title, String code, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0072FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      Get.snackbar(
                        'Copied! 📋',
                        'Code copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SyntaxView(
                    code: code,
                    syntax: Syntax.DART,
                    syntaxTheme: isDark ? SyntaxTheme.dracula() : SyntaxTheme.standard(),
                    fontSize: 12.0,
                    withZoom: true,
                    withLinesCount: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Flutter UI Cookbook',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // ── Header Banner ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE94057).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🎨', style: TextStyle(fontSize: 26)),
                          const SizedBox(width: 10),
                          Text(
                            'MODERN UI RECIPES',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ready-to-Use Production Components',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'High-demand UI components with live interactive demos and one-click copyable source code.',
                        style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Component 1: Glassmorphism Card ──
                _CookbookItemCard(
                  title: 'Glassmorphism Frosted Card',
                  category: 'Visual Effects',
                  description: 'Frosted glass blur effect with BackdropFilter and border gradient highlighting.',
                  previewWidget: _buildGlassmorphismPreview(isDark),
                  codeSnippet: _glassmorphismCode,
                  onViewCode: (title, code) => _showCodeSheet(context, title, code, isDark),
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                // ── Component 2: Neumorphic Soft UI Button ──
                _CookbookItemCard(
                  title: 'Neumorphic Soft Button',
                  category: 'Tactile UI',
                  description: 'Interactive button with realistic 3D depth shadows and smooth press physics.',
                  previewWidget: const _NeumorphicButtonPreview(),
                  codeSnippet: _neumorphicCode,
                  onViewCode: (title, code) => _showCodeSheet(context, title, code, isDark),
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                // ── Component 3: Shimmer Skeleton Loader ──
                _CookbookItemCard(
                  title: 'Animated Shimmer Skeleton',
                  category: 'Loading States',
                  description: 'Industry-standard animated placeholder for content loading in modern feeds.',
                  previewWidget: const _ShimmerSkeletonPreview(),
                  codeSnippet: _shimmerCode,
                  onViewCode: (title, code) => _showCodeSheet(context, title, code, isDark),
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                // ── Component 4: OTP Verification Field ──
                _CookbookItemCard(
                  title: 'OTP PIN Verification Boxes',
                  category: 'Forms & Inputs',
                  description: '4-digit auto-advancing pin input boxes with active focus glow.',
                  previewWidget: const _OtpFieldPreview(),
                  codeSnippet: _otpCode,
                  onViewCode: (title, code) => _showCodeSheet(context, title, code, isDark),
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                // ── Component 5: Gradient Percentage Ring ──
                _CookbookItemCard(
                  title: 'Sweep Gradient Progress Ring',
                  category: 'Data Visualization',
                  description: 'Custom animated circular progress ring with smooth sweep gradient and central stats.',
                  previewWidget: const _GradientRingPreview(),
                  codeSnippet: _gradientRingCode,
                  onViewCode: (title, code) => _showCodeSheet(context, title, code, isDark),
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // ── Anchored Banner Ad ──
          if (!AdService().isAdFree)
            const SafeArea(
              top: false,
              child: Center(child: BannerAdWidget()),
            ),
        ],
      ),
    );
  }

  // ── PREVIEWS ──
  Widget _buildGlassmorphismPreview(bool isDark) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.blur_on_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Glass Card',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const Text(
                        'BackdropFilter 10px Blur',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const String _glassmorphismCode = '''
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  const GlassmorphicCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
''';

  static const String _neumorphicCode = '''
import 'package:flutter/material.dart';

class NeumorphicButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const NeumorphicButton({super.key, required this.onTap, required this.child});

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFE0E5EC);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isPressed
              ? []
              : [
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: const Color(0xFFA3B1C6).withValues(alpha: 0.6),
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}
''';

  static const String _shimmerCode = '''
import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + (3 * _controller.value), -0.3),
              end: Alignment(0.5 + (3 * _controller.value), 0.3),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
            ),
          ),
        );
      },
    );
  }
}
''';

  static const String _otpCode = '''
import 'package:flutter/material.dart';

class OtpInputField extends StatelessWidget {
  final int length;
  const OtpInputField({super.key, this.length = 4});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 55,
          height: 60,
          child: TextField(
            autofocus: index == 0,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.blue.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
''';

  static const String _gradientRingCode = '''
import 'dart:math' as math;
import 'package:flutter/material.dart';

class GradientProgressRing extends StatelessWidget {
  final double percent; // 0.0 to 1.0
  const GradientProgressRing({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 120),
      painter: _GradientRingPainter(percent: percent),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Center(
          child: Text(
            '\${(percent * 100).round()}%',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double percent;
  _GradientRingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(center, radius, trackPaint);

    // Gradient Sweep Arc
    final sweepGradient = const SweepGradient(
      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    );

    final arcPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
''';
}

class _CookbookItemCard extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final Widget previewWidget;
  final String codeSnippet;
  final void Function(String title, String code) onViewCode;
  final bool isDark;

  const _CookbookItemCard({
    required this.title,
    required this.category,
    required this.description,
    required this.previewWidget,
    required this.codeSnippet,
    required this.onViewCode,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0072FF).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0072FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0072FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.code_rounded, size: 16),
                  label: const Text('Code'),
                  onPressed: () => onViewCode(title, codeSnippet),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Preview Canvas
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                ),
              ),
            ),
            child: previewWidget,
          ),
        ],
      ),
    );
  }
}

// ── NEUMORPHIC PREVIEW ──
class _NeumorphicButtonPreview extends StatefulWidget {
  const _NeumorphicButtonPreview();

  @override
  State<_NeumorphicButtonPreview> createState() => _NeumorphicButtonPreviewState();
}

class _NeumorphicButtonPreviewState extends State<_NeumorphicButtonPreview> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E5EC),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _pressed
                ? []
                : [
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: const Color(0xFFA3B1C6).withValues(alpha: 0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _pressed ? Icons.touch_app_rounded : Icons.fingerprint_rounded,
                color: const Color(0xFF2A5298),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _pressed ? 'Pressed!' : 'Tap Me',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A5298),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── SHIMMER SKELETON PREVIEW ──
class _ShimmerSkeletonPreview extends StatefulWidget {
  const _ShimmerSkeletonPreview();

  @override
  State<_ShimmerSkeletonPreview> createState() => _ShimmerSkeletonPreviewState();
}

class _ShimmerSkeletonPreviewState extends State<_ShimmerSkeletonPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final gradient = LinearGradient(
          begin: Alignment(-1.5 + (3 * _ctrl.value), -0.3),
          end: Alignment(0.5 + (3 * _ctrl.value), 0.3),
          colors: [
            Colors.grey.withValues(alpha: 0.2),
            Colors.grey.withValues(alpha: 0.5),
            Colors.grey.withValues(alpha: 0.2),
          ],
        );

        return Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradient,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: gradient,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: gradient,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── OTP FIELD PREVIEW ──
class _OtpFieldPreview extends StatelessWidget {
  const _OtpFieldPreview();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        final sampleDigits = ['5', '8', '2', ''];
        return Container(
          width: 50,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF0072FF).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: i == 3 ? const Color(0xFF0072FF) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              sampleDigits[i],
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }
}

// ── GRADIENT RING PREVIEW ──
class _GradientRingPreview extends StatelessWidget {
  const _GradientRingPreview();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(100, 100),
        painter: _SampleRingPainter(),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Text(
              '85%',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _SampleRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;

    final track = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, track);

    final sweep = const SweepGradient(
      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    );

    final arc = Paint()
      ..shader = sweep.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      2 * 3.14159 * 0.85,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

