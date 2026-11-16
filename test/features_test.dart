import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnflutter/screens/dart_playground_screen.dart';
import 'package:learnflutter/screens/flutter_error_dictionary_screen.dart';
import 'package:learnflutter/screens/coding_challenges_screen.dart';
import 'package:learnflutter/screens/color_palette_generator_screen.dart';

void main() {
  group('Dart Playground Tests', () {
    test('Preset codes contain valid Dart patterns', () {
      const preset = DartPreset(
        id: 'test_preset',
        title: 'Test Preset',
        category: 'Basics',
        description: 'Test Description',
        code: "void main() { print('Hello Test'); }",
      );

      expect(preset.id, 'test_preset');
      expect(preset.title, 'Test Preset');
      expect(preset.code.contains('print'), isTrue);
    });
  });

  group('Flutter Error Dictionary Tests', () {
    test('Error items have valid fields and code blocks', () {
      const item = FlutterErrorItem(
        id: 'test_err',
        title: 'RenderFlex overflowed',
        category: 'Layout',
        frequency: 'High',
        rootCause: 'Unbounded children in Flex',
        buggyCode: 'Column(children: [HugeWidget()])',
        fixedCode: 'SingleChildScrollView(child: Column(...))',
        preventionTip: 'Use scrollables for dynamic heights',
      );

      expect(item.id, 'test_err');
      expect(item.category, 'Layout');
      expect(item.buggyCode.isNotEmpty, isTrue);
      expect(item.fixedCode.isNotEmpty, isTrue);
    });
  });

  group('Coding Challenges Tests', () {
    test('Test cases validate expected Dart patterns', () {
      final testCase = TestCase(
        inputDesc: '"racecar"',
        expectedOutput: 'true',
        validator: (code) => code.contains('reversed'),
      );

      expect(testCase.validator('return s.split("").reversed.join("");'), isTrue);
      expect(testCase.validator('return s;'), isFalse);
    });
  });

  group('Color Palette Generator Tests', () {
    test('Palette colors initialize with correct roles', () {
      final pColor = PaletteColor(
        color: const Color(0xFF02569B),
        role: 'Primary',
      );

      expect(pColor.role, 'Primary');
      expect(pColor.isLocked, isFalse);
      expect(pColor.color.toARGB32(), const Color(0xFF02569B).toARGB32());
    });
  });
}
