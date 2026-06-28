import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/favorites_controller.dart';
import '../controllers/interview_review_controller.dart';
import '../controllers/progress_controller.dart';
import '../controllers/quiz_controller.dart';
import '../controllers/streak_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/interview_data.dart';
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

  Future<void> _rateApp() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: '6745765178');
    }
  }

  void _shareApp() {
    Share.share(
      '📱 Learn Flutter — Master every Flutter widget with live previews, examples & interview prep!\n\nhttps://play.google.com/store/apps/details?id=com.uksolutions.learnflutter',
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
                          version: 'v1.0.2',
                          label: 'whats_new_current'.tr,
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
            expandedHeight: 100,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'settings'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Streak Card ──
                  _StreakCard(isDark: isDark),
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
                          icon: Icons.star_rounded,
                          iconColor: Colors.amber,
                          title: 'rate_app'.tr,
                          subtitle: 'rate_app_sub'.tr,
                          onTap: _rateApp,
                          showDivider: true,
                        ),
                        _SettingsTile(
                          icon: Icons.share_rounded,
                          iconColor: Colors.blue,
                          title: 'share_app'.tr,
                          subtitle: 'share_app_sub'.tr,
                          onTap: _shareApp,
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
                          icon: Icons.info_rounded,
                          iconColor: Colors.grey,
                          title: 'version'.tr,
                          subtitle: '1.0.2',
                          onTap: () {},
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

// ─── Streak Card ─────────────────────────────────────────────
class _StreakCard extends StatelessWidget {
  final bool isDark;
  const _StreakCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final streak = Get.find<StreakController>();
    final theme = Get.find<ThemeController>();

    return Obx(() {
      final primary = theme.primaryColor.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary.withValues(alpha: 0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(streak.streakEmoji,
                style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'day_streak'.tr}: ${streak.currentStreak.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${'best'.tr}: ${streak.longestStreak.value} • ${'total_days'.tr}: ${streak.totalDays.value}',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
