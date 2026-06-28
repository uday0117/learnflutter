import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/favorites_controller.dart';
import '../controllers/progress_controller.dart';
import '../models/widget_model.dart';
import '../services/ad_service.dart';
import '../widgets/banner_ad_widget.dart';

class WidgetDetailScreen extends StatefulWidget {
  final WidgetModel widgetModel;

  const WidgetDetailScreen({super.key, required this.widgetModel});

  @override
  State<WidgetDetailScreen> createState() => _WidgetDetailScreenState();
}

class _WidgetDetailScreenState extends State<WidgetDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  final ProgressController progressController =
      Get.find<ProgressController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Track progress & trigger interstitial
    Future.delayed(const Duration(milliseconds: 300), () {
      progressController.markAsViewed(widget.widgetModel.id);
      AdService().incrementDetailScreenCounter();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'copied'.tr,
      'code_copied'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _shareCode(String code) {
    final text = '📱 Flutter Widget — ${widget.widgetModel.name}\n\n'
        '${widget.widgetModel.description}\n\n'
        '```dart\n$code\n```'
        '\n\n— Learn Flutter App';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.widgetModel.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () =>
                _shareCode(widget.widgetModel.syntax),
            tooltip: 'share'.tr,
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                favoritesController.isFavorite(widget.widgetModel.id)
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: favoritesController.isFavorite(widget.widgetModel.id)
                    ? Colors.red
                    : Colors.white,
              ),
              onPressed: () =>
                  favoritesController.toggleFavorite(widget.widgetModel.id),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'description'.tr,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(widget.widgetModel.description,
                    style: const TextStyle(height: 1.5)),
              ],
            ),
          ),

          // Live Preview
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'live_preview'.tr,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E1E2E)
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child:
                      Center(child: _buildPreview(widget.widgetModel.id)),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'syntax'.tr),
              Tab(text: 'properties'.tr),
              Tab(text: 'usage'.tr),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Syntax tab — flutter_syntax_view
                _buildSyntaxTab(widget.widgetModel.syntax, isDark),

                // Properties tab
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.widgetModel.properties.length,
                  itemBuilder: (context, index) {
                    final property = widget.widgetModel.properties[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          property.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        subtitle: Text(property.description),
                      ),
                    );
                  },
                ),

                // Usage tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(widget.widgetModel.usage,
                      style: const TextStyle(height: 1.6)),
                ),
              ],
            ),
          ),

          // Banner Ad at bottom
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSourceCode(context, isDark),
        icon: const Icon(Icons.code),
        label: Text('view_full_example'.tr),
      ),
    );
  }

  Widget _buildSyntaxTab(String code, bool isDark) {
    return Stack(
      children: [
        SyntaxView(
          code: code,
          syntax: Syntax.DART,
          syntaxTheme:
              isDark ? SyntaxTheme.vscodeDark() : SyntaxTheme.vscodeLight(),
          fontSize: 13,
          withZoom: false,
          withLinesCount: true,
          expanded: true,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CodeActionBtn(
                icon: Icons.share_rounded,
                tooltip: 'share'.tr,
                onTap: () => _shareCode(code),
              ),
              const SizedBox(width: 4),
              _CodeActionBtn(
                icon: Icons.copy_rounded,
                tooltip: 'copy'.tr,
                onTap: () => _copyToClipboard(code),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSourceCode(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'source_code'.tr,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share_rounded),
                        onPressed: () =>
                            _shareCode(widget.widgetModel.sourceCode),
                        tooltip: 'share'.tr,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () =>
                            _copyToClipboard(widget.widgetModel.sourceCode),
                        tooltip: 'copy'.tr,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SyntaxView(
                    code: widget.widgetModel.sourceCode,
                    syntax: Syntax.DART,
                    syntaxTheme: isDark
                        ? SyntaxTheme.vscodeDark()
                        : SyntaxTheme.vscodeLight(),
                    fontSize: 12.5,
                    withZoom: false,
                    withLinesCount: true,
                    expanded: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(String widgetId) {
    switch (widgetId) {
      case 'text':
        return const Text('Hello, Flutter! 👋',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold));

      case 'icon':
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: Colors.red, size: 40),
            SizedBox(width: 12),
            Icon(Icons.star, color: Colors.amber, size: 40),
            SizedBox(width: 12),
            Icon(Icons.thumb_up, color: Colors.blue, size: 40),
          ],
        );

      case 'container':
        return Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.blue],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Text('Container',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

      case 'row':
        return const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 36),
            Icon(Icons.favorite, color: Colors.red, size: 36),
            Icon(Icons.thumb_up, color: Colors.blue, size: 36),
            Icon(Icons.bolt, color: Colors.orange, size: 36),
          ],
        );

      case 'column':
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('First line', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Second line', style: TextStyle(fontSize: 15, color: Colors.blue)),
            SizedBox(height: 6),
            Text('Third line', style: TextStyle(fontSize: 14, color: Colors.green)),
          ],
        );

      case 'card':
        return Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 36, color: Colors.amber),
                const SizedBox(height: 8),
                const Text('Card Widget',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Elevated surface', style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        );

      case 'elevated_button':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.rocket_launch),
              label: const Text('ElevatedButton'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('Custom Color',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );

      case 'textbutton':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: () {}, child: const Text('TextButton')),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info),
              label: const Text('With Icon'),
            ),
          ],
        );

      case 'outlinedbutton':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
                onPressed: () {}, child: const Text('OutlinedButton')),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send),
              label: const Text('Send'),
            ),
          ],
        );

      case 'iconbutton':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite, color: Colors.red, size: 32)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Colors.blue, size: 32)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark, color: Colors.orange, size: 32)),
          ],
        );

      case 'floatingactionbutton':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Extended FAB'),
              icon: const Icon(Icons.edit),
            ),
          ],
        );

      case 'textfield':
        return SizedBox(
          width: 220,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Type something...',
              prefixIcon: const Icon(Icons.edit),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
          ),
        );

      case 'checkbox':
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CheckboxPreview(label: 'Flutter', initial: true),
            _CheckboxPreview(label: 'Dart', initial: true),
            _CheckboxPreview(label: 'React Native', initial: false),
          ],
        );

      case 'switch':
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SwitchPreview(label: 'Dark Mode', initial: true),
            _SwitchPreview(label: 'Notifications', initial: false),
          ],
        );

      case 'slider':
        return const _SliderPreview();

      case 'circleavatar':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text('AB', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Text('CD', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        );

      case 'chip':
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const Chip(label: Text('Flutter'), avatar: Icon(Icons.code, size: 16)),
            Chip(
              label: const Text('Dart'),
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              avatar: const Icon(Icons.developer_mode, size: 16),
            ),
            FilterChip(
              label: const Text('Selected'),
              selected: true,
              onSelected: (_) {},
            ),
          ],
        );

      case 'listtile':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('John Doe'),
              subtitle: Text('Flutter Developer'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const Divider(height: 1),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.check, color: Colors.white)),
              title: const Text('Task Completed'),
              subtitle: const Text('2 hours ago'),
              trailing: const Icon(Icons.more_vert),
            ),
          ],
        );

      case 'progressindicator':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: 0.65,
                backgroundColor: Colors.blue.withValues(alpha: 0.2),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            const Text('65%', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        );

      case 'stack':
        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(16)),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Icon(Icons.notifications, color: Colors.white, size: 18),
                ),
              ),
              const Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Text('Stack',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );

      case 'padding':
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              color: Colors.blue.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(12),
              child: const Text('Padded Content',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        );

      case 'center':
        return Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.circular(8)),
          child: const Center(
            child: Text('Centered!',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          ),
        );

      case 'sizedbox':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 50,
                height: 50,
                color: Colors.blue,
                child: const Center(child: Text('A', style: TextStyle(color: Colors.white)))),
            Container(
              width: 40,
              height: 50,
              color: Colors.orange.withValues(alpha: 0.3),
              child: const Center(
                child: Text('gap', style: TextStyle(fontSize: 10)),
              ),
            ),
            Container(
                width: 50,
                height: 50,
                color: Colors.green,
                child: const Center(child: Text('B', style: TextStyle(color: Colors.white)))),
          ],
        );

      case 'tooltip':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'This is a tooltip!',
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Hover / Long Press'),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Long press the button to see tooltip',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        );

      case 'divider':
        return const SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Above divider'),
              Divider(color: Colors.blue, thickness: 2),
              Text('Below divider'),
              Divider(thickness: 1, indent: 20, endIndent: 20),
              Text('With indent'),
            ],
          ),
        );

      case 'wrap':
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Flutter', 'Dart', 'iOS', 'Android', 'Web', 'Desktop']
              .map((t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                    ),
                    child: Text(t,
                        style: const TextStyle(color: Colors.blue, fontSize: 13)),
                  ))
              .toList(),
        );

      case 'expanded':
        return SizedBox(
          width: 220,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 50,
                  color: Colors.blue,
                  child: const Center(
                      child: Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  color: Colors.green,
                  child: const Center(
                      child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        );

      case 'tabbar':
        return DefaultTabController(
          length: 3,
          child: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.home), text: 'Home'),
                    Tab(icon: Icon(Icons.star), text: 'Stars'),
                    Tab(icon: Icon(Icons.person), text: 'Profile'),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: TabBarView(
                    children: [
                      const Center(child: Text('Home content')),
                      const Center(child: Icon(Icons.star, color: Colors.amber)),
                      const Center(child: Icon(Icons.person, color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 'snackbar':
        return ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Hello! This is a SnackBar 🎉'),
                action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          icon: const Icon(Icons.notifications_active),
          label: const Text('Show SnackBar'),
        );

      case 'dialog':
        return ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Dialog'),
                content: const Text('This is an AlertDialog!'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK')),
                ],
              ),
            );
          },
          child: const Text('Show Dialog'),
        );

      case 'hero':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flight_takeoff, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            const Text('Hero Widget',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Shared element transition',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        );

      case 'bottomnavigationbar':
        return BottomNavigationBar(
          currentIndex: 0,
          onTap: (_) {},
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile'),
          ],
        );

      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.widgets_rounded,
                size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(widget.widgetModel.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
    }
  }
}

// ── Stateful preview helpers ──────────────────────────────────

class _CheckboxPreview extends StatefulWidget {
  final String label;
  final bool initial;
  const _CheckboxPreview({required this.label, required this.initial});

  @override
  State<_CheckboxPreview> createState() => _CheckboxPreviewState();
}

class _CheckboxPreviewState extends State<_CheckboxPreview> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? _checked),
        ),
        Text(widget.label),
      ],
    );
  }
}

class _SwitchPreview extends StatefulWidget {
  final String label;
  final bool initial;
  const _SwitchPreview({required this.label, required this.initial});

  @override
  State<_SwitchPreview> createState() => _SwitchPreviewState();
}

class _SwitchPreviewState extends State<_SwitchPreview> {
  late bool _on;

  @override
  void initState() {
    super.initState();
    _on = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label),
        const SizedBox(width: 8),
        Switch(value: _on, onChanged: (v) => setState(() => _on = v)),
      ],
    );
  }
}

class _SliderPreview extends StatefulWidget {
  const _SliderPreview();

  @override
  State<_SliderPreview> createState() => _SliderPreviewState();
}

class _SliderPreviewState extends State<_SliderPreview> {
  double _val = 0.6;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
          value: _val,
          onChanged: (v) => setState(() => _val = v),
        ),
        Text('${(_val * 100).round()}%',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _CodeActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _CodeActionBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
