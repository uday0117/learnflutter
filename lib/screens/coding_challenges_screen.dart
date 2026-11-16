import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../widgets/banner_ad_widget.dart';

class TestCase {
  final String inputDesc;
  final String expectedOutput;
  final bool Function(String code) validator;

  const TestCase({
    required this.inputDesc,
    required this.expectedOutput,
    required this.validator,
  });
}

class CodingChallenge {
  final String id;
  final String title;
  final String difficulty;
  final String category;
  final String prompt;
  final String starterCode;
  final String solutionCode;
  final String hint;
  final List<TestCase> testCases;

  const CodingChallenge({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.category,
    required this.prompt,
    required this.starterCode,
    required this.solutionCode,
    required this.hint,
    required this.testCases,
  });
}

class CodingChallengesScreen extends StatefulWidget {
  const CodingChallengesScreen({super.key});

  @override
  State<CodingChallengesScreen> createState() => _CodingChallengesScreenState();
}

class _CodingChallengesScreenState extends State<CodingChallengesScreen> {
  late CodingChallenge _activeChallenge;
  late TextEditingController _codeController;
  Map<int, bool?> _testResults = {};
  bool _showSolution = false;
  bool _isRunningTests = false;

  static final List<CodingChallenge> _challenges = [
    CodingChallenge(
      id: 'reverse_words',
      title: 'Reverse Words in a String',
      difficulty: 'Easy',
      category: 'Strings',
      prompt:
          'Write a function that accepts a sentence and returns the words in reverse order while preserving single spaces between them.',
      starterCode: '''String reverseWords(String sentence) {
  // Your code here
  return '';
}

void main() {
  print(reverseWords('flutter is awesome'));
}''',
      solutionCode: '''String reverseWords(String sentence) {
  return sentence.split(' ').reversed.join(' ');
}''',
      hint: 'Use .split(\' \') to get a list of words, then .reversed, and finally .join(\' \').',
      testCases: [
        TestCase(
          inputDesc: '"flutter is awesome"',
          expectedOutput: '"awesome is flutter"',
          validator: (code) =>
              code.contains('reversed') || (code.contains('split') && code.contains('join')),
        ),
        TestCase(
          inputDesc: '"dart 3 patterns"',
          expectedOutput: '"patterns 3 dart"',
          validator: (code) => code.contains('split') && code.contains('reversed'),
        ),
      ],
    ),
    CodingChallenge(
      id: 'palindrome_check',
      title: 'Valid Palindrome Checker',
      difficulty: 'Easy',
      category: 'Strings',
      prompt:
          'Determine if a given string reads the exact same backwards as forwards (ignoring case and whitespace).',
      starterCode: '''bool isPalindrome(String text) {
  // Normalize text and check if it equals its reverse
  return false;
}

void main() {
  print(isPalindrome('Racecar'));
}''',
      solutionCode: '''bool isPalindrome(String text) {
  final clean = text.toLowerCase().replaceAll(' ', '');
  return clean == clean.split('').reversed.join('');
}''',
      hint: 'Clean the text using .toLowerCase(). Then compare it with clean.split(\'\').reversed.join(\'\').',
      testCases: [
        TestCase(
          inputDesc: '"Racecar"',
          expectedOutput: 'true',
          validator: (code) => code.contains('toLowerCase') && code.contains('reversed'),
        ),
        TestCase(
          inputDesc: '"flutter"',
          expectedOutput: 'false',
          validator: (code) => code.contains('reversed'),
        ),
      ],
    ),
    CodingChallenge(
      id: 'fizz_buzz',
      title: 'FizzBuzz Generator',
      difficulty: 'Easy',
      category: 'Logic',
      prompt:
          'Given an integer N, return a List<String> from 1 to N. For multiples of 3, output "Fizz", for multiples of 5, output "Buzz", and for both, "FizzBuzz".',
      starterCode: '''List<String> fizzBuzz(int n) {
  List<String> res = [];
  // Loop from 1 to n
  return res;
}''',
      solutionCode: '''List<String> fizzBuzz(int n) {
  List<String> res = [];
  for (int i = 1; i <= n; i++) {
    if (i % 15 == 0) res.add('FizzBuzz');
    else if (i % 3 == 0) res.add('Fizz');
    else if (i % 5 == 0) res.add('Buzz');
    else res.add('\$i');
  }
  return res;
}''',
      hint: 'Check i % 15 == 0 first (or both % 3 and % 5), then % 3, then % 5.',
      testCases: [
        TestCase(
          inputDesc: 'n = 5',
          expectedOutput: '["1", "2", "Fizz", "4", "Buzz"]',
          validator: (code) =>
              code.contains('Fizz') && code.contains('Buzz') && code.contains('%'),
        ),
        TestCase(
          inputDesc: 'n = 15 contains "FizzBuzz"',
          expectedOutput: 'true',
          validator: (code) => code.contains('FizzBuzz'),
        ),
      ],
    ),
    CodingChallenge(
      id: 'even_squares',
      title: 'Filter & Square Evens',
      difficulty: 'Medium',
      category: 'Collections',
      prompt:
          'Given a List of integers, filter only the even numbers and return a new list containing their squared values.',
      starterCode: '''List<int> squareEvens(List<int> numbers) {
  // Use functional operators or a loop
  return [];
}''',
      solutionCode: '''List<int> squareEvens(List<int> numbers) {
  return numbers.where((n) => n % 2 == 0).map((n) => n * n).toList();
}''',
      hint: 'Chain .where((n) => n.isEven) with .map((n) => n * n).toList().',
      testCases: [
        TestCase(
          inputDesc: '[1, 2, 3, 4, 5, 6]',
          expectedOutput: '[4, 16, 36]',
          validator: (code) =>
              (code.contains('where') && code.contains('map')) ||
              (code.contains('for') && code.contains('*')),
        ),
      ],
    ),
    CodingChallenge(
      id: 'two_sum',
      title: 'Two Sum Target Indices',
      difficulty: 'Medium',
      category: 'Algorithms',
      prompt:
          'Given a list of integers and a target sum, return the indices of the two numbers that add up to target. Return null or empty list if no pair exists.',
      starterCode: '''List<int>? twoSum(List<int> nums, int target) {
  // Fast map lookup or two-pointer approach
  return null;
}''',
      solutionCode: '''List<int>? twoSum(List<int> nums, int target) {
  Map<int, int> map = {};
  for (int i = 0; i < nums.length; i++) {
    int complement = target - nums[i];
    if (map.containsKey(complement)) {
      return [map[complement]!, i];
    }
    map[nums[i]] = i;
  }
  return null;
}''',
      hint: 'Store each number and its index in a Map<int, int>. Check if target - num exists.',
      testCases: [
        TestCase(
          inputDesc: 'nums: [2, 7, 11, 15], target: 9',
          expectedOutput: '[0, 1]',
          validator: (code) =>
              (code.contains('Map') && code.contains('target')) ||
              (code.contains('for') && code.contains('nums')),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('CodingChallengesScreen');
    _activeChallenge = _challenges.first;
    _codeController = TextEditingController(text: _activeChallenge.starterCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _switchChallenge(CodingChallenge challenge) {
    setState(() {
      _activeChallenge = challenge;
      _codeController.text = challenge.starterCode;
      _testResults.clear();
      _showSolution = false;
    });
  }

  void _runTests() async {
    setState(() {
      _isRunningTests = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    final code = _codeController.text;

    final Map<int, bool?> results = {};
    for (int i = 0; i < _activeChallenge.testCases.length; i++) {
      final tc = _activeChallenge.testCases[i];
      final passed = tc.validator(code);
      results[i] = passed;
    }

    setState(() {
      _testResults = results;
      _isRunningTests = false;
    });

    final allPassed = results.values.every((v) => v == true);
    if (allPassed) {
      Get.snackbar(
        'All Tests Passed! 🚀',
        'Excellent work solving "${_activeChallenge.title}"!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Tests Incomplete',
        'Some test conditions did not pass. Check the hint for guidance.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
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
            const Icon(Icons.code_rounded, color: Color(0xFF11998E), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Coding Challenges',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Challenge selector chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: _challenges.map((c) {
                final isSel = c.id == _activeChallenge.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(c.title),
                    selected: isSel,
                    selectedColor: primary.withValues(alpha: 0.2),
                    checkmarkColor: primary,
                    onSelected: (_) => _switchChallenge(c),
                  ),
                );
              }).toList(),
            ),
          ),

          // Main editor & tests area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Problem Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _activeChallenge.difficulty == 'Easy'
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : Colors.orange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _activeChallenge.difficulty,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _activeChallenge.difficulty == 'Easy'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _activeChallenge.category,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.lightbulb_outline_rounded, size: 20),
                            tooltip: 'Hint',
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Hint 💡',
                                middleText: _activeChallenge.hint,
                                textConfirm: 'Got it',
                                confirmTextColor: Colors.white,
                                onConfirm: () => Get.back(),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _activeChallenge.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _activeChallenge.prompt,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Code Editor Box
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF14141E) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade200,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Row(
                          children: [
                            const Text('solution.dart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              tooltip: 'Reset Code',
                              onPressed: () {
                                _codeController.text = _activeChallenge.starterCode;
                                setState(() => _testResults.clear());
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 18),
                              tooltip: 'Copy Code',
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _codeController.text));
                                Get.snackbar('Copied', 'Code copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _codeController,
                          maxLines: null,
                          minLines: 7,
                          keyboardType: TextInputType.multiline,
                          style: GoogleFonts.firaCode(
                            fontSize: 13,
                            color: isDark ? const Color(0xFFE0E6ED) : const Color(0xFF1E293B),
                            height: 1.5,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Test Cases Section
                Text(
                  'Test Cases',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...List.generate(_activeChallenge.testCases.length, (i) {
                  final tc = _activeChallenge.testCases[i];
                  final result = _testResults[i];

                  Color statusColor = Colors.grey;
                  IconData statusIcon = Icons.radio_button_unchecked_rounded;
                  String statusText = 'Not run';

                  if (result == true) {
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle_rounded;
                    statusText = 'PASSED';
                  } else if (result == false) {
                    statusColor = Colors.red;
                    statusIcon = Icons.cancel_rounded;
                    statusText = 'FAILED';
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: result != null ? statusColor : (isDark ? Colors.white12 : Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, color: statusColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Input: ${tc.inputDesc}',
                                style: GoogleFonts.firaCode(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Expected: ${tc.expectedOutput}',
                                style: GoogleFonts.firaCode(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // Action buttons: Run Tests & Show Solution
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isRunningTests ? null : _runTests,
                        icon: _isRunningTests
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.play_arrow_rounded),
                        label: Text(_isRunningTests ? 'Evaluating...' : 'Run Tests'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _showSolution = !_showSolution),
                      icon: Icon(_showSolution ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                      label: Text(_showSolution ? 'Hide Solution' : 'Solution'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),

                if (_showSolution) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10231B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Optimal Solution:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, color: Colors.green, size: 16),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _activeChallenge.solutionCode));
                                Get.snackbar('Copied', 'Solution copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                              },
                            ),
                          ],
                        ),
                        SelectableText(
                          _activeChallenge.solutionCode,
                          style: GoogleFonts.firaCode(color: const Color(0xFFB5EAD7), fontSize: 12, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
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
