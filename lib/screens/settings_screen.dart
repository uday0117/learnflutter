import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

import '../controllers/auth_controller.dart';
import '../controllers/engagement_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/interview_review_controller.dart';
import '../controllers/progress_controller.dart';
import '../controllers/quiz_controller.dart';
import '../controllers/streak_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/interview_data.dart';
import '../services/ad_service.dart';
import '../services/in_app_update_service.dart';
import '../services/notification_service.dart';
import '../translations/app_translations.dart';
import '../utils/url_launcher_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showColorPickerDialog(
      BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'choose_color'.tr,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GetBuilder<ThemeController>(
                builder: (controller) => SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...List.generate(controller.availableColors.length,
                          (index) {
                        final angle = (2 * math.pi * index) /
                            controller.availableColors.length;
                        const radius = 85.0;
                        final x = radius * math.cos(angle);
                        final y = radius * math.sin(angle);
                        final color = controller.availableColors[index];
                        final isSelected =
                            controller.primaryColor.value == color;
                        return Transform.translate(
                          offset: Offset(x, y),
                          child: GestureDetector(
                            onTap: () {
                              controller.changeColor(color);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 20)
                                  : null,
                            ),
                          ),
                        );
                      }),
                      Obx(
                        () => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: controller.primaryColor.value,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text('done'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.red, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'sign_out'.tr.isNotEmpty ? 'sign_out'.tr : 'Sign Out',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'sign_out_confirm_msg'.tr.isNotEmpty
              ? 'sign_out_confirm_msg'.tr
              : 'Are you sure you want to sign out?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text('cancel'.tr.isNotEmpty ? 'cancel'.tr : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              authController.signOut();
            },
            child: Text('sign_out'.tr.isNotEmpty ? 'sign_out'.tr : 'Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, ThemeController themeController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) {
          return Obx(() {
            final currentLocale = themeController.currentLocale.value;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'choose_language'.tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: AppLanguage.all.length,
                      itemBuilder: (_, index) {
                        final lang = AppLanguage.all[index];
                        final isSelected = currentLocale.languageCode ==
                            lang.locale.languageCode;
                        return ListTile(
                          leading: Text(lang.flag,
                              style: const TextStyle(fontSize: 24)),
                          title: Text(lang.nativeName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(lang.name),
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: Get.theme.colorScheme.primary)
                              : null,
                          onTap: () {
                            Get.updateLocale(lang.locale);
                            themeController.saveLocale(lang.locale);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  void _showFontSizePicker(
      BuildContext context, ThemeController themeController) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('font_size'.tr,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('font_size_sub'.tr,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Obx(() => Row(
                  children:
                      List.generate(ThemeController.fontScaleLabels.length,
                          (i) {
                    final isSelected =
                        themeController.fontScaleIndex.value == i;
                    final primary = themeController.primaryColor.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: i < 2 ? 12 : 0),
                        child: GestureDetector(
                          onTap: () => themeController.setFontScale(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primary
                                  : primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Aa',
                                  style: TextStyle(
                                    fontSize: 14.0 +
                                        i * 4,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  ThemeController.fontScaleLabels[i],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('done'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _InAppRatingSheet(),
    );
  }

  void _showClearProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('clear_progress'.tr),
        content: Text('clear_progress_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<ProgressController>().clearProgress();
              Get.snackbar(
                'clear_progress'.tr,
                'progress_cleared'.tr,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            child: Text(
              'clear'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const _StatsBottomSheet(),
    );
  }

  void _showWhatsNewDialog(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) {
          return Obx(() {
            final primary = themeController.primaryColor.value;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text('🎉',
                            style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'whats_new'.tr,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Learn Flutter',
                              style: TextStyle(
                                  color: primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _ChangelogVersion(
                          version: 'v1.0.7',
                          label: 'whats_new_current'.tr,
                          primary: primary,
                          isDark: isDark,
                          items: const [
                            ('🚀', 'In-App Updates: check & install latest updates directly in Settings'),
                            ('✨', 'Ultra-smooth scrolling: zero ad layout jumps / Cumulative Layout Shift'),
                            ('⏱️', 'Smart ad cooldown: protection against rapid-fire full-screen interruptions'),
                            ('🎁', 'Invite Friends reward in Settings: share to unlock 2 hours ad-free'),
                            ('📤', 'Direct Share Flutter Widget tips & Interview Q&A with deep links'),
                            ('⚡', 'Performance optimizations & smoother 60fps animations'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ChangelogVersion(
                          version: 'v1.0.5',
                          label: null,
                          primary: primary,
                          isDark: isDark,
                          items: const [
                            ('🖼️', 'Shareable achievement image cards for social'),
                            ('🔗', 'HTTPS deep links via ukrsolutions.in — share any widget URL'),
                            ('📱', 'Android home screen widget — streak & widget of the day'),
                            ('📚', '50 quiz questions & 55 interview Q&A added'),
                            ('👋', 'Welcome onboarding for new learners'),
                            ('👥', 'Invite Friends — share & earn 2hr ad-free'),
                            ('📢', 'Widget shares now include Play Store link'),
                            ('💰', 'Quiz completion interstitial for better monetization'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ChangelogVersion(
                          version: 'v1.0.4',
                          label: null,
                          primary: primary,
                          isDark: isDark,
                          items: const [
                            ('🎯', 'Daily Goal — learn 3 widgets + quiz each day'),
                            ('🔔', 'Daily reminder notifications at 9 AM'),
                            ('📢', 'Share achievements to invite friends'),
                            ('💰', 'Watch ad for 1-hour ad-free learning'),
                            ('📚', '52 new widgets — Animation, Cupertino, Slivers & more'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ChangelogVersion(
                          version: 'v1.0.2',
                          label: null,
                          primary: primary,
                          isDark: isDark,
                          items: const [
                            ('📊', 'Learning Stats in Settings — track every milestone'),
                            ('🎉', 'What\'s New changelog added'),
                            ('🐛', 'Minor bug fixes & performance improvements'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ChangelogVersion(
                          version: 'v1.0.1',
                          label: null,
                          primary: primary,
                          isDark: isDark,
                          items: const [
                            ('🎮', 'Flutter Quiz mode with lifetime stats'),
                            ('🔥', 'Daily learning streak tracker'),
                            ('📝', 'Dart Cheatsheet quick reference'),
                            ('🎤', 'Interview Q&A with 45 Flutter questions'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ChangelogVersion(
                          version: 'v1.0.0',
                          label: null,
                          primary: primary,
                          isDark: isDark,
                          items: const [
                            ('🚀', 'Initial release — 100+ Flutter widgets'),
                            ('🌍', '13 language support'),
                            ('🎨', 'Custom themes, dark mode & font size'),
                            ('❤️', 'Favorites & learning progress tracking'),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            title: Text(
              'settings'.tr,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Account Section ──
                  _SectionHeader(title: 'account'.tr, isDark: isDark),
                  const SizedBox(height: 12),
                  _AccountSection(
                    isDark: isDark,
                    onLogout: () => _showLogoutDialog(
                      context,
                      Get.find<AuthController>(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Personalization Section ──
                  _SectionHeader(
                      title: 'personalization'.tr, isDark: isDark),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[850]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Theme Color — reactive via Obx wrapper
                        Obx(() => _SettingsTile(
                              icon: Icons.palette_rounded,
                              iconColor:
                                  themeController.primaryColor.value,
                              title: 'theme_color'.tr,
                              subtitle: 'theme_color_sub'.tr,
                              trailing: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: themeController.primaryColor.value,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              onTap: () => _showColorPickerDialog(
                                  context, themeController),
                              showDivider: true,
                            )),

                        // Dark Mode
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.indigo
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.dark_mode_rounded,
                                    color: Colors.indigo),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'dark_mode'.tr,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'dark_mode_sub'.tr,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() => Switch(
                                    value: themeController.isDarkMode.value,
                                    onChanged: (_) =>
                                        themeController.toggleTheme(),
                                  )),
                            ],
                          ),
                        ),

                        const Divider(height: 1, indent: 60, endIndent: 20),

                        // Haptic Feedback
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.vibration_rounded,
                                    color: Colors.deepPurple),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'haptic_feedback'.tr,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'haptic_feedback_sub'.tr,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() => Switch(
                                    value: themeController
                                        .hapticsEnabled.value,
                                    onChanged: (_) =>
                                        themeController.toggleHaptics(),
                                  )),
                            ],
                          ),
                        ),

                        const Divider(height: 1, indent: 60, endIndent: 20),

                        // Daily Reminder
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.orange
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.notifications_active_rounded,
                                    color: Colors.orange),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'daily_reminder'.tr,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'daily_reminder_sub'.tr,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() {
                                final engagement =
                                    Get.find<EngagementController>();
                                return Switch(
                                  value: engagement
                                      .dailyReminderEnabled.value,
                                  onChanged: (v) async {
                                    if (v) {
                                      final granted =
                                          await NotificationService()
                                              .requestPermission();
                                      if (!granted) {
                                        Get.snackbar(
                                          'daily_reminder'.tr,
                                          'notification_denied'.tr,
                                          snackPosition:
                                              SnackPosition.BOTTOM,
                                        );
                                        return;
                                      }
                                      await NotificationService()
                                          .scheduleDailyReminder();
                                    } else {
                                      await NotificationService()
                                          .cancelDailyReminder();
                                    }
                                    engagement.setDailyReminder(v);
                                  },
                                );
                              }),
                            ],
                          ),
                        ),

                        const Divider(height: 1, indent: 60, endIndent: 20),

                        // Font Size
                        _SettingsTile(
                          icon: Icons.text_fields_rounded,
                          iconColor: Colors.orange,
                          title: 'font_size'.tr,
                          subtitle: 'font_size_sub'.tr,
                          trailing: Obx(() => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: themeController.primaryColor.value
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  ThemeController.fontScaleLabels[
                                      themeController.fontScaleIndex.value],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        themeController.primaryColor.value,
                                  ),
                                ),
                              )),
                          onTap: () =>
                              _showFontSizePicker(context, themeController),
                          showDivider: true,
                        ),

                        // Language
                        _SettingsTile(
                          icon: Icons.language_rounded,
                          iconColor: Colors.teal,
                          title: 'language'.tr,
                          subtitle: 'language_sub'.tr,
                          trailing: Obx(() {
                            final locale =
                                themeController.currentLocale.value;
                            final lang =
                                AppLanguage.all.firstWhereOrNull(
                              (l) =>
                                  l.locale.languageCode ==
                                  locale.languageCode,
                            );
                            return Text(
                              lang?.flag ?? '🌐',
                              style: const TextStyle(fontSize: 22),
                            );
                          }),
                          onTap: () => _showLanguagePicker(
                              context, themeController),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Support Section ──
                  _SectionHeader(title: 'support'.tr, isDark: isDark),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[850]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: Icons.bar_chart_rounded,
                          iconColor: Colors.purple,
                          title: 'my_stats'.tr,
                          subtitle: 'my_stats_sub'.tr,
                          onTap: () => _showStatsSheet(context),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.widgets_rounded,
                          iconColor: Colors.teal,
                          title: 'home_widget_title'.tr,
                          subtitle: 'home_widget_sub'.tr,
                          onTap: () {
                            Get.snackbar(
                              'home_widget_title'.tr,
                              'home_widget_hint'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 5),
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                            );
                          },
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.share_rounded,
                          iconColor: Colors.blue,
                          title: 'share_app'.tr,
                          subtitle: 'share_app_sub'.tr,
                          onTap: () => Get.find<EngagementController>().shareApp(),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.card_giftcard_rounded,
                          iconColor: Colors.amber[800] ?? Colors.amber,
                          title: 'invite_friends'.tr,
                          subtitle: 'invite_friends_sub'.tr,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'free_pass_badge'.tr,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          onTap: () => Get.find<EngagementController>().shareForInviteReward(),
                          showDivider: true,
                        ),
                        Obx(() {
                          final adFree = AdService().adFreeUntil.value;
                          if (adFree == null ||
                              !DateTime.now().isBefore(adFree)) {
                            return _SettingsTile(
                              icon: Icons.play_circle_outline_rounded,
                              iconColor: Colors.deepPurple,
                              title: 'watch_ad_adfree'.tr,
                              subtitle: 'watch_ad_adfree_sub'.tr,
                              onTap: () {
                                AdService().showRewardedAd(
                                  onRewarded: () {
                                    AdService().grantAdFreePass();
                                    Get.snackbar(
                                      'ad_free_active'.tr,
                                      'ad_free_sub'.tr,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                  onNotReady: () {
                                    Get.snackbar(
                                      'ad_not_ready'.tr,
                                      'ad_not_ready_sub'.tr,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                );
                              },
                              showDivider: true,
                            );
                          }
                          final remaining = adFree.difference(DateTime.now());
                          final mins = remaining.inMinutes;
                          return _SettingsTile(
                            icon: Icons.block_rounded,
                            iconColor: Colors.green,
                            title: 'ad_free_active'.tr,
                            subtitle: 'ad_free_remaining'.trParams(
                                {'mins': '$mins'}),
                            onTap: () {},
                            showDivider: true,
                            showArrow: false,
                          );
                        }),
                        _SettingsTile(
                          icon: Icons.star_rounded,
                          iconColor: Colors.amber,
                          title: 'rate_app'.tr,
                          subtitle: 'rate_app_sub'.tr,
                          onTap: () => _showRatingSheet(context),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.mail_rounded,
                          iconColor: Colors.green,
                          title: 'contact_us'.tr,
                          subtitle: 'contact_us_sub'.tr,
                          onTap: () =>
                              UrlLauncherHelper.openEmail(),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.delete_sweep_rounded,
                          iconColor: Colors.red,
                          title: 'clear_progress'.tr,
                          subtitle: 'clear_progress_sub'.tr,
                          onTap: () =>
                              _showClearProgressDialog(context),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Information Section ──
                  _SectionHeader(
                      title: 'information'.tr, isDark: isDark),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[850]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: Icons.new_releases_rounded,
                          iconColor: Colors.deepOrange,
                          title: 'whats_new'.tr,
                          subtitle: 'whats_new_sub'.tr,
                          onTap: () => _showWhatsNewDialog(context),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.privacy_tip_rounded,
                          iconColor: Colors.green,
                          title: 'privacy_policy'.tr,
                          onTap: () =>
                              UrlLauncherHelper.openPrivacyPolicy(),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.gavel_rounded,
                          iconColor: Colors.orange,
                          title: 'terms_conditions'.tr,
                          onTap: () =>
                              UrlLauncherHelper.openTermsAndConditions(),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.system_update_rounded,
                          iconColor: Colors.blueAccent,
                          title: 'check_for_updates'.tr,
                          subtitle: 'check_for_updates_sub'.tr,
                          onTap: () => InAppUpdateService().checkManually(context: context),
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.info_rounded,
                          iconColor: Colors.grey,
                          title: 'version'.tr,
                          subtitle: '1.0.7 (Build 8)',
                          onTap: () => InAppUpdateService().checkManually(context: context),
                          showDivider: false,
                          showArrow: false,
                        ),
                      ],
                    ),
                  ),



                  const SizedBox(height: 40),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('made_with'.tr,
                                style:
                                    const TextStyle(color: Colors.grey)),
                            const SizedBox(width: 6),
                            const Icon(Icons.favorite,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 6),
                            Text('in_flutter'.tr,
                                style:
                                    const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '© 2025 UK Solutions',
                          style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Bottom Sheet ───────────────────────────────────────
class _StatsBottomSheet extends StatelessWidget {
  const _StatsBottomSheet();

  @override
  Widget build(BuildContext context) {
    final progress = Get.find<ProgressController>();
    final favorites = Get.find<FavoritesController>();
    final quiz = Get.find<QuizController>();
    final interview = Get.find<InterviewReviewController>();
    final streak = Get.find<StreakController>();
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allInterviewIds =
        InterviewData.getAll().map((q) => q.id).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Obx(() {
          final primary = theme.primaryColor.value;
          final viewedCount = progress.viewedCount;
          final totalWidgets = progress.totalWidgets;
          final favCount = favorites.favoritesCount;
          final quizPlayed = quiz.totalPlayed.value;
          final bestScore = quiz.bestScore.value;
          final accuracy = quiz.accuracy;
          final mastered = interview.masteredCount(allInterviewIds);
          final curStreak = streak.currentStreak.value;
          final longestStr = streak.longestStreak.value;
          final totalDays = streak.totalDays.value;

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.bar_chart_rounded,
                          color: primary, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'stats_title'.tr,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // Learning Progress
                      _StatsSectionLabel(
                          label: 'stats_learning'.tr, isDark: isDark),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              emoji: '🧩',
                              value: '$viewedCount / $totalWidgets',
                              label: 'stats_widgets'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              emoji: '❤️',
                              value: '$favCount',
                              label: 'stats_favorites'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              emoji: '🎓',
                              value: '$mastered / ${allInterviewIds.length}',
                              label: 'stats_mastered'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              emoji: '🔥',
                              value: '$curStreak',
                              label: 'stats_streak'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Quiz Stats
                      _StatsSectionLabel(
                          label: 'stats_quiz_section'.tr, isDark: isDark),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              emoji: '🎮',
                              value: '$quizPlayed',
                              label: 'stats_games'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              emoji: '🏆',
                              value: '$bestScore / 10',
                              label: 'stats_best_score'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _StatCard(
                        emoji: '📊',
                        value:
                            '${(accuracy * 100).toStringAsFixed(1)}%',
                        label: 'stats_accuracy'.tr,
                        primary: primary,
                        isDark: isDark,
                        fullWidth: true,
                      ),

                      const SizedBox(height: 20),

                      // Streak Stats
                      _StatsSectionLabel(
                          label: 'stats_streak_section'.tr, isDark: isDark),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              emoji: '⚡',
                              value: '$longestStr',
                              label: 'stats_longest'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              emoji: '📅',
                              value: '$totalDays',
                              label: 'stats_total_days'.tr,
                              primary: primary,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class _StatsSectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _StatsSectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: isDark ? Colors.white38 : Colors.grey.shade500,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color primary;
  final bool isDark;
  final bool fullWidth;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.primary,
    required this.isDark,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: fullWidth
          ? Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
    );
  }
}

// ─── What's New Changelog version block ──────────────────────
class _ChangelogVersion extends StatelessWidget {
  final String version;
  final String? label;
  final Color primary;
  final bool isDark;
  final List<(String, String)> items;

  const _ChangelogVersion({
    required this.version,
    required this.label,
    required this.primary,
    required this.isDark,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: label != null
            ? Border.all(color: primary.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: label != null
                      ? primary
                      : (isDark ? Colors.grey[700] : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  version,
                  style: TextStyle(
                    color: label != null
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.grey[600]),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label!,
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$1,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.$2,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.white70
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Account Section (Clean Grouped Settings Container) ───────
class _AccountSection extends StatelessWidget {
  final bool isDark;
  final VoidCallback onLogout;

  const _AccountSection({
    required this.isDark,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final theme = Get.find<ThemeController>();

    return Obx(() {
      final primary = theme.primaryColor.value;
      final isLoggedIn = auth.isLoggedIn;
      final isLoading = auth.isLoading.value;

      return Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: isLoggedIn
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    ClipOval(
                      child: auth.photoURL != null && auth.photoURL!.isNotEmpty
                          ? Image.network(
                              auth.photoURL!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                                  _buildAvatarFallback(
                                      auth.displayName, primary),
                            )
                          : _buildAvatarFallback(auth.displayName, primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  auth.displayName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Google',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            auth.email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded,
                          color: Colors.redAccent, size: 22),
                      tooltip: 'sign_out'.tr,
                      onPressed: onLogout,
                    ),
                  ],
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: _GoogleBrandIcon(size: 22),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'sign_in_google'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'sign_in_google_sub'.tr,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          isLoading ? null : () => auth.signInWithGoogle(),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('sign_in'.tr,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildAvatarFallback(String name, Color primary) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'F';
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ─── Google Brand Icon (Clean Canvas Drawing) ───────────────────
class _GoogleBrandIcon extends StatelessWidget {
  final double size;
  const _GoogleBrandIcon({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = radius * 0.38;

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final blueBarPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    // Draw Google 4-color arcs
    canvas.drawArc(rect, 3.4, 1.9, false, redPaint);
    canvas.drawArc(rect, 2.2, 1.2, false, yellowPaint);
    canvas.drawArc(rect, 0.7, 1.5, false, greenPaint);
    canvas.drawArc(rect, -0.2, 0.9, false, bluePaint);

    final barRect = Rect.fromLTWH(
      center.dx - radius * 0.05,
      center.dy - strokeWidth / 2,
      radius * 0.95,
      strokeWidth,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, Radius.circular(strokeWidth / 4)),
      blueBarPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── In-App Rating Bottom Sheet ──────────────────────────────
class _InAppRatingSheet extends StatefulWidget {
  const _InAppRatingSheet();

  @override
  State<_InAppRatingSheet> createState() => _InAppRatingSheetState();
}

class _InAppRatingSheetState extends State<_InAppRatingSheet> {
  int _selectedRating = 5;
  bool _isSubmitting = false;

  final List<String> _starLabels = [
    'Needs improvement',
    'Could be better',
    'Good app',
    'Very good & helpful!',
    'Outstanding! Loved it! ⭐',
  ];

  Future<void> _submitReview() async {
    setState(() => _isSubmitting = true);
    final inAppReview = InAppReview.instance;

    Navigator.of(context).pop();

    if (_selectedRating >= 4) {
      try {
        if (await inAppReview.isAvailable()) {
          await inAppReview.requestReview();
        } else {
          await inAppReview.openStoreListing();
        }
      } catch (e) {
        debugPrint('[SettingsScreen] Rating error: $e');
        UrlLauncherHelper.openPlayStore();
      }

      Get.snackbar(
        'rate_app'.tr,
        'Thank you for your rating & support on Google Play! ⭐',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } else {
      UrlLauncherHelper.openEmail();
      Get.snackbar(
        'Feedback',
        'Thank you! Tell us how we can improve Learn Flutter.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = themeController.primaryColor.value;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.star_rounded, color: Colors.amber, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'rate_app'.tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'How is your experience with Learn Flutter?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= _selectedRating;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedRating = starIndex);
                  themeController.triggerHaptic();
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedScale(
                    scale: isFilled ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      isFilled
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: isFilled
                          ? Colors.amber
                          : (isDark ? Colors.white30 : Colors.grey.shade400),
                      size: 42,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _starLabels[_selectedRating - 1],
              key: ValueKey(_selectedRating),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _selectedRating >= 4
                    ? Colors.amber.shade700
                    : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _isSubmitting ? null : _submitReview,
              icon: Icon(
                _selectedRating >= 4
                    ? Icons.rate_review_rounded
                    : Icons.mail_rounded,
                size: 20,
              ),
              label: Text(
                _selectedRating >= 4
                    ? 'Rate on Google Play Store'
                    : 'Send Us Feedback',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              UrlLauncherHelper.openPlayStore();
            },
            child: Text(
              'Open Play Store listing directly',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final bool showArrow;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.showDivider,
    this.showArrow = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
                ?trailing,
                if (showArrow && trailing == null)
                  const Icon(Icons.chevron_right,
                      size: 22, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 74, endIndent: 20),
      ],
    );
  }
}
