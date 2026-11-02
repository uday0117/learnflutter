import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../services/deep_link_service.dart';
import '../services/share_card_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'dart_cheatsheet_screen.dart';
import 'interview_screen.dart';
import 'projects_list_screen.dart';
import 'quiz_screen.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  static const String _storageKey = 'roadmap_completed_items';
  final _box = GetStorage();
  late Set<String> _completedItems;

  final List<RoadmapStage> _stages = [
    RoadmapStage(
      id: 'phase_1',
      number: '01',
      title: 'Dart Foundations',
      subtitle: 'The essential backbone of Flutter development',
      badge: 'Core Language',
      gradient: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
      icon: Icons.code_rounded,
      items: [
        RoadmapItem(
          id: 'dart_vars',
          title: 'Variables, Types & Null Safety',
          desc: 'var, final, const, late, and sound null safety operators (? and !).',
          actionLabel: 'Dart Cheatsheet',
          targetScreen: const DartCheatsheetScreen(),
        ),
        RoadmapItem(
          id: 'dart_oop',
          title: 'OOP, Classes & Mixins',
          desc: 'Constructors, inheritance, abstract classes, interfaces, and mixin reuse.',
          actionLabel: 'Dart Cheatsheet',
          targetScreen: const DartCheatsheetScreen(),
        ),
        RoadmapItem(
          id: 'dart_collections',
          title: 'Collections & Functional Operators',
          desc: 'Lists, Sets, Maps, .map(), .where(), fold, and spread operators (...).',
          actionLabel: 'Dart Cheatsheet',
          targetScreen: const DartCheatsheetScreen(),
        ),
        RoadmapItem(
          id: 'dart_async',
          title: 'Asynchronous Programming',
          desc: 'Futures, async/await, Streams, StreamBuilders, and error handling.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
      ],
    ),
    RoadmapStage(
      id: 'phase_2',
      number: '02',
      title: 'Flutter UI & Layout Mastery',
      subtitle: 'Compose pixel-perfect, responsive cross-platform apps',
      badge: 'UI & UX',
      gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
      icon: Icons.layers_rounded,
      items: [
        RoadmapItem(
          id: 'flutter_lifecycle',
          title: 'Widget Lifecycle & Stateless vs Stateful',
          desc: 'initState, didUpdateWidget, dispose, and element trees.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
        RoadmapItem(
          id: 'flutter_layouts',
          title: 'Layout Essentials (Row, Column, Stack, Flex)',
          desc: 'CrossAxisAlignment, Expanded, Flexible, Stack & Positioned.',
          actionLabel: 'Explore Widgets',
        ),
        RoadmapItem(
          id: 'flutter_lists',
          title: 'Scrollable Views & Slivers',
          desc: 'ListView.builder, GridView, CustomScrollView, and SliverAppBar.',
          actionLabel: 'Explore Widgets',
        ),
        RoadmapItem(
          id: 'flutter_theming',
          title: 'Themes, Styling & Adaptive Fonts',
          desc: 'ThemeData, Material 3, Dark/Light palettes, and Google Fonts.',
          actionLabel: 'Cheatsheet',
          targetScreen: const DartCheatsheetScreen(),
        ),
      ],
    ),
    RoadmapStage(
      id: 'phase_3',
      number: '03',
      title: 'State Management',
      subtitle: 'Master scalable state for small to enterprise apps',
      badge: 'Architecture',
      gradient: const [Color(0xFFFF8008), Color(0xFFFFC837)],
      icon: Icons.sync_alt_rounded,
      items: [
        RoadmapItem(
          id: 'state_getx',
          title: 'GetX Reactive State & Dependency Injection',
          desc: 'Rx variables (.obs), Obx(), Get.put(), Get.find(), and GetxController.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
        RoadmapItem(
          id: 'state_provider',
          title: 'Provider & ChangeNotifier',
          desc: 'Consumer, Provider.of(context), and separation of business logic.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
        RoadmapItem(
          id: 'state_bloc',
          title: 'BLoC (Business Logic Component)',
          desc: 'Events, States, Streams, BlocBuilder, and predictable state transitions.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
      ],
    ),
    RoadmapStage(
      id: 'phase_4',
      number: '04',
      title: 'APIs, Networking & Storage',
      subtitle: 'Connect with backends and cache data offline',
      badge: 'Data Layer',
      gradient: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      icon: Icons.cloud_done_rounded,
      items: [
        RoadmapItem(
          id: 'net_rest',
          title: 'REST APIs & HTTP / Dio',
          desc: 'GET, POST, headers, interceptors, timeouts, and JSON decoding.',
          actionLabel: 'App Projects',
          targetScreen: const ProjectsListScreen(),
        ),
        RoadmapItem(
          id: 'net_storage',
          title: 'Local Storage & Persistence',
          desc: 'GetStorage, SharedPreferences, Hive, and SQLite local caches.',
          actionLabel: 'App Projects',
          targetScreen: const ProjectsListScreen(),
        ),
        RoadmapItem(
          id: 'net_firebase',
          title: 'Firebase Suite Integration',
          desc: 'Firebase Auth, Firestore, Push Notifications, Crashlytics & Analytics.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
      ],
    ),
    RoadmapStage(
      id: 'phase_5',
      number: '05',
      title: 'Animations & Custom Graphics',
      subtitle: 'Delight users with 60/120fps fluid motion',
      badge: 'Advanced Polish',
      gradient: const [Color(0xFFFF416C), Color(0xFFFF4B2B)],
      icon: Icons.animation_rounded,
      items: [
        RoadmapItem(
          id: 'anim_implicit',
          title: 'Implicit Animations',
          desc: 'AnimatedContainer, AnimatedOpacity, AnimatedCrossFade with ease curves.',
          actionLabel: 'Explore Widgets',
        ),
        RoadmapItem(
          id: 'anim_explicit',
          title: 'Explicit Animations & TickerProvider',
          desc: 'AnimationController, Tween, CurvedAnimation, and AnimatedBuilder.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
        RoadmapItem(
          id: 'anim_custom_paint',
          title: 'CustomPaint & Canvas Drawing',
          desc: 'Draw custom geometric paths, charts, waves, and particle effects.',
          actionLabel: 'App Projects',
          targetScreen: const ProjectsListScreen(),
        ),
      ],
    ),
    RoadmapStage(
      id: 'phase_6',
      number: '06',
      title: 'Testing, CI/CD & Production Publishing',
      subtitle: 'Ship production-ready apps to Play Store & App Store',
      badge: 'Production Ready',
      gradient: const [Color(0xFF0F2027), Color(0xFF2C5364)],
      icon: Icons.rocket_launch_rounded,
      items: [
        RoadmapItem(
          id: 'prod_clean_arch',
          title: 'Clean Architecture & Repositories',
          desc: 'Domain, Data, and Presentation separation with testable code.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
        RoadmapItem(
          id: 'prod_testing',
          title: 'Unit, Widget & Integration Testing',
          desc: 'testWidgets, Mockito, Golden tests, and test coverage.',
          actionLabel: 'Take Quiz',
          targetScreen: const QuizScreen(),
        ),
        RoadmapItem(
          id: 'prod_deploy',
          title: 'Release Builds, Signing & Store Deployment',
          desc: 'Keystores, Android App Bundles (AAB), ProGuard, and App Store review.',
          actionLabel: 'Interview Q&A',
          targetScreen: const InterviewScreen(),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    final saved = _box.read<List>(_storageKey);
    _completedItems = saved != null ? Set<String>.from(saved) : <String>{};
    AnalyticsService().logScreen('RoadmapScreen');
  }

  void _toggleItem(String id) {
    setState(() {
      if (_completedItems.contains(id)) {
        _completedItems.remove(id);
      } else {
        _completedItems.add(id);
      }
      _box.write(_storageKey, _completedItems.toList());
    });
  }

  int get _totalItems =>
      _stages.fold(0, (acc, stage) => acc + stage.items.length);

  double get _progressPercent =>
      _totalItems == 0 ? 0.0 : (_completedItems.length / _totalItems);

  String get _rankTitle {
    final pct = _progressPercent;
    if (pct >= 0.9) return 'Flutter Architect 🏆';
    if (pct >= 0.7) return 'Senior Developer ⚡';
    if (pct >= 0.45) return 'Fullstack Flutter Craftsman 🚀';
    if (pct >= 0.2) return 'Active Apprentice 🌱';
    return 'Aspiring Flutter Dev 🎯';
  }

  void _shareProgress() {
    final pct = (_progressPercent * 100).round();
    final text =
        '🚀 I am $pct% through the 2025/2026 Flutter Developer Roadmap on Learn Flutter!\n'
        'Current Rank: $_rankTitle\n\n'
        'Track your career path: ${DeepLinkService.playStoreUrl}';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = Container(
      width: 400,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00C6FF), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.rocket_launch_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter Developer Roadmap',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Verified Learning Track',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _rankTitle,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00C6FF),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progressPercent,
              minHeight: 12,
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00C6FF)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_completedItems.length} of $_totalItems topics mastered ($pct%)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF00C6FF).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download_rounded,
                    size: 16, color: Color(0xFF0072FF)),
                const SizedBox(width: 6),
                Text(
                  'Learn Flutter App • Google Play',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0072FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    ShareCardService().shareCustomWidget(
      card: card,
      text: text,
      filePrefix: 'flutter_roadmap_progress',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pctInt = (_progressPercent * 100).round();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Flutter Roadmap',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Share Progress',
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareProgress,
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // ── Hero Progress Banner ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3C72).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_rounded,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'ROADMAP 2025/2026',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$pctInt%',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _rankTitle,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_completedItems.length} of $_totalItems competencies checked off',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progressPercent,
                          minHeight: 10,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF00E676)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Roadmap Stages ──
                ..._stages.map((stage) => _buildStageCard(stage, isDark)),
              ],
            ),
          ),

          // ── Anchored Banner Ad ──
          if (!AdService().isAdFree)
            const SafeArea(
              top: false,
              child: Center(child: BannerAdWidget()),
            ),
        ],
      ),
    );
  }

  Widget _buildStageCard(RoadmapStage stage, bool isDark) {
    final stageCompleted = stage.items.where((i) => _completedItems.contains(i.id)).length;
    final isStageAllDone = stageCompleted == stage.items.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isStageAllDone
              ? Colors.green.withValues(alpha: 0.5)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade200),
          width: isStageAllDone ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: stage.id == 'phase_1' || stageCompleted > 0,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: stage.gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(stage.icon, color: Colors.white, size: 22),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  stage.title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isStageAllDone)
                const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 20),
            ],
          ),
          subtitle: Text(
            '$stageCompleted / ${stage.items.length} completed',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: stage.items.map((item) {
                  final isDone = _completedItems.contains(item.id);
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.03)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDone
                            ? Colors.green.withValues(alpha: 0.3)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: isDone,
                            activeColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (_) => _toggleItem(item.id),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isDone
                                      ? (isDark
                                          ? Colors.white38
                                          : Colors.grey)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.desc,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey.shade700,
                                  height: 1.3,
                                ),
                              ),
                              if (item.actionLabel != null) ...[
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    if (item.targetScreen != null) {
                                      Get.to(
                                        () => item.targetScreen!,
                                        transition: Transition.rightToLeft,
                                      );
                                    } else {
                                      Get.back(); // Jump back to home catalog
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: stage.gradient.first
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.actionLabel!,
                                          style: GoogleFonts.outfit(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: stage.gradient.first,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 13,
                                          color: stage.gradient.first,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoadmapStage {
  final String id;
  final String number;
  final String title;
  final String subtitle;
  final String badge;
  final List<Color> gradient;
  final IconData icon;
  final List<RoadmapItem> items;

  RoadmapStage({
    required this.id,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.gradient,
    required this.icon,
    required this.items,
  });
}

class RoadmapItem {
  final String id;
  final String title;
  final String desc;
  final String? actionLabel;
  final Widget? targetScreen;

  RoadmapItem({
    required this.id,
    required this.title,
    required this.desc,
    this.actionLabel,
    this.targetScreen,
  });
}

extension ColorExtension on Color {
  static Color get black87 => const Color(0xDD000000);
}
