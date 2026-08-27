import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetCustomizerController extends GetxController {
  // Available color palette
  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.deepPurple,
    Colors.black,
    Colors.white,
  ];

  // ── Container Customizer state ──
  final containerWidth = 150.0.obs;
  final containerHeight = 150.0.obs;
  final containerBorderRadius = 12.0.obs;
  final containerBorderWidth = 2.0.obs;
  final containerElevation = 4.0.obs;
  final containerColor = Colors.blue.obs;
  final containerBorderColor = Colors.indigo.obs;

  // ── Button Customizer state ──
  final buttonText = 'Tap Me'.obs;
  final buttonColor = Colors.deepPurple.obs;
  final buttonTextColor = Colors.white.obs;
  final buttonElevation = 2.0.obs;
  final buttonCornerRadius = 8.0.obs;
  final buttonHasIcon = false.obs;

  // ── Text Customizer state ──
  final textContent = 'Flutter is awesome!'.obs;
  final textSize = 18.0.obs;
  final textColor = Colors.black.obs;
  final textBold = false.obs;
  final textItalic = false.obs;
  final textLetterSpacing = 0.0.obs;

  String colorToCode(Color color) {
    if (color == Colors.blue) return 'Colors.blue';
    if (color == Colors.red) return 'Colors.red';
    if (color == Colors.green) return 'Colors.green';
    if (color == Colors.orange) return 'Colors.orange';
    if (color == Colors.pink) return 'Colors.pink';
    if (color == Colors.purple) return 'Colors.purple';
    if (color == Colors.teal) return 'Colors.teal';
    if (color == Colors.indigo) return 'Colors.indigo';
    if (color == Colors.amber) return 'Colors.amber';
    if (color == Colors.deepPurple) return 'Colors.deepPurple';
    if (color == Colors.black) return 'Colors.black';
    if (color == Colors.white) return 'Colors.white';
    return 'Color(0x${color.toARGB32().toRadixString(16).toUpperCase()})';
  }

  String get containerCode => '''Container(
  width: ${containerWidth.value.toStringAsFixed(0)},
  height: ${containerHeight.value.toStringAsFixed(0)},
  decoration: BoxDecoration(
    color: ${colorToCode(containerColor.value)},
    borderRadius: BorderRadius.circular(${containerBorderRadius.value.toStringAsFixed(0)}),
    border: Border.all(
      color: ${colorToCode(containerBorderColor.value)},
      width: ${containerBorderWidth.value.toStringAsFixed(1)},
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: ${containerElevation.value.toStringAsFixed(0)},
        offset: Offset(0, ${(containerElevation.value / 2).toStringAsFixed(0)}),
      ),
    ],
  ),
)''';

  String get buttonCode => '''ElevatedButton${buttonHasIcon.value ? '.icon' : ''}(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: ${colorToCode(buttonColor.value)},
    foregroundColor: ${colorToCode(buttonTextColor.value)},
    elevation: ${buttonElevation.value.toStringAsFixed(0)},
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(${buttonCornerRadius.value.toStringAsFixed(0)}),
    ),
  ),
  ${buttonHasIcon.value ? 'icon: Icon(Icons.star_rounded),\n  label: ' : 'child: '}Text('${buttonText.value}'),
)''';

  String get textCode => '''Text(
  '${textContent.value}',
  style: TextStyle(
    fontSize: ${textSize.value.toStringAsFixed(0)},
    color: ${colorToCode(textColor.value)},
    fontWeight: ${textBold.value ? 'FontWeight.bold' : 'FontWeight.normal'},
    fontStyle: ${textItalic.value ? 'FontStyle.italic' : 'FontStyle.normal'},
    letterSpacing: ${textLetterSpacing.value.toStringAsFixed(1)},
  ),
)''';
}
