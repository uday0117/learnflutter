import '../models/tutorial_model.dart';

class FlutterBasicsData {
  static List<TutorialModel> getAllTutorials() {
    return [
      TutorialModel(
        id: 'fb1',
        categoryId: '1',
        title: 'Introduction to Flutter',
        description: 'Learn what Flutter is and why it\'s revolutionary',
        content: '''
# Introduction to Flutter

Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, and the web from a single codebase.

## Key Features:

• **Fast Development**: Hot reload helps you quickly experiment, build UIs, add features, and fix bugs
• **Expressive UI**: Beautiful, customizable widgets that can be composed to create stunning UIs
• **Native Performance**: Flutter code compiles to ARM or Intel machine code ensuring fast performance
• **Single Codebase**: Write once, deploy everywhere - iOS, Android, Web, Desktop

## Why Choose Flutter?

1. **Productivity**: Build apps faster with hot reload and rich widget catalog
2. **Beautiful UIs**: Create custom designs that users love
3. **Native Performance**: No bridge between app and platform
4. **Strong Community**: Growing ecosystem with extensive packages
        ''',
        keyPoints: [
          'Cross-platform development framework',
          'Created by Google',
          'Uses Dart programming language',
          'Hot reload for fast development',
          'Rich widget library',
          'Native performance',
        ],
      ),
      TutorialModel(
        id: 'fb2',
        categoryId: '1',
        title: 'Installation Guide',
        description: 'Step-by-step guide to install Flutter',
        content: r'''
# Flutter Installation Guide

## System Requirements

### Windows
- Windows 10 or later (64-bit)
- Disk Space: 2.8 GB
- Git for Windows

### macOS
- macOS 10.14 or later
- Disk Space: 2.8 GB
- Xcode (for iOS development)

### Linux
- 64-bit distribution
- Disk Space: 600 MB

## Installation Steps

### 1. Download Flutter SDK
Download the latest stable release from [flutter.dev](https://flutter.dev)

### 2. Extract the File
Extract the downloaded file to desired location:
- Windows: C:\src\flutter
- macOS/Linux: ~/development/flutter

### 3. Add to PATH
Add Flutter to your system PATH:

**macOS/Linux:**
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

**Windows:**
Add flutter\bin to system PATH in Environment Variables

### 4. Run Flutter Doctor
```bash
flutter doctor
```

This command checks your environment and displays a report of the status of your Flutter installation.

### 5. Install Missing Dependencies
Follow the recommendations from flutter doctor to install:
- Android Studio (for Android development)
- Xcode (for iOS development - macOS only)
- VS Code or Android Studio plugins

### 6. Setup IDE
Install Flutter and Dart plugins in:
- Android Studio
- VS Code
- IntelliJ IDEA

## Verify Installation

```bash
flutter --version
flutter doctor -v
```
        ''',
        keyPoints: [
          'Download Flutter SDK',
          'Extract and add to PATH',
          'Run flutter doctor',
          'Install required dependencies',
          'Setup IDE with plugins',
          'Verify installation',
        ],
      ),
      TutorialModel(
        id: 'fb3',
        categoryId: '1',
        title: 'Project Structure',
        description: 'Understanding Flutter project structure',
        content: '''
# Flutter Project Structure

When you create a new Flutter project, it generates a specific folder structure:

## Root Level Files

- **pubspec.yaml**: Project configuration, dependencies, assets
- **analysis_options.yaml**: Linter rules and static analysis
- **README.md**: Project documentation

## Folders

### /lib
Contains all Dart code for your application
- **main.dart**: Entry point of the application

### /android
Android-specific code and configurations
- build.gradle: Build configuration
- AndroidManifest.xml: App permissions and settings

### /ios
iOS-specific code and configurations
- Info.plist: iOS app configuration
- Podfile: CocoaPods dependencies

### /web
Web-specific files
- index.html: Web entry point

### /test
Unit and widget tests

### /assets
Images, fonts, and other static resources

## Key Files

### pubspec.yaml
```yaml
name: my_app
description: A new Flutter project.

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

### main.dart
Entry point of every Flutter application:
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
```

## Best Practices

1. Organize code into separate folders (models, views, controllers)
2. Keep business logic separate from UI
3. Use meaningful file and folder names
4. Follow Dart naming conventions
5. Maintain clean project structure as app grows
        ''',
        keyPoints: [
          'lib/ contains Dart code',
          'pubspec.yaml manages dependencies',
          'Platform-specific folders for each target',
          'assets/ for static resources',
          'test/ for unit and widget tests',
          'main.dart is entry point',
        ],
      ),
      TutorialModel(
        id: 'fb4',
        categoryId: '1',
        title: 'Dart Basics',
        description: 'Learn Dart programming fundamentals',
        content: r'''
# Dart Basics

Dart is the programming language used by Flutter. It's easy to learn, especially if you know Java, JavaScript, or C#.

## Variables

```dart
// Type inference
var name = 'Flutter';
var year = 2024;

// Explicit types
String language = 'Dart';
int version = 3;
double pi = 3.14;
bool isAwesome = true;

// Final and const
final String country = 'USA'; // Runtime constant
const double gravity = 9.8;   // Compile-time constant
```

## Data Types

```dart
// Numbers
int age = 25;
double height = 5.9;

// Strings
String firstName = 'John';
String lastName = "Doe";
String fullName = '$firstName $lastName'; // String interpolation

// Booleans
bool isLoggedIn = true;

// Lists
List<String> fruits = ['Apple', 'Banana', 'Orange'];
var numbers = [1, 2, 3, 4, 5];

// Maps
Map<String, int> ages = {
  'John': 25,
  'Jane': 30,
};
```

## Functions

```dart
// Basic function
void greet(String name) {
  print('Hello, $name!');
}

// Function with return type
String getMessage(String name) {
  return 'Hello, $name!';
}

// Arrow function (single expression)
int add(int a, int b) => a + b;

// Optional parameters
void printInfo(String name, [int? age]) {
  print('Name: $name');
  if (age != null) print('Age: $age');
}

// Named parameters
void createUser({required String name, int age = 0}) {
  print('User: $name, Age: $age');
}
```

## Control Flow

```dart
// If-else
if (age >= 18) {
  print('Adult');
} else {
  print('Minor');
}

// For loop
for (var i = 0; i < 5; i++) {
  print(i);
}

// For-in loop
for (var fruit in fruits) {
  print(fruit);
}

// While loop
while (count < 10) {
  count++;
}

// Switch
switch (grade) {
  case 'A':
    print('Excellent');
    break;
  case 'B':
    print('Good');
    break;
  default:
    print('Keep trying');
}
```

## Classes

```dart
class Person {
  String name;
  int age;
  
  // Constructor
  Person(this.name, this.age);
  
  // Named constructor
  Person.guest() : name = 'Guest', age = 0;
  
  // Method
  void introduce() {
    print('I am $name, $age years old');
  }
}

// Usage
var person = Person('John', 25);
person.introduce();
```

## Null Safety

```dart
// Nullable type
String? nullableName;

// Non-nullable type
String nonNullName = 'Flutter';

// Null-aware operators
String? name;
String displayName = name ?? 'Guest';  // Default value
print(name?.length);  // Safe navigation
name ??= 'Default';   // Assign if null
```
        ''',
        codeExample: r'''
void main() {
  // Variables
  var appName = 'Learn Flutter';
  int lessons = 100;
  
  // Function
  String greet(String name) {
    return 'Welcome to $appName, $name!';
  }
  
  // Class
  class Student {
    String name;
    int age;
    
    Student(this.name, this.age);
    
    void study() {
      print('$name is studying Flutter!');
    }
  }
  
  // Usage
  print(greet('Developer'));
  
  var student = Student('John', 25);
  student.study();
  
  // Lists
  List<String> topics = ['Widgets', 'State', 'Navigation'];
  for (var topic in topics) {
    print('Learning: $topic');
  }
}
''',
        keyPoints: [
          'Variables: var, final, const',
          'Data types: int, double, String, bool',
          'Collections: List, Map, Set',
          'Functions with optional and named parameters',
          'Classes and objects',
          'Null safety with ? operator',
        ],
      ),
      TutorialModel(
        id: 'fb5',
        categoryId: '1',
        title: 'StatelessWidget',
        description: 'Learn about immutable widgets',
        content: '''
# StatelessWidget

A StatelessWidget is an immutable widget that describes part of the user interface. It doesn't maintain any state that might change during the widget's lifetime.

## When to Use StatelessWidget?

Use StatelessWidget when:
- The UI doesn't change dynamically
- No user interaction changes the widget
- Data is static or passed from parent

## Basic Structure

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello Flutter'),
    );
  }
}
```

## Key Concepts

### 1. Immutability
Once created, a StatelessWidget cannot change its properties.

### 2. Build Method
The build() method describes how to display the widget in terms of other widgets.

### 3. Constructor
Can accept parameters to customize the widget.

## Examples

### Simple StatelessWidget
```dart
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Welcome to Flutter!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text('Start building amazing apps'),
          ],
        ),
      ),
    );
  }
}
```

### StatelessWidget with Parameters
```dart
class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  
  const UserCard({
    Key? key,
    required this.name,
    required this.email,
    required this.imageUrl,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        subtitle: Text(email),
      ),
    );
  }
}

// Usage
UserCard(
  name: 'John Doe',
  email: 'john@example.com',
  imageUrl: 'https://example.com/avatar.jpg',
)
```

## Lifecycle

StatelessWidget has a simple lifecycle:
1. Constructor called
2. build() method called
3. Widget rendered
4. No state changes possible

## Best Practices

1. Use const constructors when possible
2. Keep widgets small and focused
3. Extract reusable widgets
4. Pass data through constructor parameters
5. Use for static content that doesn't change
        ''',
        codeExample: '''
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String title;
  final String description;
  
  const ProfileCard({
    Key? key,
    required this.name,
    required this.title,
    required this.description,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(description),
          ],
        ),
      ),
    );
  }
}

// Usage in another widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('StatelessWidget Example')),
        body: ProfileCard(
          name: 'John Doe',
          title: 'Flutter Developer',
          description: 'Passionate about building mobile apps',
        ),
      ),
    );
  }
}
''',
        keyPoints: [
          'Immutable widget',
          'No internal state',
          'Rebuilds only when parent rebuilds',
          'Use for static content',
          'Simple lifecycle',
          'Better performance for static UIs',
        ],
      ),
      TutorialModel(
        id: 'fb6',
        categoryId: '1',
        title: 'StatefulWidget',
        description: 'Learn about widgets with mutable state',
        content: r'''
# StatefulWidget

A StatefulWidget is a widget that has mutable state. It can change its appearance in response to events triggered by user interactions or when it receives data.

## When to Use StatefulWidget?

Use StatefulWidget when:
- The UI changes based on user interaction
- Widget needs to maintain state
- Data changes over time
- Animation or timer is involved

## Basic Structure

```dart
class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // State variables
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Counter: $_counter'),
    );
  }
}
```

## Key Concepts

### 1. Two Classes
- StatefulWidget: Immutable widget definition
- State: Mutable state logic

### 2. setState()
Updates the state and triggers rebuild:
```dart
setState(() {
  _counter++;
});
```

### 3. Lifecycle Methods

```dart
class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Called once when widget is created
    print('Widget initialized');
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called when dependencies change
  }
  
  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Called when widget configuration changes
  }
  
  @override
  void dispose() {
    // Clean up resources
    print('Widget disposed');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## Complete Example

```dart
class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);
  
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Counter Value:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrementCounter,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## Lifecycle Flow

1. **Constructor**: Widget created
2. **initState()**: Initialize state
3. **didChangeDependencies()**: Dependencies ready
4. **build()**: Widget rendered
5. **didUpdateWidget()**: Widget updated
6. **setState()**: State changes, triggers rebuild
7. **dispose()**: Widget removed, cleanup

## Best Practices

1. Keep State class private (prefix with _)
2. Call setState() only when necessary
3. Avoid expensive operations in build()
4. Clean up resources in dispose()
5. Use const widgets where possible
6. Consider state management solutions for complex apps

## StatelessWidget vs StatefulWidget

| StatelessWidget | StatefulWidget |
|----------------|----------------|
| Immutable | Mutable state |
| No setState() | Has setState() |
| Simple lifecycle | Complex lifecycle |
| Better performance | Slightly slower |
| Static content | Dynamic content |
        ''',
        codeExample: '''
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);
  
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todos = [];
  final TextEditingController _controller = TextEditingController();
  
  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(_controller.text);
        _controller.clear();
      });
    }
  }
  
  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter todo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todos[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTodo(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
''',
        keyPoints: [
          'Has mutable state',
          'Two classes: Widget and State',
          'setState() triggers rebuild',
          'Complex lifecycle',
          'Use for dynamic content',
          'Clean up in dispose()',
        ],
      ),
    ];
  }
}
