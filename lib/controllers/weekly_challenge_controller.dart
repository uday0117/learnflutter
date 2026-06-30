import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Tracks weekly learning points and a local personal leaderboard
/// (your past weeks ranked — no cloud, no paid services).
class WeeklyChallengeController extends GetxController {
  static const weeklyGoal = 300;
  static const _weekKey = 'wc_current_week';
  static const _pointsKey = 'wc_current_points';
  static const _historyKey = 'wc_history';

  final _box = GetStorage();

  var weeklyPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _rollWeekIfNeeded();
    weeklyPoints.value = _box.read<int>(_pointsKey) ?? 0;
  }

  String _weekId(DateTime dt) {
    final jan1 = DateTime(dt.year);
    final dayOfYear = dt.difference(jan1).inDays + 1;
    final week = ((dayOfYear + jan1.weekday - 1) / 7).ceil();
    return '${dt.year}-W$week';
  }

  void _rollWeekIfNeeded() {
    final current = _weekId(DateTime.now());
    final stored = _box.read<String>(_weekKey);
    if (stored == null) {
      _box.write(_weekKey, current);
      return;
    }
    if (stored != current) {
      _archiveWeek(stored, _box.read<int>(_pointsKey) ?? 0);
      _box.write(_weekKey, current);
      _box.write(_pointsKey, 0);
      weeklyPoints.value = 0;
    }
  }

  void _archiveWeek(String weekId, int points) {
    if (points <= 0) return;
    final history = _readHistory();
    history.removeWhere((e) => e.weekId == weekId);
    history.add(WeeklyScoreEntry(weekId: weekId, points: points));
    history.sort((a, b) => b.points.compareTo(a.points));
    _box.write(
      _historyKey,
      history.map((e) => {'weekId': e.weekId, 'points': e.points}).toList(),
    );
  }

  List<WeeklyScoreEntry> _readHistory() {
    final raw = _box.read<List>(_historyKey) ?? [];
    return raw
        .map((e) => WeeklyScoreEntry(
              weekId: e['weekId']?.toString() ?? '',
              points: (e['points'] as num?)?.toInt() ?? 0,
            ))
        .where((e) => e.weekId.isNotEmpty && e.points > 0)
        .toList();
  }

  void addPoints(int amount) {
    if (amount <= 0) return;
    _rollWeekIfNeeded();
    weeklyPoints.value += amount;
    _box.write(_pointsKey, weeklyPoints.value);
  }

  void recordWidgetView() => addPoints(15);

  void recordDailyGoalComplete() => addPoints(50);

  void recordQuizScore(int score) => addPoints(score * 5);

  double get weeklyProgress =>
      (weeklyPoints.value / weeklyGoal).clamp(0.0, 1.0);

  bool get isWeeklyGoalComplete => weeklyPoints.value >= weeklyGoal;

  int get pointsToGoal =>
      (weeklyGoal - weeklyPoints.value).clamp(0, weeklyGoal);

  /// Personal local leaderboard: current week + archived weeks, ranked.
  List<WeeklyScoreEntry> get leaderboard {
    _rollWeekIfNeeded();
    final current = WeeklyScoreEntry(
      weekId: _weekId(DateTime.now()),
      points: weeklyPoints.value,
      isCurrent: true,
    );
    final entries = [..._readHistory()];
    entries.removeWhere((e) => e.weekId == current.weekId);
    if (current.points > 0) entries.add(current);
    entries.sort((a, b) => b.points.compareTo(a.points));
    return entries.take(10).toList();
  }

  int rankFor(WeeklyScoreEntry entry) {
    final sorted = [...leaderboard]..sort((a, b) => b.points.compareTo(a.points));
    return sorted.indexWhere((e) => e.weekId == entry.weekId) + 1;
  }
}

class WeeklyScoreEntry {
  final String weekId;
  final int points;
  final bool isCurrent;

  const WeeklyScoreEntry({
    required this.weekId,
    required this.points,
    this.isCurrent = false,
  });
}
