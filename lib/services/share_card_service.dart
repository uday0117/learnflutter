import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/engagement_controller.dart';
import '../controllers/progress_controller.dart';
import '../controllers/streak_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/achievement_card.dart';
import 'analytics_service.dart';
import 'deep_link_service.dart';

/// Captures branded cards as PNG images and shares them.
class ShareCardService {
  static final ShareCardService _instance = ShareCardService._internal();
  factory ShareCardService() => _instance;
  ShareCardService._internal();

  final _screenshot = ScreenshotController();

  Future<void> shareAchievement(ShareMilestoneType type) async {
    final streak = Get.find<StreakController>();
    final progress = Get.find<ProgressController>();
    final theme = Get.find<ThemeController>();
    final pct = (progress.progressPercent * 100).round();

    final card = AchievementCard(
      type: type,
      streak: streak.currentStreak.value,
      progressPercent: pct,
      primaryColor: theme.primaryColor.value,
    );

    final text = _achievementText(type, streak.currentStreak.value, pct);
    await _captureAndShare(card, text, 'achievement_${type.name}');
    AnalyticsService().logEvent('achievement_shared', parameters: {
      'type': type.name,
      'format': 'image',
    });
  }

  Future<void> shareQuizResult(int score, int total) async {
    final theme = Get.find<ThemeController>();
    final card = QuizResultCard(
      score: score,
      total: total,
      primaryColor: theme.primaryColor.value,
    );

    final text =
        '🎯 I scored $score/$total on the Flutter Quiz!\n\n'
        'Test your Flutter knowledge: ${DeepLinkService.playStoreUrl}';

    await _captureAndShare(card, text, 'quiz_result');
    AnalyticsService().logEvent('quiz_result_shared', parameters: {
      'score': score,
      'total': total,
    });
  }

  String _achievementText(ShareMilestoneType type, int streak, int pct) {
    return switch (type) {
      ShareMilestoneType.streak3 =>
        '💪 3-day Flutter learning streak! Join me:\n${DeepLinkService.playStoreUrl}',
      ShareMilestoneType.streak7 =>
        '🔥 7-day streak learning Flutter!\n${DeepLinkService.playStoreUrl}',
      ShareMilestoneType.streak30 =>
        '🏆 30-day Flutter streak!\n${DeepLinkService.playStoreUrl}',
      ShareMilestoneType.progress50 =>
        '📈 $pct% through all Flutter widgets!\n${DeepLinkService.playStoreUrl}',
      ShareMilestoneType.progress100 =>
        '🎓 I completed ALL Flutter widgets!\n${DeepLinkService.playStoreUrl}',
      ShareMilestoneType.dailyGoal =>
        '✅ Daily Flutter goal crushed! $streak-day streak 🔥\n${DeepLinkService.playStoreUrl}',
    };
  }

  Future<void> _captureAndShare(
    Widget card,
    String text,
    String filePrefix,
  ) async {
    try {
      final imageBytes = await _screenshot.captureFromWidget(
        card,
        delay: const Duration(milliseconds: 50),
        pixelRatio: 3.0,
      );

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/${filePrefix}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: text,
      );
    } catch (e) {
      debugPrint('[ShareCard] capture failed: $e');
      await Share.share(text);
    }
  }
}
