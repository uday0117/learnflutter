import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/engagement_controller.dart';
import '../controllers/theme_controller.dart';

class ShareMilestoneDialog {
  static void show({required ShareMilestoneType type}) {
    final context = Get.context;
    if (context == null) return;

    final engagement = Get.find<EngagementController>();
    final theme = Get.find<ThemeController>();

    final (emoji, title, subtitle) = _content(type);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Obx(() {
        final primary = theme.primaryColor.value;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 52)),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      engagement.shareAchievement(type);
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: Text('share_achievement'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('maybe_later'.tr),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  static (String, String, String) _content(ShareMilestoneType type) {
    return switch (type) {
      ShareMilestoneType.streak3 => (
          '💪',
          'milestone_streak_3_title'.tr,
          'milestone_share_sub'.tr,
        ),
      ShareMilestoneType.streak7 => (
          '🔥',
          'milestone_streak_7_title'.tr,
          'milestone_share_sub'.tr,
        ),
      ShareMilestoneType.streak30 => (
          '🏆',
          'milestone_streak_30_title'.tr,
          'milestone_share_sub'.tr,
        ),
      ShareMilestoneType.progress50 => (
          '📈',
          'milestone_progress_50_title'.tr,
          'milestone_share_sub'.tr,
        ),
      ShareMilestoneType.progress100 => (
          '🎓',
          'milestone_progress_100_title'.tr,
          'milestone_share_sub'.tr,
        ),
      ShareMilestoneType.dailyGoal => (
          '✅',
          'milestone_daily_goal_title'.tr,
          'milestone_share_sub'.tr,
        ),
    };
  }
}
