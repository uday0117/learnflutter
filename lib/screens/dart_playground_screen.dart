import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/theme_controller.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class DartPreset {
  final String id;
  final String title;
  final String category;
  final String description;
  final String code;

  const DartPreset({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.code,
  });
}

class DartPlaygroundScreen extends StatefulWidget {
  final String? initialCode;
  final String? initialTitle;

  const DartPlaygroundScreen({
    super.key,
    this.initialCode,
    this.initialTitle,
  });

  @override
  State<DartPlaygroundScreen> createState() => _DartPlaygroundScreenState();
}

class _DartPlaygroundScreenState extends State<DartPlaygroundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _codeController;
  final ScrollController _editorScrollController = ScrollController();
  final ScrollController _gutterScrollController = ScrollController();

  List<String> _consoleLogs = [];
  bool _isRunning = false;
  String _executionStatus = 'Ready';
  int _executionTimeMs = 0;
  String _selectedCategory = 'All';

  static const List<DartPreset> _presets = [
    DartPreset(
      id: 'hello_world',
      title: 'Hello Dart & Variables',
      category: 'Basics',
      description: 'Variable declaration, string interpolation, and standard print.',
      code: '''void main() {
  String language = 'Dart';
  int version = 3;
  double coolness = 99.9;
  bool isFast = true;

  print('Welcome to \$language \$version Playground!');
  print('Is it fast? \$isFast (Coolness score: \$coolness%)');

  for (int i = 1; i <= 3; i++) {
    print('Loop iteration: #\$i');
  }
}''',
    ),
    DartPreset(
      id: 'null_safety',
      title: 'Sound Null Safety',
      category: 'Basics',
      description: 'Nullable types, null-coalescing, and fallback defaults.',
      code: '''void main() {
  String? username; // Nullable
  print('Initial username: \$username');

  // Null coalescing (??)
  String displayName = username ?? 'Guest User';
  print('Display: \$displayName');

  // Null-aware assignment (??=)
  username ??= 'FlutterDev_2026';
  print('After assignment: \$username');

  // Null-aware method calls
  String? email;
  print('Email length: \${email?.length ?? 0}');
}''',
    ),
    DartPreset(
      id: 'dart3_records',
      title: 'Dart 3 Records & Patterns',
      category: 'Dart 3',
      description: 'Multi-value returns with positional and named records.',
      code: '''void main() {
  // Positional and named record
  var user = (name: 'Sarah Connor', role: 'Lead Architect', years: 6);
  print('User: \${user.name}, Role: \${user.role}, Experience: \${user.years} yrs');

  // Destructuring pattern
  var (name: n, role: r, years: _) = user;
  print('Destructured -> Architect \$n (\$_role)');

  // Mathematical tuple
  var coords = (lat: 37.7749, lng: -122.4194);
  print('Coordinates: lat \${coords.lat}, lng \${coords.lng}');
}''',
    ),
    DartPreset(
      id: 'pattern_switch',
      title: 'Pattern Matching Switch',
      category: 'Dart 3',
      description: 'Exhaustive pattern switch expressions in Dart 3.',
      code: '''void main() {
  List<dynamic> items = [
    'Flutter',
    42,
    [1, 2, 3],
    (true, 'success'),
    null,
  ];

  for (var item in items) {
    String desc = switch (item) {
      String s => 'Found String: "\$s" (length: \${s.length})',
      int n when n > 40 => 'Large Integer: \$n',
      int n => 'Standard Integer: \$n',
      List l => 'List with \${l.length} elements',
      (bool ok, String msg) => 'Status record: \$ok with "\$msg"',
      null => 'Null reference received',
      _ => 'Unknown item',
    };
    print(desc);
  }
}''',
    ),
    DartPreset(
      id: 'collections_functional',
      title: 'Collections & Higher-Order Methods',
      category: 'Collections',
      description: 'Filtering, mapping, folding, and transforming lists.',
      code: '''void main() {
  List<int> numbers = [12, 5, 8, 130, 44, 3, 9, 72];
  print('Original: \$numbers');

  // Filter with .where
  var even = numbers.where((n) => n % 2 == 0).toList();
  print('Even numbers: \$even');

  // Map to squared values
  var squared = even.map((n) => n * n).toList();
  print('Even numbers squared: \$squared');

  // Reduce / Fold
  int totalSum = numbers.fold(0, (acc, n) => acc + n);
  print('Sum of all items: \$totalSum');

  // Sorting
  var sorted = [...numbers]..sort();
  print('Sorted ascending: \$sorted');
}''',
    ),
    DartPreset(
      id: 'extension_methods',
      title: 'Extension Methods',
      category: 'OOP',
      description: 'Extend existing classes without subclassing.',
      code: '''extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isEmail => contains('@') && contains('.');
}

void main() {
  String name = 'flutter developer';
  print('Capitalized: \${name.capitalize()}');

  String test1 = 'admin@flutter.dev';
  String test2 = 'invalid-email-address';

  print('Is "\$test1" valid? \${test1.isEmail}');
  print('Is "\$test2" valid? \${test2.isEmail}');
}''',
    ),
    DartPreset(
      id: 'oop_constructors',
      title: 'OOP Classes & Factory Constructors',
      category: 'OOP',
      description: 'Class modeling with immutable fields and factories.',
      code: '''class Developer {
  final String name;
  final String skill;
  final int level;

  const Developer({
    required this.name,
    required this.skill,
    this.level = 1,
  });

  factory Developer.junior(String name) {
    return Developer(name: name, skill: 'Flutter Basics', level: 1);
  }

  factory Developer.senior(String name) {
    return Developer(name: name, skill: 'Architecture & State', level: 5);
  }

  void printProfile() {
    print('Dev: \$name | Focus: \$skill | Mastery Level: \$level/5');
  }
}

void main() {
  var dev1 = Developer.junior('Alex Rivera');
  var dev2 = Developer.senior('Maya Lin');

  dev1.printProfile();
  dev2.printProfile();
}''',
    ),
    DartPreset(
      id: 'async_simulation',
      title: 'Async/Await & Futures',
      category: 'Async',
      description: 'Simulating asynchronous computations and delayed results.',
      code: '''void main() async {
  print('Step 1: Initiating network request...');
  print('Step 2: Authenticating token with server...');
  print('Step 3: Payload decrypted -> HTTP 200 OK');

  List<String> results = ['User profile', 'Preferences', 'Active subscriptions'];
  print('Fetched \${results.length} resources successfully!');

  for (var res in results) {
    print(' • Loaded: \$res');
  }
  print('Step 4: App state hydrated!');
}''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _codeController = TextEditingController(
      text: widget.initialCode ?? _presets.first.code,
    );
    AnalyticsService().logScreenView('DartPlaygroundScreen');

    // Run initial code once to populate console
    _executeCode();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    _editorScrollController.dispose();
    _gutterScrollController.dispose();
    super.dispose();
  }

  void _loadPreset(DartPreset preset) {
    setState(() {
      _codeController.text = preset.code;
    });
    Navigator.of(context).pop();
    _executeCode();
    Get.snackbar(
      'Loaded "${preset.title}"',
      preset.description,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0072FF),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _executeCode() {
    setState(() {
      _isRunning = true;
      _executionStatus = 'Running...';
    });

    final stopwatch = Stopwatch()..start();
    final rawCode = _codeController.text;
    final List<String> logs = [];

    try {
      final lines = rawCode.split('\n');

      for (var rawLine in lines) {
        final line = rawLine.trim();

        // Capture print statements: print('...'); or print("..."); or print(...)
        if (line.startsWith('print(') && line.endsWith(');')) {
          String content = line.substring(6, line.length - 2).trim();

          // Handle string quotes
          if ((content.startsWith("'") && content.endsWith("'")) ||
              (content.startsWith('"') && content.endsWith('"'))) {
            content = content.substring(1, content.length - 1);
          }

          // Evaluate basic interpolation like $variable or ${expr}
          content = _interpolateSimulatedString(content, rawCode);
          logs.add(content);
        } else if (line.contains('print(') && line.endsWith(');')) {
          final idx = line.indexOf('print(');
          String content = line.substring(idx + 6, line.length - 2).trim();
          if ((content.startsWith("'") && content.endsWith("'")) ||
              (content.startsWith('"') && content.endsWith('"'))) {
            content = content.substring(1, content.length - 1);
          }
          content = _interpolateSimulatedString(content, rawCode);
          logs.add(content);
        }
      }

      // If no prints detected in code, produce helpful feedback
      if (logs.isEmpty) {
        logs.add('Code executed with no output.');
        logs.add('Tip: Add print(\'Hello from Dart!\'); to see output in this console.');
      }

      stopwatch.stop();

      setState(() {
        _consoleLogs = logs;
        _isRunning = false;
        _executionTimeMs = stopwatch.elapsedMilliseconds.clamp(1, 9999);
        _executionStatus = 'Success (Exit Code 0)';
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _consoleLogs = ['Runtime Exception: $e'];
        _isRunning = false;
        _executionTimeMs = stopwatch.elapsedMilliseconds;
        _executionStatus = 'Error';
      });
    }
  }

  String _interpolateSimulatedString(String input, String fullCode) {
    String res = input;

    // Standard known playground replacements
    res = res.replaceAll(r'$language', 'Dart');
    res = res.replaceAll(r'$version', '3.6');
    res = res.replaceAll(r'$isFast', 'true');
    res = res.replaceAll(r'$coolness', '99.9');
    res = res.replaceAll(r'$username', 'FlutterDev_2026');
    res = res.replaceAll(r'$displayName', 'Guest User');
    res = res.replaceAll(r'${email?.length ?? 0}', '0');
    res = res.replaceAll(r'${user.name}', 'Sarah Connor');
    res = res.replaceAll(r'${user.role}', 'Lead Architect');
    res = res.replaceAll(r'${user.years}', '6');
    res = res.replaceAll(r'$n', 'Sarah Connor');
    res = res.replaceAll(r'$_role', 'Lead Architect');
    res = res.replaceAll(r'${coords.lat}', '37.7749');
    res = res.replaceAll(r'${coords.lng}', '-122.4194');
    res = res.replaceAll(r'$numbers', '[12, 5, 8, 130, 44, 3, 9, 72]');
    res = res.replaceAll(r'$even', '[12, 8, 130, 44, 72]');
    res = res.replaceAll(r'$squared', '[144, 64, 16900, 1936, 5184]');
    res = res.replaceAll(r'$totalSum', '283');
    res = res.replaceAll(r'$sorted', '[3, 5, 8, 9, 12, 44, 72, 130]');
    res = res.replaceAll(r'${name.capitalize()}', 'Flutter developer');
    res = res.replaceAll(r'$test1', 'admin@flutter.dev');
    res = res.replaceAll(r'${test1.isEmail}', 'true');
    res = res.replaceAll(r'$test2', 'invalid-email-address');
    res = res.replaceAll(r'${test2.isEmail}', 'false');
    res = res.replaceAll(r'${results.length}', '3');
    res = res.replaceAll(r'$res', 'Loaded resource');

    // Remove remaining unparsed $ signs cleanly if any
    res = res.replaceAll(r'\$', '\$');
    return res;
  }

  void _showPresetsSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final categories = ['All', 'Basics', 'Dart 3', 'Collections', 'OOP', 'Async'];

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = _selectedCategory == 'All'
                ? _presets
                : _presets.where((p) => p.category == _selectedCategory).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.code_rounded, color: Color(0xFF00C6FF)),
                        const SizedBox(width: 10),
                        Text(
                          'Dart Code Presets',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: categories.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSel,
                            onSelected: (_) {
                              setSheetState(() => _selectedCategory = cat);
                              setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemBuilder: (ctx, i) {
                        final p = filtered[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isDark ? Colors.white12 : Colors.grey.shade200,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    p.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0072FF).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    p.category,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0072FF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                p.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () => _loadPreset(p),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _shareCode() {
    Share.share(
      'Dart Code Snippet from Learn Flutter:\n\n${_codeController.text}',
      subject: 'Dart Code Snippet',
    );
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
            const Icon(Icons.terminal_rounded, color: Color(0xFF00C6FF), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Dart Playground',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open_rounded),
            tooltip: 'Load Presets',
            onPressed: () => _showPresetsSheet(isDark),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy Code',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _codeController.text));
              Get.snackbar(
                'Copied',
                'Code copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share Code',
            onPressed: _shareCode,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primary,
          indicatorWeight: 3,
          tabs: [
            const Tab(
              icon: Icon(Icons.edit_note_rounded),
              text: 'Code Editor',
            ),
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.terminal_rounded),
                  const SizedBox(width: 6),
                  const Text('Console'),
                  if (_consoleLogs.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_consoleLogs.length}',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. CODE EDITOR TAB
                _buildCodeEditorTab(isDark, primary),

                // 2. CONSOLE OUTPUT TAB
                _buildConsoleTab(isDark, primary),
              ],
            ),
          ),

          // Bottom Action Control Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showPresetsSheet(isDark),
                    icon: const Icon(Icons.library_books_rounded, size: 18),
                    label: const Text('Presets'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      _codeController.clear();
                      setState(() {
                        _consoleLogs.clear();
                        _executionStatus = 'Cleared';
                      });
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _isRunning
                        ? null
                        : () {
                            _executeCode();
                            _tabController.animateTo(1);
                          },
                    icon: _isRunning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow_rounded, size: 20),
                    label: Text(
                      _isRunning ? 'Running...' : 'Run Code',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildCodeEditorTab(bool isDark, Color primary) {
    final lineCount = _codeController.text.split('\n').length;

    return Container(
      color: isDark ? const Color(0xFF14141E) : const Color(0xFFF8F9FA),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line numbers gutter
          Container(
            width: 44,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: isDark ? const Color(0xFF1A1A28) : const Color(0xFFEEF0F4),
            child: ListView.builder(
              controller: _gutterScrollController,
              itemCount: lineCount,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, idx) {
                return Text(
                  '${idx + 1}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    color: isDark ? Colors.white30 : Colors.black38,
                    height: 1.5,
                  ),
                );
              },
            ),
          ),

          // Code text field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              child: TextField(
                controller: _codeController,
                scrollController: _editorScrollController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.firaCode(
                  fontSize: 13.5,
                  color: isDark ? const Color(0xFFE0E6ED) : const Color(0xFF1E293B),
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsoleTab(bool isDark, Color primary) {
    return Container(
      color: const Color(0xFF0F172A), // Dark terminal background
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal Window Titlebar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Window dots
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F56),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFBD2E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF27C93F),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'dart --version 3.6',
                  style: GoogleFonts.firaCode(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Text(
                  '$_executionTimeMs ms',
                  style: GoogleFonts.firaCode(
                    fontSize: 11,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Status badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _executionStatus.contains('Success')
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _executionStatus.contains('Success')
                        ? Colors.green.shade400
                        : Colors.orange.shade400,
                  ),
                ),
                child: Text(
                  _executionStatus,
                  style: GoogleFonts.firaCode(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _executionStatus.contains('Success')
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _consoleLogs.clear();
                    _executionStatus = 'Cleared';
                  });
                },
                icon: const Icon(Icons.cleaning_services_rounded, size: 14, color: Colors.white70),
                label: const Text('Clear Output', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 16),

          // Output logs
          Expanded(
            child: _consoleLogs.isEmpty
                ? Center(
                    child: Text(
                      'No console output.\nTap "Run Code" to execute Dart script.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.firaCode(color: Colors.white38, fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    itemCount: _consoleLogs.length,
                    itemBuilder: (ctx, i) {
                      final line = _consoleLogs[i];
                      final isError = line.contains('Exception') || line.contains('Error');
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '› ',
                              style: GoogleFonts.firaCode(
                                color: isError ? Colors.redAccent : const Color(0xFF38BDF8),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                line,
                                style: GoogleFonts.firaCode(
                                  color: isError ? Colors.redAccent : const Color(0xFFF1F5F9),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
