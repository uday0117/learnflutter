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
}
