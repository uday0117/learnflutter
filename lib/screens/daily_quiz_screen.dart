import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/streak_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/quiz_data.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../services/share_card_service.dart';
import '../widgets/banner_ad_widget.dart';

class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key});

  @override
  State<DailyQuizScreen> createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen> {
  final _box = GetStorage();
  final StreakController _streak = Get.find<StreakController>();

  late String _todayKey;
  late List<QuizQuestion> _dailyQuestions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCompletedToday = false;
  bool _justFinished = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('DailyQuizScreen');

    final now = DateTime.now();
    _todayKey = 'daily_quiz_${now.year}_${now.month}_${now.day}';
    _isCompletedToday = _box.read<bool>(_todayKey) ?? false;

    // Pick 5 stable daily questions seeded by day of year
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final allQuestions = QuizData.all;
    _dailyQuestions = List.generate(5, (i) {
      final idx = (dayOfYear * 7 + i * 13) % allQuestions.length;
      return allQuestions[idx];
    });
  }

  void _submitAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
      if (index == _dailyQuestions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _dailyQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      // Finished daily quiz
      _box.write(_todayKey, true);
      _box.write('${_todayKey}_score', _score);
      AnalyticsService().logEvent(
        'daily_quiz_completed',
        parameters: {'score': _score, 'total': _dailyQuestions.length},
      );

      setState(() {
        _justFinished = true;
        _isCompletedToday = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = theme.primaryColor.value;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🔥 ', style: TextStyle(fontSize: 20)),
            Text(
              'Daily Quiz Challenge',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _justFinished || (_isCompletedToday && !_isAnswered && _currentIndex == 0)
                ? _buildCompletedView(isDark, primary)
                : _buildQuizView(isDark, primary),
          ),

          // AdMob banner
          Obx(() {
            if (AdService().isAdFree) return const SizedBox.shrink();
            return const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Center(child: BannerAdWidget()),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuizView(bool isDark, Color primary) {
    final q = _dailyQuestions[_currentIndex];
    final progress = (_currentIndex + 1) / _dailyQuestions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8008), Color(0xFFFFC837)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1} of ${_dailyQuestions.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Complete daily quiz to protect and boost your streak!',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: primary.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
          const SizedBox(height: 20),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.grey.shade300,
              ),
            ),
            child: Text(
              q.question,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Options
          ...List.generate(q.options.length, (i) {
            final option = q.options[i];
            final isCorrect = i == q.correctIndex;
            final isSelected = _selectedAnswer == i;

            Color borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
            Color bgColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;

            if (_isAnswered) {
              if (isCorrect) {
                borderColor = Colors.green;
                bgColor = Colors.green.withValues(alpha: 0.15);
              } else if (isSelected) {
                borderColor = Colors.red;
                bgColor = Colors.red.withValues(alpha: 0.15);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _submitAnswer(i),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _isAnswered && isCorrect
                              ? Colors.green
                              : (_isAnswered && isSelected ? Colors.red : primary.withValues(alpha: 0.1)),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          String.fromCharCode(65 + i),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isAnswered && (isCorrect || isSelected) ? Colors.white : primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (_isAnswered) ...[
                        if (isCorrect)
                          const Icon(Icons.check_circle_rounded, color: Colors.green)
                        else if (isSelected)
                          const Icon(Icons.cancel_rounded, color: Colors.red),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          // Explanation when answered
          if (_isAnswered) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      q.explanation,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(_currentIndex < _dailyQuestions.length - 1 ? 'Next Question' : 'Finish Daily Quiz'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletedView(bool isDark, Color primary) {
    final savedScore = _box.read<int>('${_todayKey}_score') ?? _score;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 54)),
              const SizedBox(height: 12),
              Text(
                'Daily Quiz Completed!',
                style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored $savedScore out of 5 today',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Streak: ${_streak.currentStreak.value} Days 🔥',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Home'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ShareCardService().shareQuizResult(savedScore, 5);
                      },
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
