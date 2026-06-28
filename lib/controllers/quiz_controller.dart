import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/quiz_data.dart';
import '../services/ad_service.dart';

class QuizController extends GetxController {
  static const _totalKey = 'quiz_total_played';
  static const _correctKey = 'quiz_total_correct';
  static const _bestKey = 'quiz_best_score';

  final _box = GetStorage();

  var currentIndex = 0.obs;
  var selectedAnswer = (-1).obs;
  var isAnswered = false.obs;
  var score = 0.obs;
  var isFinished = false.obs;

  // Lifetime stats
  var totalPlayed = 0.obs;
  var totalCorrect = 0.obs;
  var bestScore = 0.obs;

  // ── Hint (50/50 lifeline) ──────────────────────────────────────────
  /// Whether the hint has been revealed for the current question.
  var hintRevealed = false.obs;

  /// Whether the hint has already been used this session (one per session).
  var hintUsedThisSession = false.obs;

  /// Indices of the two wrong options eliminated when the hint is active.
  List<int> get eliminatedOptions {
    if (!hintRevealed.value) return [];
    final wrongs = List.generate(current.options.length, (i) => i)
      ..removeWhere((i) => i == current.correctIndex);
    wrongs.shuffle();
    return wrongs.take(2).toList();
  }

  // Cache the eliminated list so it doesn't re-shuffle on rebuild
  List<int> _cachedEliminated = [];

  void _cacheEliminated() {
    final wrongs = List.generate(current.options.length, (i) => i)
      ..removeWhere((i) => i == current.correctIndex);
    wrongs.shuffle();
    _cachedEliminated = wrongs.take(2).toList();
  }

  List<int> get eliminatedOptionsStable => _cachedEliminated;

  // ── Bonus round ─────────────────────────────────────────────────────
  /// Whether the bonus-round offer is visible on the result screen.
  var bonusAvailable = true.obs;

  /// Set to true once the bonus round has been unlocked via a rewarded ad.
  var bonusUnlocked = false.obs;

  late List<QuizQuestion> _questions;

  List<QuizQuestion> get questions => _questions;
  QuizQuestion get current => _questions[currentIndex.value];
  int get totalQuestions => _questions.length;

  @override
  void onInit() {
    super.onInit();
    totalPlayed.value = _box.read<int>(_totalKey) ?? 0;
    totalCorrect.value = _box.read<int>(_correctKey) ?? 0;
    bestScore.value = _box.read<int>(_bestKey) ?? 0;
    _startNewQuiz();
  }

  void _startNewQuiz() {
    final shuffled = List<QuizQuestion>.from(QuizData.all)..shuffle();
    _questions = shuffled.take(10).toList();
    currentIndex.value = 0;
    selectedAnswer.value = -1;
    isAnswered.value = false;
    score.value = 0;
    isFinished.value = false;
    hintRevealed.value = false;
    hintUsedThisSession.value = false;
    bonusAvailable.value = true;
    bonusUnlocked.value = false;
    _cachedEliminated = [];
  }

  void answer(int index) {
    if (isAnswered.value) return;
    selectedAnswer.value = index;
    isAnswered.value = true;
    if (index == current.correctIndex) {
      score.value++;
    }
  }

  void next() {
    hintRevealed.value = false;
    _cachedEliminated = [];

    if (currentIndex.value + 1 >= totalQuestions) {
      _finishQuiz();
    } else {
      final nextIndex = currentIndex.value + 1;
      // Show interstitial before every 5th question (Q5→Q6, Q10→Q11, …)
      if (nextIndex % 5 == 0) {
        AdService().showInterstitialAdWithCallback(() {
          currentIndex.value = nextIndex;
          selectedAnswer.value = -1;
          isAnswered.value = false;
        });
      } else {
        currentIndex.value = nextIndex;
        selectedAnswer.value = -1;
        isAnswered.value = false;
      }
    }
  }

  void _finishQuiz() {
    isFinished.value = true;
    totalPlayed.value++;
    totalCorrect.value += score.value;
    if (score.value > bestScore.value) {
      bestScore.value = score.value;
      _box.write(_bestKey, bestScore.value);
    }
    _box.write(_totalKey, totalPlayed.value);
    _box.write(_correctKey, totalCorrect.value);
  }

  void restart() {
    _startNewQuiz();
  }

  // ── Hint logic ───────────────────────────────────────────────────────

  /// Called after the user earns the reward from a rewarded ad.
  /// Eliminates two wrong options (50/50 lifeline).
  void revealHint() {
    if (isAnswered.value) return;
    _cacheEliminated();
    hintRevealed.value = true;
    hintUsedThisSession.value = true;
  }

  // ── Bonus round logic ────────────────────────────────────────────────

  /// Called after the user earns the reward from a rewarded ad on result screen.
  /// Appends 5 fresh questions and resumes the quiz.
  void unlockBonusRound() {
    bonusUnlocked.value = true;
    bonusAvailable.value = false;

    // Pick 5 questions not already in the current set (use question text as key)
    final existing = _questions.map((q) => q.question).toSet();
    final pool = QuizData.all
        .where((q) => !existing.contains(q.question))
        .toList()
      ..shuffle();
    final bonus = pool.take(5).toList();

    if (bonus.isEmpty) {
      // Edge case: not enough unique questions — restart fresh
      restart();
      return;
    }

    _questions = List<QuizQuestion>.from(_questions)..addAll(bonus);
    isFinished.value = false;
    currentIndex.value = _questions.length - bonus.length;
    selectedAnswer.value = -1;
    isAnswered.value = false;
    hintRevealed.value = false;
    _cachedEliminated = [];
  }

  String get scoreMessage {
    final pct = score.value / totalQuestions;
    if (pct == 1.0) return 'Perfect! 🏆';
    if (pct >= 0.8) return 'Excellent! 🌟';
    if (pct >= 0.6) return 'Good job! 👍';
    if (pct >= 0.4) return 'Keep practicing! 📚';
    return 'Try again! 💪';
  }

  double get accuracy =>
      totalPlayed.value == 0
          ? 0
          : totalCorrect.value / (totalPlayed.value * totalQuestions);
}
