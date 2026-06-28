import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/quiz_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/quiz_data.dart';
import '../services/ad_service.dart';
import '../widgets/banner_ad_widget.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = Get.find<QuizController>();
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        if (quiz.isFinished.value) {
          return _ResultView(quiz: quiz, theme: theme, isDark: isDark);
        }
        return _QuizView(quiz: quiz, theme: theme, isDark: isDark);
      }),
    );
  }
}

// ─── Quiz View ───────────────────────────────────────────────
class _QuizView extends StatelessWidget {
  final QuizController quiz;
  final ThemeController theme;
  final bool isDark;

  const _QuizView(
      {required this.quiz, required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final q = quiz.current;
      final primary = theme.primaryColor.value;
      final answered = quiz.isAnswered.value;
      final selected = quiz.selectedAnswer.value;
      final hintRevealed = quiz.hintRevealed.value;
      final eliminated = quiz.eliminatedOptionsStable;

      return SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'quiz_mode'.tr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (quiz.currentIndex.value + 1) /
                                quiz.totalQuestions,
                            minHeight: 6,
                            backgroundColor: primary.withValues(alpha: 0.2),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${quiz.currentIndex.value + 1}/${quiz.totalQuestions}',
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Category chip ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _categoryColor(q.category)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _categoryLabel(q.category),
                        style: TextStyle(
                          color: _categoryColor(q.category),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Question ──
                    Text(
                      q.question,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Options ──
                    ...List.generate(q.options.length, (i) {
                      final isEliminated =
                          hintRevealed && eliminated.contains(i);

                      Color optionColor;
                      Color textColor;
                      IconData? trailingIcon;

                      if (!answered) {
                        optionColor = isEliminated
                            ? (isDark
                                ? const Color(0xFF1E1E2E).withValues(alpha: 0.4)
                                : Colors.grey.shade100)
                            : (isDark
                                ? const Color(0xFF1E1E2E)
                                : Colors.white);
                        textColor = isEliminated
                            ? Colors.grey.shade400
                            : (isDark ? Colors.white : Colors.black87);
                        trailingIcon =
                            isEliminated ? Icons.remove_circle_outline : null;
                      } else if (i == q.correctIndex) {
                        optionColor = Colors.green;
                        textColor = Colors.white;
                        trailingIcon = Icons.check_circle_rounded;
                      } else if (i == selected) {
                        optionColor = Colors.red.shade400;
                        textColor = Colors.white;
                        trailingIcon = Icons.cancel_rounded;
                      } else {
                        optionColor = isDark
                            ? const Color(0xFF1E1E2E)
                            : Colors.white;
                        textColor = isDark
                            ? Colors.white54
                            : Colors.black38;
                        trailingIcon = null;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Opacity(
                          opacity: (!answered && isEliminated) ? 0.45 : 1.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: optionColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: answered
                                    ? Colors.transparent
                                    : (isEliminated
                                        ? Colors.grey.withValues(alpha: 0.3)
                                        : (isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.1)
                                            : Colors.grey.shade200)),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: (answered || isEliminated)
                                  ? null
                                  : () => quiz.answer(i),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: answered
                                            ? Colors.white
                                                .withValues(alpha: 0.2)
                                            : primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          ['A', 'B', 'C', 'D'][i],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: answered
                                                ? textColor
                                                : (isEliminated
                                                    ? Colors.grey.shade400
                                                    : primary),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        q.options[i],
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          decoration: isEliminated
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                    if (trailingIcon != null)
                                      Icon(
                                        trailingIcon,
                                        color: isEliminated
                                            ? Colors.grey
                                            : Colors.white,
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // ── Explanation (after answer) ──
                    if (answered) ...[
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E1E2E)
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_rounded,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q.explanation,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.blue.shade800,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Banner Ad ──
            const Center(child: BannerAdWidget()),

            // ── Score bar + Hint button + Next button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Obx(() => Text(
                            '${'score'.tr}: ${quiz.score.value}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ── 50/50 Hint button (rewarded ad) ──────────────────
                  Obx(() {
                    final isAnsweredNow = quiz.isAnswered.value;
                    final hintUsed = quiz.hintUsedThisSession.value;
                    if (isAnsweredNow || hintUsed) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.amber.shade600, width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => _showHintAd(context, quiz),
                          icon: const Icon(Icons.lightbulb_rounded,
                              color: Colors.amber, size: 18),
                          label: Text(
                            'quiz_hint_watch_ad'.tr,
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  if (answered)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: quiz.next,
                        child: Text(
                          quiz.currentIndex.value + 1 >= quiz.totalQuestions
                              ? 'finish'.tr
                              : 'next_question'.tr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showHintAd(BuildContext context, QuizController quiz) {
    // Inform the user what they will receive before showing the ad
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lightbulb_rounded, color: Colors.amber),
            const SizedBox(width: 8),
            Text('quiz_hint_title'.tr),
          ],
        ),
        content: Text('quiz_hint_desc'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              AdService().showRewardedAd(
                onRewarded: () => quiz.revealHint(),
                onNotReady: () => _showAdNotReady(context),
              );
            },
            child: Text('quiz_watch_ad'.tr),
          ),
        ],
      ),
    );
  }

  void _showAdNotReady(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ad_not_ready'.tr),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _categoryColor(QuizCategory cat) {
    switch (cat) {
      case QuizCategory.widgets:
        return const Color(0xFF1E88E5);
      case QuizCategory.layout:
        return const Color(0xFF43A047);
      case QuizCategory.state:
        return const Color(0xFF8E24AA);
      case QuizCategory.dart:
        return const Color(0xFFFF6F00);
      case QuizCategory.navigation:
        return const Color(0xFF00ACC1);
    }
  }

  String _categoryLabel(QuizCategory cat) {
    switch (cat) {
      case QuizCategory.widgets:
        return 'Widgets';
      case QuizCategory.layout:
        return 'Layout';
      case QuizCategory.state:
        return 'State';
      case QuizCategory.dart:
        return 'Dart';
      case QuizCategory.navigation:
        return 'Navigation';
    }
  }
}

// ─── Result View ─────────────────────────────────────────────
class _ResultView extends StatelessWidget {
  final QuizController quiz;
  final ThemeController theme;
  final bool isDark;

  const _ResultView(
      {required this.quiz, required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final primary = theme.primaryColor.value;
      final pct = quiz.score.value / quiz.totalQuestions;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Trophy icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, primary.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    pct == 1.0
                        ? '🏆'
                        : pct >= 0.8
                            ? '🌟'
                            : pct >= 0.6
                                ? '👍'
                                : '📚',
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Text(
                quiz.scoreMessage,
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'quiz_result_sub'.tr
                    .replaceAll('@score', '${quiz.score.value}')
                    .replaceAll('@total', '${quiz.totalQuestions}'),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  _StatCard(
                    label: 'best'.tr,
                    value: '${quiz.bestScore.value}/${quiz.totalQuestions}',
                    icon: Icons.emoji_events_rounded,
                    color: Colors.amber,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'played'.tr,
                    value: '${quiz.totalPlayed.value}',
                    icon: Icons.play_circle_rounded,
                    color: Colors.blue,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'accuracy'.tr,
                    value:
                        '${(quiz.accuracy * 100).toStringAsFixed(0)}%',
                    icon: Icons.track_changes_rounded,
                    color: Colors.green,
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Bonus Round card (rewarded ad) ─────────────────────
              Obx(() {
                if (!quiz.bonusAvailable.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade600,
                          Colors.deepPurple.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.deepPurple.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('🎁',
                                style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'quiz_bonus_title'.tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'quiz_bonus_desc'.tr,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  Colors.deepPurple.shade700,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            onPressed: () =>
                                _showBonusAdDialog(context, quiz),
                            icon: const Icon(
                                Icons.play_circle_fill_rounded,
                                size: 18),
                            label: Text(
                              'quiz_watch_ad'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: quiz.restart,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text('try_again'.tr,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Share.share(
                          '🎯 I scored ${quiz.score.value}/${quiz.totalQuestions} on the Flutter Quiz in Learn Flutter app!\n\nTest your Flutter knowledge too: https://play.google.com/store/apps/details?id=com.uksolutions.learnflutter',
                        );
                      },
                      icon: Icon(Icons.share_rounded, color: primary),
                      label: Text('share'.tr,
                          style: TextStyle(color: primary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.home_rounded,
                          color: Colors.grey),
                      label: Text('home'.tr,
                          style:
                              const TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showBonusAdDialog(BuildContext context, QuizController quiz) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🎁', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text('quiz_bonus_title'.tr),
          ],
        ),
        content: Text('quiz_bonus_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              AdService().showRewardedAd(
                onRewarded: () => quiz.unlockBonusRound(),
                onNotReady: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ad_not_ready'.tr),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
            child: Text('quiz_watch_ad'.tr),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
