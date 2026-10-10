import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/favorites_controller.dart';
import '../controllers/progress_controller.dart';
import '../models/widget_model.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../services/deep_link_service.dart';
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

  Map<String, dynamic> _playgroundParams = {};

  final List<Color> _playgroundColors = const [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.deepPurple,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initPlaygroundParams();

    // Track progress & trigger interstitial
    Future.delayed(const Duration(milliseconds: 300), () {
      progressController.markAsViewed(widget.widgetModel.id);
      AdService().incrementDetailScreenCounter();
      AnalyticsService().logWidgetViewed(
        widgetId: widget.widgetModel.id,
        widgetName: widget.widgetModel.name,
        category: widget.widgetModel.categoryId,
      );
      AnalyticsService().logScreenView('widget_detail');
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
    final text = '${DeepLinkService.widgetShareText(
      name: widget.widgetModel.name,
      description: widget.widgetModel.description,
      widgetId: widget.widgetModel.id,
    )}\n\n```dart\n$code\n```';
    Share.share(text);
    AnalyticsService().logEvent('widget_shared', parameters: {
      'widget_id': widget.widgetModel.id,
      'widget_name': widget.widgetModel.name,
    });
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
                      Center(child: _buildDynamicPreview(widget.widgetModel.id)),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'syntax'.tr),
              Tab(text: 'playground'.tr),
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

                // Playground tab
                _buildPlaygroundTab(isDark),

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
        ],
      ),
      bottomNavigationBar: const SafeArea(
        child: BannerAdWidget(),
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

  // ─────────────────────────────────────────────────────────────
  // INTERACTIVE PLAYGROUND HELPER METHODS
  // ─────────────────────────────────────────────────────────────

  void _initPlaygroundParams() {
    final id = widget.widgetModel.id.toLowerCase();
    if (id == 'text') {
      _playgroundParams = {
        'text': 'Hello, Flutter! 👋',
        'fontSize': 22.0,
        'isBold': true,
        'isItalic': false,
        'color': Colors.blue,
      };
    } else if (id == 'container') {
      _playgroundParams = {
        'width': 120.0,
        'height': 80.0,
        'borderRadius': 16.0,
        'color': Colors.deepPurple,
        'elevation': 6.0,
      };
    } else if (id == 'icon') {
      _playgroundParams = {
        'size': 48.0,
        'color': Colors.red,
        'icon': 'favorite',
      };
    } else if (id == 'row' || id == 'column') {
      _playgroundParams = {
        'mainAxisAlignment': MainAxisAlignment.center,
        'crossAxisAlignment': CrossAxisAlignment.center,
      };
    } else if (id == 'elevatedbutton') {
      _playgroundParams = {
        'label': 'Click Me',
        'color': Colors.blue,
        'elevation': 2.0,
        'borderRadius': 8.0,
      };
    } else if (id == 'card') {
      _playgroundParams = {
        'elevation': 4.0,
        'color': Colors.amber,
        'margin': 8.0,
      };
    } else if (id == 'textfield') {
      _playgroundParams = {
        'filled': false,
        'outlineBorder': true,
        'hintText': 'Type here...',
      };
    }
  }

  bool get _hasPlayground {
    final id = widget.widgetModel.id.toLowerCase();
    return [
      'text',
      'container',
      'icon',
      'row',
      'column',
      'elevatedbutton',
      'card',
      'textfield'
    ].contains(id);
  }

  Widget _buildDynamicPreview(String widgetId) {
    final id = widgetId.toLowerCase();
    if (!_hasPlayground) {
      return _buildPreview(widgetId);
    }
    switch (id) {
      case 'text':
        final text = _playgroundParams['text'] as String? ?? 'Hello, Flutter! 👋';
        final fontSize = _playgroundParams['fontSize'] as double? ?? 22.0;
        final isBold = _playgroundParams['isBold'] as bool? ?? true;
        final isItalic = _playgroundParams['isItalic'] as bool? ?? false;
        final color = _playgroundParams['color'] as Color? ?? Colors.blue;
        return Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: color,
          ),
        );

      case 'container':
        final width = _playgroundParams['width'] as double? ?? 120.0;
        final height = _playgroundParams['height'] as double? ?? 80.0;
        final borderRadius = _playgroundParams['borderRadius'] as double? ?? 16.0;
        final color = _playgroundParams['color'] as Color? ?? Colors.deepPurple;
        final elevation = _playgroundParams['elevation'] as double? ?? 6.0;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: elevation * 2,
                      offset: Offset(0, elevation),
                    ),
                  ]
                : null,
          ),
          child: const Center(
            child: Text('Container',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

      case 'icon':
        final size = _playgroundParams['size'] as double? ?? 48.0;
        final color = _playgroundParams['color'] as Color? ?? Colors.red;
        final iconStr = _playgroundParams['icon'] as String? ?? 'favorite';
        IconData iconData = Icons.favorite;
        if (iconStr == 'star') iconData = Icons.star;
        if (iconStr == 'thumb_up') iconData = Icons.thumb_up;
        if (iconStr == 'home') iconData = Icons.home;
        if (iconStr == 'settings') iconData = Icons.settings;
        return Icon(iconData, color: color, size: size);

      case 'row':
        final mainAlign = _playgroundParams['mainAxisAlignment'] as MainAxisAlignment? ?? MainAxisAlignment.center;
        final crossAlign = _playgroundParams['crossAxisAlignment'] as CrossAxisAlignment? ?? CrossAxisAlignment.center;
        return Row(
          mainAxisAlignment: mainAlign,
          crossAxisAlignment: crossAlign,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star, color: Colors.amber, size: 36),
            Icon(Icons.favorite, color: Colors.red, size: 36),
            Icon(Icons.thumb_up, color: Colors.blue, size: 36),
          ],
        );

      case 'column':
        final mainAlign = _playgroundParams['mainAxisAlignment'] as MainAxisAlignment? ?? MainAxisAlignment.center;
        final crossAlign = _playgroundParams['crossAxisAlignment'] as CrossAxisAlignment? ?? CrossAxisAlignment.center;
        return Column(
          mainAxisAlignment: mainAlign,
          crossAxisAlignment: crossAlign,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star, color: Colors.amber, size: 30),
            Icon(Icons.favorite, color: Colors.red, size: 30),
            Icon(Icons.thumb_up, color: Colors.blue, size: 30),
          ],
        );

      case 'elevatedbutton':
        final label = _playgroundParams['label'] as String? ?? 'Click Me';
        final color = _playgroundParams['color'] as Color? ?? Colors.blue;
        final elevation = _playgroundParams['elevation'] as double? ?? 2.0;
        final borderRadius = _playgroundParams['borderRadius'] as double? ?? 8.0;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          onPressed: () {},
          child: Text(label),
        );

      case 'card':
        final elevation = _playgroundParams['elevation'] as double? ?? 4.0;
        final color = _playgroundParams['color'] as Color? ?? Colors.amber;
        final margin = _playgroundParams['margin'] as double? ?? 8.0;
        return Card(
          elevation: elevation,
          color: color,
          margin: EdgeInsets.all(margin),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text('Card Widget',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        );

      case 'textfield':
        final filled = _playgroundParams['filled'] as bool? ?? false;
        final outlineBorder = _playgroundParams['outlineBorder'] as bool? ?? true;
        final hintText = _playgroundParams['hintText'] as String? ?? 'Type here...';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            decoration: InputDecoration(
              filled: filled,
              hintText: hintText,
              border: outlineBorder
                  ? const OutlineInputBorder()
                  : const UnderlineInputBorder(),
            ),
          ),
        );

      default:
        return _buildPreview(widgetId);
    }
  }

  Widget _buildPlaygroundTab(bool isDark) {
    if (!_hasPlayground) {
      return _buildPlaygroundPlaceholder(isDark);
    }

    final id = widget.widgetModel.id.toLowerCase();
    List<Widget> controls = [];

    if (id == 'text') {
      controls = [
        _buildTextFieldInput(label: 'Text Value', key: 'text'),
        _buildSlider(label: 'Font Size', key: 'fontSize', min: 12, max: 36),
        _buildSwitch(label: 'Bold', key: 'isBold'),
        _buildSwitch(label: 'Italic', key: 'isItalic'),
        _buildColorSelector('color'),
      ];
    } else if (id == 'container') {
      controls = [
        _buildSlider(label: 'Width', key: 'width', min: 50, max: 200),
        _buildSlider(label: 'Height', key: 'height', min: 40, max: 150),
        _buildSlider(label: 'Border Radius', key: 'borderRadius', min: 0, max: 40),
        _buildSlider(label: 'Elevation / Shadow', key: 'elevation', min: 0, max: 15),
        _buildColorSelector('color'),
      ];
    } else if (id == 'icon') {
      controls = [
        _buildSlider(label: 'Icon Size', key: 'size', min: 20, max: 80),
        _buildDropdown<String>(
          label: 'Icon Symbol',
          key: 'icon',
          items: const ['favorite', 'star', 'thumb_up', 'home', 'settings'],
          itemNames: const ['Favorite', 'Star', 'Thumb Up', 'Home', 'Settings'],
        ),
        _buildColorSelector('color'),
      ];
    } else if (id == 'row' || id == 'column') {
      controls = [
        _buildDropdown<MainAxisAlignment>(
          label: 'Main Axis Alignment',
          key: 'mainAxisAlignment',
          items: MainAxisAlignment.values,
          itemNames: MainAxisAlignment.values.map((v) => v.toString().split('.').last).toList(),
        ),
        _buildDropdown<CrossAxisAlignment>(
          label: 'Cross Axis Alignment',
          key: 'crossAxisAlignment',
          items: const [CrossAxisAlignment.start, CrossAxisAlignment.center, CrossAxisAlignment.end],
          itemNames: const ['start', 'center', 'end'],
        ),
      ];
    } else if (id == 'elevatedbutton') {
      controls = [
        _buildTextFieldInput(label: 'Button Label', key: 'label'),
        _buildSlider(label: 'Elevation', key: 'elevation', min: 0, max: 10),
        _buildSlider(label: 'Border Radius', key: 'borderRadius', min: 0, max: 30),
        _buildColorSelector('color'),
      ];
    } else if (id == 'card') {
      controls = [
        _buildSlider(label: 'Elevation', key: 'elevation', min: 0, max: 20),
        _buildSlider(label: 'Margin', key: 'margin', min: 0, max: 24),
        _buildColorSelector('color'),
      ];
    } else if (id == 'textfield') {
      controls = [
        _buildTextFieldInput(label: 'Hint Text', key: 'hintText'),
        _buildSwitch(label: 'Filled Background', key: 'filled'),
        _buildSwitch(label: 'Outline Border Style', key: 'outlineBorder'),
      ];
    }

    final generatedCode = _buildGeneratedCode(id);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'customize_widget'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...controls,
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'generated_code'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  SyntaxView(
                    code: generatedCode,
                    syntax: Syntax.DART,
                    syntaxTheme: isDark
                        ? SyntaxTheme.vscodeDark()
                        : SyntaxTheme.vscodeLight(),
                    fontSize: 12.5,
                    withZoom: false,
                    withLinesCount: false,
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
                          onTap: () => _shareCode(generatedCode),
                        ),
                        const SizedBox(width: 4),
                        _CodeActionBtn(
                          icon: Icons.copy_rounded,
                          tooltip: 'copy'.tr,
                          onTap: () => _copyToClipboard(generatedCode),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaygroundPlaceholder(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'playground'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Interactive playground is not yet available for this widget.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Try basic widgets like:'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Text', 'Container', 'Icon', 'Row', 'Column', 
                        'Card', 'ElevatedButton', 'TextField'
                      ].map((w) => Chip(
                        label: Text(w),
                        visualDensity: VisualDensity.compact,
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildGeneratedCode(String widgetId) {
    final id = widgetId.toLowerCase();
    switch (id) {
      case 'text':
        final text = _playgroundParams['text'] ?? 'Hello, Flutter! 👋';
        final fontSize = _playgroundParams['fontSize'] ?? 22.0;
        final isBold = _playgroundParams['isBold'] ?? true;
        final isItalic = _playgroundParams['isItalic'] ?? false;
        final color = _playgroundParams['color'] ?? Colors.blue;
        
        String style = '';
        if (fontSize != 14.0 || isBold || isItalic || color != Colors.black) {
          style = ',\n  style: TextStyle(\n';
          style += '    fontSize: $fontSize,\n';
          if (isBold) style += '    fontWeight: FontWeight.bold,\n';
          if (isItalic) style += '    fontStyle: FontStyle.italic,\n';
          style += "    color: Color(0xFF${color.value.toRadixString(16).substring(2).toUpperCase()}),\n";
          style += '  )';
        }
        return "Text(\n  '$text'$style\n)";

      case 'container':
        final width = _playgroundParams['width'] ?? 120.0;
        final height = _playgroundParams['height'] ?? 80.0;
        final borderRadius = _playgroundParams['borderRadius'] ?? 16.0;
        final color = _playgroundParams['color'] ?? Colors.deepPurple;
        final elevation = _playgroundParams['elevation'] ?? 6.0;
        return """Container(
  width: $width,
  height: $height,
  decoration: BoxDecoration(
    color: Color(0xFF${color.value.toRadixString(16).substring(2).toUpperCase()}),
    borderRadius: BorderRadius.circular($borderRadius),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF${color.value.toRadixString(16).substring(2).toUpperCase()}).withValues(alpha: 0.4),
        blurRadius: ${elevation * 2},
        offset: Offset(0, $elevation),
      ),
    ],
  ),
  child: Center(
    child: Text('Container', style: TextStyle(color: Colors.white)),
  ),
)""";

      case 'icon':
        final size = _playgroundParams['size'] ?? 48.0;
        final color = _playgroundParams['color'] ?? Colors.red;
        final iconStr = _playgroundParams['icon'] ?? 'favorite';
        return "Icon(\n  Icons.$iconStr,\n  color: Color(0xFF${color.value.toRadixString(16).substring(2).toUpperCase()}),\n  size: $size,\n)";

      case 'row':
        final mainAlign = _playgroundParams['mainAxisAlignment'] ?? MainAxisAlignment.center;
        final crossAlign = _playgroundParams['crossAxisAlignment'] ?? CrossAxisAlignment.center;
        final mainAlignStr = mainAlign.toString().split('.').last;
        final crossAlignStr = crossAlign.toString().split('.').last;
        return """Row(
  mainAxisAlignment: MainAxisAlignment.$mainAlignStr,
  crossAxisAlignment: CrossAxisAlignment.$crossAlignStr,
  children: const [
    Icon(Icons.star, color: Colors.amber, size: 36),
    Icon(Icons.favorite, color: Colors.red, size: 36),
    Icon(Icons.thumb_up, color: Colors.blue, size: 36),
  ],
)""";

      case 'column':
        final mainAlign = _playgroundParams['mainAxisAlignment'] ?? MainAxisAlignment.center;
        final crossAlign = _playgroundParams['crossAxisAlignment'] ?? CrossAxisAlignment.center;
        final mainAlignStr = mainAlign.toString().split('.').last;
        final crossAlignStr = crossAlign.toString().split('.').last;
        return """Column(
  mainAxisAlignment: MainAxisAlignment.$mainAlignStr,
  crossAxisAlignment: CrossAxisAlignment.$crossAlignStr,
  children: const [
    Icon(Icons.star, color: Colors.amber, size: 30),
    Icon(Icons.favorite, color: Colors.red, size: 30),
    Icon(Icons.thumb_up, color: Colors.blue, size: 30),
  ],
)""";

      case 'elevatedbutton':
        final label = _playgroundParams['label'] ?? 'Click Me';
        final color = _playgroundParams['color'] ?? Colors.blue;
        final elevation = _playgroundParams['elevation'] ?? 2.0;
        final borderRadius = _playgroundParams['borderRadius'] ?? 8.0;
        return """ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF${color.value.toRadixString(16).substring(2).toUpperCase()}),
    foregroundColor: Colors.white,
    elevation: $elevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular($borderRadius),
    ),
  ),
  onPressed: () {},
  child: Text('$label'),
)""";

      case 'card':
        final elevation = _playgroundParams['elevation'] ?? 4.0;
        final color = _playgroundParams['color'] ?? Colors.amber;
        final margin = _playgroundParams['margin'] ?? 8.0;
        return """Card(
  elevation: $elevation,
  color: Color(0xFF${color.value.toRadixString(16).substring(2).toUpperCase()}),
  margin: EdgeInsets.all($margin),
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Text('Card Widget'),
  ),
)""";

      case 'textfield':
        final filled = _playgroundParams['filled'] ?? false;
        final outlineBorder = _playgroundParams['outlineBorder'] ?? true;
        final hintText = _playgroundParams['hintText'] ?? 'Type here...';
        final borderStr = outlineBorder ? 'OutlineInputBorder()' : 'UnderlineInputBorder()';
        return """TextField(
  decoration: InputDecoration(
    filled: $filled,
    hintText: '$hintText',
    border: $borderStr,
  ),
)""";

      default:
        return "";
    }
  }

  Widget _buildColorSelector(String key) {
    final activeColor = _playgroundParams[key] as Color? ?? Colors.blue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'theme_color'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _playgroundColors.length,
            itemBuilder: (context, index) {
              final color = _playgroundColors[index];
              final isSelected = activeColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _playgroundParams[key] = color;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3.5,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required String key,
    required double min,
    required double max,
    int? divisions,
  }) {
    final val = (_playgroundParams[key] as num? ?? min).toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(val.toStringAsFixed(1), style: const TextStyle(fontFamily: 'monospace')),
            ],
          ),
          Slider(
            value: val,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: (newVal) {
              setState(() {
                _playgroundParams[key] = newVal;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({required String label, required String key}) {
    final val = _playgroundParams[key] as bool? ?? false;
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      value: val,
      onChanged: (newVal) {
        setState(() {
          _playgroundParams[key] = newVal;
        });
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required String key,
    required List<T> items,
    required List<String> itemNames,
  }) {
    final activeVal = _playgroundParams[key] as T;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: activeVal,
                items: List.generate(items.length, (index) {
                  return DropdownMenuItem<T>(
                    value: items[index],
                    child: Text(itemNames[index]),
                  );
                }),
                onChanged: (newVal) {
                  if (newVal != null) {
                    setState(() {
                      _playgroundParams[key] = newVal;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldInput({required String label, required String key}) {
    final textVal = _playgroundParams[key] as String? ?? '';
    final controller = TextEditingController(text: textVal);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        onChanged: (val) {
          setState(() {
            _playgroundParams[key] = val;
          });
        },
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
