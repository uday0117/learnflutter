import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/theme_controller.dart';
import '../data/dart_cheatsheet_data.dart';

class DartCheatsheetScreen extends StatelessWidget {
  const DartCheatsheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = DartCheatsheetData.getSections();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ThemeController theme = Get.find<ThemeController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'cheatsheet_title'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.primaryColor.value,
                        theme.primaryColor.value.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.developer_mode_rounded,
                        color: Colors.white38, size: 60),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final section = sections[index];
                  return _SectionExpansion(
                    section: section,
                    isDark: isDark,
                    theme: theme,
                  );
                },
                childCount: sections.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionExpansion extends StatefulWidget {
  final CheatsheetSection section;
  final bool isDark;
  final ThemeController theme;

  const _SectionExpansion({
    required this.section,
    required this.isDark,
    required this.theme,
  });

  @override
  State<_SectionExpansion> createState() => _SectionExpansionState();
}

class _SectionExpansionState extends State<_SectionExpansion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(widget.section.emoji,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.section.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '${widget.section.items.length} snippets',
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Column(
              children: [
                const Divider(height: 1),
                ...widget.section.items.map((item) => _CheatItem(
                      item: item,
                      isDark: widget.isDark,
                      theme: widget.theme,
                    )),
              ],
            ),
        ],
      ),
    );
  }
}

class _CheatItem extends StatefulWidget {
  final CheatsheetItem item;
  final bool isDark;
  final ThemeController theme;

  const _CheatItem({
    required this.item,
    required this.isDark,
    required this.theme,
  });

  @override
  State<_CheatItem> createState() => _CheatItemState();
}

class _CheatItemState extends State<_CheatItem> {
  bool _codeExpanded = false;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.item.code));
    Get.snackbar(
      'copied'.tr,
      'code_copied'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _share() {
    final text = '📱 Dart Cheatsheet — ${widget.item.title}\n\n'
        '${widget.item.description}\n\n'
        '```dart\n${widget.item.code}\n```'
        '\n\n— Learn Flutter App';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.item.description,
                      style: TextStyle(
                          fontSize: 12,
                          color: widget.isDark
                              ? Colors.white60
                              : Colors.grey.shade600,
                          height: 1.4),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _share,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.share_rounded,
                          size: 16,
                          color: widget.isDark
                              ? Colors.white54
                              : Colors.grey.shade500),
                    ),
                  ),
                  InkWell(
                    onTap: _copy,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.copy_rounded,
                          size: 16,
                          color: widget.isDark
                              ? Colors.white54
                              : Colors.grey.shade500),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        setState(() => _codeExpanded = !_codeExpanded),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        _codeExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 18,
                        color: widget.isDark
                            ? Colors.white54
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Code block — always show first 4 lines, expand for rest
          GestureDetector(
            onTap: () => setState(() => _codeExpanded = !_codeExpanded),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? const Color(0xFF12121E)
                    : const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _codeExpanded
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        widget.item.code,
                        style: GoogleFonts.jetBrainsMono(
                            color: Colors.white, fontSize: 11.5, height: 1.5),
                      ),
                    )
                  : ClipRect(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 72),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.item.code,
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.jetBrainsMono(
                                color: Colors.white,
                                fontSize: 11.5,
                                height: 1.5),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
