import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Show interstitial ad every 3rd screen view
    Future.delayed(const Duration(milliseconds: 500), () {
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
      'Copied',
      'Code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.widgetModel.name),
        actions: [
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
              onPressed: () {
                favoritesController.toggleFavorite(widget.widgetModel.id);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Description section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(widget.widgetModel.description),
              ],
            ),
          ),

          // Live Preview section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Live Preview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.fullscreen),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Center(child: _buildPreview(widget.widgetModel.id)),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Syntax'),
              Tab(text: 'Properties'),
              Tab(text: 'Usage'),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Syntax tab
                _buildCodeSection('Syntax', widget.widgetModel.syntax),

                // Properties tab
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.widgetModel.properties.length,
                  itemBuilder: (context, index) {
                    final property = widget.widgetModel.properties[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.settings),
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
                  child: Text(widget.widgetModel.usage),
                ),
              ],
            ),
          ),

          // Banner Ad at bottom
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSourceCode(context);
        },
        icon: const Icon(Icons.code),
        label: const Text('View Full Example'),
      ),
    );
  }

  Widget _buildCodeSection(String title, String code) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(code),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSourceCode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Source Code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () =>
                            _copyToClipboard(widget.widgetModel.sourceCode),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: SelectableText(
                      widget.widgetModel.sourceCode,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white,
                        fontSize: 13,
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

  Widget _buildPreview(String widgetId) {
    // Simple preview widgets based on the widget type
    switch (widgetId) {
      case 'text':
        return const Text(
          'Hello World',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      case 'icon':
        return const Icon(Icons.favorite, color: Colors.red, size: 50);
      case 'container':
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Container', style: TextStyle(color: Colors.white)),
          ),
        );
      case 'row':
        return const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 40),
            Icon(Icons.favorite, color: Colors.red, size: 40),
            Icon(Icons.thumb_up, color: Colors.blue, size: 40),
          ],
        );
      case 'column':
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Line 1', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Line 2', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Line 3', style: TextStyle(fontSize: 18)),
          ],
        );
      case 'card':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, size: 40, color: Colors.red),
                const SizedBox(height: 8),
                Text('Card', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        );
      case 'elevated_button':
        return ElevatedButton(onPressed: () {}, child: const Text('Click Me'));
      default:
        return const Icon(Icons.widgets, size: 50);
    }
  }
}
