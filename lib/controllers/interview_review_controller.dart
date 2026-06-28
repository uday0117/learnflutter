import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class InterviewReviewController extends GetxController {
  static const _reviewsKey = 'interview_reviews';
  final _box = GetStorage();

  // questionId -> revision count
  final RxMap<String, int> _reviewCounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final stored = _box.read<Map>(_reviewsKey);
    if (stored != null) {
      _reviewCounts.addAll(
        stored.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      );
    }
  }

  void _save() =>
      _box.write(_reviewsKey, Map<String, int>.from(_reviewCounts));

  int getCount(String questionId) => _reviewCounts[questionId] ?? 0;

  /// Increments the revision count for the given question.
  void markReviewed(String questionId) {
    _reviewCounts[questionId] = (_reviewCounts[questionId] ?? 0) + 1;
    _save();
  }

  /// Resets the revision count for the given question back to zero.
  void resetQuestion(String questionId) {
    _reviewCounts.remove(questionId);
    _save();
  }

  bool isMastered(String questionId) => getCount(questionId) >= 3;
  bool isReviewed(String questionId) => getCount(questionId) >= 1;

  int masteredCount(List<String> ids) =>
      ids.where((id) => isMastered(id)).length;
  int reviewedAtLeastOnce(List<String> ids) =>
      ids.where((id) => isReviewed(id)).length;

  void clearAll() {
    _reviewCounts.clear();
    _box.remove(_reviewsKey);
  }
}
