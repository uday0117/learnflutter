import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/project_model.dart';
import '../services/ad_service.dart';

class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  bool _isUnlocked() {
    if (AdService().isAdFree) return true;
    final expiry = GetStorage().read<int>('project_unlocked_${widget.project.id}');
    if (expiry == null) return false;
    return DateTime.now().millisecondsSinceEpoch < expiry;
  }

  String _getRemainingTime() {
    if (AdService().isAdFree) return 'Unlocked (Ad-free Active)';
    final expiry = GetStorage().read<int>('project_unlocked_${widget.project.id}');
    if (expiry == null) return '';
    final remaining = DateTime.fromMillisecondsSinceEpoch(expiry).difference(DateTime.now());
    if (remaining.isNegative) return '';
    if (remaining.inHours > 0) {
      return 'Unlocked: ${remaining.inHours}h ${remaining.inMinutes % 60}m left';
    }
    return 'Unlocked: ${remaining.inMinutes}m left';
  }

  void _watchAdToUnlock() {
    AdService().showRewardedAd(
      onRewarded: () {
        final expiry = DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch;
        GetStorage().write('project_unlocked_${widget.project.id}', expiry);
        setState(() {});
        Get.snackbar(
          'Unlocked',
          'Source code unlocked for 24 hours!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onNotReady: () {
        Get.snackbar(
          'Ad Not Ready',
          'Ad is loading. Please try again in a few seconds.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorWeight: 3.5,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Features'),
            Tab(text: 'Structure'),
            Tab(text: 'Source Code'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(isDark),
          _buildFeaturesTab(isDark),
          _buildStructureTab(isDark),
          _buildSourceCodeTab(isDark),
        ],
      ),
    );
  }

  // ── OVERVIEW TAB ──
  Widget _buildOverviewTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDifficultyBadge(widget.project.difficulty),
              if (_isUnlocked())
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_open_rounded, color: Colors.green, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        _getRemainingTime(),
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'About Project',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.project.description,
            style: const TextStyle(height: 1.5, fontSize: 15),
          ),
          const SizedBox(height: 30),
          Text(
            'Dependencies Required',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...widget.project.libraries.map((lib) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.code_rounded, color: Colors.blue, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      lib,
                      style: GoogleFonts.firaCode(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── FEATURES TAB ──
  Widget _buildFeaturesTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.project.features.length,
      itemBuilder: (context, index) {
        final feature = widget.project.features[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(fontSize: 14.5, height: 1.4, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── STRUCTURE TAB ──
  Widget _buildStructureTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Folder Structure',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: Text(
              widget.project.folderStructure,
              style: GoogleFonts.firaCode(fontSize: 14, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  // ── SOURCE CODE TAB ──
  Widget _buildSourceCodeTab(bool isDark) {
    final unlocked = _isUnlocked();

    if (!unlocked) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_rounded,
                  size: 64,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  'Premium Source Code Locked',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This clean-architecture source code is locked. Watch a short video ad to unlock access to all code files for this project for 24 hours!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _watchAdToUnlock,
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  label: const Text('Watch Ad to Unlock'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'main.dart',
                style: GoogleFonts.firaCode(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded),
                tooltip: 'Copy Source Code',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.project.sourceCode));
                  Get.snackbar(
                    'Success',
                    'Code copied to clipboard!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SyntaxView(
                  code: widget.project.sourceCode,
                  syntax: Syntax.DART,
                  syntaxTheme: isDark ? SyntaxTheme.vscodeDark() : SyntaxTheme.standard(),
                  withZoom: true,
                  withLinesCount: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    switch (difficulty) {
      case 'Beginner':
        color = Colors.green;
        break;
      case 'Intermediate':
        color = Colors.orange;
        break;
      case 'Advanced':
      default:
        color = Colors.red;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        difficulty,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}
