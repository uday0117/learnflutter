class CheatsheetSection {
  final String id;
  final String title;
  final String emoji;
  final List<CheatsheetItem> items;

  const CheatsheetSection({
    required this.id,
    required this.title,
    required this.emoji,
    required this.items,
  });
}

class CheatsheetItem {
  final String title;
  final String description;
  final String code;

  const CheatsheetItem({
    required this.title,
    required this.description,
    required this.code,
  });
}

class DartCheatsheetData {
  static List<CheatsheetSection> getSections() => _sections;

  static const List<CheatsheetSection> _sections = [
    // ─── VARIABLES & TYPES ───
    CheatsheetSection(
      id: 'variables',
      title: 'Variables & Types',
      emoji: '📦',
      items: [
        CheatsheetItem(
          title: 'var / final / const',
          description: 'var: inferred, mutable. final: set once (runtime). const: compile-time constant.',
          code: '''var name = "Alice";          // inferred as String
final age = 30;              // set once, runtime value OK
const pi = 3.14159;          // compile-time constant

// Explicit types
int count = 0;
double price = 9.99;
bool isActive = true;
String message = "Hello";''',
        ),
        CheatsheetItem(
          title: 'Null Safety',
          description: 'Types are non-nullable by default. Use ? to allow null.',
          code: '''String name = "Alice";      // cannot be null
String? nickname;            // nullable

// Operators
String a = nickname ?? "Default";  // null coalescing
nickname ??= "Bob";                // assign if null
int? len = nickname?.length;       // null-aware access
String forced = nickname!;         // assert non-null (throws if null)''',
        ),
        CheatsheetItem(
          title: 'Type Casting',
          description: 'as for casting, is for type checking, is! for negation.',
          code: '''Object obj = "Hello";
if (obj is String) {
  print(obj.length);  // smart cast inside if block
}

// Safe cast
String? str = obj as String?;

// Check type
print(42 is int);         // true
print(42 is! String);     // true''',
        ),
        CheatsheetItem(
          title: 'Late Variables',
          description: 'late defers initialization. Throws if accessed before set.',
          code: '''late String description;   // initialized later

// Useful for dependency injection
late final UserService _service;

void init() {
  _service = UserService();  // set before first use
}''',
        ),
      ],
    ),

    // ─── COLLECTIONS ───
    CheatsheetSection(
      id: 'collections',
      title: 'Collections',
      emoji: '📚',
      items: [
        CheatsheetItem(
          title: 'List',
          description: 'Ordered, indexed, allows duplicates.',
          code: '''// Fixed
var fixed = List.filled(3, 0);        // [0, 0, 0]

// Growable
var items = <String>[];
items.add("Apple");
items.addAll(["Banana", "Cherry"]);
items.removeAt(0);

// Useful methods
items.length;
items.isEmpty;
items.first;
items.last;
items.reversed.toList();
items.where((i) => i.startsWith("B")).toList();
items.map((i) => i.toUpperCase()).toList();
items.any((i) => i.length > 5);
items.every((i) => i.isNotEmpty);
items.sort();

// Spread operator
var combined = [...items, ...otherList];''',
        ),
        CheatsheetItem(
          title: 'Map',
          description: 'Key-value pairs. Keys must be unique.',
          code: '''var user = <String, dynamic>{
  "name": "Alice",
  "age": 30,
  "active": true,
};

// Access
user["name"];               // "Alice"
user["email"] ?? "none";   // null-safe access

// Iteration
user.keys.forEach(print);
user.entries.forEach((e) => print("\${e.key}: \${e.value}"));

// Update
user["age"] = 31;
user.remove("active");
user.putIfAbsent("email", () => "alice@example.com");

// From JSON
Map<String, dynamic> json = jsonDecode(response.body);''',
        ),
        CheatsheetItem(
          title: 'Set',
          description: 'Unordered collection of unique values.',
          code: '''var fruits = <String>{"apple", "banana", "cherry"};
fruits.add("apple");     // no duplicate — still 3 items

// Set operations
var a = {1, 2, 3};
var b = {2, 3, 4};
a.union(b);         // {1, 2, 3, 4}
a.intersection(b);  // {2, 3}
a.difference(b);    // {1}
a.contains(2);      // true''',
        ),
        CheatsheetItem(
          title: 'Collection-if / Collection-for',
          description: 'Build collections conditionally or iteratively inline.',
          code: '''bool showAdmin = true;

var menu = [
  "Home",
  "Profile",
  if (showAdmin) "Admin Panel",     // conditional
  for (var item in extraItems) item, // spread loop
];''',
        ),
      ],
    ),

    // ─── FUNCTIONS ───
    CheatsheetSection(
      id: 'functions',
      title: 'Functions',
      emoji: '⚙️',
      items: [
        CheatsheetItem(
          title: 'Function Syntax',
          description: 'Named, anonymous, arrow functions.',
          code: '''// Named function
int add(int a, int b) => a + b;

// Named with body
String greet(String name) {
  return "Hello, \$name!";
}

// Anonymous / lambda
var multiply = (int a, int b) => a * b;

// Higher-order
List<int> transform(List<int> list, int Function(int) fn) {
  return list.map(fn).toList();
}
transform([1, 2, 3], (x) => x * 2);  // [2, 4, 6]''',
        ),
        CheatsheetItem(
          title: 'Optional Parameters',
          description: 'Named parameters ({}) and positional optional ([]).',
          code: '''// Named parameters (recommended)
void createUser({
  required String name,
  int age = 18,
  String? email,
}) {
  print("\$name, \$age, \${email ?? 'no email'}");
}
createUser(name: "Alice", age: 25);

// Optional positional
String greet(String name, [String greeting = "Hello"]) {
  return "\$greeting, \$name!";
}
greet("Bob");           // Hello, Bob!
greet("Bob", "Hey");    // Hey, Bob!''',
        ),
        CheatsheetItem(
          title: 'Closures',
          description: 'A function that captures variables from its surrounding scope.',
          code: '''Function makeCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

var counter = makeCounter();
counter(); // 1
counter(); // 2
counter(); // 3''',
        ),
        CheatsheetItem(
          title: 'typedef',
          description: 'Create a named type alias for a function signature.',
          code: '''typedef Predicate<T> = bool Function(T value);
typedef Callback = void Function(String message);

// Usage
bool isEven(int n) => n % 2 == 0;
Predicate<int> check = isEven;
check(4); // true

// In APIs
void fetchData({required Callback onComplete}) { ... }''',
        ),
      ],
    ),

    // ─── CLASSES & OOP ───
    CheatsheetSection(
      id: 'classes',
      title: 'Classes & OOP',
      emoji: '🏗️',
      items: [
        CheatsheetItem(
          title: 'Class Basics',
          description: 'Constructors, getters, setters, methods.',
          code: '''class User {
  final String name;
  int _age;  // private field

  // Generative constructor (shorthand)
  User({required this.name, required int age}) : _age = age;

  // Named constructor
  User.guest() : name = "Guest", _age = 0;

  // Getter
  int get age => _age;

  // Setter
  set age(int value) {
    if (value >= 0) _age = value;
  }

  // Method
  String greet() => "Hi, I'm \$name!";

  // toString override
  @override
  String toString() => "User(\$name, \$_age)";
}

// Usage
final user = User(name: "Alice", age: 25);
final guest = User.guest();
print(user.greet());''',
        ),
        CheatsheetItem(
          title: 'Inheritance & Interfaces',
          description: 'extends for inheritance, implements for interface, abstract for abstract classes.',
          code: '''abstract class Animal {
  String get name;
  void speak();  // abstract — must override
  void breathe() => print("Breathing...");  // concrete
}

class Dog extends Animal {
  @override
  final String name;
  Dog(this.name);

  @override
  void speak() => print("Woof!");
}

// Implementing interface (any class can be an interface)
class Robot implements Animal {
  @override
  final String name = "R2D2";
  @override
  void speak() => print("Beep boop");
}''',
        ),
        CheatsheetItem(
          title: 'Factory Constructors',
          description: 'Return an existing instance or subtype. Commonly used for singletons and fromJson.',
          code: '''class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;  // always returns same instance
  Logger._internal();
}

class Shape {
  factory Shape.fromType(String type) {
    if (type == "circle") return Circle();
    if (type == "rect") return Rectangle();
    throw ArgumentError("Unknown shape: \$type");
  }
}

// fromJson pattern
class User {
  final String name;
  final int age;
  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json["name"], age: json["age"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "age": age};
}''',
        ),
        CheatsheetItem(
          title: 'Mixins',
          description: 'Add reusable capabilities to classes without inheritance.',
          code: '''mixin Serializable {
  Map<String, dynamic> toJson();
  
  String toJsonString() => jsonEncode(toJson());
}

mixin Printable {
  void printInfo() => print(toString());
}

class User with Serializable, Printable {
  final String name;
  User(this.name);

  @override
  Map<String, dynamic> toJson() => {"name": name};
}

// Flutter usage
class _MyState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
}''',
        ),
        CheatsheetItem(
          title: 'Enums',
          description: 'Dart 2.17+ enhanced enums with methods and fields.',
          code: '''// Basic
enum Status { active, inactive, pending }

// Enhanced enum (Dart 2.17+)
enum Priority {
  low(1, "Low"),
  medium(2, "Medium"),
  high(3, "High");

  final int value;
  final String label;
  const Priority(this.value, this.label);

  bool get isUrgent => this == Priority.high;
}

// Usage
Priority.high.label     // "High"
Priority.high.isUrgent  // true
Status.active.name      // "active"''',
        ),
      ],
    ),

    // ─── ASYNC ───
    CheatsheetSection(
      id: 'async',
      title: 'Async & Streams',
      emoji: '⚡',
      items: [
        CheatsheetItem(
          title: 'Future & async/await',
          description: 'Handle single async values.',
          code: '''// async function returns Future
Future<String> fetchUser(int id) async {
  final response = await http.get(Uri.parse("/users/\$id"));
  return jsonDecode(response.body)["name"];
}

// Error handling
Future<void> loadData() async {
  try {
    final name = await fetchUser(1);
    print(name);
  } on HttpException catch (e) {
    print("HTTP error: \$e");
  } catch (e, stack) {
    print("Unexpected error: \$e\n\$stack");
  } finally {
    print("Always runs");
  }
}

// Future combinators
await Future.wait([future1, future2]);      // parallel
await Future.any([future1, future2]);      // first to complete
await Future.delayed(Duration(seconds: 1)); // delay''',
        ),
        CheatsheetItem(
          title: 'Stream',
          description: 'Handle sequences of async events.',
          code: '''// Generator function
Stream<int> ticker() async* {
  int i = 0;
  while (true) {
    yield i++;
    await Future.delayed(Duration(seconds: 1));
  }
}

// StreamController (manual)
final controller = StreamController<String>();
controller.sink.add("event1");
controller.stream.listen((event) => print(event));
controller.close(); // always close!

// StreamBuilder in Flutter
StreamBuilder<int>(
  stream: ticker(),
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text("Error");
    if (!snapshot.hasData) return CircularProgressIndicator();
    return Text("Tick: \${snapshot.data}");
  },
)''',
        ),
        CheatsheetItem(
          title: 'Isolates & compute()',
          description: 'Run heavy tasks without blocking the UI thread.',
          code: '''import "package:flutter/foundation.dart";

// compute() runs a top-level or static function in a new Isolate
List<Post> parsePosts(String responseBody) {
  final parsed = jsonDecode(responseBody) as List;
  return parsed.map((j) => Post.fromJson(j)).toList();
}

Future<List<Post>> fetchPosts() async {
  final response = await http.get(Uri.parse("/posts"));
  // Off the main thread:
  return compute(parsePosts, response.body);
}''',
        ),
      ],
    ),

    // ─── NULL SAFETY PATTERNS ───
    CheatsheetSection(
      id: 'null_safety',
      title: 'Null Safety Patterns',
      emoji: '🛡️',
      items: [
        CheatsheetItem(
          title: 'Common Patterns',
          description: 'Idiomatic null-safe code.',
          code: '''// Null coalescing
String name = user?.name ?? "Anonymous";

// Conditional access chain
String? city = user?.address?.city;

// If-null assignment
user ??= User.anonymous();

// Null check before use
if (user != null) {
  print(user.name);  // promoted to non-null
}

// Early return pattern
String processUser(User? user) {
  if (user == null) return "No user";
  // user is non-null from here
  return user.name.toUpperCase();
}''',
        ),
        CheatsheetItem(
          title: 'Required & Default in Functions',
          description: 'Handling nullability in function parameters.',
          code: '''// Required named parameter
void createPost({required String title, required String body}) {}

// Optional with default
void log({String level = "info", String? tag}) {
  print("[\${tag ?? "APP"}][\$level]");
}

// Assigning to non-nullable from nullable context
int getLength(String? s) {
  return s?.length ?? 0;
}''',
        ),
      ],
    ),

    // ─── EXTENSIONS ───
    CheatsheetSection(
      id: 'extensions',
      title: 'Extensions & Generics',
      emoji: '🔌',
      items: [
        CheatsheetItem(
          title: 'Extensions',
          description: 'Add methods to existing types without subclassing.',
          code: '''extension StringExt on String {
  bool get isValidEmail =>
    RegExp(r"^[\\w.]+@[\\w.]+\\.[a-z]{2,}\$").hasMatch(this);

  String get titleCase =>
    split(" ").map((w) => w[0].toUpperCase() + w.substring(1)).join(" ");
}

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  double get width => MediaQuery.of(this).size.width;
  bool get isDark => theme.brightness == Brightness.dark;
}

// Usage
"hello world".titleCase          // "Hello World"
"me@example.com".isValidEmail    // true
context.isDark                   // true/false''',
        ),
        CheatsheetItem(
          title: 'Generics',
          description: 'Write type-safe reusable code.',
          code: '''// Generic class
class Box<T> {
  T value;
  Box(this.value);
  T unwrap() => value;
}

Box<String> nameBox = Box("Alice");
Box<int> numBox = Box(42);

// Generic function
T first<T>(List<T> list) => list.first;

// Bounded generics
class Repository<T extends Entity> {
  Future<T> findById(String id) async { ... }
}

// Generic API wrapper
class ApiResult<T> {
  final T? data;
  final String? error;
  bool get isSuccess => data != null;
  
  ApiResult.ok(this.data) : error = null;
  ApiResult.err(this.error) : data = null;
}''',
        ),
      ],
    ),

    // ─── PATTERNS ───
    CheatsheetSection(
      id: 'patterns',
      title: 'Dart 3 Patterns',
      emoji: '🎯',
      items: [
        CheatsheetItem(
          title: 'Pattern Matching & Switch Expressions',
          description: 'Dart 3 adds exhaustive switch expressions and destructuring.',
          code: '''// Switch expression (Dart 3)
String describe(Object value) => switch (value) {
  int n when n < 0 => "negative",
  int n when n == 0 => "zero",
  int n => "positive \$n",
  String s => "string: \$s",
  _ => "unknown",
};

// Record destructuring
var (name, age) = ("Alice", 30);
print("\$name is \$age");

// Object pattern
switch (shape) {
  case Circle(radius: var r): print("Circle r=\$r");
  case Rectangle(width: var w, height: var h): print("\${w}x\$h");
}''',
        ),
        CheatsheetItem(
          title: 'Records (Dart 3)',
          description: 'Anonymous, immutable, structured values.',
          code: '''// Record type
(String, int) getUser() => ("Alice", 30);

var (name, age) = getUser();
print("\$name, \$age");

// Named fields
({String name, int age}) createUser() =>
    (name: "Bob", age: 25);

var user = createUser();
print(user.name);   // Bob
print(user.age);    // 25

// Useful for multiple return values
(bool success, String message) validate(String email) {
  if (!email.contains("@")) return (false, "Invalid email");
  return (true, "OK");
}''',
        ),
      ],
    ),
  ];
}
