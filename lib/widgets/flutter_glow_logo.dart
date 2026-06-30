import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Animated Flutter mark with multi-layer glow, orbiting sparks, and shimmer.
class FlutterGlowLogo extends StatelessWidget {
  const FlutterGlowLogo({
    super.key,
    required this.size,
    required this.glowPulse,
    required this.orbitProgress,
    required this.shimmerProgress,
    this.opacity = 1,
    this.showBackdrop = false,
  });

  final double size;
  final double glowPulse;
  final double orbitProgress;
  final double shimmerProgress;
  final double opacity;
  final bool showBackdrop;

  static const Color _flutterBlue = Color(0xFF02569B);
  static const Color _flutterCyan = Color(0xFF54C5F8);
  static const Color _flutterLight = Color(0xFF7DD3FC);

  @override
  Widget build(BuildContext context) {
    final logoSize = size * 0.68;
    final glowScale = 0.94 + glowPulse * 0.14;

    return SizedBox(
      width: size,
      height: size,
      child: Opacity(
        opacity: opacity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showBackdrop) ...[
              // Soft floor reflection
              Positioned(
                bottom: size * 0.06,
                child: Transform.scale(
                  scaleX: 1,
                  scaleY: 0.22,
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(0, size * 0.55),
                    child: Container(
                      width: size * 0.72,
                      height: size * 0.72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _flutterCyan.withValues(alpha: 0.22 + glowPulse * 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Frosted glass disc
              Transform.scale(
                scale: glowScale * 1.02,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: size * 0.88,
                      height: size * 0.88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.16),
                            Colors.white.withValues(alpha: 0.04),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _flutterBlue.withValues(alpha: 0.25),
                            blurRadius: 28,
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Ambient color bloom
            Transform.scale(
              scale: glowScale * 1.42,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _flutterLight.withValues(alpha: 0.22 + glowPulse * 0.14),
                      _flutterCyan.withValues(alpha: 0.16),
                      _flutterBlue.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.28, 0.55, 1.0],
                  ),
                ),
              ),
            ),

            // Rotating accent ring
            Transform.rotate(
              angle: orbitProgress * math.pi * 2,
              child: CustomPaint(
                size: Size(size, size),
                painter: _AccentRingPainter(
                  glowPulse: glowPulse,
                  cyan: _flutterCyan,
                  blue: _flutterBlue,
                ),
              ),
            ),

            // Soft blurred logo halos
            for (final layer in _glowLayers)
              Transform.scale(
                scale: glowScale * layer.scale,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: layer.blur,
                    sigmaY: layer.blur,
                  ),
                  child: Opacity(
                    opacity: layer.opacity * (0.75 + glowPulse * 0.25),
                    child: FlutterLogo(
                      size: logoSize,
                      style: FlutterLogoStyle.markOnly,
                      textColor: layer.color,
                    ),
                  ),
                ),
              ),

            // Orbiting sparks
            CustomPaint(
              size: Size(size, size),
              painter: _OrbitSparkPainter(
                progress: orbitProgress,
                glowPulse: glowPulse,
                cyan: _flutterCyan,
                blue: _flutterBlue,
              ),
            ),

            // Main logo with shimmer sweep
            Transform.scale(
              scale: glowScale,
              child: ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) {
                  final sweep = shimmerProgress * 2.6 - 1.3;
                  return LinearGradient(
                    begin: Alignment(sweep - 0.55, -0.35),
                    end: Alignment(sweep + 0.55, 0.35),
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.75),
                      Colors.white.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.32, 0.44, 0.5, 0.56, 0.68],
                  ).createShader(bounds);
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: _flutterLight.withValues(alpha: 0.45),
                        blurRadius: 26,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: _flutterCyan.withValues(alpha: 0.55),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: _flutterBlue.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: FlutterLogo(
                    size: logoSize,
                    style: FlutterLogoStyle.markOnly,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _glowLayers = [
    _GlowLayer(color: _flutterLight, blur: 30, opacity: 0.28, scale: 1.1),
    _GlowLayer(color: _flutterCyan, blur: 22, opacity: 0.32, scale: 1.06),
    _GlowLayer(color: _flutterBlue, blur: 14, opacity: 0.26, scale: 1.0),
  ];
}

class _GlowLayer {
  const _GlowLayer({
    required this.color,
    required this.blur,
    required this.opacity,
    required this.scale,
  });

  final Color color;
  final double blur;
  final double opacity;
  final double scale;
}

class _AccentRingPainter extends CustomPainter {
  _AccentRingPainter({
    required this.glowPulse,
    required this.cyan,
    required this.blue,
  });

  final double glowPulse;
  final Color cyan;
  final Color blue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..shader = SweepGradient(
        colors: [
          cyan.withValues(alpha: 0.05),
          cyan.withValues(alpha: 0.45 + glowPulse * 0.25),
          blue.withValues(alpha: 0.35 + glowPulse * 0.2),
          cyan.withValues(alpha: 0.08),
        ],
        stops: const [0.0, 0.35, 0.65, 1.0],
      ).createShader(rect);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AccentRingPainter oldDelegate) {
    return oldDelegate.glowPulse != glowPulse;
  }
}

class _OrbitSparkPainter extends CustomPainter {
  _OrbitSparkPainter({
    required this.progress,
    required this.glowPulse,
    required this.cyan,
    required this.blue,
  });

  final double progress;
  final double glowPulse;
  final Color cyan;
  final Color blue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.46;

    const sparkCount = 6;
    for (var i = 0; i < sparkCount; i++) {
      final angle =
          (i / sparkCount) * math.pi * 2 + progress * math.pi * 2;
      final wobble = math.sin(progress * math.pi * 4 + i) * 6;
      final radius = baseRadius + wobble;
      final sparkSize = 2.2 + (i.isEven ? glowPulse * 1.8 : glowPulse);

      final pos = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      final color = i.isEven ? cyan : blue;
      final paint = Paint()
        ..color = color.withValues(alpha: 0.55 + glowPulse * 0.35)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, sparkSize * 1.6);

      canvas.drawCircle(pos, sparkSize, paint);
      canvas.drawCircle(
        pos,
        sparkSize * 0.45,
        Paint()..color = Colors.white.withValues(alpha: 0.85),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitSparkPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.glowPulse != glowPulse;
  }
}
