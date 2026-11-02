import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class PackagesGuideScreen extends StatefulWidget {
  const PackagesGuideScreen({super.key});

  @override
  State<PackagesGuideScreen> createState() => _PackagesGuideScreenState();
}

class _PackagesGuideScreenState extends State<PackagesGuideScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'State Management',
    'Networking',
    'Local Storage',
    'UI & Animations',
    'Utilities & Native',
  ];

  final List<PackageItem> _packages = [
    PackageItem(
      name: 'dio',
      category: 'Networking',
      version: '^5.7.0',
      tag: 'Flutter Favorite',
      badgeColor: Color(0xFF00C6FF),
      description: 'Powerful HTTP client for Dart with interceptors, global configuration, FormData, request cancellation, and file downloading.',
      whenToUse: 'Use Dio over basic http when building apps needing auth token refresh interceptors, file downloads with progress, or request retries.',
      pubAddCmd: 'flutter pub add dio',
      quickstartCode: '''
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 5),
));

// Adding auth interceptor
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers['Authorization'] = 'Bearer YOUR_TOKEN';
    return handler.next(options);
  },
));

Future<void> fetchUser() async {
  try {
    final res = await dio.get('/user/123');
    print(res.data);
  } on DioException catch (e) {
    print('Dio Error: \${e.message}');
  }
}
''',
    ),
    PackageItem(
      name: 'get',
      category: 'State Management',
      version: '^4.6.6',
      tag: 'Super Lightweight',
      badgeColor: Color(0xFF8E2DE2),
      description: 'High-performance reactive state management, micro-dependency injection, and smart route management without BuildContext.',
      whenToUse: 'Perfect for rapid development and clean code without boilerplate. Lets you navigate and show snackbars anywhere without passing context.',
      pubAddCmd: 'flutter pub add get',
      quickstartCode: '''
import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 0.obs;
  void increment() => count.value++;
}

// In your Widget:
final controller = Get.put(CounterController());

Obx(() => Text('Count: \${controller.count}'));

// Navigate without BuildContext:
Get.to(() => const DetailScreen());
Get.snackbar('Hello', 'Welcome to GetX!');
''',
    ),
    PackageItem(
      name: 'flutter_bloc',
      category: 'State Management',
      version: '^8.1.6',
      tag: 'Enterprise Standard',
      badgeColor: Color(0xFF0072FF),
      description: 'Predictable state management library that helps implement the BLoC (Business Logic Component) design pattern.',
      whenToUse: 'Ideal for large teams and enterprise apps where predictable state transitions and strict separation of UI and business logic are mandatory.',
      pubAddCmd: 'flutter pub add flutter_bloc',
      quickstartCode: '''
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}

// Bloc
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementEvent>((event, emit) => emit(state + 1));
  }
}

// In Widget:
BlocBuilder<CounterBloc, int>(
  builder: (context, count) => Text('\$count'),
);
''',
    ),
    PackageItem(
      name: 'get_storage',
      category: 'Local Storage',
      version: '^2.1.1',
      tag: 'Blazing Fast',
      badgeColor: Color(0xFF11998E),
      description: 'Fast, synchronous key-value storage written in pure Dart with GetX memory caching and zero native dependencies.',
      whenToUse: 'Use when storing user preferences, tokens, themes, or cache without the async overhead of SharedPreferences.',
      pubAddCmd: 'flutter pub add get_storage',
      quickstartCode: '''
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

final box = GetStorage();

// Write
box.write('dark_mode', true);

// Read synchronously
bool isDark = box.read('dark_mode') ?? false;

// Remove
box.remove('dark_mode');
''',
    ),
    PackageItem(
      name: 'flutter_animate',
      category: 'UI & Animations',
      version: '^4.5.2',
      tag: 'Declarative Magic',
      badgeColor: Color(0xFFFF416C),
      description: 'Performant, chainable declarative animations for any widget with zero AnimationController boilerplate.',
      whenToUse: 'The fastest way to add modern entry, fade, slide, shimmer, and bounce animations to UI without writing controllers.',
      pubAddCmd: 'flutter pub add flutter_animate',
      quickstartCode: '''
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Chain animations directly onto ANY widget:
Text('Hello World')
  .animate()
  .fadeIn(duration: 500.ms)
  .scale(delay: 200.ms)
  .shake(hz: 4);
''',
    ),
    PackageItem(
      name: 'google_fonts',
      category: 'UI & Animations',
      version: '^6.2.1',
      tag: 'Flutter Favorite',
      badgeColor: Color(0xFFFF9100),
      description: 'Access over 1,500+ Google Fonts directly in your Flutter app with dynamic caching and font pairing.',
      whenToUse: 'Instantly elevate your app typography (Poppins, Outfit, Inter, Roboto) without downloading OTF/TTF files into assets.',
      pubAddCmd: 'flutter pub add google_fonts',
      quickstartCode: '''
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text(
  'Typography Elevated',
  style: GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
);
''',
    ),
    PackageItem(
      name: 'share_plus',
      category: 'Utilities & Native',
      version: '^10.0.0',
      tag: 'Community Favorite',
      badgeColor: Color(0xFF00C6FF),
      description: 'Flutter plugin to share text, URLs, files, and images to other social and messaging apps on Android, iOS, Web & Desktop.',
      whenToUse: 'Essential for viral social sharing loops, referral links, and exporting receipts or certificates.',
      pubAddCmd: 'flutter pub add share_plus',
      quickstartCode: '''
import 'package:share_plus/share_plus.dart';

// Share text and links
Share.share('Check out Learn Flutter: https://play.google.com/store/apps');

// Share images/files
Share.shareXFiles([XFile('/path/to/image.png')], text: 'My Achievement!');
''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreen('PackagesGuideScreen');
  }

  void _showCodeModal(PackageItem pkg, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: pkg.badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.inventory_2_rounded, color: pkg.badgeColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pkg.name,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Quickstart Example',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0072FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: pkg.quickstartCode));
                      Get.snackbar(
                        'Copied! 📋',
                        '${pkg.name} example copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SyntaxView(
                    code: pkg.quickstartCode,
                    syntax: Syntax.DART,
                    syntaxTheme: isDark ? SyntaxTheme.dracula() : SyntaxTheme.standard(),
                    fontSize: 12.0,
                    withZoom: true,
                    withLinesCount: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _selectedCategory == 'All'
        ? _packages
        : _packages.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Top Flutter Packages',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Category Filters ──
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0072FF),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Package List ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final pkg = filtered[index];
                return _buildPackageCard(pkg, isDark);
              },
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

  Widget _buildPackageCard(PackageItem pkg, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    pkg.name,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pkg.version,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: pkg.badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pkg.tag,
                  style: GoogleFonts.outfit(
                    color: pkg.badgeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            pkg.description,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),

          // Pro-tip: When to use
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade200,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pkg.whenToUse,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Actions: Copy CLI command + View Code
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: pkg.pubAddCmd));
                    Get.snackbar(
                      'Copied! 📋',
                      'Run "${pkg.pubAddCmd}" in terminal',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF0072FF),
                      colorText: Colors.white,
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black38 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.terminal_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            pkg.pubAddCmd,
                            style: GoogleFonts.sourceCodePro(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.copy_rounded, size: 13, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0072FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.code_rounded, size: 15),
                label: const Text('Example', style: TextStyle(fontSize: 12)),
                onPressed: () => _showCodeModal(pkg, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PackageItem {
  final String name;
  final String category;
  final String version;
  final String tag;
  final Color badgeColor;
  final String description;
  final String whenToUse;
  final String pubAddCmd;
  final String quickstartCode;

  PackageItem({
    required this.name,
    required this.category,
    required this.version,
    required this.tag,
    required this.badgeColor,
    required this.description,
    required this.whenToUse,
    required this.pubAddCmd,
    required this.quickstartCode,
  });
}

