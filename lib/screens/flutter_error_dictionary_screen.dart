import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class FlutterErrorItem {
  final String id;
  final String title;
  final String category;
  final String frequency;
  final String rootCause;
  final String buggyCode;
  final String fixedCode;
  final String preventionTip;

  const FlutterErrorItem({
    required this.id,
    required this.title,
    required this.category,
    required this.frequency,
    required this.rootCause,
    required this.buggyCode,
    required this.fixedCode,
    required this.preventionTip,
  });
}

class FlutterErrorDictionaryScreen extends StatefulWidget {
  const FlutterErrorDictionaryScreen({super.key});

  @override
  State<FlutterErrorDictionaryScreen> createState() =>
      _FlutterErrorDictionaryScreenState();
}

class _FlutterErrorDictionaryScreenState
    extends State<FlutterErrorDictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final Set<String> _expandedIds = {};

  static const List<FlutterErrorItem> _errors = [
    FlutterErrorItem(
      id: 'renderflex_overflow',
      title: 'A RenderFlex overflowed by xxx pixels on the bottom / right',
      category: 'Layout',
      frequency: 'Very High',
      rootCause:
          'Children in a Row or Column exceeded the bounded physical pixels of the parent screen without being wrapped in a scrollable or flexible container.',
      buggyCode: '''// ❌ Buggy: Column children exceed screen height
Column(
  children: [
    HeaderWidget(),
    LongTextWidget(),
    HugeImageWidget(), // Overflows by 142 pixels!
  ],
)''',
      fixedCode: '''// ✅ Fix 1: Wrap Column in SingleChildScrollView
SingleChildScrollView(
  child: Column(
    children: [
      HeaderWidget(),
      LongTextWidget(),
      HugeImageWidget(),
    ],
  ),
)

// ✅ Fix 2: Wrap internal list in Expanded
Column(
  children: [
    HeaderWidget(),
    Expanded(child: ListView.builder(...)),
  ],
)''',
      preventionTip:
          'Always use Expanded or Flexible for dynamically sized children in a Flex, or SingleChildScrollView / ListView for lists that may exceed screen bounds.',
    ),
    FlutterErrorItem(
      id: 'vertical_viewport_unbounded',
      title: 'Vertical viewport was given unbounded height',
      category: 'Layout',
      frequency: 'Very High',
      rootCause:
          'A scrollable widget like ListView or GridView was placed inside a Column without a constrained height, causing an infinite height calculation cycle.',
      buggyCode: '''// ❌ Buggy: ListView inside Column without constraints
Column(
  children: [
    Text('Products'),
    ListView.builder(
      itemCount: 20,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item \$i')),
    ), // Crashing: Unbounded height!
  ],
)''',
      fixedCode: '''// ✅ Fix 1: Wrap ListView in Expanded
Column(
  children: [
    Text('Products'),
    Expanded(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (ctx, i) => ListTile(title: Text('Item \$i')),
      ),
    ),
  ],
)

// ✅ Fix 2: Set shrinkWrap: true & physics if bounded by parent
ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: 20,
  itemBuilder: (ctx, i) => ListTile(title: Text('Item \$i')),
)''',
      preventionTip:
          'A scrollable needs bounded height. When putting a ListView inside Column, either wrap it in Expanded or set shrinkWrap: true with NeverScrollableScrollPhysics.',
    ),
    FlutterErrorItem(
      id: 'setstate_during_build',
      title: 'setState() or markNeedsBuild() called during build',
      category: 'Lifecycle',
      frequency: 'High',
      rootCause:
          'You called setState(), modified reactive state, or showed a dialog/snackbar directly in the build() method while the widget tree was still being assembled.',
      buggyCode: '''// ❌ Buggy: Modifying state or navigating during build()
@override
Widget build(BuildContext context) {
  if (userNotLoggedIn) {
    Navigator.pushNamed(context, '/login'); // Crashing!
    setState(() => isLoading = true);       // Crashing!
  }
  return Scaffold(...);
}''',
      fixedCode: '''// ✅ Fix: Defer execution after the frame renders
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (userNotLoggedIn) {
      Navigator.pushNamed(context, '/login');
    }
  });
}''',
      preventionTip:
          'Never trigger side-effects directly inside build(). Use initState with addPostFrameCallback or user event callbacks (e.g. onPressed).',
    ),
    FlutterErrorItem(
      id: 'no_material_widget',
      title: 'No Material widget found',
      category: 'Context',
      frequency: 'High',
      rootCause:
          'A Material Design widget (such as TextField, ListTile, InkWell) requires an ancestor Material widget to paint text styles, ripples, and elevation.',
      buggyCode: '''// ❌ Buggy: TextField or InkWell without Material ancestor
Widget build(BuildContext context) {
  return Container(
    child: TextField(decoration: InputDecoration(hintText: 'Search')),
  );
}''',
      fixedCode: '''// ✅ Fix: Wrap in Scaffold or Material widget
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      child: TextField(decoration: InputDecoration(hintText: 'Search')),
    ),
  );
}

// Or specifically:
Material(
  type: MaterialType.transparency,
  child: TextField(...),
)''',
      preventionTip:
          'Always structure screen trees with Scaffold or ensure a parent Material widget exists for Material Design components.',
    ),
    FlutterErrorItem(
      id: 'late_initialization_error',
      title: 'LateInitializationError: Field has not been initialized',
      category: 'Null Safety',
      frequency: 'High',
      rootCause:
          'A variable declared with the "late" keyword was accessed before any value was assigned to it.',
      buggyCode: '''// ❌ Buggy: Accessing late variable before initialization
class ProfileController extends GetxController {
  late String authToken;

  void fetchUser() {
    print(authToken); // Crashing if called before init!
  }
}''',
      fixedCode: '''// ✅ Fix 1: Initialize in onInit or initState
@override
void onInit() {
  super.onInit();
  authToken = loadSavedToken();
}

// ✅ Fix 2: Use nullable type if it may not exist immediately
String? authToken;
if (authToken != null) { ... }''',
      preventionTip:
          'Avoid overusing "late". Prefer nullable types (String?) or default initial values unless initialization is guaranteed in initState/onInit.',
    ),
    FlutterErrorItem(
      id: 'null_check_operator',
      title: 'Null check operator used on a null value',
      category: 'Null Safety',
      frequency: 'Very High',
      rootCause:
          'The bang operator (!) was forced on a variable that was actually null at runtime.',
      buggyCode: '''// ❌ Buggy: Forcing ! on null data
String? userEmail = authService.currentUser?.email;
print('User: ' + userEmail!.toLowerCase()); // Crashing if user is null!''',
      fixedCode: '''// ✅ Fix: Use null-aware operators or null guards
String? userEmail = authService.currentUser?.email;

// Safe call with ?. and fallback ??
String safeEmail = userEmail?.toLowerCase() ?? 'no-email';

// Or explicit if guard:
if (userEmail != null) {
  print('User: ' + userEmail.toLowerCase());
}''',
      preventionTip:
          'Never use the "!" operator unless you have checked the variable immediately prior. Prefer ?? and ?.',
    ),
    FlutterErrorItem(
      id: 'hero_duplicate_tag',
      title: 'A Hero animation cannot be used with multiple widgets with same tag',
      category: 'Navigation',
      frequency: 'Medium',
      rootCause:
          'Two Hero widgets on the same route shared identical non-unique tag strings, confusing Flutter\'s transition engine.',
      buggyCode: '''// ❌ Buggy: Static hero tag in ListView
ListView.builder(
  itemCount: items.length,
  itemBuilder: (ctx, i) => Hero(
    tag: 'item_hero', // Same tag for all list items!
    child: Image.network(items[i].image),
  ),
)''',
      fixedCode: '''// ✅ Fix: Use unique identifier in tag
ListView.builder(
  itemCount: items.length,
  itemBuilder: (ctx, i) => Hero(
    tag: 'item_hero_\${items[i].id}', // Distinct per item!
    child: Image.network(items[i].image),
  ),
)''',
      preventionTip:
          'Append unique database IDs or index values to your Hero tags: tag: "avatar_\${user.id}".',
    ),
    FlutterErrorItem(
      id: 'looking_up_deactivated_widget',
      title: 'Looking up a deactivated widget\'s ancestor is unsafe',
      category: 'Lifecycle',
      frequency: 'Medium',
      rootCause:
          'A BuildContext was used after an async await gap when the widget had already been unmounted/dismissed.',
      buggyCode: '''// ❌ Buggy: context used after await without mounted check
void submitData() async {
  await apiService.save();
  Navigator.pop(context); // Crashing if user closed page while saving!
}''',
      fixedCode: '''// ✅ Fix: Check context.mounted or mounted
void submitData() async {
  await apiService.save();
  if (!mounted) return;
  Navigator.pop(context);
}''',
      preventionTip:
          'Always add "if (!mounted) return;" or "if (!context.mounted) return;" immediately following any "await" keyword.',
    ),
    FlutterErrorItem(
      id: 'missing_plugin_exception',
      title: 'MissingPluginException(No implementation found for method ...)',
      category: 'Platform',
      frequency: 'High',
      rootCause:
          'A new native Flutter package was added to pubspec.yaml, but the native host application was not rebuilt, or native pods / gradle dependencies were not linked.',
      buggyCode: '''// ❌ Error occurs at runtime when calling a plugin:
await FlutterLocalNotifications.show(...);
// MissingPluginException on iOS or Android''',
      fixedCode: '''// ✅ Fix Step-by-Step:
1. Stop the running app completely (not Hot Reload/Restart).
2. Run in terminal:
   flutter clean
   flutter pub get
3. On iOS:
   cd ios && pod install --repo-update && cd ..
4. Run fresh build:
   flutter run''',
      preventionTip:
          'Hot Reload does not inject native platform code (Kotlin/Swift). Always perform a full cold restart after adding dependencies with native code.',
    ),
    FlutterErrorItem(
      id: 'bad_state_stream_listened',
      title: 'Bad state: Stream has already been listened to',
      category: 'Async',
      frequency: 'Medium',
      rootCause:
          'A single-subscription Stream was listened to more than once (e.g. by two StreamBuilders or manual .listen calls).',
      buggyCode: '''// ❌ Buggy: Single subscription stream listened to twice
final stream = mySingleStream();
StreamBuilder(stream: stream, ...);
StreamBuilder(stream: stream, ...); // Crashing!''',
      fixedCode: '''// ✅ Fix: Convert to broadcast stream
final broadcastStream = mySingleStream().asBroadcastStream();

StreamBuilder(stream: broadcastStream, ...);
StreamBuilder(stream: broadcastStream, ...); // Safe!''',
      preventionTip:
          'Use .asBroadcastStream() if multiple UI components or listeners need to subscribe to the same stream.',
    ),
    FlutterErrorItem(
      id: 'concurrent_modification',
      title: 'Concurrent modification during iteration',
      category: 'Collections',
      frequency: 'Medium',
      rootCause:
          'A List or Set was modified (items added or removed) while looping over it using a for-in or forEach loop.',
      buggyCode: '''// ❌ Buggy: Removing item while iterating
for (var item in userList) {
  if (item.isBanned) {
    userList.remove(item); // Crashing: Concurrent modification!
  }
}''',
      fixedCode: '''// ✅ Fix 1: Use removeWhere
userList.removeWhere((item) => item.isBanned);

// ✅ Fix 2: Iterate over a shallow copy
for (var item in List.from(userList)) {
  if (item.isBanned) {
    userList.remove(item);
  }
}''',
      preventionTip:
          'Always prefer list.removeWhere(...) or iterate over a shallow copy [...list] if you need to mutate during iteration.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('FlutterErrorDictionaryScreen');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = theme.primaryColor.value;

    final categories = ['All', 'Layout', 'Lifecycle', 'Null Safety', 'Context', 'Platform', 'Async', 'Collections'];

    final query = _searchController.text.trim().toLowerCase();
    final filtered = _errors.where((err) {
      final matchesCategory = _selectedCategory == 'All' || err.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          err.title.toLowerCase().contains(query) ||
          err.rootCause.toLowerCase().contains(query) ||
          err.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.bug_report_rounded, color: Colors.redAccent, size: 22),
            const SizedBox(width: 8),
            Text(
              'Error Dictionary',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search error message or keyword...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: categories.map((cat) {
                final isSel = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSel,
                    selectedColor: primary.withValues(alpha: 0.2),
                    checkmarkColor: primary,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Error count label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} Errors & Fixes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_expandedIds.length == filtered.length) {
                        _expandedIds.clear();
                      } else {
                        _expandedIds.addAll(filtered.map((e) => e.id));
                      }
                    });
                  },
                  child: Text(
                    _expandedIds.length == filtered.length ? 'Collapse All' : 'Expand All',
                    style: TextStyle(fontSize: 12, color: primary),
                  ),
                ),
              ],
            ),
          ),

          // Errors list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'No errors found matching "$query"',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemBuilder: (ctx, i) {
                      final err = filtered[i];
                      final isExpanded = _expandedIds.contains(err.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isExpanded
                                ? primary.withValues(alpha: 0.5)
                                : (isDark ? Colors.white12 : Colors.grey.shade300),
                            width: isExpanded ? 1.5 : 1.0,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _toggleExpanded(err.id),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Category & Frequency
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        err.category,
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Frequency: ${err.frequency}',
                                        style: TextStyle(
                                          color: Colors.amber.shade700,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Error Title
                                Text(
                                  err.title,
                                  style: GoogleFonts.firaCode(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? const Color(0xFFFF8B8B) : Colors.red.shade800,
                                  ),
                                ),

                                const SizedBox(height: 6),
                                Text(
                                  err.rootCause,
                                  maxLines: isExpanded ? null : 2,
                                  overflow: isExpanded ? null : TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),

                                // Expanded Section: Buggy code, Fix code, Prevention tip
                                if (isExpanded) ...[
                                  const Divider(height: 24),

                                  // Buggy Code Block
                                  Row(
                                    children: [
                                      const Icon(Icons.close_rounded, size: 16, color: Colors.redAccent),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Buggy Code (What causes it):',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E1417),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                                    ),
                                    child: SelectableText(
                                      err.buggyCode,
                                      style: GoogleFonts.firaCode(
                                        fontSize: 12,
                                        color: const Color(0xFFFFB3BA),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Fixed Code Block
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Fixed Code (Solution):',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.copy_rounded, size: 16),
                                        tooltip: 'Copy Fix',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: err.fixedCode));
                                          Get.snackbar(
                                            'Copied!',
                                            'Fixed solution copied to clipboard',
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration: const Duration(seconds: 2),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10231B),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                                    ),
                                    child: SelectableText(
                                      err.fixedCode,
                                      style: GoogleFonts.firaCode(
                                        fontSize: 12,
                                        color: const Color(0xFFB5EAD7),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Pro Prevention Tip
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('💡 ', style: TextStyle(fontSize: 16)),
                                        Expanded(
                                          child: Text(
                                            err.preventionTip,
                                            style: TextStyle(
                                              fontSize: 12,
                                              height: 1.4,
                                              fontWeight: FontWeight.w500,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
}
