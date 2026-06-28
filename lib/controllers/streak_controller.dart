import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StreakController extends GetxController {
  static const _lastDateKey = 'streak_last_date';
  static const _streakKey = 'streak_count';
  static const _longestKey = 'streak_longest';
  static const _totalDaysKey = 'streak_total_days';

  final _box = GetStorage();

  var currentStreak = 0.obs;
  var longestStreak = 0.obs;
  var totalDays = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAndUpdateStreak();
  }

  void _checkAndUpdateStreak() {
    final today = DateTime.now();
    final todayStr = _dateString(today);

    final lastStr = _box.read<String>(_lastDateKey);
    final savedStreak = _box.read<int>(_streakKey) ?? 0;
    final longest = _box.read<int>(_longestKey) ?? 0;
    final total = _box.read<int>(_totalDaysKey) ?? 0;

    int newStreak;
    int newTotal = total;

    if (lastStr == null) {
      newStreak = 1;
      newTotal = 1;
    } else if (lastStr == todayStr) {
      newStreak = savedStreak;
    } else {
      final parts = lastStr.split('-');
      final last = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      final diff = todayDate.difference(last).inDays;
      if (diff == 1) {
        newStreak = savedStreak + 1;
        newTotal = total + 1;
      } else {
        newStreak = 1;
        newTotal = total + 1;
      }
    }

    currentStreak.value = newStreak;
    longestStreak.value = newStreak > longest ? newStreak : longest;
    totalDays.value = newTotal;

    _box.write(_lastDateKey, todayStr);
    _box.write(_streakKey, newStreak);
    _box.write(_longestKey, longestStreak.value);
    _box.write(_totalDaysKey, newTotal);
  }

  String _dateString(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

  String get streakEmoji {
    if (currentStreak.value >= 30) return '🔥';
    if (currentStreak.value >= 14) return '⚡';
    if (currentStreak.value >= 7) return '🌟';
    if (currentStreak.value >= 3) return '💪';
    return '🌱';
  }
}
