import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../controllers/update_controller.dart';

class InAppUpdateBanner extends StatefulWidget {
  const InAppUpdateBanner({super.key});

  @override
  State<InAppUpdateBanner> createState() => _InAppUpdateBannerState();
}

class _InAppUpdateBannerState extends State<InAppUpdateBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final update = Get.find<UpdateController>();

    return Obx(() {
      if (!update.isVisible) return const SizedBox.shrink();

      final primary = theme.primaryColor.value;
      final isDark = theme.isDarkMode.value;
      final phase = update.phase.value;
      final progress = update.progress.value;
      final bottomInset = MediaQuery.of(context).padding.bottom;

      return Positioned(
        left: 16,
        right: 16,
        bottom: 16 + bottomInset,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 24, end: 0),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          builder: (context, offset, child) => Transform.translate(
            offset: Offset(0, offset),
            child: child,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(primary, Colors.white, isDark ? 0.08 : 0.22)!,
                      Color.lerp(primary, Colors.black, isDark ? 0.45 : 0.18)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: isDark ? 0.14 : 0.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _pulse,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            phase == UpdateUiPhase.installing
                                ? Icons.system_update_alt_rounded
                                : Icons.cloud_download_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              phase == UpdateUiPhase.installing
                                  ? 'update_installing_title'.tr
                                  : 'update_available_title'.tr,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              update.statusMessage.value.isNotEmpty
                                  ? update.statusMessage.value
                                  : 'update_downloading_sub'.tr,
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontSize: 12.5,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: phase == UpdateUiPhase.downloading
                                    ? progress
                                    : null,
                                minHeight: 6,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.22),
                                color: Colors.white,
                              ),
                            ),
                            if (phase == UpdateUiPhase.downloading) ...[
                              const SizedBox(height: 6),
                              Text(
                                '${(progress * 100).round()}%',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
