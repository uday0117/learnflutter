import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../services/deep_link_service.dart';
import '../services/share_card_service.dart';
import '../widgets/banner_ad_widget.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  static const String _userNameKey = 'certificate_user_name';
  static const String _goldThemeUnlockedKey = 'certificate_gold_unlocked';

  final _box = GetStorage();
  late TextEditingController _nameController;

  int _selectedTrackIndex = 0;
  String _selectedTheme = 'classic'; // 'classic' or 'prestige_gold'
  bool _isGoldUnlocked = false;

  final List<CertificateTrack> _tracks = [
    CertificateTrack(
      id: 'ui_specialist',
      title: 'Flutter UI Specialist',
      subtitle: 'Demonstrated mastery in Flutter widgets, reactive layouts & responsive design',
      badgeLabel: 'UI / UX PRO',
      ribbonColor: Color(0xFF02569B),
    ),
    CertificateTrack(
      id: 'quiz_master',
      title: 'Flutter Quiz Master',
      subtitle: 'Excellence in Dart language theory, widget architecture & performance concepts',
      badgeLabel: 'KNOWLEDGE ACE',
      ribbonColor: Color(0xFF7B1FA2),
    ),
    CertificateTrack(
      id: 'interview_ready',
      title: 'Flutter Job-Ready Certified',
      subtitle: 'Thoroughly prepared across junior, intermediate & senior Flutter interview questions',
      badgeLabel: 'JOB READY',
      ribbonColor: Color(0xFF00796B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreen('CertificateScreen');

    // Default to Firebase user displayName if available, or saved name, or 'Flutter Developer'
    String initialName = _box.read<String>(_userNameKey) ?? '';
    if (initialName.isEmpty) {
      final auth = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
      initialName = auth?.displayName ?? auth?.user.value?.displayName ?? 'Flutter Developer';
    }
    _nameController = TextEditingController(text: initialName);

    _isGoldUnlocked = _box.read<bool>(_goldThemeUnlockedKey) ?? AdService().isAdFree;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName(String name) {
    _box.write(_userNameKey, name.trim());
  }

  void _unlockGoldThemeWithAd() {
    AnalyticsService().logRewardAccepted(placement: 'certificate_gold_theme');
    AdService().showRewardedAd(
      context: context,
      onRewarded: () {
        setState(() {
          _isGoldUnlocked = true;
          _selectedTheme = 'prestige_gold';
        });
        _box.write(_goldThemeUnlockedKey, true);
        AnalyticsService().logRewardCompleted(placement: 'certificate_gold_theme');
        Get.snackbar(
          'Unlocked! 🏆',
          'Prestige Gold Certificate Theme is now permanently unlocked!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber.shade800,
          colorText: Colors.white,
        );
      },
      onNotReady: () {
        Get.snackbar(
          'Ad Loading',
          'Video ad is preparing. Please try again in a moment.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }

  String _generateCertificateId(String trackId) {
    final nameHash = (_nameController.text.trim().hashCode.abs() % 9000) + 1000;
    return 'LF-${trackId.toUpperCase().substring(0, 2)}-$nameHash';
  }

  void _shareCertificate() {
    final track = _tracks[_selectedTrackIndex];
    final certId = _generateCertificateId(track.id);
    final studentName = _nameController.text.trim().isEmpty ? 'Flutter Developer' : _nameController.text.trim();

    final text =
        '🎓 Thrilled to receive my "${track.title}" from Learn Flutter!\n'
        'Issued to: $studentName (ID: $certId)\n\n'
        'Master Flutter with hands-on widgets & interactive quizzes: ${DeepLinkService.playStoreUrl}';

    final certWidget = _buildCertificateWidget(
      track: track,
      studentName: studentName,
      certId: certId,
      isForExport: true,
    );

    ShareCardService().shareCustomWidget(
      card: certWidget,
      text: text,
      filePrefix: 'flutter_certificate_${track.id}',
    );

    AnalyticsService().logEvent('certificate_shared', parameters: {
      'track': track.id,
      'theme': _selectedTheme,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final track = _tracks[_selectedTrackIndex];
    final studentName = _nameController.text.trim().isEmpty ? 'Flutter Developer' : _nameController.text.trim();
    final certId = _generateCertificateId(track.id);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Certificate of Mastery',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Share Certificate',
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareCertificate,
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // ── Track Selector ──
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_tracks.length, (index) {
                      final t = _tracks[index];
                      final isSelected = _selectedTrackIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(t.title),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF02569B),
                          onSelected: (val) {
                            if (val) setState(() => _selectedTrackIndex = index);
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Name input field ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.badge_rounded, color: Color(0xFF02569B), size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Your Full Name for Certificate',
                          ),
                          onChanged: (val) {
                            setState(() {});
                            _saveName(val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Theme Selector Row ──
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTheme = 'classic'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: _selectedTheme == 'classic'
                                ? const Color(0xFF02569B).withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedTheme == 'classic'
                                  ? const Color(0xFF02569B)
                                  : (isDark ? Colors.white12 : Colors.grey.shade300),
                              width: _selectedTheme == 'classic' ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.workspace_premium_rounded, color: Color(0xFF02569B), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Royal Classic',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_isGoldUnlocked || AdService().isAdFree) {
                            setState(() => _selectedTheme = 'prestige_gold');
                          } else {
                            _showGoldThemeDialog();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: _selectedTheme == 'prestige_gold'
                                ? Colors.amber.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedTheme == 'prestige_gold'
                                  ? Colors.amber.shade700
                                  : (isDark ? Colors.white12 : Colors.grey.shade300),
                              width: _selectedTheme == 'prestige_gold' ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isGoldUnlocked ? Icons.stars_rounded : Icons.lock_outline_rounded,
                                color: Colors.amber.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Prestige Gold',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.amber.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Live Certificate Preview ──
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _buildCertificateWidget(
                      track: track,
                      studentName: studentName,
                      certId: certId,
                      isForExport: false,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Share / Export Button ──
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF02569B),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.share_rounded, size: 20),
                    label: Text(
                      'Share Certificate to LinkedIn / Socials',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    onPressed: _shareCertificate,
                  ),
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

  void _showGoldThemeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Unlock Prestige Gold',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'Watch 1 quick sponsor video to permanently unlock the luxury Prestige Gold Certificate theme for your profile and social sharing!',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade800,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
            label: const Text('Watch & Unlock Free'),
            onPressed: () {
              Navigator.pop(ctx);
              _unlockGoldThemeWithAd();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateWidget({
    required CertificateTrack track,
    required String studentName,
    required String certId,
    required bool isForExport,
  }) {
    final isGold = _selectedTheme == 'prestige_gold';
    final bgColor = isGold ? const Color(0xFF14141E) : Colors.white;
    final borderColor = isGold ? const Color(0xFFFFD700) : const Color(0xFF02569B);
    final textColor = isGold ? Colors.white : const Color(0xFF1A1A24);
    final subColor = isGold ? Colors.white70 : Colors.black54;

    return Container(
      width: 480,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: isGold ? 0.35 : 0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Certificate Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: borderColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school_rounded, color: borderColor, size: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LEARN FLUTTER',
                    style: GoogleFonts.outfit(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w900,
                      color: borderColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: borderColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Text(
                  track.badgeLabel,
                  style: GoogleFonts.outfit(
                    color: borderColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Title ──
          Text(
            'CERTIFICATE OF MASTERY',
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: borderColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This is proudly presented to',
            style: GoogleFonts.outfit(fontSize: 12, color: subColor),
          ),
          const SizedBox(height: 10),

          // ── Student Name ──
          Text(
            studentName,
            style: GoogleFonts.greatVibes(
              fontSize: 34,
              color: isGold ? const Color(0xFFFFE082) : const Color(0xFF02569B),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            width: 260,
            height: 1.5,
            color: borderColor.withValues(alpha: 0.4),
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),

          // ── Track Title & Description ──
          Text(
            track.title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              track.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: subColor, height: 1.3),
            ),
          ),
          const SizedBox(height: 20),

          // ── Footer with ID and Verification ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: $certId',
                      style: GoogleFonts.sourceCodePro(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: borderColor)),
                  const SizedBox(height: 2),
                  Text(
                    'Issued: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 10, color: subColor),
                  ),
                ],
              ),
              // Golden seal badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isGold
                        ? [const Color(0xFFFFD700), const Color(0xFFFFA000)]
                        : [const Color(0xFF02569B), const Color(0xFF0072FF)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'VERIFIED APP',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CertificateTrack {
  final String id;
  final String title;
  final String subtitle;
  final String badgeLabel;
  final Color ribbonColor;

  CertificateTrack({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.ribbonColor,
  });
}

