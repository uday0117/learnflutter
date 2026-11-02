import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class AnimationLabScreen extends StatefulWidget {
  const AnimationLabScreen({super.key});

  @override
  State<AnimationLabScreen> createState() => _AnimationLabScreenState();
}

class _AnimationLabScreenState extends State<AnimationLabScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _selectedTabIndex = 0; // 0 = Playground, 1 = Presets, 2 = Dart Code

  // Animation Controls
  double _durationMs = 800;
  Curve _selectedCurve = Curves.elasticOut;
  String _selectedCurveName = 'elasticOut';

  double _targetScale = 1.3;
  double _targetRotationDegrees = 45;
  double _targetRadius = 24;
  Color _startColor = const Color(0xFF00C6FF);
  Color _endColor = const Color(0xFF0072FF);

  bool _isLooping = false;

  final List<CurveItem> _availableCurves = [
    CurveItem('elasticOut', Curves.elasticOut, 'Rubber band bounce effect'),
    CurveItem('bounceOut', Curves.bounceOut, 'Physical ball bouncing floor effect'),
    CurveItem('easeInOutBack', Curves.easeInOutBack, 'Pulls back before shooting forward'),
    CurveItem('fastOutSlowIn', Curves.fastOutSlowIn, 'Material 3 standard natural curve'),
    CurveItem('easeInOutCubic', Curves.easeInOutCubic, 'Smooth gradual acceleration and deceleration'),
    CurveItem('decelerate', Curves.decelerate, 'Starts fast, gently slows down'),
    CurveItem('linear', Curves.linear, 'Constant uniform speed with no acceleration'),
  ];

  final List<AnimationPreset> _presets = [
    AnimationPreset(
      name: 'Rubber Pop',
      icon: '💥',
      curveName: 'elasticOut',
      curve: Curves.elasticOut,
      durationMs: 900,
      scale: 1.4,
      rotation: 0,
      radius: 28,
      startColor: const Color(0xFFFF416C),
      endColor: const Color(0xFFFF4B2B),
    ),
    AnimationPreset(
      name: 'Bouncy Card',
      icon: '🏀',
      curveName: 'bounceOut',
      curve: Curves.bounceOut,
      durationMs: 1000,
      scale: 1.15,
      rotation: 15,
      radius: 35,
      startColor: const Color(0xFF11998E),
      endColor: const Color(0xFF38EF7D),
    ),
    AnimationPreset(
      name: 'Modern Twist',
      icon: '🌀',
      curveName: 'easeInOutBack',
      curve: Curves.easeInOutBack,
      durationMs: 750,
      scale: 1.25,
      rotation: 90,
      radius: 50,
      startColor: const Color(0xFF8E2DE2),
      endColor: const Color(0xFF4A00E0),
    ),
    AnimationPreset(
      name: 'Smooth Morph',
      icon: '✨',
      curveName: 'fastOutSlowIn',
      curve: Curves.fastOutSlowIn,
      durationMs: 600,
      scale: 1.1,
      rotation: 0,
      radius: 50,
      startColor: const Color(0xFF00C6FF),
      endColor: const Color(0xFF0072FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreen('AnimationLabScreen');
    _initController();
  }

  void _initController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _durationMs.round()),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: _selectedCurve,
    );

    _controller.forward();
  }

  void _rebuildController() {
    _controller.duration = Duration(milliseconds: _durationMs.round());
    _animation = CurvedAnimation(
      parent: _controller,
      curve: _selectedCurve,
    );
    _playAnimation();
  }

  void _playAnimation() {
    _controller.reset();
    if (_isLooping) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  void _applyPreset(AnimationPreset preset) {
    setState(() {
      _selectedCurveName = preset.curveName;
      _selectedCurve = preset.curve;
      _durationMs = preset.durationMs;
      _targetScale = preset.scale;
      _targetRotationDegrees = preset.rotation;
      _targetRadius = preset.radius;
      _startColor = preset.startColor;
      _endColor = preset.endColor;
    });
    _rebuildController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _generateDartCode() {
    return '''
import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomAnimatedWidget extends StatefulWidget {
  const CustomAnimatedWidget({super.key});

  @override
  State<CustomAnimatedWidget> createState() => _CustomAnimatedWidgetState();
}

class _CustomAnimatedWidgetState extends State<CustomAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: ${_durationMs.round()}),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.$_selectedCurveName,
    );

    ${_isLooping ? '_controller.repeat(reverse: true);' : '_controller.forward();'}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value;
        final scale = 1.0 + (t * (${(_targetScale - 1.0).toStringAsFixed(2)}));
        final rotation = t * (${_targetRotationDegrees.toStringAsFixed(1)} * math.pi / 180);
        final radius = 16.0 + (t * (${(_targetRadius - 16.0).toStringAsFixed(1)}));

        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x${_startColor.toARGB32().toRadixString(16).padLeft(8, '0')}),
                    Color(0x${_endColor.toARGB32().toRadixString(16).padLeft(8, '0')}),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x${_startColor.toARGB32().toRadixString(16).padLeft(8, '0')}).withValues(alpha: 0.4),
                    blurRadius: 16 * t,
                    offset: Offset(0, 8 * t),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.flutter_dash, color: Colors.white, size: 54),
              ),
            ),
          ),
        );
      },
    );
  }
}
''';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Flutter Animation Studio',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Replay Animation',
            icon: const Icon(Icons.replay_rounded),
            onPressed: _playAnimation,
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Navigation Tabs ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildSegmentTab(0, 'Playground', Icons.tune_rounded),
                const SizedBox(width: 8),
                _buildSegmentTab(1, 'Presets', Icons.auto_awesome_rounded),
                const SizedBox(width: 8),
                _buildSegmentTab(2, 'Dart Code', Icons.code_rounded),
              ],
            ),
          ),

          // ── Main Body Content ──
          Expanded(
            child: _selectedTabIndex == 2
                ? _buildCodeTab(isDark)
                : _selectedTabIndex == 1
                    ? _buildPresetsTab(isDark)
                    : _buildPlaygroundTab(isDark),
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

  Widget _buildSegmentTab(int index, String label, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0072FF)
                : const Color(0xFF0072FF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF0072FF),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF0072FF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 1. PLAYGROUND TAB ──
  Widget _buildPlaygroundTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        // ── Visual Canvas Stage ──
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.grey.shade300,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Grid background dots
              CustomPaint(
                size: const Size(double.infinity, 240),
                painter: _GridDotsPainter(isDark: isDark),
              ),

              // Animated Widget Canvas
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final t = _animation.value;
                  final scale = 1.0 + (t * (_targetScale - 1.0));
                  final rotationRad = t * (_targetRotationDegrees * 3.14159 / 180);
                  final radius = 16.0 + (t * (_targetRadius - 16.0));

                  return Transform.scale(
                    scale: scale,
                    child: Transform.rotate(
                      angle: rotationRad,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_startColor, _endColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(radius),
                          boxShadow: [
                            BoxShadow(
                              color: _startColor.withValues(alpha: 0.35 * t),
                              blurRadius: 18 * t,
                              offset: Offset(0, 8 * t),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.flutter_dash, color: Colors.white, size: 54),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Bottom control pill
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Curve: $_selectedCurveName',
                        style: GoogleFonts.sourceCodePro(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() => _isLooping = !_isLooping);
                            _playAnimation();
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _isLooping ? Colors.green : Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.repeat_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isLooping ? 'Looping' : 'Loop Off',
                                  style: const TextStyle(fontSize: 11, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.play_circle_fill_rounded,
                              size: 32, color: Color(0xFF00C6FF)),
                          onPressed: _playAnimation,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Curve Selector ──
        Text(
          'Select Animation Curve',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _availableCurves.map((curveItem) {
              final isSelected = _selectedCurveName == curveItem.name;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(curveItem.name),
                  selected: isSelected,
                  selectedColor: const Color(0xFF0072FF),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedCurveName = curveItem.name;
                      _selectedCurve = curveItem.curve;
                    });
                    _rebuildController();
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // ── Sliders Section ──
        Text(
          'Fine-Tune Parameters',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        _buildSliderTile(
          label: 'Duration (${_durationMs.round()} ms)',
          value: _durationMs,
          min: 200,
          max: 2500,
          divisions: 23,
          onChanged: (v) {
            setState(() => _durationMs = v);
            _rebuildController();
          },
          isDark: isDark,
        ),
        _buildSliderTile(
          label: 'Scale Target (${_targetScale.toStringAsFixed(2)}x)',
          value: _targetScale,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: (v) {
            setState(() => _targetScale = v);
            _playAnimation();
          },
          isDark: isDark,
        ),
        _buildSliderTile(
          label: 'Rotation Target (${_targetRotationDegrees.round()}°)',
          value: _targetRotationDegrees,
          min: 0,
          max: 360,
          divisions: 36,
          onChanged: (v) {
            setState(() => _targetRotationDegrees = v);
            _playAnimation();
          },
          isDark: isDark,
        ),
        _buildSliderTile(
          label: 'Corner Radius (${_targetRadius.round()} px)',
          value: _targetRadius,
          min: 0,
          max: 55,
          divisions: 11,
          onChanged: (v) {
            setState(() => _targetRadius = v);
            _playAnimation();
          },
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildSliderTile({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: const Color(0xFF0072FF),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ── 2. PRESETS TAB ──
  Widget _buildPresetsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Quick Production Presets',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tap any preset to apply and inspect its code immediately.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        ..._presets.map((preset) {
          final isSelected = _selectedCurveName == preset.curveName;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0072FF)
                    : (isDark ? Colors.white12 : Colors.grey.shade200),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [preset.startColor, preset.endColor],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(preset.icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preset.name,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Curve: Curves.${preset.curveName} • ${preset.durationMs.round()}ms',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0072FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _applyPreset(preset);
                    setState(() => _selectedTabIndex = 0);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── 3. DART CODE TAB ──
  Widget _buildCodeTab(bool isDark) {
    final code = _generateDartCode();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Production Flutter Code',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0072FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy Code'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  Get.snackbar(
                    'Copied! 📋',
                    'Animation code copied to clipboard',
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
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
    );
  }
}

class CurveItem {
  final String name;
  final Curve curve;
  final String description;

  CurveItem(this.name, this.curve, this.description);
}

class AnimationPreset {
  final String name;
  final String icon;
  final String curveName;
  final Curve curve;
  final double durationMs;
  final double scale;
  final double rotation;
  final double radius;
  final Color startColor;
  final Color endColor;

  AnimationPreset({
    required this.name,
    required this.icon,
    required this.curveName,
    required this.curve,
    required this.durationMs,
    required this.scale,
    required this.rotation,
    required this.radius,
    required this.startColor,
    required this.endColor,
  });
}

class _GridDotsPainter extends CustomPainter {
  final bool isDark;
  _GridDotsPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 2.0;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
