import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/customizer_controller.dart';
import '../services/deep_link_service.dart';

class WidgetCustomizerScreen extends StatefulWidget {
  const WidgetCustomizerScreen({super.key});

  @override
  State<WidgetCustomizerScreen> createState() => _WidgetCustomizerScreenState();
}

class _WidgetCustomizerScreenState extends State<WidgetCustomizerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _controller = Get.put(WidgetCustomizerController());
  final _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _shareDesign() async {
    try {
      final imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 50),
      );
      if (imageBytes == null) return;

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/custom_widget_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: '🎨 Look at this custom Flutter widget I designed!\nGet the code and learn Flutter: ${DeepLinkService.playStoreUrl}',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to share design: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Code Generator', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3.5,
          tabs: const [
            Tab(icon: Icon(Icons.crop_square_rounded), text: 'Container'),
            Tab(icon: Icon(Icons.smart_button_rounded), text: 'Button'),
            Tab(icon: Icon(Icons.text_fields_rounded), text: 'Text'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Live Preview Box (with screenshot wrapper) ──
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1E2E), const Color(0xFF161622)]
                    : [Colors.grey.shade100, Colors.grey.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Screenshot(
                controller: _screenshotController,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A40) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, _) {
                      return Obx(() {
                        switch (_tabController.index) {
                          case 0:
                            return Container(
                              width: _controller.containerWidth.value,
                              height: _controller.containerHeight.value,
                              decoration: BoxDecoration(
                                color: _controller.containerColor.value,
                                borderRadius: BorderRadius.circular(
                                    _controller.containerBorderRadius.value),
                                border: Border.all(
                                  color: _controller.containerBorderColor.value,
                                  width: _controller.containerBorderWidth.value,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: _controller.containerElevation.value,
                                    offset: Offset(0, _controller.containerElevation.value / 2),
                                  ),
                                ],
                              ),
                            );
                          case 1:
                            return ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _controller.buttonColor.value,
                                foregroundColor: _controller.buttonTextColor.value,
                                elevation: _controller.buttonElevation.value,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      _controller.buttonCornerRadius.value),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_controller.buttonHasIcon.value) ...[
                                    const Icon(Icons.star_rounded),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    _controller.buttonText.value,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          case 2:
                          default:
                            return Text(
                              _controller.textContent.value,
                              style: TextStyle(
                                fontSize: _controller.textSize.value,
                                color: _controller.textColor.value,
                                fontWeight: _controller.textBold.value
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontStyle: _controller.textItalic.value
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                letterSpacing: _controller.textLetterSpacing.value,
                              ),
                            );
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          // ── Settings Scroll Area ──
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildContainerOptions(),
                        _buildButtonOptions(),
                        _buildTextOptions(),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  _buildCodeViewerSection(isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── CONTAINER OPTIONS ──
  Widget _buildContainerOptions() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        _buildSlider('Width', _controller.containerWidth, 50, 220),
        _buildSlider('Height', _controller.containerHeight, 50, 220),
        _buildSlider('Border Radius', _controller.containerBorderRadius, 0, 80),
        _buildSlider('Border Width', _controller.containerBorderWidth, 0, 12),
        _buildSlider('Elevation (Shadow)', _controller.containerElevation, 0, 20),
        _buildColorPicker('Background Color', _controller.containerColor),
        _buildColorPicker('Border Color', _controller.containerBorderColor),
      ],
    );
  }

  // ── BUTTON OPTIONS ──
  Widget _buildButtonOptions() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Button Label',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (val) => _controller.buttonText.value = val.isEmpty ? 'Button' : val,
          ),
        ),
        _buildSlider('Elevation', _controller.buttonElevation, 0, 15),
        _buildSlider('Corner Radius', _controller.buttonCornerRadius, 0, 30),
        Obx(() => SwitchListTile(
              title: const Text('Show Left Icon'),
              value: _controller.buttonHasIcon.value,
              onChanged: (val) => _controller.buttonHasIcon.value = val,
            )),
        _buildColorPicker('Button Color', _controller.buttonColor),
        _buildColorPicker('Text Color', _controller.buttonTextColor),
      ],
    );
  }

  // ── TEXT OPTIONS ──
  Widget _buildTextOptions() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Text Content',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (val) => _controller.textContent.value = val.isEmpty ? 'Hello World' : val,
          ),
        ),
        _buildSlider('Font Size', _controller.textSize, 12, 38),
        _buildSlider('Letter Spacing', _controller.textLetterSpacing, -2, 10),
        Obx(() => Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Bold'),
                    value: _controller.textBold.value,
                    onChanged: (val) => _controller.textBold.value = val ?? false,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Italic'),
                    value: _controller.textItalic.value,
                    onChanged: (val) => _controller.textItalic.value = val ?? false,
                  ),
                ),
              ],
            )),
        _buildColorPicker('Text Color', _controller.textColor),
      ],
    );
  }

  // ── REUSABLE PICKERS & SLIDERS ──
  Widget _buildSlider(String label, RxDouble value, double min, double max) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(value.value.toStringAsFixed(1), style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Slider(
              value: value.value.clamp(min, max),
              min: min,
              max: max,
              onChanged: (val) => value.value = val,
            ),
          ],
        ));
  }

  Widget _buildColorPicker(String title, Rx<Color> selectedColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _controller.availableColors.length,
            itemBuilder: (context, index) {
              final color = _controller.availableColors[index];
              return Obx(() {
                final isSelected = selectedColor.value == color;
                return GestureDetector(
                  onTap: () => selectedColor.value = color,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? (color == Colors.black ? Colors.blue : Colors.black)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6)]
                          : null,
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  // ── CODE VIEWER SECTION ──
  Widget _buildCodeViewerSection(bool isDark) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return Obx(() {
          String code = '';
          switch (_tabController.index) {
            case 0:
              code = _controller.containerCode;
              break;
            case 1:
              code = _controller.buttonCode;
              break;
            case 2:
              code = _controller.textCode;
              break;
          }

          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Generated Code',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_rounded),
                          tooltip: 'Copy Code',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: code));
                            Get.snackbar(
                              'Success',
                              'Code copied to clipboard!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withValues(alpha: 0.9),
                              colorText: Colors.white,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_rounded),
                          tooltip: 'Share Card',
                          onPressed: _shareDesign,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SyntaxView(
                      code: code,
                      syntax: Syntax.DART,
                      syntaxTheme: isDark ? SyntaxTheme.vscodeDark() : SyntaxTheme.standard(),
                      withZoom: false,
                      withLinesCount: false,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        });
      },
    );
  }
}
