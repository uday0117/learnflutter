import '../models/app_models.dart';

class AppData {
  static List<Category> getCategories() {
    return [
      Category(
        id: '1',
        title: 'Dart Basics',
        description: 'Learn Dart fundamentals from scratch',
        icon: '🎯',
        color: '#02569B',
        route: '/dart-basics',
      ),
      Category(
        id: '2',
        title: 'Flutter Basics',
        description: 'Master Flutter core concepts',
        icon: '📱',
        color: '#13B9FD',
        route: '/flutter-basics',
      ),
      Category(
        id: '3',
        title: 'Widget Reference',
        description: 'Complete widget catalog with examples',
        icon: '🧩',
        color: '#54C5F8',
        route: '/widgets',
      ),
      Category(
        id: '4',
        title: 'UI Examples',
        description: 'Beautiful UI screens with code',
        icon: '🎨',
        color: '#00897B',
        route: '/ui-examples',
      ),
      Category(
        id: '5',
        title: 'Interview Q&A',
        description: 'Prepare for Flutter interviews',
        icon: '💡',
        color: '#E53935',
        route: '/interview',
      ),
      Category(
        id: '6',
        title: 'Learning Path',
        description: 'Curated roadmap to mastery',
        icon: '🗺️',
        color: '#8E24AA',
        route: '/learning-path',
      ),
      Category(
        id: '7',
        title: 'Code Challenges',
        description: 'Practice with coding exercises',
        icon: '⚡',
        color: '#FF6F00',
        route: '/challenges',
      ),
    ];
  }
  
  // Example: Dart Basics Topics (Template for other categories)
  static List<Topic> getDartBasicsTopics() {
    return [
      Topic(
        id: 'dart_1',
        categoryId: '1',
        title: 'Variables & Data Types',
        description: 'Learn about Dart variables and data types',
        difficulty: 'beginner',
        content: '''
# Variables & Data Types in Dart

Dart is a strongly typed language. Every variable has a type.

## Variable Declaration

You can declare variables in several ways:

### Using var
When you use `var`, Dart infers the type:
```dart
var name = 'John';  // String
var age = 25;       // int
```

### Explicit Type
You can explicitly specify the type:
```dart
String name = 'John';
int age = 25;
double height = 5.9;
bool isStudent = true;
```

### Using dynamic
Use `dynamic` when the type can change:
```dart
dynamic value = 'Hello';
value = 42;  // OK
```

## Basic Data Types

- **int**: Integer numbers (42, -10)
- **double**: Floating-point numbers (3.14, -0.5)
- **String**: Text ('Hello', "World")
- **bool**: Boolean (true, false)
- **List**: Ordered collection
- **Map**: Key-value pairs
- **Set**: Unordered collection of unique items

## Null Safety

Dart supports null safety. By default, variables cannot be null:
```dart
String name = null;  // ERROR
String? name = null;  // OK (nullable)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Basic Variables',
            language: 'dart',
            code: '''void main() {
  // Integer
  int age = 25;
  
  // Double
  double price = 19.99;
  
  // String
  String name = 'Flutter Dev';
  
  // Boolean
  bool isActive = true;
  
  // Print values
  print('Name: \$name');
  print('Age: \$age');
  print('Price: \$price');
  print('Active: \$isActive');
}''',
            explanation: 'Demonstrates basic variable declaration and usage',
          ),
          CodeExample(
            title: 'Null Safety Example',
            language: 'dart',
            code: '''void main() {
  // Non-nullable String
  String name = 'John';
  // name = null; // ERROR!
  
  // Nullable String
  String? nickname;
  nickname = null; // OK
  nickname = 'Johnny'; // OK
  
  // Safe access
  print(nickname?.length); // Safe: returns null if nickname is null
  print(nickname ?? 'No nickname'); // Provides default if null
}''',
            explanation: 'Shows Dart null safety features',
          ),
        ],
      ),
      // Add more topics here following the same pattern
    ];
  }
}
