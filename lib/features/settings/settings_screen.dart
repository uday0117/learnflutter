import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Mode Section
          _buildSectionTitle('Appearance'),
          Card(
            child: Obx(
              () => Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Light Mode'),
                    value: ThemeMode.light,
                    groupValue: themeController.themeMode.value,
                    onChanged: (mode) => themeController.updateThemeMode(mode!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark Mode'),
                    value: ThemeMode.dark,
                    groupValue: themeController.themeMode.value,
                    onChanged: (mode) => themeController.updateThemeMode(mode!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('System Default'),
                    value: ThemeMode.system,
                    groupValue: themeController.themeMode.value,
                    onChanged: (mode) => themeController.updateThemeMode(mode!),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Color Picker Section
          _buildSectionTitle('Theme Color'),
          const SizedBox(height: 12),

          // Predefined color presets
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Colors',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ThemeController.colorPresets.map((color) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () =>
                              themeController.updatePrimaryColor(color),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    themeController.primaryColor.value == color
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                if (themeController.primaryColor.value == color)
                                  BoxShadow(
                                    color: color.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                              ],
                            ),
                            child: themeController.primaryColor.value == color
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Custom color picker
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Custom Color',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => ColorPicker(
                      color: themeController.primaryColor.value,
                      onColorChanged: (color) =>
                          themeController.updatePrimaryColor(color),
                      width: 44,
                      height: 44,
                      borderRadius: 22,
                      spacing: 8,
                      runSpacing: 8,
                      wheelDiameter: 200,
                      heading: const SizedBox.shrink(),
                      subheading: const SizedBox.shrink(),
                      pickersEnabled: const <ColorPickerType, bool>{
                        ColorPickerType.both: false,
                        ColorPickerType.primary: true,
                        ColorPickerType.accent: false,
                        ColorPickerType.bw: false,
                        ColorPickerType.custom: false,
                        ColorPickerType.wheel: true,
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionTitle('About'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Version'),
              subtitle: const Text('1.0.0+1'),
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Contact'),
              subtitle: const Text('apps.uksolutions@gmail.com'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
