import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/streak_controller.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../services/deep_link_service.dart';
import 'certificate_screen.dart';

class RewardsHubScreen extends StatefulWidget {
  const RewardsHubScreen({super.key});

  @override
  State<RewardsHubScreen> createState() => _RewardsHubScreenState();
}

class _RewardsHubScreenState extends State<RewardsHubScreen> {
  final AdService _adService = AdService();
  final StreakController _streakController = Get.find<StreakController>();
  final _box = GetStorage();

  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreen('RewardsHubScreen');
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _updateRemaining();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    setState(() {
      _remaining = _adService.adFreeRemaining;
    });
  }

  String _formatDuration(Duration d) {
    if (d <= Duration.zero) return '00:00';
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _claimAdFreePass() {
    _adService.showRewardedAd(
      onRewarded: () {
        _adService.grantAdFreePass(duration: const Duration(hours: 1));
        _updateRemaining();
        Get.snackbar(
          'Ad-Free Activated! 🚀',
          'Enjoy 1 hour completely ad-free across the entire app!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onNotReady: _showAdNotReady,
    );
  }

  void _claimStreakShield() {
    _adService.showRewardedAd(
      onRewarded: () {
        _streakController.addShield();
        Get.snackbar(
          'Streak Shield Claimed! 🛡️',
          'Your learning streak is protected if you miss a day.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00C6FF),
          colorText: Colors.white,
        );
      },
      onNotReady: _showAdNotReady,
    );
  }

  void _unlockAllProjects() {
    _adService.showRewardedAd(
      onRewarded: () {
        final expiry = DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch;
        _box.write('all_projects_unlocked_expiry', expiry);
        Get.snackbar(
          'Projects Unlocked! 📦',
          'Full source code for all mini-projects unlocked for 24 hours!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.purple,
          colorText: Colors.white,
        );
      },
      onNotReady: _showAdNotReady,
    );
  }

  void _showAdNotReady() {
    Get.snackbar(
      'Sponsor Video Loading',
      'Please wait a few seconds and try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _inviteFriends() {
    final text =
        '⚡ Learning Flutter with interactive widgets, quizzes & real source code!\n'
        'Check out Learn Flutter on Google Play:\n${DeepLinkService.playStoreUrl}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAdFree = _remaining > Duration.zero;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Rewards & Power-Ups',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          // ── Hero Card: 1-Hour Ad-Free Status ──
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isAdFree
                    ? [const Color(0xFF11998E), const Color(0xFF38EF7D)]
                    : [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (isAdFree ? const Color(0xFF11998E) : const Color(0xFF2575FC))
                      .withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isAdFree ? Icons.check_circle_rounded : Icons.bolt_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isAdFree ? 'AD-FREE ACTIVE' : 'POWER PASS',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isAdFree)
                      Text(
                        _formatDuration(_remaining),
                        style: GoogleFonts.sourceCodePro(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isAdFree ? 'Zero Ads Running' : '1-Hour Ad-Free Experience',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isAdFree
                      ? 'All banners, interstitials, and popups are completely silenced.'
                      : 'Watch a short 20-30s sponsor video to disable all ads across the app for 60 minutes.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isAdFree ? Colors.green.shade800 : Colors.blue.shade900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: Icon(
                      isAdFree ? Icons.add_alarm_rounded : Icons.play_arrow_rounded,
                      size: 20,
                    ),
                    label: Text(
                      isAdFree ? 'Extend by +1 Hour' : 'Watch Video to Activate (Free)',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    onPressed: _claimAdFreePass,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Section Title ──
          Text(
            'Daily Perks & Rewards',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 14),

          // ── Perk 1: Streak Freeze Shield ──
          Obx(() {
            final shields = _streakController.streakShields.value;
            return _buildRewardCard(
              isDark: isDark,
              icon: Icons.shield_rounded,
              iconGradient: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
              title: 'Streak Freeze Shield',
              badge: '$shields Owned',
              desc: 'Protects your daily learning streak if you ever miss a day of practice.',
              actionLabel: 'Get +1 Shield',
              onTap: _claimStreakShield,
            );
          }),
          const SizedBox(height: 14),

          // ── Perk 2: 24h Project Source Code Pass ──
          _buildRewardCard(
            isDark: isDark,
            icon: Icons.code_rounded,
            iconGradient: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            title: 'Full Projects Source Code (24h)',
            badge: '24h Pass',
            desc: 'Unlock all 5+ complete Flutter app project architectures and source codes.',
            actionLabel: 'Unlock 24h',
            onTap: _unlockAllProjects,
          ),
          const SizedBox(height: 14),

          // ── Perk 3: Luxury Gold Certificate Theme ──
          _buildRewardCard(
            isDark: isDark,
            icon: Icons.stars_rounded,
            iconGradient: const [Color(0xFFFFD700), Color(0xFFFFA000)],
            title: 'Prestige Gold Certificate',
            badge: 'Exclusive',
            desc: 'Unlock the high-end dark gold certificate theme to showcase on LinkedIn & resume.',
            actionLabel: 'Customize',
            onTap: () => Get.to(() => const CertificateScreen(), transition: Transition.rightToLeft),
          ),
          const SizedBox(height: 24),

          // ── Viral Growth Card: Invite Friends ──
          InkWell(
            onTap: _inviteFriends,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('👥', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite a Study Buddy',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to share the app with a friend and learn Flutter together!',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard({
    required bool isDark,
    required IconData icon,
    required List<Color> iconGradient,
    required String title,
    required String badge,
    required String desc,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: iconGradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: iconGradient.first.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: iconGradient.first,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: iconGradient),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          actionLabel,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
