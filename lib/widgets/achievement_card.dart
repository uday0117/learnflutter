import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/engagement_controller.dart';

/// Branded shareable achievement card rendered as an image.
class AchievementCard extends StatelessWidget {
  final ShareMilestoneType type;
  final int streak;
  final int progressPercent;
  final Color primaryColor;

  const AchievementCard({
    super.key,
    required this.type,
    required this.streak,
    required this.progressPercent,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final (emoji, title, subtitle) = _content(type);

    return Container(
      width: 360,
      height: 480,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            Color.lerp(primaryColor, Colors.black, 0.35)!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Learn Flutter',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '🔥 $streak-day streak',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                if (progressPercent > 0)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressPercent / 100,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                if (progressPercent > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '$progressPercent% widgets explored',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Download free on Play Store',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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

  static (String, String, String) _content(ShareMilestoneType type) {
    return switch (type) {
      ShareMilestoneType.streak3 => (
          '💪',
          '3-Day Streak!',
          'Building a daily Flutter habit — one widget at a time.',
        ),
      ShareMilestoneType.streak7 => (
          '🔥',
          '7-Day Streak — On Fire!',
          'A full week of Flutter learning. Keep the momentum going!',
        ),
      ShareMilestoneType.streak30 => (
          '🏆',
          '30-Day Legend!',
          'A month of consistent Flutter practice. Unstoppable!',
        ),
      ShareMilestoneType.progress50 => (
          '📈',
          'Halfway There!',
          'Explored half of all Flutter widgets. Almost a pro!',
        ),
      ShareMilestoneType.progress100 => (
          '🎓',
          'All Widgets Complete!',
          'Mastered every Flutter widget in the app. Incredible!',
        ),
      ShareMilestoneType.dailyGoal => (
          '✅',
          'Daily Goal Crushed!',
          'Learned widgets + finished a quiz today. Well done!',
        ),
    };
  }
}

/// Branded quiz result card for sharing.
class QuizResultCard extends StatelessWidget {
  final int score;
  final int total;
  final Color primaryColor;

  const QuizResultCard({
    super.key,
    required this.score,
    required this.total,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (score / total * 100).round() : 0;
    final emoji = pct >= 90
        ? '🏆'
        : pct >= 70
            ? '🔥'
            : pct >= 50
                ? '💪'
                : '📚';

    return Container(
      width: 360,
      height: 480,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            Color.lerp(primaryColor, Colors.black, 0.35)!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learn Flutter',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Flutter Quiz',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$score / $total',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '$pct% correct',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Can you beat my score?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
