import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../services/ad_service.dart';
import '../widgets/flutter_glow_logo.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final ThemeController themeController = Get.find<ThemeController>();

  // Master orchestrator
  late final AnimationController _masterController;

  // Background gradient shift
  late final AnimationController _gradientController;

  // Logo entrance
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotate;
  late final Animation<double> _logoFade;

  // Glow rings pulse
  late final AnimationController _glowController;
  late final Animation<double> _glowRing1;
  late final Animation<double> _glowRing2;

  // Shimmer sweep across the Flutter mark
  late final AnimationController _shimmerController;

  // Text entrance
  late final AnimationController _textController;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _subtitleFade;

  // Progress bar
  late final AnimationController _progressController;
  late final Animation<double> _progressAnim;

  // Particles
  late final AnimationController _particleController;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _buildParticles();
    _setupAnimations();
    _navigateToHome();
  }

  void _buildParticles() {
    final rng = math.Random(42);
    for (int i = 0; i < 18; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: rng.nextDouble() * 4 + 2,
        speed: rng.nextDouble() * 0.6 + 0.2,
        phase: rng.nextDouble() * math.pi * 2,
        opacity: rng.nextDouble() * 0.35 + 0.08,
      ));
    }
  }

  void _setupAnimations() {
    // Gradient — loops forever
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Glow rings — loops
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _glowRing1 = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowRing2 = Tween<double>(begin: 1.12, end: 0.88).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    // Particles — loops
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Logo entrance — plays once
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 35,
      ),
    ]).animate(_logoController);

    _logoRotate = Tween<double>(begin: -0.08, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text entrance
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleSlide = Tween<double>(begin: 32, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
      ),
    );

    // Progress bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressAnim = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    // Master orchestrator — staggers logo → text → progress
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // Stagger sequence
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _progressController.forward();
    });
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    AdService().showAppOpenAdIfAvailable();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    Get.off(
      () => const HomeScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _masterController.dispose();
    _gradientController.dispose();
    _logoController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          final primary = themeController.primaryColor.value;
          final dark = Color.lerp(primary, Colors.black, 0.55)!;
          final mid = Color.lerp(primary, Colors.black, 0.28)!;

          return AnimatedBuilder(
            animation: Listenable.merge([
              _gradientController,
              _logoController,
              _glowController,
              _shimmerController,
              _textController,
              _progressController,
              _particleController,
            ]),
            builder: (context, _) {
              final gShift = _gradientController.value;

              return Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.6 + gShift * 0.4, -1.0),
                    end: Alignment(0.6 - gShift * 0.4, 1.0),
                    colors: [
                      dark,
                      Color.lerp(dark, mid, gShift)!,
                      mid,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    // Floating particles
                    ..._particles.map((p) => _buildParticle(p, size, primary)),

                    // Decorative top-right orb
                    Positioned(
                      top: -size.width * 0.25,
                      right: -size.width * 0.2,
                      child: Container(
                        width: size.width * 0.75,
                        height: size.width * 0.75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              primary.withValues(alpha: 0.22),
                              primary.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Decorative bottom-left orb
                    Positioned(
                      bottom: -size.width * 0.3,
                      left: -size.width * 0.25,
                      child: Container(
                        width: size.width * 0.85,
                        height: size.width * 0.85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              primary.withValues(alpha: 0.15),
                              primary.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Center content
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Glow rings + logo
                          SizedBox(
                            width: 220,
                            height: 220,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer glow ring 2
                                Transform.scale(
                                  scale: _glowRing2.value * 1.48,
                                  child: Container(
                                    width: 168,
                                    height: 168,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.08 +
                                              _glowController.value * 0.04,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                // Outer glow ring 1
                                Transform.scale(
                                  scale: _glowRing1.value * 1.22,
                                  child: Container(
                                    width: 148,
                                    height: 148,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          primary.withValues(alpha: 0.28),
                                          Colors.white.withValues(alpha: 0.12),
                                          primary.withValues(alpha: 0.18),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: primary.withValues(alpha: 0.24),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                // Inner glow halo
                                Transform.scale(
                                  scale: _glowRing1.value,
                                  child: Container(
                                    width: 124,
                                    height: 124,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          primary.withValues(alpha: 0.42),
                                          primary.withValues(alpha: 0.12),
                                          primary.withValues(alpha: 0.0),
                                        ],
                                        stops: const [0.0, 0.55, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                                // Glowing Flutter mark
                                FadeTransition(
                                  opacity: _logoFade,
                                  child: Transform.scale(
                                    scale: _logoScale.value,
                                    child: Transform.rotate(
                                      angle: _logoRotate.value,
                                      child: FlutterGlowLogo(
                                        size: 128,
                                        glowPulse: _glowController.value,
                                        orbitProgress:
                                            _particleController.value,
                                        shimmerProgress:
                                            _shimmerController.value,
                                        showBackdrop: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 36),

                          // Title
                          Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: Opacity(
                              opacity: _titleFade.value,
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withValues(alpha: 0.92),
                                    primary.withValues(alpha: 0.85),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Learn Flutter',
                                  style: GoogleFonts.inter(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.8,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Subtitle
                          Opacity(
                            opacity: _subtitleFade.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Master Every Widget',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom progress bar
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Opacity(
                            opacity: _subtitleFade.value,
                            child: Text(
                              'Preparing your experience...',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.45),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 52),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _progressAnim.value,
                                minHeight: 3,
                                backgroundColor: Colors.white.withValues(alpha: 0.12),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Version tag
                    Positioned(
                      bottom: 22,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: _subtitleFade.value * 0.5,
                        child: Text(
                          'v1.0.4',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.4),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildParticle(_Particle p, Size size, Color primary) {
    final t = _particleController.value;
    final dy = (t * p.speed + p.phase / (math.pi * 2)) % 1.0;
    final x = p.x * size.width +
        math.sin(t * math.pi * 2 * p.speed + p.phase) * 20;
    final y = (1.0 - dy) * size.height;

    return Positioned(
      left: x - p.radius,
      top: y - p.radius,
      child: Opacity(
        opacity: p.opacity * (0.5 + 0.5 * math.sin(t * math.pi * 2 + p.phase)),
        child: Container(
          width: p.radius * 2,
          height: p.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary.withValues(alpha: 0.7),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.3),
                blurRadius: p.radius * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.opacity,
  });
}
