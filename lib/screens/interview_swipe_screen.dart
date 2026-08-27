import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/interview_review_controller.dart';
import '../data/interview_data.dart';
import '../models/interview_question.dart';
import '../services/ad_service.dart';

class InterviewSwipeScreen extends StatefulWidget {
  const InterviewSwipeScreen({super.key});

  @override
  State<InterviewSwipeScreen> createState() => _InterviewSwipeScreenState();
}

class _InterviewSwipeScreenState extends State<InterviewSwipeScreen> {
  final InterviewReviewController _review = Get.find<InterviewReviewController>();
  late List<InterviewQuestion> _questions;
  int _swipeCount = 0;

  @override
  void initState() {
    super.initState();
    // Copy and shuffle the questions
    _questions = List.from(InterviewData.getAll())..shuffle();
  }

  void _handleSwipe(bool mastered) {
    if (_questions.isEmpty) return;
    final question = _questions.last;

    if (mastered) {
      // Mark as mastered by ensuring count is at least 3
      while (!_review.isMastered(question.id)) {
        _review.markReviewed(question.id);
      }
    } else {
      // Mark as review later (reviewed at least once, count is 1)
      final current = _review.getCount(question.id);
      if (current >= 3) {
        _review.resetQuestion(question.id);
      }
      if (_review.getCount(question.id) == 0) {
        _review.markReviewed(question.id);
      }
    }

    setState(() {
      _questions.removeLast();
      _swipeCount++;
    });

    // Interstitial ad every 10 swipes
    if (_swipeCount % 10 == 0) {
      AdService().showInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Flashcards', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reshuffle Deck',
            onPressed: () {
              setState(() {
                _questions = List.from(InterviewData.getAll())..shuffle();
                _swipeCount = 0;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ── Progress Tracker ──
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cards remaining: ${_questions.length}',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    Text(
                      'Session swipes: $_swipeCount',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // ── Card Stack Area ──
              Expanded(
                child: _questions.isEmpty
                    ? _buildCompletionScreen(isDark)
                    : Stack(
                        clipBehavior: Clip.none,
                        children: _questions.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final question = entry.value;
                          final isTop = idx == _questions.length - 1;

                          return _SwipeCard(
                            key: ValueKey(question.id),
                            question: question,
                            isTop: isTop,
                            onSwipeLeft: () => _handleSwipe(false),
                            onSwipeRight: () => _handleSwipe(true),
                          );
                        }).toList(),
                      ),
              ),

              // ── Swipe Guidance Footer ──
              if (_questions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSwipeIndicator(Icons.arrow_back_rounded, 'Review Later', Colors.red),
                      _buildSwipeIndicator(Icons.arrow_forward_rounded, 'Mastered', Colors.green),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeIndicator(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCompletionScreen(bool isDark) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deck Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'You have reviewed all the flashcards in this session. Great job keeping your prep active!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _questions = List.from(InterviewData.getAll())..shuffle();
                    _swipeCount = 0;
                  });
                },
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Restart Session'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Back to Questions List'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── SWIPEABLE & FLIPPABLE CARD WIDGET ──
class _SwipeCard extends StatefulWidget {
  final InterviewQuestion question;
  final bool isTop;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const _SwipeCard({
    super.key,
    required this.question,
    required this.isTop,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  State<_SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<_SwipeCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Offset _dragOffset = Offset.zero;
  double _rotation = 0.0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _resetPosition() {
    _animController.forward(from: 0.0);
    final startOffset = _dragOffset;
    final startRotation = _rotation;

    _animController.addListener(() {
      setState(() {
        _dragOffset = Offset.lerp(startOffset, Offset.zero, _animController.value)!;
        _rotation = lerpDouble(startRotation, 0.0, _animController.value);
      });
    });
  }

  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Card dimensions
    final cardWidget = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotate = Tween(begin: pi, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotate,
              child: child,
              builder: (context, child) {
                final isBack = child!.key == const ValueKey('back');
                var tilt = rotate.value;
                if (isBack) tilt += pi;

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(tilt),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          child: _isFlipped ? _buildBack(isDark) : _buildFront(isDark),
        ),
      ),
    );

    if (!widget.isTop) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
        child: cardWidget,
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlipped = !_isFlipped;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
          _rotation = _dragOffset.dx / 350.0;
        });
      },
      onPanEnd: (details) {
        if (_dragOffset.dx > 130) {
          // Swipe Right (Mastered)
          widget.onSwipeRight();
        } else if (_dragOffset.dx < -130) {
          // Swipe Left (Review)
          widget.onSwipeLeft();
        } else {
          _resetPosition();
        }
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: _rotation,
          child: Stack(
            children: [
              cardWidget,

              // Swipe Stamp Overlay
              if (_dragOffset.dx.abs() > 40)
                Positioned(
                  top: 40,
                  left: _dragOffset.dx > 0 ? 40 : null,
                  right: _dragOffset.dx < 0 ? 40 : null,
                  child: Transform.rotate(
                    angle: _dragOffset.dx > 0 ? -0.2 : 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _dragOffset.dx > 0 ? Colors.green : Colors.red,
                          width: 3.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _dragOffset.dx > 0 ? 'MASTERED' : 'REVIEW',
                        style: TextStyle(
                          color: _dragOffset.dx > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFront(bool isDark) {
    return Container(
      key: const ValueKey('front'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.question.category.toUpperCase(),
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              _buildLevelBadge(widget.question.level),
            ],
          ),
          const Spacer(),
          Center(
            child: Text(
              widget.question.question,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const Spacer(),
          const Center(
            child: Column(
              children: [
                Icon(Icons.touch_app_rounded, color: Colors.grey, size: 28),
                SizedBox(height: 4),
                Text(
                  'Tap card to reveal answer',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(bool isDark) {
    return Container(
      key: const ValueKey('back'),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ANSWER',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey, fontSize: 12),
              ),
              IconButton(
                icon: const Icon(Icons.flip_to_front_rounded, size: 20),
                onPressed: () {
                  setState(() {
                    _isFlipped = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.answer,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  if (widget.question.codeExample != null && widget.question.codeExample!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Code Example',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SyntaxView(
                          code: widget.question.codeExample!,
                          syntax: Syntax.DART,
                          syntaxTheme: isDark ? SyntaxTheme.vscodeDark() : SyntaxTheme.standard(),
                          withZoom: false,
                          withLinesCount: false,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Swipe Left to Review  ·  Swipe Right to Master',
              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(QuestionLevel level) {
    Color color;
    String label;
    switch (level) {
      case QuestionLevel.beginner:
        color = Colors.green;
        label = 'Beginner';
        break;
      case QuestionLevel.intermediate:
        color = Colors.orange;
        label = 'Intermediate';
        break;
      case QuestionLevel.advanced:
        color = Colors.red;
        label = 'Advanced';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}
