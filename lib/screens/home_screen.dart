import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/engagement_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/progress_controller.dart';
import '../controllers/streak_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/weekly_challenge_controller.dart';
import '../data/widgets_data.dart';
import '../models/widget_category.dart';
import '../screens/dart_cheatsheet_screen.dart';
import '../screens/interview_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/widget_detail_screen.dart';
import '../screens/widgets_list_screen.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SearchScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],

          // Banner Ad above bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 105,
            child: Center(child: const BannerAdWidget()),
          ),

          // Custom bottom navigation
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Obx(
              () => Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeController.primaryColor.value,
                      themeController.primaryColor.value.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.primaryColor.value
                          .withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: Icons.home_rounded,
                        label: 'nav_home'.tr,
                        index: 0,
                      ),
                      _buildNavItem(
                        icon: Icons.favorite_rounded,
                        label: 'nav_favorites'.tr,
                        index: 1,
                        hasBadge: true,
                      ),
                      _buildNavItem(
                        icon: Icons.search_rounded,
                        label: 'nav_search'.tr,
                        index: 2,
                      ),
                      _buildNavItem(
                        icon: Icons.settings_rounded,
                        label: 'nav_settings'.tr,
                        index: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool hasBadge = false,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedIndex == index) return;
          setState(() => _selectedIndex = index);
          const tabNames = ['home', 'favorites', 'search', 'settings'];
          AnalyticsService().logTabSelected(tabNames[index]);
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.25)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: isSelected ? 30 : 26,
                    ),
                  ),
                  if (hasBadge)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Obx(
                        () => favoritesController.favoritesCount > 0
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 18, minHeight: 18),
                                child: Text(
                                  '${favoritesController.favoritesCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected ? 11 : 10,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                child: Text(label, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CATEGORIES / HOME DASHBOARD SCREEN
// ─────────────────────────────────────────────────────────────

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = WidgetsData.getCategories();
    final ThemeController themeController = Get.find<ThemeController>();
    final ProgressController progress = Get.find<ProgressController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Search bar + theme toggle ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'search_bar',
                        child: Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () => Get.to(() => const SearchScreen()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E1E2E)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'search_hint'.tr,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white60
                                          : Colors.grey.shade600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () => GestureDetector(
                        onTap: () => themeController.toggleTheme(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeController.primaryColor.value,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            themeController.isDarkMode.value
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Widget of the Day ──
            SliverToBoxAdapter(
              child: _WidgetOfTheDay(isDark: isDark),
            ),

            // ── Daily Goal ──
            SliverToBoxAdapter(
              child: _DailyGoalCard(isDark: isDark),
            ),

            // ── Weekly Challenge ──
            SliverToBoxAdapter(
              child: _WeeklyChallengeCard(isDark: isDark),
            ),

            // ── Progress card ──
            SliverToBoxAdapter(
              child: Obx(() {
                final viewed = progress.viewedCount;
                final total = progress.totalWidgets;
                if (viewed == 0) return const SizedBox.shrink();
                return _ProgressCard(
                  viewed: viewed,
                  total: total,
                  percent: progress.progressPercent,
                  label: progress.progressLabel.tr,
                  isDark: isDark,
                );
              }),
            ),

            // ── Streak Banner ──
            SliverToBoxAdapter(
              child: _StreakBanner(isDark: isDark),
            ),

            // ── Daily Flutter Tip ──
            SliverToBoxAdapter(
              child: _DailyTipCard(isDark: isDark),
            ),

            // ── Learn More section ──
            SliverToBoxAdapter(
              child: _LearnMoreSection(isDark: isDark),
            ),

            // ── Quick Stats ──
            SliverToBoxAdapter(
              child: _QuickStatsCard(isDark: isDark),
            ),

            // ── Recently Viewed ──
            SliverToBoxAdapter(
              child: Obx(() {
                final ids = progress.recentIds;
                if (ids.isEmpty) return const SizedBox.shrink();
                return _RecentlyViewedSection(ids: ids, isDark: isDark);
              }),
            ),

            // ── Categories heading ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text(
                  'categories'.tr,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),

            // ── Categories grid ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 160),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      ModernCategoryCard(category: categories[index]),
                  childCount: categories.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget of the Day ───
class _WidgetOfTheDay extends StatelessWidget {
  final bool isDark;
  const _WidgetOfTheDay({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final allWidgets = WidgetsData.getAllWidgets();
    final dayIndex = DateTime.now().difference(
                DateTime(2024, 1, 1)).inDays %
            allWidgets.length;
    final wotd = allWidgets[dayIndex];
    final ThemeController theme = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Obx(() {
        final primary = theme.primaryColor.value;
        return GestureDetector(
          onTap: () => Get.to(() => WidgetDetailScreen(widgetModel: wotd)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, primary.withValues(alpha: 0.75)],
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
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.widgets_rounded,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'widget_of_the_day'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wotd.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wotd.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white70, size: 18),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─── Daily Goal Card ───
class _DailyGoalCard extends StatelessWidget {
  final bool isDark;
  const _DailyGoalCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final engagement = Get.find<EngagementController>();
    final theme = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(() {
        final primary = theme.primaryColor.value;
        final widgetsDone = engagement.dailyWidgetsViewed.value;
        final quizDone = engagement.dailyQuizDone.value;
        final complete = engagement.isDailyGoalComplete;
        final remaining = engagement.widgetsRemaining;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: complete
                  ? Colors.green.withValues(alpha: 0.5)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade200),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    complete ? '✅' : '🎯',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'daily_goal'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          complete
                              ? 'daily_goal_complete'.tr
                              : 'daily_goal_sub'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (complete)
                    TextButton.icon(
                      onPressed: () => engagement.shareApp(),
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: Text('share'.tr),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: engagement.dailyProgress,
                  minHeight: 8,
                  backgroundColor: primary.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    complete ? Colors.green : primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _GoalChip(
                    done: widgetsDone >= EngagementController.dailyWidgetGoal,
                    label: '$widgetsDone/${EngagementController.dailyWidgetGoal} ${'widgets'.tr}',
                    primary: primary,
                  ),
                  const SizedBox(width: 8),
                  _GoalChip(
                    done: quizDone,
                    label: 'quiz'.tr,
                    primary: primary,
                  ),
                ],
              ),
              if (!complete) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (remaining > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final all = WidgetsData.getAllWidgets();
                            final idx = DateTime.now()
                                    .difference(DateTime(2024, 1, 1))
                                    .inDays %
                                all.length;
                            Get.to(() =>
                                WidgetDetailScreen(widgetModel: all[idx]));
                          },
                          child: Text('learn_widget'.tr),
                        ),
                      ),
                    if (remaining > 0 && !quizDone) const SizedBox(width: 8),
                    if (!quizDone)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => const QuizScreen()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('take_quiz'.tr),
                        ),
                      ),
                  ],
                ),
              ],
              if (!AdService().isAdFree) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    AdService().showRewardedAd(
                      onRewarded: () {
                        AdService().grantAdFreePass();
                        Get.snackbar(
                          'ad_free_active'.tr,
                          'ad_free_sub'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 3),
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
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: Text(
                    'watch_ad_adfree'.tr,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

// ─── Weekly Challenge Card ───
class _WeeklyChallengeCard extends StatelessWidget {
  final bool isDark;
  const _WeeklyChallengeCard({required this.isDark});

  void _showLeaderboard(BuildContext context) {
    final weekly = Get.find<WeeklyChallengeController>();
    final theme = Get.find<ThemeController>();
    final entries = weekly.leaderboard;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'weekly_leaderboard'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'weekly_leaderboard_sub'.tr,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'weekly_to_go'.trParams({
                        'pts': '${WeeklyChallengeController.weeklyGoal}',
                      }),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                )
              else
                ...entries.asMap().entries.map((e) {
                  final rank = e.key + 1;
                  final entry = e.value;
                  final primary = theme.primaryColor.value;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: rank == 1
                          ? Colors.amber.withValues(alpha: 0.2)
                          : primary.withValues(alpha: 0.1),
                      child: Text(
                        'weekly_rank'.trParams({'rank': '$rank'}),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: rank == 1 ? Colors.amber.shade800 : primary,
                        ),
                      ),
                    ),
                    title: Text(
                      entry.isCurrent
                          ? 'weekly_this_week'.tr
                          : entry.weekId,
                      style: TextStyle(
                        fontWeight:
                            entry.isCurrent ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      'weekly_pts'.trParams({'pts': '${entry.points}'}),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekly = Get.find<WeeklyChallengeController>();
    final theme = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(() {
        final primary = theme.primaryColor.value;
        final complete = weekly.isWeeklyGoalComplete;
        final pts = weekly.weeklyPoints.value;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: complete
                  ? Colors.amber.withValues(alpha: 0.5)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade200),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    complete ? '🏆' : '⚡',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'weekly_challenge'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          complete
                              ? 'weekly_challenge_complete'.tr
                              : 'weekly_challenge_sub'.trParams({
                                  'goal':
                                      '${WeeklyChallengeController.weeklyGoal}',
                                }),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showLeaderboard(context),
                    child: Text('view_leaderboard'.tr),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: weekly.weeklyProgress,
                  minHeight: 8,
                  backgroundColor: primary.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    complete ? Colors.amber : primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                complete
                    ? 'weekly_pts'.trParams({'pts': '$pts'})
                    : 'weekly_to_go'.trParams(
                        {'pts': '${weekly.pointsToGoal}'},
                      ),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: complete ? Colors.amber.shade700 : primary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final bool done;
  final String label;
  final Color primary;

  const _GoalChip({
    required this.done,
    required this.label,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: done
            ? Colors.green.withValues(alpha: 0.12)
            : primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: done ? Colors.green : primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: done ? Colors.green : primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress Card ───
class _ProgressCard extends StatelessWidget {
  final int viewed;
  final int total;
  final double percent;
  final String label;
  final bool isDark;

  const _ProgressCard({
    required this.viewed,
    required this.total,
    required this.percent,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = Get.find<ThemeController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(() {
        final primary = theme.primaryColor.value;
        return Container(
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'progress'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    '$viewed / $total ${'widgets_viewed'.tr}',
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: primary.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                    fontSize: 12,
                    color: primary,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Streak Banner ───
class _StreakBanner extends StatelessWidget {
  final bool isDark;
  const _StreakBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final streak = Get.find<StreakController>();
    final theme = Get.find<ThemeController>();

    return Obx(() {
      if (streak.currentStreak.value < 2) return const SizedBox.shrink();
      final primary = theme.primaryColor.value;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary.withValues(alpha: 0.15),
                primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Text(streak.streakEmoji,
                  style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'day_streak'.tr}: ${streak.currentStreak.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: primary,
                      ),
                    ),
                    Text(
                      'streak_sub'.tr,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${'best'.tr} ${streak.longestStreak.value}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Learn More Section (Interview Q&A + Dart Cheatsheet + Quiz) ───
class _LearnMoreSection extends StatelessWidget {
  final bool isDark;
  const _LearnMoreSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'learn_more'.tr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _LearnCard(
                  emoji: '🎤',
                  title: 'interview_qa'.tr,
                  subtitle: 'interview_qa_subtitle'.tr,
                  gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                  onTap: () => Get.to(
                    () => const InterviewScreen(),
                    transition: Transition.rightToLeft,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LearnCard(
                  emoji: '📋',
                  title: 'dart_cheatsheet'.tr,
                  subtitle: 'dart_cheatsheet_subtitle'.tr,
                  gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                  onTap: () => Get.to(
                    () => const DartCheatsheetScreen(),
                    transition: Transition.rightToLeft,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Quiz Mode card — full width
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: GestureDetector(
            onTap: () => Get.to(
              () => const QuizScreen(),
              transition: Transition.rightToLeft,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFf7971e), Color(0xFFffd200)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFf7971e).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🧠', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'quiz_mode'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'quiz_mode_subtitle'.tr,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white70, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Daily Flutter Tip ───
class _DailyTipCard extends StatelessWidget {
  final bool isDark;
  const _DailyTipCard({required this.isDark});

  static const List<Map<String, String>> _tips = [
    {
      'icon': '💡',
      'title': 'Use const constructors',
      'body':
          'Mark widgets with const whenever possible. Flutter skips rebuilding them, giving you a big performance win with zero effort.',
    },
    {
      'icon': '🎨',
      'title': 'Theme everything centrally',
      'body':
          'Define colors, fonts, and shapes in ThemeData once. Widgets pick them up automatically, keeping your UI consistent and easy to update.',
    },
    {
      'icon': '⚡',
      'title': 'Prefer ListView.builder',
      'body':
          'ListView.builder renders only visible items. Use it instead of ListView with a children list whenever your list can grow beyond a handful of items.',
    },
    {
      'icon': '🔑',
      'title': 'Keys help Flutter identify widgets',
      'body':
          'Add a Key (ValueKey, GlobalKey, UniqueKey) when Flutter needs to distinguish siblings of the same type — essential for animated lists and forms.',
    },
    {
      'icon': '📦',
      'title': 'Isolates for heavy work',
      'body':
          'Long computations block the UI thread. Offload them to a separate Isolate with compute() so your app stays smooth at 60 fps.',
    },
    {
      'icon': '🗂️',
      'title': 'Organize by feature, not type',
      'body':
          'Group related screens, models, and logic in one folder (e.g. /auth) rather than splitting everything into /screens, /models, /controllers.',
    },
    {
      'icon': '🖼️',
      'title': 'Use RepaintBoundary wisely',
      'body':
          'Wrap frequently-animating widgets in RepaintBoundary. Flutter repaints only that subtree instead of the whole screen.',
    },
    {
      'icon': '🧪',
      'title': 'Write widget tests early',
      'body':
          'A simple widgetTester.pump() test catches layout overflows and missing keys long before a QA cycle. Start small — one test per screen.',
    },
    {
      'icon': '🚀',
      'title': 'Defer expensive work with Future.microtask',
      'body':
          'Schedule non-critical initialization after the first frame with Future.microtask(() => ...). Your splash screen will feel instant.',
    },
    {
      'icon': '🎯',
      'title': 'SizedBox over Container for sizing',
      'body':
          'When you only need to set width/height with no decoration, prefer SizedBox. It compiles to a simpler render object than Container.',
    },
    {
      'icon': '🔄',
      'title': 'Use StreamBuilder for real-time data',
      'body':
          'StreamBuilder automatically rebuilds when new data arrives. Pair it with a Stream from your repository for clean, reactive UIs.',
    },
    {
      'icon': '🛡️',
      'title': 'Validate user input at the source',
      'body':
          'Use TextFormField validators and Form.validate() instead of catching bad data further down the stack. Fail fast and show clear error messages.',
    },
    {
      'icon': '📐',
      'title': 'LayoutBuilder for responsive design',
      'body':
          'LayoutBuilder gives you the parent\'s constraints at build time. Use maxWidth to switch between single-column and multi-column layouts.',
    },
    {
      'icon': '🎭',
      'title': 'AnimatedSwitcher for smooth transitions',
      'body':
          'Wrap changing content with AnimatedSwitcher and set a duration. Flutter automatically cross-fades between the old and new widget.',
    },
    {
      'icon': '🔌',
      'title': 'InheritedWidget over global state',
      'body':
          'For data that many widgets need (like locale or theme), InheritedWidget propagates it down the tree efficiently without a full state management library.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dayIndex =
        DateTime.now().difference(DateTime(2024, 1, 1)).inDays % _tips.length;
    final tip = _tips[dayIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.amber.withValues(alpha: 0.3)
                  : Colors.amber.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(tip['icon']!,
                    style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Tip of the Day',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tip['title']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip['body']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

// ─── Quick Stats Card ───
class _QuickStatsCard extends StatelessWidget {
  final bool isDark;
  const _QuickStatsCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = Get.find<ThemeController>();
    final ProgressController progress = Get.find<ProgressController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Obx(() {
        final primary = theme.primaryColor.value;
        final viewed = progress.viewedCount;
        final total = progress.totalWidgets;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Learning Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatTile(
                  icon: Icons.widgets_rounded,
                  label: 'Widgets',
                  value: '$total',
                  color: primary,
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _StatTile(
                  icon: Icons.visibility_rounded,
                  label: 'Viewed',
                  value: '$viewed',
                  color: Colors.green,
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _StatTile(
                  icon: Icons.quiz_rounded,
                  label: 'Quiz Qs',
                  value: '50+',
                  color: const Color(0xFFf7971e),
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _StatTile(
                  icon: Icons.mic_rounded,
                  label: 'Interview',
                  value: '45',
                  color: const Color(0xFF667EEA),
                  isDark: isDark,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LearnCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _LearnCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recently Viewed ───
class _RecentlyViewedSection extends StatelessWidget {
  final List<String> ids;
  final bool isDark;

  const _RecentlyViewedSection({required this.ids, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = Get.find<ThemeController>();
    final allWidgets = WidgetsData.getAllWidgets();
    final recentWidgets = ids
        .map((id) => allWidgets.where((w) => w.id == id).firstOrNull)
        .whereType<dynamic>()
        .take(8)
        .toList();

    if (recentWidgets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'recently_viewed'.tr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentWidgets.length,
            itemBuilder: (context, index) {
              final w = recentWidgets[index];
              return Obx(() {
                final primary = theme.primaryColor.value;
                return GestureDetector(
                  onTap: () =>
                      Get.to(() => WidgetDetailScreen(widgetModel: w)),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E2E)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.widgets_rounded,
                            color: primary, size: 24),
                        const SizedBox(height: 6),
                        Text(
                          w.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MODERN CATEGORY CARD
// ─────────────────────────────────────────────────────────────

class ModernCategoryCard extends StatelessWidget {
  final WidgetCategory category;

  const ModernCategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ThemeController themeController = Get.find<ThemeController>();
    final ProgressController progress = Get.find<ProgressController>();

    return Obx(() {
      final primaryColor = themeController.primaryColor.value;
      final categoryWidgets = WidgetsData.getWidgetsByCategory(category.id);
      final viewedInCategory = categoryWidgets
          .where((w) => progress.isViewed(w.id))
          .length;
      final total = categoryWidgets.length;
      final pct = total == 0 ? 0.0 : viewedInCategory / total;

      return GestureDetector(
        onTap: () => Get.to(() => WidgetsListScreen(category: category)),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withValues(alpha: 0.8),
                        primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(category.icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                      height: 1.2,
                    ),
                  ),
                ),
                // Mini progress bar
                if (pct > 0) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 4,
                      backgroundColor: primaryColor.withValues(alpha: 0.15),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$viewedInCategory/$total',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
