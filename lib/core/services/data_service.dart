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
      Topic(
        id: 'dart_2',
        categoryId: '1',
        title: 'Functions & Parameters',
        description: 'Master Dart functions and parameter types',
        difficulty: 'beginner',
        content: '''
# Functions & Parameters

Functions are reusable blocks of code that perform specific tasks.

## Function Syntax

```dart
returnType functionName(parameters) {
  // Function body
  return value;
}
```

## Types of Parameters

### Required Positional Parameters
```dart
void greet(String name, int age) {
  print('Hello \$name, age \$age');
}
```

### Optional Positional Parameters
```dart
void greet(String name, [int? age]) {
  print('Hello \$name');
}
```

### Named Parameters
```dart
void greet({required String name, int age = 18}) {
  print('Hello \$name, age \$age');
}
```

## Arrow Functions

For single-expression functions:
```dart
int add(int a, int b) => a + b;
```

## Anonymous Functions

```dart
var list = ['a', 'b', 'c'];
list.forEach((item) {
  print(item);
});
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Function Types',
            language: 'dart',
            code: '''void main() {
  // Regular function
  print(add(5, 3));
  
  // Named parameters
  greetPerson(name: 'Alice', age: 25);
  
  // Optional parameters
  printInfo('Bob');
}

int add(int a, int b) {
  return a + b;
}

void greetPerson({required String name, int age = 18}) {
  print('Hello \$name, you are \$age years old');
}

void printInfo(String name, [String? city]) {
  if (city != null) {
    print('\$name from \$city');
  } else {
    print(name);
  }
}''',
            explanation: 'Demonstrates different function types and parameters',
          ),
        ],
      ),
      Topic(
        id: 'dart_3',
        categoryId: '1',
        title: 'Classes & Objects',
        description: 'Object-oriented programming in Dart',
        difficulty: 'beginner',
        content: '''
# Classes & Objects

Classes are blueprints for creating objects.

## Class Definition

```dart
class Person {
  String name;
  int age;
  
  // Constructor
  Person(this.name, this.age);
  
  // Method
  void introduce() {
    print('Hi, I\\'m \$name, \$age years old');
  }
}
```

## Constructors

### Default Constructor
```dart
Person(this.name, this.age);
```

### Named Constructor
```dart
Person.guest() : name = 'Guest', age = 0;
```

### Factory Constructor
```dart
factory Person.fromJson(Map<String, dynamic> json) {
  return Person(json['name'], json['age']);
}
```

## Getters and Setters

```dart
class Rectangle {
  double width, height;
  
  Rectangle(this.width, this.height);
  
  double get area => width * height;
  
  set dimensions(List<double> values) {
    width = values[0];
    height = values[1];
  }
}
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Complete Class Example',
            language: 'dart',
            code: '''void main() {
  // Create objects
  var person1 = Person('Alice', 25);
  person1.introduce();
  
  var person2 = Person.guest();
  person2.introduce();
  
  // Using getters
  var rect = Rectangle(5, 3);
  print('Area: \${rect.area}');
}

class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  Person.guest() : name = 'Guest', age = 0;
  
  void introduce() {
    print('Hi, I\\'m \$name, \$age years old');
  }
}

class Rectangle {
  double width, height;
  
  Rectangle(this.width, this.height);
  
  double get area => width * height;
}''',
            explanation: 'Shows class creation, constructors, and methods',
          ),
        ],
      ),
      Topic(
        id: 'dart_4',
        categoryId: '1',
        title: 'Collections (List, Set, Map)',
        description: 'Work with Dart collections',
        difficulty: 'beginner',
        content: '''
# Collections in Dart

Dart provides three main collection types.

## List

Ordered collection of items:
```dart
var numbers = [1, 2, 3, 4, 5];
List<String> names = ['Alice', 'Bob'];
```

Common operations:
- `add()`, `insert()`, `remove()`
- `length`, `isEmpty`, `isNotEmpty`
- `first`, `last`, `contains()`
- `map()`, `where()`, `fold()`

## Set

Unordered collection of unique items:
```dart
var uniqueNumbers = {1, 2, 3, 2}; // {1, 2, 3}
Set<String> tags = {'flutter', 'dart'};
```

## Map

Key-value pairs:
```dart
var user = {
  'name': 'Alice',
  'age': 25,
  'city': 'NYC'
};
Map<String, int> scores = {'Alice': 95, 'Bob': 87};
```

Common operations:
- `keys`, `values`, `entries`
- `containsKey()`, `containsValue()`
- `putIfAbsent()`, `remove()`
        ''',
        codeExamples: [
          CodeExample(
            title: 'Collections in Action',
            language: 'dart',
            code: '''void main() {
  // List
  var fruits = ['Apple', 'Banana', 'Orange'];
  fruits.add('Mango');
  print('Fruits: \$fruits');
  print('First: \${fruits.first}, Last: \${fruits.last}');
  
  // Set
  var numbers = {1, 2, 3, 2, 4, 5};
  print('Unique numbers: \$numbers');
  
  // Map
  var person = {
    'name': 'Alice',
    'age': 25,
    'city': 'NYC'
  };
  print('Name: \${person['name']}');
  
  // List operations
  var doubled = fruits.map((f) => f.toUpperCase()).toList();
  print('Uppercase: \$doubled');
  
  var filtered = numbers.where((n) => n > 2).toList();
  print('Greater than 2: \$filtered');
}''',
            explanation: 'Demonstrates List, Set, and Map with operations',
          ),
        ],
      ),
      Topic(
        id: 'dart_5',
        categoryId: '1',
        title: 'Async/Await & Futures',
        description: 'Asynchronous programming in Dart',
        difficulty: 'intermediate',
        content: '''
# Asynchronous Programming

Handle time-consuming operations without blocking the main thread.

## Future

Represents a value that will be available in the future:
```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data loaded';
}
```

## async & await

- `async`: Marks a function as asynchronous
- `await`: Waits for a Future to complete

```dart
Future<void> loadData() async {
  print('Loading...');
  String data = await fetchData();
  print(data);
}
```

## Error Handling

```dart
try {
  String data = await fetchData();
  print(data);
} catch (e) {
  print('Error: \$e');
}
```

## Future Methods

- `Future.then()`: Execute code when complete
- `Future.catchError()`: Handle errors
- `Future.whenComplete()`: Always execute
- `Future.wait()`: Wait for multiple Futures
        ''',
        codeExamples: [
          CodeExample(
            title: 'Async/Await Example',
            language: 'dart',
            code: '''void main() async {
  print('Start');
  
  await loadUserData();
  
  print('End');
}

Future<void> loadUserData() async {
  try {
    print('Fetching user...');
    var user = await fetchUser();
    print('User: \$user');
    
    print('Fetching posts...');
    var posts = await fetchPosts();
    print('Posts: \$posts');
  } catch (e) {
    print('Error: \$e');
  }
}

Future<String> fetchUser() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Alice';
}

Future<int> fetchPosts() async {
  await Future.delayed(Duration(seconds: 1));
  return 42;
}''',
            explanation: 'Shows async/await with error handling',
          ),
        ],
      ),
      Topic(
        id: 'dart_6',
        categoryId: '1',
        title: 'Null Safety Deep Dive',
        description: 'Master Dart null safety features',
        difficulty: 'intermediate',
        content: '''
# Null Safety in Dart

Dart's null safety prevents null reference errors at compile time.

## Non-Nullable by Default

```dart
String name = 'Alice';  // Cannot be null
int age = 25;           // Cannot be null
```

## Nullable Types

Add `?` to allow null:
```dart
String? nickname;  // Can be null
int? score;        // Can be null
```

## Null Safety Operators

### Null-aware access (?.)
```dart
String? name;
print(name?.length);  // Returns null if name is null
```

### Null-coalescing (??)
```dart
String? name;
print(name ?? 'Guest');  // Use default if null
```

### Null assertion (!)
```dart
String? name = getName();
print(name!.length);  // Assert not null (throws if null)
```

### Null-aware assignment (??=)
```dart
String? name;
name ??= 'Default';  // Assign only if null
```

## Late Variables

Declare non-nullable variables that are initialized later:
```dart
late String description;

void initialize() {
  description = 'Hello';
}
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Null Safety Operators',
            language: 'dart',
            code: '''void main() {
  String? nullableName;
  String name = 'Alice';
  
  // Null-aware access
  print(nullableName?.length);  // null
  print(name.length);           // 5
  
  // Null-coalescing
  print(nullableName ?? 'Guest');  // Guest
  
  // Null-aware assignment
  nullableName ??= 'Bob';
  print(nullableName);  // Bob
  
  // Late variable
  late String description;
  description = 'Late initialized';
  print(description);
  
  // Cascades with null safety
  Person? person = Person('Alice', 25);
  person
    ?..name = 'Updated'
    ..introduce();
}

class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  void introduce() {
    print('\$name, \$age');
  }
}''',
            explanation: 'Demonstrates all null safety operators',
          ),
        ],
      ),
      Topic(
        id: 'dart_7',
        categoryId: '1',
        title: 'Streams & Stream Controllers',
        description: 'Work with continuous data flows',
        difficulty: 'advanced',
        content: '''
# Streams in Dart

Streams provide a sequence of asynchronous events.

## Creating Streams

```dart
Stream<int> countStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
```

## Listening to Streams

```dart
stream.listen((data) {
  print(data);
});
```

## Stream Types

- **Single-subscription**: Only one listener allowed
- **Broadcast**: Multiple listeners allowed

## StreamController

```dart
var controller = StreamController<int>();
controller.stream.listen((data) => print(data));
controller.add(1);
controller.add(2);
controller.close();
```

## Stream Operators

- `map()`: Transform data
- `where()`: Filter data
- `take()`: Limit items
- `asyncMap()`: Async transformation
        ''',
        codeExamples: [
          CodeExample(
            title: 'Stream Example',
            language: 'dart',
            code: '''void main() async {
  // Create and listen to stream
  await for (var value in countStream()) {
    print('Received: \$value');
  }
  
  // StreamController
  var controller = StreamController<String>();
  
  controller.stream
    .map((s) => s.toUpperCase())
    .listen((data) => print(data));
  
  controller.add('hello');
  controller.add('world');
  await controller.close();
}

Stream<int> countStream() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}''',
            explanation: 'Shows stream creation and stream controllers',
          ),
        ],
      ),
      Topic(
        id: 'dart_8',
        categoryId: '1',
        title: 'Exception Handling',
        description: 'Handle errors and exceptions properly',
        difficulty: 'beginner',
        content: '''
# Exception Handling

Properly handle runtime errors to prevent app crashes.

## Try-Catch

```dart
try {
  var result = 10 / 0;
} catch (e) {
  print('Error: \$e');
}
```

## Catching Specific Exceptions

```dart
try {
  // code
} on FormatException catch (e) {
  print('Format error: \$e');
} on Exception catch (e) {
  print('General error: \$e');
} catch (e) {
  print('Unknown error: \$e');
}
```

## Finally Block

Always executes:
```dart
try {
  // code
} catch (e) {
  print(e);
} finally {
  print('Cleanup');
}
```

## Throwing Exceptions

```dart
throw Exception('Something went wrong');
throw FormatException('Invalid format');
```

## Custom Exceptions

```dart
class CustomException implements Exception {
  final String message;
  CustomException(this.message);
  
  @override
  String toString() => 'CustomException: \$message';
}
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Exception Handling',
            language: 'dart',
            code: '''void main() {
  // Basic try-catch
  try {
    divide(10, 0);
  } catch (e) {
    print('Caught: \$e');
  }
  
  // Custom exception
  try {
    validateAge(-5);
  } on AgeException catch (e) {
    print(e);
  } finally {
    print('Validation complete');
  }
}

void divide(int a, int b) {
  if (b == 0) {
    throw Exception('Cannot divide by zero');
  }
  print(a / b);
}

void validateAge(int age) {
  if (age < 0) {
    throw AgeException('Age cannot be negative');
  }
  print('Valid age: \$age');
}

class AgeException implements Exception {
  final String message;
  AgeException(this.message);
  
  @override
  String toString() => 'AgeException: \$message';
}''',
            explanation: 'Demonstrates error handling with custom exceptions',
          ),
        ],
      ),
      Topic(
        id: 'dart_9',
        categoryId: '1',
        title: 'Inheritance & Mixins',
        description: 'Code reuse through inheritance and mixins',
        difficulty: 'intermediate',
        content: '''
# Inheritance & Mixins

## Inheritance

Classes can extend other classes:
```dart
class Animal {
  void eat() => print('Eating');
}

class Dog extends Animal {
  void bark() => print('Woof!');
}
```

## Override Methods

```dart
class Cat extends Animal {
  @override
  void eat() {
    print('Cat is eating');
  }
}
```

## Super Keyword

Call parent class methods:
```dart
class Cat extends Animal {
  @override
  void eat() {
    super.eat();
    print('Cat finished eating');
  }
}
```

## Mixins

Reuse code in multiple class hierarchies:
```dart
mixin Swimmer {
  void swim() => print('Swimming');
}

mixin Flyer {
  void fly() => print('Flying');
}

class Duck extends Animal with Swimmer, Flyer {
  // Duck can swim and fly
}
```

## Abstract Classes

Cannot be instantiated:
```dart
abstract class Shape {
  double area();  // Abstract method
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);
  
  @override
  double area() => 3.14 * radius * radius;
}
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Inheritance and Mixins',
            language: 'dart',
            code: '''void main() {
  var dog = Dog('Buddy');
  dog.eat();
  dog.bark();
  
  var duck = Duck('Donald');
  duck.eat();
  duck.swim();
  duck.fly();
  
  var circle = Circle(5);
  print('Circle area: \${circle.area()}');
}

class Animal {
  String name;
  Animal(this.name);
  
  void eat() => print('\$name is eating');
}

class Dog extends Animal {
  Dog(super.name);
  
  void bark() => print('\$name says Woof!');
}

mixin Swimmer {
  void swim() => print('Swimming');
}

mixin Flyer {
  void fly() => print('Flying');
}

class Duck extends Animal with Swimmer, Flyer {
  Duck(super.name);
}

abstract class Shape {
  double area();
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);
  
  @override
  double area() => 3.14 * radius * radius;
}''',
            explanation: 'Shows inheritance, mixins, and abstract classes',
          ),
        ],
      ),
      Topic(
        id: 'dart_10',
        categoryId: '1',
        title: 'Extension Methods',
        description: 'Add methods to existing classes',
        difficulty: 'intermediate',
        content: '''
# Extension Methods

Add functionality to existing classes without modifying them.

## Basic Extension

```dart
extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}

// Usage
'hello'.capitalize(); // 'Hello'
```

## Extensions with Generic Types

```dart
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

// Usage
[].firstOrNull; // null
```

## Extensions with Multiple Methods

```dart
extension NumberExtension on int {
  bool get isEven => this % 2 == 0;
  bool get isOdd => !isEven;
  int get squared => this * this;
}

// Usage
5.isOdd; // true
3.squared; // 9
```

## Extensions on Nullable Types

```dart
extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
```

## Why Use Extensions?

- Keep code organized
- Add utility methods to SDK classes
- Improve code readability
- Avoid helper classes
        ''',
        codeExamples: [
          CodeExample(
            title: 'Extension Methods',
            language: 'dart',
            code: '''void main() {
  // String extensions
  print('hello world'.capitalize()); // Hello world
  print('HELLO'.reverseCase());       // hello
  
  // Number extensions
  print(5.isEven);      // false
  print(4.squared);     // 16
  print(3.times(() => print('Hi'))); // Prints Hi 3 times
  
  // List extensions
  var numbers = [1, 2, 3];
  print(numbers.sum()); // 6
  
  var empty = <int>[];
  print(empty.firstOrNull); // null
}

extension StringExt on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
  
  String reverseCase() {
    return toLowerCase();
  }
}

extension IntExt on int {
  bool get isEven => this % 2 == 0;
  int get squared => this * this;
  
  void times(Function action) {
    for (var i = 0; i < this; i++) {
      action();
    }
  }
}

extension ListExt<T extends num> on List<T> {
  T sum() => isEmpty ? 0 as T : reduce((a, b) => (a + b) as T);
}

extension NullableListExt<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}''',
            explanation: 'Comprehensive extension methods examples',
          ),
        ],
      ),
    ];
  }

  // Flutter Basics Topics
  static List<Topic> getFlutterBasicsTopics() {
    return [
      Topic(
        id: 'flutter_1',
        categoryId: '2',
        title: 'StatelessWidget vs StatefulWidget',
        description: 'Understanding the two fundamental widget types',
        difficulty: 'beginner',
        content: '''
# StatelessWidget vs StatefulWidget

Flutter has two types of widgets for building UI.

## StatelessWidget

Immutable widgets that don't change over time:
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello');
  }
}
```

**Use when:**
- UI doesn't change after creation
- No user interaction needed
- Data is static

## StatefulWidget

Widgets that can change state:
```dart
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    return Text('\$count');
  }
}
```

**Use when:**
- UI changes based on user input
- Animations
- Data updates over time

## setState()

Update UI by calling setState():
```dart
void increment() {
  setState(() {
    count++;
  });
}
```

## Lifecycle Methods

- `initState()`: Called once when state is created
- `dispose()`: Clean up resources
- `didUpdateWidget()`: Called when widget configuration changes
        ''',
        codeExamples: [
          CodeExample(
            title: 'StatefulWidget Counter',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    print('Counter initialized');
  }

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '\$_count',
          style: const TextStyle(fontSize: 48),
        ),
        ElevatedButton(
          onPressed: _increment,
          child: const Text('Increment'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    print('Counter disposed');
    super.dispose();
  }
}''',
            explanation: 'Complete stateful widget with lifecycle methods',
          ),
        ],
      ),
      Topic(
        id: 'flutter_2',
        categoryId: '2',
        title: 'Layout Widgets (Row, Column, Stack)',
        description: 'Master Flutter layout fundamentals',
        difficulty: 'beginner',
        content: '''
# Layout Widgets

Flutter provides powerful widgets for arranging children.

## Column

Arrange widgets vertically:
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('First'),
    Text('Second'),
  ],
)
```

## Row

Arrange widgets horizontally:
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Icon(Icons.home),
    Text('Home'),
  ],
)
```

## Stack

Layer widgets on top of each other:
```dart
Stack(
  children: [
    Container(color: Colors.blue),
    Positioned(
      top: 10,
      left: 10,
      child: Text('Overlay'),
    ),
  ],
)
```

## MainAxisAlignment

- `start`, `end`, `center`
- `spaceBetween`, `spaceAround`, `spaceEvenly`

## CrossAxisAlignment

- `start`, `end`, `center`
- `stretch`, `baseline`

## Expanded & Flexible

Control how children fill available space:
```dart
Row(
  children: [
    Expanded(child: Container(color: Colors.red)),
    Flexible(child: Container(color: Colors.blue)),
  ],
)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Layout Example',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Demo')),
      body: Column(
        children: [
          // Row example
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.home, size: 40),
              Icon(Icons.favorite, size: 40),
              Icon(Icons.settings, size: 40),
            ],
          ),
          const SizedBox(height: 20),
          
          // Expanded in Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 50,
                  color: Colors.red,
                  child: const Center(child: Text('2x')),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  color: Colors.blue,
                  child: const Center(child: Text('1x')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Stack example
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Container(
                  color: Colors.grey[300],
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.orange,
                    child: const Text('Positioned'),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.star, size: 50),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}''',
            explanation:
                'Demonstrates Row, Column, Stack with Expanded and Positioned',
          ),
        ],
      ),
      Topic(
        id: 'flutter_3',
        categoryId: '2',
        title: 'Container, Padding, and Margin',
        description: 'Box model and styling basics',
        difficulty: 'beginner',
        content: '''
# Container, Padding, and Margin

## Container

The most versatile widget for styling:
```dart
Container(
  width: 200,
  height: 100,
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.symmetric(horizontal: 20),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Text('Hello'),
)
```

## Padding

Add space inside a widget:
```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: Text('Padded text'),
)
```

## EdgeInsets Types

- `EdgeInsets.all(16)`: Same on all sides
- `EdgeInsets.symmetric(horizontal: 20, vertical: 10)`
- `EdgeInsets.only(left: 10, top: 5)`
- `EdgeInsets.fromLTRB(10, 5, 10, 5)`

## BoxDecoration

Style containers:
```dart
BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.blue, width: 2),
  gradient: LinearGradient(
    colors: [Colors.blue, Colors.purple],
  ),
  boxShadow: [...],
)
```

## SizedBox

Fixed size spacer:
```dart
SizedBox(width: 20, height: 20)
const SizedBox(height: 10) // spacing
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Container Styling',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class ContainerDemo extends StatelessWidget {
  const ContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Basic container
            Container(
              width: 200,
              height: 100,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'Basic',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Styled container
            Container(
              width: 200,
              height: 100,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Styled',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}''',
            explanation: 'Shows Container styling with decoration and shadows',
          ),
        ],
      ),
      Topic(
        id: 'flutter_4',
        categoryId: '2',
        title: 'ListView and GridView',
        description: 'Scrollable lists and grids',
        difficulty: 'beginner',
        content: '''
# ListView and GridView

Display scrollable content efficiently.

## ListView

### Static List
```dart
ListView(
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
  ],
)
```

### ListView.builder
For dynamic/large lists:
```dart
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item \$index'),
    );
  },
)
```

### ListView.separated
With separators:
```dart
ListView.separated(
  itemCount: 10,
  itemBuilder: (context, index) => ListTile(title: Text('Item \$index')),
  separatorBuilder: (context, index) => Divider(),
)
```

## GridView

Display items in a grid:
```dart
GridView.count(
  crossAxisCount: 2,
  children: [
    Card(child: Center(child: Text('1'))),
    Card(child: Center(child: Text('2'))),
  ],
)
```

### GridView.builder
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: 20,
  itemBuilder: (context, index) {
    return Card(child: Center(child: Text('\$index')));
  },
)
```

## Performance

- Use `.builder()` for large lists
- Implement lazy loading
- Use `shrinkWrap: true` carefully
        ''',
        codeExamples: [
          CodeExample(
            title: 'ListView and GridView',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class ListGridDemo extends StatelessWidget {
  const ListGridDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List & Grid'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ListView'),
              Tab(text: 'GridView'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ListView Tab
            ListView.separated(
              itemCount: 20,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('\${index + 1}'),
                  ),
                  title: Text('Item \${index + 1}'),
                  subtitle: Text('Subtitle for item \${index + 1}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
            
            // GridView Tab
            GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: Center(
                    child: Text(
                      'Item \${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}''',
            explanation: 'Demonstrates ListView.separated and GridView.builder',
          ),
        ],
      ),
      Topic(
        id: 'flutter_5',
        categoryId: '2',
        title: 'Navigation & Routes',
        description: 'Navigate between screens',
        difficulty: 'intermediate',
        content: '''
# Navigation & Routes

Navigate between screens in Flutter.

## Basic Navigation

### Push to new screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondScreen()),
);
```

### Pop back
```dart
Navigator.pop(context);
```

## Passing Data

### Forward
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(data: 'Hello'),
  ),
);
```

### Backward
```dart
Navigator.pop(context, 'Result data');
```

## Named Routes

Define routes in MaterialApp:
```dart
MaterialApp(
  routes: {
    '/': (context) => HomeScreen(),
    '/details': (context) => DetailsScreen(),
  },
)
```

Navigate using names:
```dart
Navigator.pushNamed(context, '/details');
Navigator.pushReplacementNamed(context, '/home');
```

## Advanced Navigation

### Replace current screen
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

### Clear stack and push
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
  (route) => false,
);
```

## Page Transitions

Custom animations:
```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(opacity: animation, child: child);
  },
)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Navigation Example',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

void main() => runApp(const NavigationApp());

class NavigationApp extends StatelessWidget {
  const NavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        '/second': (context) => const SecondScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Navigate and wait for result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecondScreen(),
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Result: \$result')),
                  );
                }
              },
              child: const Text('Go to Second Screen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('Go to Second (Named)'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, 'Data from second screen');
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}''',
            explanation: 'Shows navigation with data passing and named routes',
          ),
        ],
      ),
    ];
  }

  // Widget Reference Topics
  static List<Topic> getWidgetReferenceTopics() {
    return [
      Topic(
        id: 'widget_1',
        categoryId: '3',
        title: 'Text & RichText',
        description: 'Display and style text in your app',
        difficulty: 'beginner',
        content: '''
# Text & RichText Widgets

Display styled text in Flutter applications.

## Text Widget

Basic text display:
```dart
Text(
  'Hello Flutter',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)
```

## Text Styling

```dart
TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  fontStyle: FontStyle.italic,
  color: Colors.red,
  backgroundColor: Colors.yellow,
  letterSpacing: 2.0,
  wordSpacing: 5.0,
  decoration: TextDecoration.underline,
  decorationColor: Colors.red,
  decorationStyle: TextDecorationStyle.dashed,
)
```

## Text Overflow

Handle long text:
```dart
Text(
  'Very long text...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

## RichText

Multiple styles in one text:
```dart
RichText(
  text: TextSpan(
    text: 'Hello ',
    style: TextStyle(color: Colors.black),
    children: [
      TextSpan(
        text: 'Flutter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    ],
  ),
)
```

## Text.rich

Simpler alternative:
```dart
Text.rich(
  TextSpan(
    children: [
      TextSpan(text: 'Normal '),
      TextSpan(
        text: 'Bold',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  ),
)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Text Styling Examples',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class TextDemo extends StatelessWidget {
  const TextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Widgets')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic text
            const Text(
              'Basic Text',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            
            // Styled text
            const Text(
              'Styled Text',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 20),
            
            // Text with overflow
            const Text(
              'This is a very long text that will overflow and show ellipsis',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            
            // RichText
            RichText(
              text: const TextSpan(
                text: 'Regular ',
                style: TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  TextSpan(
                    text: 'Bold ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Italic',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}''',
            explanation: 'Various text styling and RichText examples',
          ),
        ],
      ),
      Topic(
        id: 'widget_2',
        categoryId: '3',
        title: 'Button Widgets',
        description: 'ElevatedButton, TextButton, IconButton, etc.',
        difficulty: 'beginner',
        content: '''
# Button Widgets

Flutter provides various button types for user interactions.

## ElevatedButton

Material Design raised button:
```dart
ElevatedButton(
  onPressed: () {
    print('Pressed');
  },
  child: const Text('Click Me'),
)
```

## TextButton

Flat button without elevation:
```dart
TextButton(
  onPressed: () {},
  child: const Text('Text Button'),
)
```

## OutlinedButton

Button with an outline:
```dart
OutlinedButton(
  onPressed: () {},
  child: const Text('Outlined'),
)
```

## IconButton

Button with an icon:
```dart
IconButton(
  icon: const Icon(Icons.favorite),
  onPressed: () {},
)
```

## FloatingActionButton

Circular button:
```dart
FloatingActionButton(
  onPressed: () {},
  child: const Icon(Icons.add),
)
```

## Button Styling

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  onPressed: () {},
  child: const Text('Styled Button'),
)
```

## Button with Icon

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.send),
  label: const Text('Send'),
)
```

## Disabled State

Set onPressed to null:
```dart
ElevatedButton(
  onPressed: null,  // Disabled
  child: const Text('Disabled'),
)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Button Types',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button Widgets')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
              const SizedBox(height: 10),
              
              // TextButton
              TextButton(
                onPressed: () {},
                child: const Text('Text Button'),
              ),
              const SizedBox(height: 10),
              
              // OutlinedButton
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined Button'),
              ),
              const SizedBox(height: 10),
              
              // Styled button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text('Styled Button'),
              ),
              const SizedBox(height: 10),
              
              // Button with icon
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send),
                label: const Text('Send Message'),
              ),
              const SizedBox(height: 10),
              
              // IconButton
              IconButton(
                icon: const Icon(Icons.favorite),
                color: Colors.red,
                iconSize: 40,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}''',
            explanation: 'Demonstrates all button types with styling',
          ),
        ],
      ),
      Topic(
        id: 'widget_3',
        categoryId: '3',
        title: 'Image Widget',
        description: 'Display images from various sources',
        difficulty: 'beginner',
        content: '''
# Image Widget

Display images in your Flutter app.

## Image Sources

### From Assets
```dart
Image.asset('assets/images/logo.png')
```

### From Network
```dart
Image.network('https://example.com/image.jpg')
```

### From File
```dart
Image.file(File('/path/to/image.jpg'))
```

### From Memory
```dart
Image.memory(bytes)
```

## Image Properties

```dart
Image.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  alignment: Alignment.center,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator();
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
  },
)
```

## BoxFit Options

- `fill`: Stretch to fill
- `contain`: Fit within bounds
- `cover`: Fill bounds, may crop
- `fitWidth`: Fit width, may overflow height
- `fitHeight`: Fit height, may overflow width
- `none`: No scaling
- `scaleDown`: Same as contain but won't scale up

## CircleAvatar

Display circular images:
```dart
CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage('https://...'),
)
```

## ClipRRect

Rounded corners:
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.network('https://...'),
)
```

## FadeInImage

Placeholder while loading:
```dart
FadeInImage.assetNetwork(
  placeholder: 'assets/loading.gif',
  image: 'https://...',
)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Image Examples',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class ImageDemo extends StatelessWidget {
  const ImageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Widget')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Network image with loading
            Image.network(
              'https://picsum.photos/400/300',
              width: 300,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 300,
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // Rounded image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://picsum.photos/400/300?random=1',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            
            // Circle avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=1',
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=2',
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=3',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}''',
            explanation:
                'Shows network images, loading states, and circular avatars',
          ),
        ],
      ),
      Topic(
        id: 'widget_4',
        categoryId: '3',
        title: 'TextField & Form Widgets',
        description: 'Input fields and form validation',
        difficulty: 'intermediate',
        content: '''
# TextField & Form Widgets

Collect user input with text fields and forms.

## TextField

Basic text input:
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Name',
    hintText: 'Enter your name',
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(),
  ),
  onChanged: (value) {
    print(value);
  },
)
```

## TextFormField

TextField with validation:
```dart
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  },
)
```

## Form Widget

Wrap fields for validation:
```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(...),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Process data
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

## Input Decoration

Style text fields:
```dart
InputDecoration(
  labelText: 'Email',
  hintText: 'your@email.com',
  helperText: 'Enter a valid email',
  errorText: 'Invalid email',
  prefixIcon: Icon(Icons.email),
  suffixIcon: Icon(Icons.check),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  filled: true,
  fillColor: Colors.grey[200],
)
```

## TextEditingController

Control text field:
```dart
final controller = TextEditingController();

TextField(
  controller: controller,
)

// Get value
print(controller.text);

// Set value
controller.text = 'New value';

// Dispose
controller.dispose();
```

## Keyboard Types

```dart
TextField(
  keyboardType: TextInputType.emailAddress,
  // Other types: number, phone, url, multiline
)
```

## Input Actions

```dart
TextField(
  textInputAction: TextInputAction.next,
  onSubmitted: (value) {
    // Handle submission
  },
)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Form Example',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class FormDemo extends StatefulWidget {
  const FormDemo({super.key});

  @override
  State<FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Widgets')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'your@email.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}''',
            explanation: 'Complete form with validation and controllers',
          ),
        ],
      ),
      Topic(
        id: 'widget_5',
        categoryId: '3',
        title: 'Card & ListTile',
        description: 'Material design cards and list items',
        difficulty: 'beginner',
        content: '''
# Card & ListTile Widgets

Create material design cards and list items.

## Card

Material design card:
```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card Content'),
  ),
)
```

## Card Properties

```dart
Card(
  elevation: 8,
  shadowColor: Colors.blue,
  color: Colors.white,
  margin: EdgeInsets.all(10),
  clipBehavior: Clip.antiAlias,
  child: ...,
)
```

## ListTile

Pre-built list item:
```dart
ListTile(
  leading: Icon(Icons.person),
  title: Text('John Doe'),
  subtitle: Text('Developer'),
  trailing: Icon(Icons.arrow_forward),
  onTap: () {},
)
```

## ListTile Properties

```dart
ListTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage('...'),
  ),
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  trailing: Icon(Icons.more_vert),
  isThreeLine: true,
  dense: true,
  enabled: true,
  selected: false,
  onTap: () {},
  onLongPress: () {},
)
```

## Card with ListTile

Common pattern:
```dart
Card(
  child: ListTile(
    leading: Icon(Icons.album),
    title: Text('Song Name'),
    subtitle: Text('Artist Name'),
    trailing: Icon(Icons.play_arrow),
    onTap: () {},
  ),
)
```

## Styled Card

```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    side: BorderSide(
      color: Colors.blue,
      width: 2,
    ),
  ),
  child: ...,
)
```
        ''',
        codeExamples: [
          CodeExample(
            title: 'Card & ListTile Examples',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class CardDemo extends StatelessWidget {
  const CardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card & ListTile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Simple card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Simple Card',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('This is a simple card with some content.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Card with ListTile
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('John Doe'),
              subtitle: const Text('Flutter Developer'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),
          
          // Styled card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.info, size: 40, color: Colors.blue[700]),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('This is an informational card.'),
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
}''',
            explanation: 'Shows various card and list tile styles',
          ),
        ],
      ),
    ];
  }

  // UI Examples Topics
  static List<Topic> getUIExamplesTopics() {
    return [
      Topic(
        id: 'ui_1',
        categoryId: '4',
        title: 'Login Screen UI',
        description: 'Beautiful login screen with form validation',
        difficulty: 'beginner',
        content: '''
# Login Screen UI

Create a modern login screen with form validation.

## Features

- Email and password fields
- Form validation
- Password visibility toggle
- Responsive layout
- Loading state
- Error handling

## Key Components

### TextField with Validation
```dart
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (!value.contains('@')) {
      return 'Please enter valid email';
    }
    return null;
  },
)
```

### Password Field
```dart
TextFormField(
  obscureText: !_passwordVisible,
  decoration: InputDecoration(
    suffixIcon: IconButton(
      icon: Icon(
        _passwordVisible
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          _passwordVisible = !_passwordVisible;
        });
      },
    ),
  ),
)
```

### Submit Button with Loading
```dart
ElevatedButton(
  onPressed: _isLoading ? null : _handleLogin,
  child: _isLoading
      ? CircularProgressIndicator()
      : Text('Login'),
)
```

## Design Tips

- Use consistent spacing
- Add subtle shadows
- Consider dark mode
- Make buttons full-width on mobile
- Add social login options
- Include "Forgot Password?" link
        ''',
        codeExamples: [
          CodeExample(
            title: 'Complete Login Screen',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.flutter_dash,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 48),
                  
                  // Title
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to your account',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 48),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}''',
            explanation:
                'Complete login screen with validation and loading states',
          ),
        ],
      ),
      Topic(
        id: 'ui_2',
        categoryId: '4',
        title: 'Profile Screen',
        description: 'User profile with editable fields and avatar',
        difficulty: 'intermediate',
        content: '''
# Profile Screen UI

Create a user profile screen with editable information.

## Features

- Profile avatar
- User information display
- Editable fields
- Statistics cards
- Action buttons
- Settings options

## Layout Structure

```
SafeArea
└── SingleChildScrollView
    ├── Profile Header (Avatar + Name)
    ├── Statistics Row
    ├── Info Cards
    └── Action Buttons
```

## Profile Header

```dart
Column(
  children: [
    CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(userImage),
    ),
    SizedBox(height: 16),
    Text(userName, style: titleStyle),
    Text(userEmail, style: subtitleStyle),
  ],
)
```

## Statistics Cards

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _StatCard(title: 'Posts', value: '42'),
    _StatCard(title: 'Followers', value: '1.2K'),
    _StatCard(title: 'Following', value: '456'),
  ],
)
```

## Design Considerations

- Use Cards for grouped information
- Add proper spacing between sections
- Consider tablet/desktop layouts
- Add pull-to-refresh
- Implement edit mode
- Show loading states
        ''',
        codeExamples: [
          CodeExample(
            title: 'Profile Screen Example',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/200',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18),
                            color: Colors.white,
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            // Statistics
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn('Posts', '42'),
                  _buildStatColumn('Followers', '1.2K'),
                  _buildStatColumn('Following', '456'),
                ],
              ),
            ),
            
            // Info Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: '+1 234 567 8900',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Location',
                    value: 'San Francisco, CA',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.cake,
                    title: 'Birthday',
                    value: 'January 1, 1990',
                  ),
                ],
              ),
            ),
            
            // Action Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}''',
            explanation:
                'Complete profile screen with avatar, stats, and editable info',
          ),
        ],
      ),
      Topic(
        id: 'ui_3',
        categoryId: '4',
        title: 'Product Card Grid',
        description: 'E-commerce product listing with grid layout',
        difficulty: 'intermediate',
        content: '''
# Product Card Grid

Create an e-commerce product listing screen.

## Features

- Grid layout
- Product cards
- Images with placeholders
- Price and ratings
- Add to cart button
- Favorites toggle
- Search and filters

## GridView Setup

```dart
GridView.builder(
  padding: const EdgeInsets.all(16),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.7,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)
```

## Product Card Design

```dart
Card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image
      AspectRatio(
        aspectRatio: 1,
        child: Image.network(product.image, fit: BoxFit.cover),
      ),
      // Details
      Padding(
        child: Column(
          children: [
            Text(product.name),
            Row(
              children: [
                Text('\$\${product.price}'),
                Spacer(),
                Icon(Icons.star),
                Text(product.rating),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
)
```

## Best Practices

- Use cached images
- Implement lazy loading
- Add shimmer loading effect
- Handle empty states
- Optimize for different screen sizes
- Add pull-to-refresh
        ''',
        codeExamples: [
          CodeExample(
            title: 'Product Grid Example',
            language: 'dart',
            code: '''import 'package:flutter/material.dart';

class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = List.generate(
      20,
      (i) => {
        'id': i,
        'name': 'Product \${i + 1}',
        'price': (20 + i * 5).toString(),
        'rating': '4.\${i % 10}',
        'image': 'https://picsum.photos/200?random=\$i',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductCard(product: product);
        },
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.product['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\\\$\${widget.product['price']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(widget.product['rating']),
                      ],
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
}''',
            explanation:
                'Product grid with images, ratings, and favorite toggle',
          ),
        ],
      ),
    ];
  }

  // Interview Q&A Topics
  static List<Topic> getInterviewTopics() {
    return [
      Topic(
        id: 'interview_1',
        categoryId: '5',
        title: 'What is Flutter and why use it?',
        description: 'Fundamental understanding of Flutter',
        difficulty: 'beginner',
        content: '''
# What is Flutter and why use it?

## Answer:

Flutter is Google's open-source UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

### Key Advantages:

**1. Single Codebase**
- Write once, deploy everywhere (iOS, Android, Web, Desktop)
- Reduces development time and cost

**2. Hot Reload**
- See changes instantly without losing app state
- Dramatically speeds up development

**3. Rich Widget Library**
- Pre-built Material Design and Cupertino widgets
- Highly customizable

**4. Native Performance**
- Compiles to native ARM code
- No JavaScript bridge (unlike React Native)
- 60fps/120fps smooth animations

**5. Growing Community**
- Strong backing from Google
- Large ecosystem of packages
- Excellent documentation

### When to Use Flutter:

✅ Cross-platform mobile apps
✅ MVPs and prototypes
✅ Apps with custom UI
✅ Performance-critical apps

❌ Apps requiring heavy native integrations
❌ Very platform-specific features
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'interview_2',
        categoryId: '5',
        title: 'StatelessWidget vs StatefulWidget',
        description: 'Core difference between widget types',
        difficulty: 'beginner',
        content: '''
# StatelessWidget vs StatefulWidget

## StatelessWidget

Immutable widget that doesn't change after being built.

### When to Use:
- Static content that doesn't change
- UI depends only on constructor parameters
- No user interaction that changes state

### Example Use Cases:
- Text labels
- Icons
- Static images
- Structural layouts

## StatefulWidget

Mutable widget that can rebuild when state changes.

### When to Use:
- Interactive UI elements
- Content that changes over time
- User input handling
- Animated widgets

### Example Use Cases:
- Forms with text fields
- Checkboxes and switches
- Counters
- Lists that update

## Key Interview Points:

1. **Performance**: Stateless widgets are slightly more efficient
2. **State Management**: Stateful widgets maintain State object
3. **Lifecycle**: Stateful widgets have initState, dispose, etc.
4. **Rebuilding**: Stateful widgets can call setState() to rebuild
        ''',
        codeExamples: [
          CodeExample(
            title: 'StatelessWidget Example',
            language: 'dart',
            code: '''class Greeting extends StatelessWidget {
  final String name;
  
  const Greeting({Key? key, required this.name}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text('Hello, \$name!');
  }
}''',
            explanation: 'Simple immutable widget',
          ),
          CodeExample(
            title: 'StatefulWidget Example',
            language: 'dart',
            code: '''class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);
  
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;
  
  void _increment() {
    setState(() {
      count++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: \$count'),
        ElevatedButton(
          onPressed: _increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}''',
            explanation: 'Interactive widget with mutable state',
          ),
        ],
      ),
      Topic(
        id: 'interview_3',
        categoryId: '5',
        title: 'Explain Flutter Widget Tree',
        description: 'Understanding the widget hierarchy',
        difficulty: 'intermediate',
        content: '''
# Flutter Widget Tree

Flutter uses three trees to manage UI:

## 1. Widget Tree (Configuration)

- Immutable descriptions of UI
- Lightweight objects
- Rebuilt frequently
- Defines WHAT to display

## 2. Element Tree (Lifecycle)

- Manages widget lifecycle
- Links Widget and RenderObject trees
- Handles state
- Represents WHERE widgets are in the tree

## 3. RenderObject Tree (Rendering)

- Handles layout and painting
- Mutable and expensive
- Updated only when necessary
- Defines HOW to display

## Widget Build Process:

1. Widget created (immutable configuration)
2. Element created (links widget to render object)
3. RenderObject created (handles rendering)
4. setState() called
5. Widget rebuilt
6. Element compares old/new widgets
7. RenderObject updated if needed

## Interview Points:

- **Why three trees?** Separation of concerns - immutable config, mutable rendering
- **Performance**: Element tree reuses RenderObjects when possible
- **Keys**: Help Flutter identify which widgets changed
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'interview_4',
        categoryId: '5',
        title: 'What are Keys in Flutter?',
        description: 'When and why to use keys',
        difficulty: 'intermediate',
        content: '''
# Keys in Flutter

Keys help Flutter identify which widgets in a list have changed, been added, or removed.

## When to Use Keys:

1. **Reorderable Lists**
   - Drag-and-drop lists
   - Animated list reordering

2. **Preserving State**
   - When widget order changes
   - When removing/adding items

3. **Form Fields**
   - To preserve input state
   - When rebuilding forms

## Types of Keys:

### ValueKey
Based on a value (like ID):
```dart
ValueKey<int>(item.id)
```

### ObjectKey
Based on object identity:
```dart
ObjectKey(item)
```

### UniqueKey
Always unique (use sparingly):
```dart
UniqueKey()
```

### GlobalKey
Access state across the tree:
```dart
final key = GlobalKey<FormState>();
```

## Common Interview Questions:

**Q: When do you need keys?**
A: When widgets of the same type need to be distinguished, especially in lists

**Q: Local vs Global keys?**
A: Local keys (ValueKey, ObjectKey) for list items. Global keys for accessing state from anywhere.

**Q: Performance impact?**
A: Minimal overhead, but don't overuse GlobalKey
        ''',
        codeExamples: [
          CodeExample(
            title: 'List with Keys',
            language: 'dart',
            code: '''class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [
    Todo(id: 1, title: 'Task 1'),
    Todo(id: 2, title: 'Task 2'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoItem(
          key: ValueKey(todos[index].id),
          todo: todos[index],
        );
      },
    );
  }
}''',
            explanation: 'Using ValueKey to preserve widget state in lists',
          ),
        ],
      ),
      Topic(
        id: 'interview_5',
        categoryId: '5',
        title: 'Explain setState() and when to use it',
        description: 'State management fundamentals',
        difficulty: 'beginner',
        content: '''
# setState() in Flutter

Method to notify Flutter that internal state has changed and widget needs to rebuild.

## How It Works:

```dart
setState(() {
  _counter++;
});
```

1. Marks widget as "dirty"
2. Schedules rebuild
3. build() method called again
4. New widget tree created
5. Flutter efficiently updates UI

## Best Practices:

### ✅ DO:
- Keep setState() callbacks fast
- Only update variables inside setState()
- Use for simple local state

### ❌ DON'T:
- Call expensive operations inside setState()
- Update state outside setState()
- Use for complex app-wide state

## Common Mistakes:

**Mistake 1**: Updating without setState
```dart
// ❌ Wrong - won't rebuild
_counter++;

// ✅ Correct
setState(() {
  _counter++;
});
```

**Mistake 2**: Async operations in setState
```dart
// ❌ Wrong
setState(() async {
  await fetchData(); // Don't await here
});

// ✅ Correct
await fetchData();
setState(() {
  // Update state here
});
```

## Interview Points:

- **Purpose**: Triggers rebuild
- **Scope**: Only rebuilds current widget
- **Performance**: Flutter is smart about minimal rebuilds
- **Alternatives**: Provider, Riverpod, BLoC for complex state
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'interview_6',
        categoryId: '5',
        title: 'Hot Reload vs Hot Restart',
        description: 'Development workflow understanding',
        difficulty: 'beginner',
        content: '''
# Hot Reload vs Hot Restart

## Hot Reload (r key)

Injects updated code into running Dart VM.

### Characteristics:
- ⚡ Fast (~1 second)
- 🔄 Preserves app state
- 🎯 Updates build() methods
- ✅ Works with most code changes

### When to Use:
- UI changes
- Widget modifications
- Logic updates in build methods
- Styling changes

### Limitations:
- Can't update: global variables, static fields, main() method
- Can't change: app initialization, const values
- May cause issues with: changed class constructors, state initialization

## Hot Restart (R key or ⟳)

Restarts app completely.

### Characteristics:
- ⏱️ Slower (~3-5 seconds)
- 🔄 Resets all state
- 🎯 Reinitializes everything
- ✅ Guaranteed fresh start

### When to Use:
- Global state changes
- Enum modifications
- Adding/removing libraries
- Changing app configuration
- When hot reload doesn't work

## Interview Quick Points:

- **Hot Reload**: Fast, keeps state, UI changes
- **Hot Restart**: Slower, resets everything, structural changes
- **When to restart**: Global changes, initialization issues
- **Productivity**: Hot reload makes Flutter development incredibly fast
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'interview_7',
        categoryId: '5',
        title: 'BuildContext - What is it?',
        description: 'Understanding context in Flutter',
        difficulty: 'intermediate',
        content: '''
# BuildContext in Flutter

BuildContext is a reference to the location of a widget in the widget tree.

## Key Points:

### What is BuildContext?

- Handle to the location of a widget
- Access to ancestor widgets
- Used for navigation, themes, media queries
- Every widget has its own BuildContext

### Common Uses:

**1. Theme Access**
```dart
Theme.of(context)
```

**2. MediaQuery**
```dart
MediaQuery.of(context).size.width
```

**3. Navigator**
```dart
Navigator.of(context).push(...)
```

**4. Scaffold**
```dart
ScaffoldMessenger.of(context).showSnackBar(...)
```

## Common Pitfalls:

### Async Gap

```dart
// ❌ Wrong - context might be invalid
onPressed: () async {
  await fetchData();
  Navigator.of(context).push(...); // Context may be unmounted
}

// ✅ Correct - check mounted
onPressed: () async {
  await fetchData();
  if (!mounted) return;
  Navigator.of(context).push(...);
}
```

### Wrong Context

```dart
// ❌ Wrong - Scaffold not ancestor
Scaffold(
  body: Builder(
    builder: (context) {
      return ElevatedButton(
        onPressed: () {
          Scaffold.of(context).showSnackBar(...); // Works!
        },
      );
    },
  ),
);
```

## Interview Points:

- **BuildContext**: Widget's location in tree
- **of() methods**: Find ancestor widgets
- **Context safety**: Check mounted in async operations
- **Inherited widgets**: Accessed via context
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'interview_8',
        categoryId: '5',
        title: 'InheritedWidget explained',
        description: 'Low-level state propagation',
        difficulty: 'advanced',
        content: '''
# InheritedWidget

Low-level mechanism to efficiently propagate data down the widget tree.

## What is InheritedWidget?

Base class for widgets that efficiently propagate information to descendants.

### Key Features:

- Data flows down the tree
- Descendants can access data without passing through constructors
- Automatic rebuild when data changes
- Foundation for Provider, Theme, MediaQuery

## How It Works:

1. InheritedWidget stores data
2. Descendants call `context.dependOnInheritedWidgetOfExactType<T>()`
3. When data changes, only dependent widgets rebuild
4. Efficient compared to passing data through constructors

## Use Cases:

- Theme data
- Locale/translations
- User authentication state
- App configuration
- State management libraries (Provider, Riverpod)

## Interview Points:

**Q: What is InheritedWidget?**
A: Efficient way to pass data down widget tree without constructors

**Q: When to use InheritedWidget?**
A: When multiple widgets need access to the same data and it changes occasionally

**Q: How does Provider use InheritedWidget?**
A: Provider wraps InheritedWidget for simpler API and dependency injection

**Q: Performance benefits?**
A: Only widgets that depend on the data rebuild, not entire tree
        ''',
        codeExamples: [
          CodeExample(
            title: 'Simple InheritedWidget',
            language: 'dart',
            code: '''class AppTheme extends InheritedWidget {
  final Color primaryColor;
  
  const AppTheme({
    Key? key,
    required this.primaryColor,
    required Widget child,
  }) : super(key: key, child: child);
  
  static AppTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTheme>();
  }
  
  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return oldWidget.primaryColor != primaryColor;
  }
}

// Usage:
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(color: theme?.primaryColor);
  }
}''',
            explanation: 'Basic InheritedWidget for theme data',
          ),
        ],
      ),
    ];
  }

  // Learning Path Topics
  static List<Topic> getLearningPathTopics() {
    return [
      Topic(
        id: 'path_1',
        categoryId: '6',
        title: 'Beginner: Foundations (Weeks 1-2)',
        description: 'Start your Flutter journey',
        difficulty: 'beginner',
        content: '''
# Beginner Phase: Foundations

## Week 1: Dart Fundamentals

### Day 1-2: Variables & Types
- Dart basics
- Variables declaration
- Data types (int, double, String, bool)
- Type inference with var
- Null safety basics

### Day 3-4: Functions & Control Flow
- Function declaration
- Parameters (positional, named, optional)
- If-else statements
- Switch cases
- Loops (for, while, forEach)

### Day 5-7: OOP Basics
- Classes and objects
- Constructors
- Methods and properties
- Basic inheritance

## Week 2: Flutter Basics

### Day 1-2: Your First App
- Setup development environment
- Create first app
- Hot reload/restart
- Understanding main.dart

### Day 3-4: Basic Widgets
- StatelessWidget
- StatefulWidget
- Text, Image, Icon
- Container, Padding
- Row, Column

### Day 5-7: Layouts
- Layout principles
- Stack widget
- Expanded and Flexible
- ListView basics
- Practice building simple UIs

## Goals:
✅ Understand Dart syntax
✅ Build simple Flutter UIs
✅ Use basic widgets confidently
✅ Understand state management basics
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'path_2',
        categoryId: '6',
        title: 'Intermediate: Core Concepts (Weeks 3-6)',
        description: 'Build real-world features',
        difficulty: 'intermediate',
        content: '''
# Intermediate Phase: Core Concepts

## Week 3-4: Navigation & State

### Navigation
- Navigator.push/pop
- Named routes
- Passing data between screens
- Bottom navigation
- Drawer navigation

### State Management
- setState() mastery
- Lifting state up
- Provider basics
- State management patterns

## Week 5-6: API & Data

### Networking
- HTTP requests
- JSON parsing
- async/await
- FutureBuilder
- Error handling

### Local Storage
- SharedPreferences
- SQLite basics
- File I/O
- Caching strategies

## Additional Topics:

### Forms & Validation
- TextField widget
- Form widget
- Input validation
- User feedback

### Lists & Performance
- ListView.builder
- GridView
- Infinite scrolling
- Performance optimization

## Goals:
✅ Build multi-screen apps
✅ Fetch and display API data
✅ Store data locally
✅ Handle user input properly
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'path_3',
        categoryId: '6',
        title: 'Advanced: Professional Skills (Weeks 7-12)',
        description: 'Master advanced techniques',
        difficulty: 'advanced',
        content: '''
# Advanced Phase: Professional Skills

## Week 7-8: Architecture & Patterns

- Clean Architecture
- MVVM pattern
- Repository pattern
- Dependency injection
- Separation of concerns

## Week 9-10: Advanced State Management

- Provider deep dive
- Riverpod
- BLoC pattern
- GetX (if needed)
- State management comparison

## Week 11-12: Production Ready

### Testing
- Unit tests
- Widget tests
- Integration tests
- Test-driven development (TDD)

### Deployment
- App signing
- Build configurations
- App store submission (iOS/Android)
- CI/CD basics

### Performance
- Profiling tools
- Memory management
- Rendering optimization
- Build size optimization

## Advanced Features:

### Animations
- Implicit animations
- Explicit animations
- Custom animations
- Hero animations

### Custom Widgets
- CustomPainter
- Custom layouts
- Reusable components

### Platform Integration
- Platform channels
- Native code integration
- Platform-specific UI

## Goals:
✅ Build production-ready apps
✅ Write testable code
✅ Deploy to app stores
✅ Handle complex state
✅ Optimize performance
        ''',
        codeExamples: [],
      ),
    ];
  }

  // Code Challenges Topics
  static List<Topic> getChallengesTopics() {
    return [
      Topic(
        id: 'challenge_1',
        categoryId: '7',
        title: 'Counter App with Persistence',
        description: 'Build a counter that saves state',
        difficulty: 'beginner',
        content: '''
# Challenge: Counter App with Persistence

## Objective
Create a counter app that remembers its value even after app restart.

## Requirements

### Features:
1. Display current count
2. Increment button
3. Decrement button
4. Reset button
5. Save count to SharedPreferences
6. Load count on app start

### Bonus:
- Add custom increment value
- Add history of counts
- Beautiful UI with animations

## Learning Goals:
- StatefulWidget
- setState()
- SharedPreferences
- async/await
- initState() lifecycle

## Hints:
```dart
// Save count
final prefs = await SharedPreferences.getInstance();
await prefs.setInt('counter', count);

// Load count
final prefs = await SharedPreferences.getInstance();
final count = prefs.getInt('counter') ?? 0;
```

## Test Checklist:
☐ Counter increments correctly
☐ Counter decrements correctly
☐ Reset button works
☐ Count persists after app restart
☐ No errors in console
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'challenge_2',
        categoryId: '7',
        title: 'Todo List with CRUD Operations',
        description: 'Complete task management app',
        difficulty: 'intermediate',
        content: '''
# Challenge: Todo List App

## Objective
Build a full-featured todo list application with local storage.

## Requirements

### Core Features:
1. Add new todos
2. Mark todos as complete
3. Edit existing todos
4. Delete todos
5. Filter (All/Active/Completed)
6. Persist data locally

### UI Requirements:
- List view of todos
- Add button
- Swipe to delete
- Tap to edit
- Checkbox to mark complete
- Different styling for completed items

### Bonus:
- Categories/tags
- Due dates
- Search functionality
- Statistics (total, completed, pending)

## Technical Requirements:
- State management (Provider or GetX)
- SQLite or Hive for storage
- Form validation
- Confirm dialogs
- Snackbar notifications

## Test Cases:
☐ Can add todo
☐ Can mark as complete
☐ Can edit todo
☐ Can delete todo
☐ Filters work correctly
☐ Data persists
☐ No memory leaks
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'challenge_3',
        categoryId: '7',
        title: 'Weather App with API Integration',
        description: 'Fetch and display real-time weather data',
        difficulty: 'intermediate',
        content: '''
# Challenge: Weather App

## Objective
Create a weather app that fetches real-time weather data from an API.

## Requirements

### Features:
1. Search by city name
2. Display current weather
3. Show 5-day forecast
4. Temperature unit toggle (C/F)
5. Refresh functionality
6. Error handling

### Data to Display:
- Temperature
- Weather condition (sunny, rainy, etc.)
- Humidity
- Wind speed
- Weather icon
- City name

### API Suggestion:
Use OpenWeatherMap API (free tier)
- Sign up for API key
- Read documentation
- Handle rate limits

## Technical Requirements:
- HTTP requests (dio or http package)
- JSON parsing
- FutureBuilder or StreamBuilder
- Loading states
- Error states
- Offline handling

## Bonus:
- Location permission
- Auto-detect location
- Save favorite cities
- Beautiful animations
- Dark mode support

## Test Scenarios:
☐ Valid city shows weather
☐ Invalid city shows error
☐ Loading state visible
☐ Data updates on refresh
☐ No app crashes
☐ Offline message displayed
        ''',
        codeExamples: [],
      ),
      Topic(
        id: 'challenge_4',
        categoryId: '7',
        title: 'Chat UI Clone',
        description: 'Replicate a messaging app interface',
        difficulty: 'advanced',
        content: '''
# Challenge: Chat UI Clone

## Objective
Build a WhatsApp or Telegram-like chat interface (UI only, no backend).

## Requirements

### Screens:
1. **Chat List Screen**
   - List of conversations
   - Profile pictures
   - Last message preview
   - Timestamp
   - Unread badge

2. **Chat Screen**
   - Message bubbles (sent/received)
   - Timestamps
   - Message input field
   - Send button
   - Scroll to bottom

### UI Requirements:
- Different colors for sent/received
- Rounded bubbles
- Profile images
- Time stamps
- Input field at bottom
- Smooth animations
- Keyboard handling

### Bonus Features:
- Image messages
- Audio messages
- Emoji picker
- Reply functionality
- Message reactions
- Swipe gestures
- Search messages

## Technical Challenges:
- Reverse ListView
- Keyboard overlap handling
- Scroll controller
- Custom message bubbles
- Date separators
- Performance with many messages

## Mock Data:
Create dummy messages with:
- Sender
- Content
- Timestamp
- Read status
- Message type

## Evaluation Criteria:
☐ Clean, modern UI
☐ Smooth scrolling
☐ Responsive layout
☐ Proper keyboard handling
☐ No performance issues
☐ Pixel-perfect design
        ''',
        codeExamples: [],
      ),
    ];
  }
}


