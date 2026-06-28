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
import '../widgets/banner_ad_widget.dart';

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
  final Color levelColor;
  final bool isDark;

  const _QuestionCard({
    required this.question,
    required this.index,
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
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Get.to(
            () => InterviewDetailScreen(question: question),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                      fontSize: 15,
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
                            fontWeight: FontWeight.w600, fontSize: 14.5),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _LevelChip(label: question.level.name[0].toUpperCase() +
                              question.level.name.substring(1), color: levelColor),
                          const SizedBox(width: 6),
                          _CategoryChip(label: question.category, isDark: isDark),
                          if (count > 0) ...[
                            const SizedBox(width: 6),
                            _RevisionChip(count: count, isMastered: isMastered),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

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

  const InterviewDetailScreen({super.key, required this.question});

  @override
  State<InterviewDetailScreen> createState() => _InterviewDetailScreenState();
}

class _InterviewDetailScreenState extends State<InterviewDetailScreen> {
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
  void initState() {
    super.initState();
    // Track every 5 interview questions viewed, then show an interstitial
    AdService().incrementInterviewQuestionCounter();
  }

  void _copyAnswer() {
    Clipboard.setData(ClipboardData(
        text: '${widget.question.question}\n\n${widget.question.answer}'));
    Get.snackbar(
      'copied'.tr,
      'code_copied'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _share() {
    final text = '📱 Flutter Interview Q&A\n\n'
        'Q: ${widget.question.question}\n\n'
        'A: ${widget.question.answer}'
        '${widget.question.codeExample != null ? '\n\n```dart\n${widget.question.codeExample}\n```' : ''}'
        '\n\n— Learn Flutter App';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final levelColor = _levelColor(widget.question.level);
    final ThemeController theme = Get.find<ThemeController>();
    final InterviewReviewController review =
        Get.find<InterviewReviewController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('question'.tr),
        actions: [
          // Mark reviewed button in AppBar
          Obx(() {
            final count = review.getCount(widget.question.id);
            final isMastered = count >= 3;
            return IconButton(
              icon: Icon(
                isMastered
                    ? Icons.verified_rounded
                    : count > 0
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                color: isMastered
                    ? Colors.green
                    : count >= 2
                        ? Colors.orange
                        : count == 1
                            ? Colors.amber
                            : null,
              ),
              tooltip: isMastered
                  ? 'mastered'.tr
                  : count == 0
                      ? 'mark_reviewed'.tr
                      : '${'revision'.tr} $count / 3',
              onPressed: () {
                review.markReviewed(widget.question.id);
                final newCount = review.getCount(widget.question.id);
                Get.snackbar(
                  newCount >= 3 ? '⭐ ${'mastered'.tr}!' : '${'revision'.tr} $newCount',
                  newCount >= 3
                      ? 'mastered_message'.tr
                      : 'reviewed_x_times'.tr.replaceAll('@count', '$newCount'),
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                  backgroundColor: newCount >= 3
                      ? Colors.green.withValues(alpha: 0.9)
                      : null,
                  colorText: newCount >= 3 ? Colors.white : null,
                );
              },
            );
          }),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _share,
            tooltip: 'share'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            onPressed: _copyAnswer,
            tooltip: 'copy'.tr,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level + Category + Revision chips
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                Chip(
                  label: Text(
                    widget.question.level.name[0].toUpperCase() +
                        widget.question.level.name.substring(1),
                    style: TextStyle(
                        color: levelColor, fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: levelColor.withValues(alpha: 0.1),
                  side: BorderSide(color: levelColor.withValues(alpha: 0.3)),
                  padding: EdgeInsets.zero,
                ),
                Chip(
                  label: Text(widget.question.category),
                  backgroundColor:
                      isDark ? Colors.white12 : Colors.grey.shade100,
                  padding: EdgeInsets.zero,
                ),
                // Revision count chip
                Obx(() {
                  final count = review.getCount(widget.question.id);
                  if (count == 0) return const SizedBox.shrink();
                  final isMastered = count >= 3;
                  final color = isMastered
                      ? Colors.green
                      : count >= 2
                          ? Colors.orange
                          : Colors.amber;
                  return Chip(
                    avatar: Icon(
                      isMastered
                          ? Icons.star_rounded
                          : Icons.replay_rounded,
                      color: color,
                      size: 16,
                    ),
                    label: Text(
                      isMastered
                          ? 'mastered'.tr
                          : '${'revision'.tr} $count/3',
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: color.withValues(alpha: 0.1),
                    side: BorderSide(color: color.withValues(alpha: 0.3)),
                    padding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Question
            Obx(() {
              final primary = theme.primaryColor.value;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'question'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.question.question,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Answer
            _SectionCard(
              title: 'answer'.tr,
              icon: Icons.lightbulb_rounded,
              iconColor: Colors.amber,
              isDark: isDark,
              child: Text(
                widget.question.answer,
                style: const TextStyle(fontSize: 14.5, height: 1.6),
              ),
            ),

            // Code Example
            if (widget.question.codeExample != null) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: 'example'.tr,
                icon: Icons.code_rounded,
                iconColor: Colors.blue,
                isDark: isDark,
                trailing: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.question.codeExample!));
                    Get.snackbar(
                      'copied'.tr,
                      'code_copied'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      widget.question.codeExample!,
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Banner Ad
            const SizedBox(height: 20),
            const Center(child: BannerAdWidget()),
            const SizedBox(height: 90),
          ],
        ),
      ),

      // Floating "Mark as Reviewed" button
      floatingActionButton: Obx(() {
        final count = review.getCount(widget.question.id);
        if (count >= 3) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () {
            review.markReviewed(widget.question.id);
            final newCount = review.getCount(widget.question.id);
            Get.snackbar(
              newCount >= 3 ? '⭐ ${'mastered'.tr}!' : '${'revision'.tr} $newCount / 3',
              newCount >= 3
                  ? 'mastered_message'.tr
                  : 'reviewed_x_times'.tr.replaceAll('@count', '$newCount'),
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              backgroundColor: newCount >= 3
                  ? Colors.green.withValues(alpha: 0.9)
                  : null,
              colorText: newCount >= 3 ? Colors.white : null,
            );
          },
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: Text(
            count == 0
                ? 'mark_reviewed'.tr
                : '${'revision'.tr} ${count + 1} / 3',
          ),
        );
      }),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isDark;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.isDark,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Spacer(),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
