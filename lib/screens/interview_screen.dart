import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/interview_review_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/interview_data.dart';
import '../models/interview_question.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../services/deep_link_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'interview_swipe_screen.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ThemeController _theme = Get.find<ThemeController>();
  final InterviewReviewController _review =
      Get.find<InterviewReviewController>();

  final _tabs = [
    ('all_questions'.tr, null),
    ('beginner'.tr, QuestionLevel.beginner),
    ('intermediate'.tr, QuestionLevel.intermediate),
    ('advanced'.tr, QuestionLevel.advanced),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    AnalyticsService().logScreenView('InterviewScreen');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<InterviewQuestion> _getQuestions(QuestionLevel? level) =>
      level == null ? InterviewData.getAll() : InterviewData.getByLevel(level);

  Color _levelColor(QuestionLevel level) {
    switch (level) {
      case QuestionLevel.beginner:
        return Colors.green;
      case QuestionLevel.intermediate:
        return Colors.orange;
      case QuestionLevel.advanced:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final primary = _theme.primaryColor.value;
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.style_rounded, color: Colors.white),
                  tooltip: 'Flashcards Swipe Deck',
                  onPressed: () => Get.to(
                    () => const InterviewSwipeScreen(),
                    transition: Transition.rightToLeft,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'interview_title'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primary, primary.withValues(alpha: 0.7)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Icon(Icons.quiz_rounded,
                            color: Colors.white54, size: 40),
                        const SizedBox(height: 4),
                        Obx(() {
                          final all = InterviewData.getAll();
                          final mastered = _review.masteredCount(
                              all.map((q) => q.id).toList());
                          return Text(
                            '${all.length} ${'questions'.tr}  ·  $mastered ${'mastered'.tr}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: _tabs
                .map((t) => _QuestionList(
                      questions: _getQuestions(t.$2),
                      levelColor: _levelColor,
                      isDark: isDark,
                      primary: primary,
                    ))
                .toList(),
          ),
        ),
      );
    });
  }
}

// ─────────────── Question List with progress header ───────────────

class _QuestionList extends StatelessWidget {
  final List<InterviewQuestion> questions;
  final Color Function(QuestionLevel) levelColor;
  final bool isDark;
  final Color primary;

  const _QuestionList({
    required this.questions,
    required this.levelColor,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final review = Get.find<InterviewReviewController>();
    final ids = questions.map((q) => q.id).toList();

    return Column(
      children: [
        // Progress banner
        Obx(() {
          final reviewed = review.reviewedAtLeastOnce(ids);
          final mastered = review.masteredCount(ids);
          final total = questions.length;
          final pct = total == 0 ? 0.0 : reviewed / total;
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : primary.withValues(alpha: 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$reviewed / $total ${'reviewed'.tr}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    const Spacer(),
                    _MasteredBadge(count: mastered),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 5,
                    backgroundColor:
                        isDark ? Colors.white12 : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      pct >= 1.0 ? Colors.green : primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // Question cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: questions.length,
            itemBuilder: (_, i) {
              final q = questions[i];
              return _QuestionCard(
                question: q,
                index: i + 1,
                questions: questions,
                levelColor: levelColor(q.level),
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MasteredBadge extends StatelessWidget {
  final int count;
  const _MasteredBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.green, size: 12),
          const SizedBox(width: 3),
          Text(
            '$count ${'mastered'.tr}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Question Card ───────────────

class _QuestionCard extends StatelessWidget {
  final InterviewQuestion question;
  final int index;
  final List<InterviewQuestion>? questions;
  final Color levelColor;
  final bool isDark;

  const _QuestionCard({
    required this.question,
    required this.index,
    this.questions,
    required this.levelColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final review = Get.find<InterviewReviewController>();

    return Obx(() {
      final count = review.getCount(question.id);
      final isMastered = count >= 3;

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        color: isDark ? const Color(0xFF1B1E2B) : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(
            () => InterviewDetailScreen(
              question: question,
              questionList: questions,
              initialIndex: index - 1,
            ),
            transition: Transition.rightToLeft,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Index badge
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Question text + chips
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _LevelChip(
                            label: question.level.name[0].toUpperCase() +
                                question.level.name.substring(1),
                            color: levelColor,
                          ),
                          _CategoryChip(
                            label: question.category,
                            isDark: isDark,
                          ),
                          if (count > 0)
                            _RevisionChip(
                              count: count,
                              isMastered: isMastered,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Review button column
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _ReviewButton(
                      count: count,
                      isMastered: isMastered,
                      onTap: () => review.markReviewed(question.id),
                      onLongPress: () => _confirmReset(context, review),
                    ),
                    const SizedBox(height: 6),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _confirmReset(BuildContext context, InterviewReviewController review) {
    if (review.getCount(question.id) == 0) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('reset_progress'.tr),
        content: Text('reset_question_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              review.resetQuestion(question.id);
              Get.back();
            },
            child: Text('reset'.tr,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Chip widgets ───────────────

class _LevelChip extends StatelessWidget {
  final String label;
  final Color color;
  const _LevelChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _CategoryChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white60 : Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _RevisionChip extends StatelessWidget {
  final int count;
  final bool isMastered;
  const _RevisionChip({required this.count, required this.isMastered});

  @override
  Widget build(BuildContext context) {
    final color = isMastered ? Colors.green : (count >= 2 ? Colors.orange : Colors.amber);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMastered ? Icons.star_rounded : Icons.replay_rounded,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            isMastered ? 'mastered'.tr : '×$count',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Review Button ───────────────

class _ReviewButton extends StatelessWidget {
  final int count;
  final bool isMastered;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ReviewButton({
    required this.count,
    required this.isMastered,
    required this.onTap,
    required this.onLongPress,
  });

  Color get _color {
    if (isMastered) return Colors.green;
    if (count == 2) return Colors.orange;
    if (count == 1) return Colors.amber;
    return Colors.grey;
  }

  IconData get _icon {
    if (isMastered) return Icons.verified_rounded;
    if (count > 0) return Icons.check_circle_rounded;
    return Icons.radio_button_unchecked_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isMastered
          ? 'mastered'.tr
          : count == 0
              ? 'mark_reviewed'.tr
              : '${'revision'.tr} $count',
      child: GestureDetector(
        onTap: onTap,
        onLongPress: count > 0 ? onLongPress : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: _color.withValues(alpha: 0.5)),
          ),
          child: count > 0 && !isMastered
              ? Center(
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _color,
                    ),
                  ),
                )
              : Icon(_icon, color: _color, size: 18),
        ),
      ),
    );
  }
}

// ─────────────── Detail Screen ───────────────

class InterviewDetailScreen extends StatefulWidget {
  final InterviewQuestion question;
  final List<InterviewQuestion>? questionList;
  final int? initialIndex;

  const InterviewDetailScreen({
    super.key,
    required this.question,
    this.questionList,
    this.initialIndex,
  });

  @override
  State<InterviewDetailScreen> createState() => _InterviewDetailScreenState();
}

class _InterviewDetailScreenState extends State<InterviewDetailScreen> {
  late List<InterviewQuestion> _items;
  late int _currentIndex;
  late PageController _pageController;

  final InterviewReviewController _review =
      Get.find<InterviewReviewController>();

  Color _levelColor(QuestionLevel level) {
    switch (level) {
      case QuestionLevel.beginner:
        return const Color(0xFF10B981);
      case QuestionLevel.intermediate:
        return const Color(0xFFF59E0B);
      case QuestionLevel.advanced:
        return const Color(0xFFEF4444);
    }
  }

  @override
  void initState() {
    super.initState();
    _items = widget.questionList ?? [widget.question];
    final foundIndex = _items.indexWhere((q) => q.id == widget.question.id);
    _currentIndex = widget.initialIndex ?? (foundIndex >= 0 ? foundIndex : 0);
    _pageController = PageController(initialPage: _currentIndex);

    _logActiveQuestion();
  }

  void _logActiveQuestion() {
    if (_currentIndex >= 0 && _currentIndex < _items.length) {
      final q = _items[_currentIndex];
      AnalyticsService().logScreenView('InterviewDetail_${q.id}');
      AnalyticsService().logInterviewQuestionViewed(
        questionId: q.id,
        category: q.category,
        level: q.level.name,
        questionIndex: _currentIndex + 1,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _copyQuestionAndAnswer(InterviewQuestion q) {
    Clipboard.setData(ClipboardData(
      text: 'Q: ${q.question}\n\n'
          'A: ${q.answer}'
          '${q.codeExample != null ? '\n\nCode Example:\n${q.codeExample}' : ''}',
    ));
    AnalyticsService().logCodeCopied(contentType: 'interview_qa', contentId: q.id);
    Get.snackbar(
      'copied'.tr,
      'code_copied'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _copyCode(String code, String qId) {
    Clipboard.setData(ClipboardData(text: code));
    AnalyticsService().logCodeCopied(contentType: 'interview_code', contentId: qId);
    HapticFeedback.lightImpact();
    Get.snackbar(
      'copied'.tr,
      'Dart snippet copied to clipboard!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _share(InterviewQuestion q) {
    final text = '📱 Flutter Interview Question\n\n'
        'Q: ${q.question}\n\n'
        'A: ${q.answer}'
        '${q.codeExample != null ? '\n\n```dart\n${q.codeExample}\n```' : ''}'
        '\n\n👉 Master 55+ Flutter Interview Questions Free:\n${DeepLinkService.playStoreUrl}';
    Share.share(text);
  }

  void _advanceMastery(InterviewQuestion q) {
    HapticFeedback.mediumImpact();
    _review.markReviewed(q.id);
    final count = _review.getCount(q.id);
    if (count >= 3) {
      AnalyticsService().logInterviewMastered(
        questionId: q.id,
        revisionCount: count,
      );
    }
    Get.snackbar(
      count >= 3 ? '⭐ ${'mastered'.tr}!' : '${'revision'.tr} $count / 3',
      count >= 3
          ? 'mastered_message'.tr
          : 'reviewed_x_times'.tr.replaceAll('@count', '$count'),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: count >= 3 ? const Color(0xFF10B981) : null,
      colorText: count >= 3 ? Colors.white : null,
    );
  }

  void _resetMastery(InterviewQuestion q) {
    HapticFeedback.lightImpact();
    _review.resetQuestion(q.id);
    Get.snackbar(
      'Progress Reset',
      'Question mastery reset to review again.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQuestion = _items[_currentIndex];
    final lvlColor = _levelColor(currentQuestion.level);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          AdService().incrementInterviewQuestionCounter();
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F111A) : const Color(0xFFF7F9FC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF151824) : Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${_items.length}',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() {
              final count = _review.getCount(currentQuestion.id);
              final isMastered = count >= 3;
              return IconButton(
                icon: Icon(
                  isMastered
                      ? Icons.star_rounded
                      : count > 0
                          ? Icons.star_half_rounded
                          : Icons.star_outline_rounded,
                  color: isMastered
                      ? Colors.amber
                      : count > 0
                          ? Colors.orange
                          : null,
                ),
                tooltip: isMastered ? 'Mastered Question' : 'Mark as Reviewed',
                onPressed: () => _advanceMastery(currentQuestion),
              );
            }),
            IconButton(
              icon: const Icon(Icons.share_rounded, size: 20),
              tooltip: 'share'.tr,
              onPressed: () => _share(currentQuestion),
            ),
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20),
              tooltip: 'copy'.tr,
              onPressed: () => _copyQuestionAndAnswer(currentQuestion),
            ),
          ],
        ),
        body: Column(
          children: [
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _items.length,
              minHeight: 3,
              backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(lvlColor),
            ),

            // PageView of Questions
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _logActiveQuestion();
                },
                itemBuilder: (context, index) {
                  final q = _items[index];
                  return _buildQuestionDetailView(q, index, isDark);
                },
              ),
            ),

            // Bottom Navigation Bar
            _buildBottomNavigator(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionDetailView(InterviewQuestion q, int index, bool isDark) {
    final lvlColor = _levelColor(q.level);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HERO QUESTION CARD ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF181B28) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chips Row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: lvlColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: lvlColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        q.level.name.toUpperCase(),
                        style: TextStyle(
                          color: lvlColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        q.category,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Question Title
                Text(
                  q.question,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                    color: isDark ? Colors.white : const Color(0xFF1A202C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── MASTERY STATUS CARD ──
          Obx(() {
            final count = _review.getCount(q.id);
            final isMastered = count >= 3;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isMastered
                    ? Colors.green.withValues(alpha: isDark ? 0.12 : 0.08)
                    : isDark ? const Color(0xFF181B28) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMastered
                      ? Colors.green.withValues(alpha: 0.3)
                      : isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  // Progress dots
                  Row(
                    children: List.generate(3, (dotIndex) {
                      final filled = dotIndex < count;
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? (isMastered ? Colors.green : Colors.orange)
                              : (isDark ? Colors.white24 : Colors.grey.shade300),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isMastered
                          ? 'Mastered (${count}x reviewed)'
                          : count == 0
                              ? 'Not practiced yet'
                              : 'Reviewed $count/3 times',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isMastered
                            ? Colors.green
                            : isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => isMastered ? _resetMastery(q) : _advanceMastery(q),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isMastered
                            ? (isDark ? Colors.white10 : Colors.grey.shade200)
                            : lvlColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isMastered
                              ? Colors.transparent
                              : lvlColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        isMastered ? 'Reset' : '+ Practice',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isMastered
                              ? (isDark ? Colors.white70 : Colors.black87)
                              : lvlColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // ── DETAILED ANSWER CARD ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF181B28) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_stories_rounded, color: Colors.amber, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Explanation & Answer',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A202C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  q.answer,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.65,
                    color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),

          // ── CODE EXAMPLE BLOCK ──
          if (q.codeExample != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF141622),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Code Header Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      border: Border(
                        bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Terminal Dots
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                            const SizedBox(width: 5),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                            const SizedBox(width: 5),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Dart Example',
                          style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () => _copyCode(q.codeExample!, q.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              children: const [
                                Icon(Icons.copy_rounded, color: Colors.white70, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Copy',
                                  style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Monospace Code Text
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        q.codeExample!,
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFFE2E8F0),
                          fontSize: 12.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          const Center(child: BannerAdWidget()),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBottomNavigator(bool isDark) {
    final canPrev = _currentIndex > 0;
    final canNext = _currentIndex < _items.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151824) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            TextButton.icon(
              onPressed: canPrev
                  ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  : null,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Previous', style: TextStyle(fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.white : Colors.black87,
                disabledForegroundColor: Colors.grey.shade400,
              ),
            ),

            // Indicator
            Text(
              '${_currentIndex + 1} of ${_items.length}',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),

            // Next Button
            ElevatedButton.icon(
              onPressed: canNext
                  ? () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  : null,
              icon: const Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
              label: const Icon(Icons.arrow_forward_rounded, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: _levelColor(_items[_currentIndex].level),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
