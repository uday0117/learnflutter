import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/share_milestone_dialog.dart';
import 'progress_controller.dart';
import 'streak_controller.dart';
import 'weekly_challenge_controller.dart';

/// Tracks daily goals, milestones, and growth prompts (share + review).
class EngagementController extends GetxController {
  static const dailyWidgetGoal = 3;
  static const _dailyDateKey = 'eng_daily_date';
  static const _dailyWidgetsKey = 'eng_daily_widgets';
  static const _dailyQuizKey = 'eng_daily_quiz';
  static const _milestonesKey = 'eng_milestones';
  static const _sessionsKey = 'eng_sessions';
  static const _reminderKey = 'eng_daily_reminder';

  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.uksolutions.learnflutter';

  final _box = GetStorage();
  final InAppReview _review = InAppReview.instance;

  var dailyWidgetsViewed = 0.obs;
  var dailyQuizDone = false.obs;
  var dailyReminderEnabled = false.obs;
  var totalSessions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDailyState();
    dailyReminderEnabled.value = _box.read<bool>(_reminderKey) ?? false;
    totalSessions.value = (_box.read<int>(_sessionsKey) ?? 0) + 1;
    _box.write(_sessionsKey, totalSessions.value);
  }

  void _loadDailyState() {
    final today = _todayStr();
    if (_box.read<String>(_dailyDateKey) != today) {
      _box.write(_dailyDateKey, today);
      _box.write(_dailyWidgetsKey, 0);
      _box.write(_dailyQuizKey, false);
      dailyWidgetsViewed.value = 0;
      dailyQuizDone.value = false;
    } else {
      dailyWidgetsViewed.value = _box.read<int>(_dailyWidgetsKey) ?? 0;
      dailyQuizDone.value = _box.read<bool>(_dailyQuizKey) ?? false;
    }
  }

  String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }

  double get dailyProgress {
    final widgetPart = (dailyWidgetsViewed.value / dailyWidgetGoal).clamp(0.0, 1.0);
    final quizPart = dailyQuizDone.value ? 1.0 : 0.0;
    return ((widgetPart * 0.7) + (quizPart * 0.3)).clamp(0.0, 1.0);
  }

  bool get isDailyGoalComplete =>
      dailyWidgetsViewed.value >= dailyWidgetGoal && dailyQuizDone.value;

  int get widgetsRemaining =>
      (dailyWidgetGoal - dailyWidgetsViewed.value).clamp(0, dailyWidgetGoal);

  void recordWidgetView() {
    _loadDailyState();
    if (dailyWidgetsViewed.value < dailyWidgetGoal) {
      dailyWidgetsViewed.value++;
      _box.write(_dailyWidgetsKey, dailyWidgetsViewed.value);
    }
    if (Get.isRegistered<WeeklyChallengeController>()) {
      Get.find<WeeklyChallengeController>().recordWidgetView();
    }
    _checkMilestones();
  }

  void recordQuizComplete() {
    _loadDailyState();
    dailyQuizDone.value = true;
    _box.write(_dailyQuizKey, true);
    _checkMilestones();
  }

  void setDailyReminder(bool enabled) {
    dailyReminderEnabled.value = enabled;
    _box.write(_reminderKey, enabled);
  }

  void _checkMilestones() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (Get.context == null) return;

      final streak = Get.find<StreakController>();
      final progress = Get.find<ProgressController>();
      final shown = Set<String>.from(
        (_box.read<List>(_milestonesKey) ?? []).map((e) => e.toString()),
      );

      void maybeShow(String id, bool condition, ShareMilestoneType type) {
        if (!condition || shown.contains(id)) return;
        shown.add(id);
        _box.write(_milestonesKey, shown.toList());
        ShareMilestoneDialog.show(type: type);
      }

      maybeShow(
        'streak_3',
        streak.currentStreak.value == 3,
        ShareMilestoneType.streak3,
      );
      maybeShow(
        'streak_7',
        streak.currentStreak.value == 7,
        ShareMilestoneType.streak7,
      );
      maybeShow(
        'streak_30',
        streak.currentStreak.value == 30,
        ShareMilestoneType.streak30,
      );
      maybeShow(
        'progress_50',
        progress.progressPercent >= 0.5,
        ShareMilestoneType.progress50,
      );
      maybeShow(
        'progress_100',
        progress.progressPercent >= 1.0,
        ShareMilestoneType.progress100,
      );
      maybeShow(
        'daily_goal',
        isDailyGoalComplete,
        ShareMilestoneType.dailyGoal,
      );

      if (isDailyGoalComplete &&
          Get.isRegistered<WeeklyChallengeController>()) {
        final weeklyKey = 'wc_daily_bonus_${_todayStr()}';
        if (_box.read<bool>(weeklyKey) != true) {
          _box.write(weeklyKey, true);
          Get.find<WeeklyChallengeController>().recordDailyGoalComplete();
        }
      }

      if (streak.currentStreak.value == 5) {
        _maybeRequestReview('streak_5');
      }
      if (totalSessions.value == 10) {
        _maybeRequestReview('sessions_10');
      }
    });
  }

  Future<void> _maybeRequestReview(String id) async {
    final reviewKey = 'review_$id';
    if (_box.read<bool>(reviewKey) == true) return;
    if (!await _review.isAvailable()) return;
    _box.write(reviewKey, true);
    await _review.requestReview();
  }

  void shareApp({String? customMessage}) {
    final streak = Get.find<StreakController>();
    final message = customMessage ??
        '🔥 I\'m on a ${streak.currentStreak.value}-day Flutter learning streak with Learn Flutter!\n\n'
            '📚 125+ widgets, quizzes & interview prep — free!\n\n'
            'Download: $playStoreUrl';
    Share.share(message);
  }

  void shareAchievement(ShareMilestoneType type) {
    final streak = Get.find<StreakController>();
    final progress = Get.find<ProgressController>();
    final pct = (progress.progressPercent * 100).toStringAsFixed(0);

    final text = switch (type) {
      ShareMilestoneType.streak3 =>
        '💪 3-day Flutter learning streak! Join me on Learn Flutter:\n$playStoreUrl',
      ShareMilestoneType.streak7 =>
        '🔥 7-day streak learning Flutter! Try Learn Flutter:\n$playStoreUrl',
      ShareMilestoneType.streak30 =>
        '🏆 30-day Flutter streak! Master widgets with Learn Flutter:\n$playStoreUrl',
      ShareMilestoneType.progress50 =>
        '📈 $pct% through all Flutter widgets on Learn Flutter!\n$playStoreUrl',
      ShareMilestoneType.progress100 =>
        '🎓 I completed ALL Flutter widgets on Learn Flutter!\n$playStoreUrl',
      ShareMilestoneType.dailyGoal =>
        '✅ Daily Flutter goal crushed! ${streak.currentStreak.value}-day streak 🔥\n$playStoreUrl',
    };
    Share.share(text);
  }
}

enum ShareMilestoneType {
  streak3,
  streak7,
  streak30,
  progress50,
  progress100,
  dailyGoal,
}
