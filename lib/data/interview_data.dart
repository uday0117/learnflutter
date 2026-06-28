import '../models/interview_question.dart';

class InterviewData {
  static List<InterviewQuestion> getAll() => _questions;

  static List<InterviewQuestion> getByLevel(QuestionLevel level) =>
      _questions.where((q) => q.level == level).toList();

  static List<InterviewQuestion> getByCategory(String category) =>
      _questions.where((q) => q.category == category).toList();

  static const List<InterviewQuestion> _questions = [
    // ─────────────── BEGINNER ───────────────
    InterviewQuestion(
      id: 'q1',
      question: 'What is Flutter?',
      answer:
          'Flutter is Google\'s open-source UI toolkit for building natively compiled, multi-platform applications from a single codebase. It uses the Dart programming language and provides its own rendering engine (Skia/Impeller), which means Flutter widgets look and behave the same across iOS, Android, Web, Desktop, and embedded devices.',
      level: QuestionLevel.beginner,
      category: 'Basics',
    ),
    InterviewQuestion(
      id: 'q2',
      question: 'What is a Widget in Flutter?',
      answer:
          'In Flutter, everything is a widget. A widget is an immutable description of part of the user interface. Widgets form a tree structure. There are two types: StatelessWidget (immutable, rebuilds only when its parent does) and StatefulWidget (has mutable State that can trigger rebuilds independently).',
      codeExample: '''// Stateless Widget
class MyLabel extends StatelessWidget {
  final String text;
  const MyLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

// Stateful Widget
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _count++),
      child: Text('Count: \$_count'),
    );
  }
}''',
      level: QuestionLevel.beginner,
      category: 'Basics',
    ),
    InterviewQuestion(
      id: 'q3',
      question: 'What is the difference between StatelessWidget and StatefulWidget?',
      answer:
          'StatelessWidget: Has no mutable state. It rebuilds only when its parent rebuilds or its constructor arguments change. Use it for static UI elements like labels, icons, or cards.\n\nStatefulWidget: Has a separate State object that persists across rebuilds. Calling setState() inside State triggers a rebuild. Use it for interactive UI: counters, forms, animations.',
      level: QuestionLevel.beginner,
      category: 'Widgets',
    ),
    InterviewQuestion(
      id: 'q4',
      question: 'What is the Widget tree / Element tree / RenderObject tree?',
      answer:
          '• Widget Tree: The blueprint. Widgets are lightweight, immutable descriptions of UI. Built every frame.\n• Element Tree: The "live" instance. Flutter creates an Element for each Widget. Elements persist and manage widget lifecycle.\n• RenderObject Tree: Handles layout, painting, and hit-testing. Created from Elements. This is what actually draws pixels on screen.\n\nSeparating these trees is what makes Flutter fast — only the parts that change are rebuilt.',
      level: QuestionLevel.beginner,
      category: 'Internals',
    ),
    InterviewQuestion(
      id: 'q5',
      question: 'What is BuildContext?',
      answer:
          'BuildContext is a handle to the location of a Widget in the widget tree. It provides:\n• Access to the nearest ancestor widgets (Theme.of(context), Navigator.of(context), etc.)\n• Information about the current widget\'s position for InheritedWidgets\n• MediaQuery, Scaffold, and other environment data\n\nEach Widget\'s build() method receives its own BuildContext.',
      level: QuestionLevel.beginner,
      category: 'Basics',
    ),
    InterviewQuestion(
      id: 'q6',
      question: 'What is setState() and when should you use it?',
      answer:
          'setState() is called inside a StatefulWidget\'s State to notify Flutter that the internal state has changed and the widget needs to rebuild. You should:\n• Only call it when the data that affects the UI actually changes\n• Avoid calling it in initState() or dispose()\n• Keep the code inside setState() minimal — just update the variable\n\nFor complex apps, prefer state management solutions (Provider, Bloc, GetX, Riverpod) over setState.',
      codeExample: '''setState(() {
  _counter++;
  _isLoading = false;
});''',
      level: QuestionLevel.beginner,
      category: 'State',
    ),
    InterviewQuestion(
      id: 'q7',
      question: 'What is the pubspec.yaml file?',
      answer:
          'pubspec.yaml is the project manifest for a Flutter/Dart project. It declares:\n• Package name, description, and version\n• SDK constraints (environment)\n• Dependencies (packages from pub.dev)\n• Dev dependencies (test tools, code generators)\n• Assets (images, fonts, JSON files)\n• Flutter-specific config (fonts, icons)\n\nRun "flutter pub get" after editing it to fetch packages.',
      level: QuestionLevel.beginner,
      category: 'Basics',
    ),
    InterviewQuestion(
      id: 'q8',
      question: 'What are the main layout widgets in Flutter?',
      answer:
          'Single-child: Container, Center, Padding, Align, SizedBox, Expanded, Flexible, AspectRatio\n\nMulti-child: Row, Column, Stack, Wrap, Flow, Table\n\nScrolling: ListView, GridView, SingleChildScrollView, CustomScrollView\n\nSliver-based: SliverList, SliverGrid, SliverAppBar\n\nThe most common are Column (vertical), Row (horizontal), and Stack (layered).',
      level: QuestionLevel.beginner,
      category: 'Layout',
    ),
    InterviewQuestion(
      id: 'q9',
      question: 'What is Dart? Why does Flutter use it?',
      answer:
          'Dart is a statically-typed, object-oriented language developed by Google. Flutter uses it because:\n• AOT (Ahead-of-Time) compilation → fast startup & native performance\n• JIT (Just-in-Time) compilation in debug → enables hot reload\n• Sound null safety → fewer runtime crashes\n• Rich async support (async/await, Streams, Futures)\n• Simple, readable syntax familiar to Java/Kotlin/Swift developers\n• Dart compiles to native ARM/x64, JavaScript, and WASM',
      level: QuestionLevel.beginner,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q10',
      question: 'What is Hot Reload and Hot Restart?',
      answer:
          'Hot Reload: Injects updated source code into the running Dart VM and rebuilds the widget tree, preserving app state. Takes < 1 second. Does NOT re-run main() or initState().\n\nHot Restart: Fully restarts the Dart VM, re-runs main() and initState(). App state is lost. Slower than hot reload.\n\nFull Restart: Rebuilds and reinstalls the entire app. Slowest. Required for native code changes.',
      level: QuestionLevel.beginner,
      category: 'Basics',
    ),
    InterviewQuestion(
      id: 'q11',
      question: 'What is the difference between mainAxisAlignment and crossAxisAlignment?',
      answer:
          'In a Row or Column:\n• mainAxisAlignment: Aligns children along the main axis (horizontal for Row, vertical for Column). Options: start, end, center, spaceBetween, spaceAround, spaceEvenly.\n• crossAxisAlignment: Aligns children perpendicular to the main axis. Options: start, end, center, stretch, baseline.',
      codeExample: '''Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [Widget1(), Widget2(), Widget3()],
)''',
      level: QuestionLevel.beginner,
      category: 'Layout',
    ),
    InterviewQuestion(
      id: 'q12',
      question: 'What is a Future in Dart?',
      answer:
          'A Future<T> represents the result of an asynchronous operation that will complete at some point in the future, either with a value of type T or with an error. You can await a Future inside an async function.',
      codeExample: '''Future<String> fetchData() async {
  final response = await http.get(Uri.parse('https://api.example.com/data'));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
}

// Usage
void loadData() async {
  try {
    final data = await fetchData();
    print(data);
  } catch (e) {
    print('Error: \$e');
  }
}''',
      level: QuestionLevel.beginner,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q13',
      question: 'What is null safety in Dart?',
      answer:
          'Null safety (sound null safety) is a language feature in Dart 2.12+ that prevents null reference errors at compile time. By default, variables cannot hold null. You must explicitly mark a type as nullable with "?".\n\nKey operators:\n• T? — nullable type\n• ! — null assertion (throws if null)\n• ?? — null coalescing (return right side if left is null)\n• ??= — assign if null\n• ?. — null-aware member access',
      codeExample: '''String name = "Alice";   // non-nullable
String? nickname;         // nullable (can be null)

// Null coalescing
String display = nickname ?? "No nickname";

// Null-aware access
int? length = nickname?.length;

// Null assertion (use carefully!)
String forced = nickname!;  // throws if nickname is null''',
      level: QuestionLevel.beginner,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q14',
      question: 'What is the Scaffold widget?',
      answer:
          'Scaffold is the top-level Material Design layout structure. It provides default implementations for all visual elements defined by Material Design, including:\n• appBar — TopAppBar\n• body — Main content area\n• floatingActionButton — FAB\n• bottomNavigationBar\n• drawer / endDrawer — Side navigation\n• bottomSheet\n• snackBar (via ScaffoldMessenger)\n• backgroundColor',
      level: QuestionLevel.beginner,
      category: 'Widgets',
    ),
    InterviewQuestion(
      id: 'q15',
      question: 'How do you navigate between screens in Flutter?',
      answer:
          'Flutter uses Navigator (a stack of routes) for navigation.\n\n1. Imperative (Navigator 1.0):\n• Navigator.push() — push a new route\n• Navigator.pop() — go back\n• Navigator.pushReplacement() — replace current\n• Navigator.pushNamed() — push by named route\n\n2. Declarative (Navigator 2.0 / Router API) — for complex web-like routing.\n\n3. Packages: go_router, auto_route, GetX routing.',
      codeExample: '''// Push
Navigator.push(context,
  MaterialPageRoute(builder: (_) => DetailScreen()));

// Pop with result
Navigator.pop(context, 'result');

// Named route
Navigator.pushNamed(context, '/details', arguments: item);

// GetX
Get.to(() => DetailScreen());
Get.back();''',
      level: QuestionLevel.beginner,
      category: 'Navigation',
    ),

    // ─────────────── INTERMEDIATE ───────────────
    InterviewQuestion(
      id: 'q16',
      question: 'What is State Management? Which approach do you prefer?',
      answer:
          'State management refers to how you share and update data (state) across your widget tree.\n\nOptions:\n• setState — local, simple\n• InheritedWidget — Flutter\'s built-in, low-level mechanism\n• Provider — lightweight, recommended by Google\n• Riverpod — type-safe evolution of Provider\n• Bloc/Cubit — event-driven, good for complex flows\n• GetX — all-in-one: routing, DI, state, storage\n• MobX — observable-based reactive state\n\nFor production apps, Riverpod or Bloc are generally recommended for scalability and testability.',
      level: QuestionLevel.intermediate,
      category: 'State',
    ),
    InterviewQuestion(
      id: 'q17',
      question: 'What is the difference between Provider and Riverpod?',
      answer:
          'Provider:\n• Based on InheritedWidget\n• Context-dependent (must call context.watch/read)\n• Cannot access providers outside widget tree\n• Prone to ProviderNotFoundException\n\nRiverpod:\n• Compile-time safe (no runtime errors)\n• Context-independent (global Providers)\n• Supports multiple providers of same type\n• Better support for async data and caching\n• Supports code generation (@riverpod annotation)',
      level: QuestionLevel.intermediate,
      category: 'State',
    ),
    InterviewQuestion(
      id: 'q18',
      question: 'What are Keys in Flutter? When should you use them?',
      answer:
          'Keys preserve state when widgets move in the tree. Flutter uses keys to identify which widget maps to which element when the tree changes.\n\nTypes:\n• ValueKey(value) — unique by value (e.g., item id)\n• ObjectKey(object) — unique by object identity\n• UniqueKey() — always unique (no two are equal)\n• GlobalKey — access State/RenderObject from anywhere\n\nUse keys when you have a list of stateful widgets that can be reordered or removed.',
      codeExample: '''ListView(
  children: items.map((item) =>
    MyCard(key: ValueKey(item.id), item: item)
  ).toList(),
)''',
      level: QuestionLevel.intermediate,
      category: 'Internals',
    ),
    InterviewQuestion(
      id: 'q19',
      question: 'What is the difference between ListView and ListView.builder?',
      answer:
          'ListView: Creates all children at once in memory. Good for small, fixed lists. All items are built even if not visible.\n\nListView.builder: Lazy — only builds items that are visible (or about to be). Uses an itemBuilder callback and itemCount. Significantly more memory-efficient for large or infinite lists.\n\nListView.separated: Like builder, but adds a separator widget between items.\n\nListView.custom: Maximum control using a SliverChildDelegate.',
      codeExample: '''// Prefer for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index].name));
  },
)''',
      level: QuestionLevel.intermediate,
      category: 'Widgets',
    ),
    InterviewQuestion(
      id: 'q20',
      question: 'What is a Stream in Dart?',
      answer:
          'A Stream is a sequence of asynchronous events over time (like a pipeline). Unlike a Future (single value), a Stream can emit zero or more values.\n\nTypes:\n• Single-subscription stream — one listener, typical for HTTP responses\n• Broadcast stream — multiple listeners, typical for events\n\nUsed in Flutter for: Firebase snapshots, WebSocket messages, user input events, BLoC\'s event-to-state pipeline.',
      codeExample: '''Stream<int> countUp() async* {
  for (int i = 0; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// Usage
StreamBuilder<int>(
  stream: countUp(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    return Text('Count: \${snapshot.data}');
  },
)''',
      level: QuestionLevel.intermediate,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q21',
      question: 'What is the difference between Expanded and Flexible?',
      answer:
          'Both are used inside Row/Column to distribute remaining space.\n\nExpanded: Forces the child to fill all available space along the main axis. Equivalent to Flexible with fit: FlexFit.tight.\n\nFlexible: Allows the child to be at most as large as the available space, but it can be smaller. Uses fit: FlexFit.loose by default — the child can shrink to its intrinsic size.\n\nUse Expanded when you want equal or proportional distribution. Use Flexible when the child should only take what it needs.',
      codeExample: '''Row(children: [
  Expanded(child: Text('Takes all available space')),
  Flexible(child: Text('Only as wide as needed')),
])''',
      level: QuestionLevel.intermediate,
      category: 'Layout',
    ),
    InterviewQuestion(
      id: 'q22',
      question: 'How does FutureBuilder work?',
      answer:
          'FutureBuilder is a widget that builds itself based on the latest snapshot of a Future. It is rebuilt every time the future completes or has an error.',
      codeExample: '''FutureBuilder<User>(
  future: fetchUser(userId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: \${snapshot.error}');
    }
    if (snapshot.hasData) {
      return UserCard(user: snapshot.data!);
    }
    return const Text('No data');
  },
)''',
      level: QuestionLevel.intermediate,
      category: 'Async',
    ),
    InterviewQuestion(
      id: 'q23',
      question: 'What is Hero animation in Flutter?',
      answer:
          'Hero is a widget that creates a "shared element" transition between two screens. When navigating, the widget with the same tag animates smoothly from its position on screen A to its position on screen B.\n\nRequirements:\n• Both screens must have a Hero widget\n• Both must have the same tag value\n• The tags must be unique within one screen',
      codeExample: '''// Screen A
Hero(
  tag: 'product-image-\${product.id}',
  child: Image.network(product.imageUrl),
)

// Screen B
Hero(
  tag: 'product-image-\${product.id}',
  child: Image.network(product.imageUrl, width: 300),
)''',
      level: QuestionLevel.intermediate,
      category: 'Animation',
    ),
    InterviewQuestion(
      id: 'q24',
      question: 'What is Isolate in Dart? When should you use it?',
      answer:
          'Dart is single-threaded, but you can run code in parallel using Isolates. Unlike threads (which share memory), Isolates have their own memory heap and communicate only via message passing.\n\nUse Isolates for:\n• Heavy CPU-bound computation (JSON parsing of large files, encryption, image processing)\n• Work that blocks the UI thread (the main Isolate)\n\nFor most tasks, use compute() which spawns a temporary Isolate:\ncompute(expensiveFunction, data)',
      codeExample: '''// Using compute() for heavy work
final result = await compute(parseHeavyJson, jsonString);

// Full Isolate example
final receivePort = ReceivePort();
await Isolate.spawn(heavyTask, receivePort.sendPort);
final result = await receivePort.first;''',
      level: QuestionLevel.intermediate,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q25',
      question: 'What is InheritedWidget?',
      answer:
          'InheritedWidget is Flutter\'s built-in mechanism to efficiently propagate data down the widget tree without explicitly passing it through constructors. Descendant widgets can access the data using context.dependOnInheritedWidgetOfExactType().\n\nWhen the InheritedWidget\'s data changes, only widgets that called dependOnInheritedWidgetOfExactType() (not context.getElementForInheritedWidgetOfExactType()) will rebuild.\n\nProvider, Theme, MediaQuery, and Navigator all use InheritedWidget internally.',
      level: QuestionLevel.intermediate,
      category: 'Internals',
    ),
    InterviewQuestion(
      id: 'q26',
      question: 'What is the difference between const and final in Dart?',
      answer:
          'final: Set once at runtime. The value doesn\'t have to be known at compile time.\nconst: Compile-time constant. The value must be known at compile time. const objects are canonicalized — identical const values share the same instance.\n\nIn Flutter, using const constructors (const Text, const SizedBox) is a powerful optimization — these widgets are never rebuilt because Flutter knows they\'re immutable.',
      codeExample: '''// final - set once, runtime value OK
final DateTime now = DateTime.now();

// const - compile-time constant
const double pi = 3.14159;
const Text label = Text('Hello'); // widget optimization

// const constructor
const SizedBox(height: 16) // Flutter reuses this instance''',
      level: QuestionLevel.intermediate,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q27',
      question: 'How do you handle forms and validation in Flutter?',
      answer:
          'Use Form with a GlobalKey<FormState> to group and validate multiple FormField widgets.\n\nKey steps:\n1. Wrap fields with Form and assign a GlobalKey\n2. Use TextFormField with validator callback\n3. Call formKey.currentState!.validate() on submit\n4. Use formKey.currentState!.save() to collect values',
      codeExample: '''final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(children: [
    TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (!value.contains('@')) return 'Invalid email';
        return null;
      },
    ),
    ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          // submit
        }
      },
      child: Text('Submit'),
    ),
  ]),
)''',
      level: QuestionLevel.intermediate,
      category: 'Widgets',
    ),
    InterviewQuestion(
      id: 'q28',
      question: 'What are mixins in Dart?',
      answer:
          'Mixins let you reuse code across multiple class hierarchies without inheritance. A mixin defines methods and properties that can be "mixed in" to another class.\n\nIn Flutter, common mixins:\n• SingleTickerProviderStateMixin — provides a single Ticker for AnimationController\n• TickerProviderStateMixin — provides multiple Tickers\n• AutomaticKeepAliveClientMixin — prevents page from being disposed in PageView/TabBarView',
      codeExample: '''mixin Validation {
  bool isValidEmail(String email) => email.contains('@');
  bool isValidPassword(String pw) => pw.length >= 8;
}

class LoginController with Validation {
  void login(String email, String pw) {
    if (isValidEmail(email) && isValidPassword(pw)) {
      // proceed
    }
  }
}

// Flutter animation mixin
class _MyState extends State<My> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
}''',
      level: QuestionLevel.intermediate,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q29',
      question: 'What are extensions in Dart?',
      answer:
          'Extensions allow you to add new methods to existing types without modifying the type or creating a subclass. They are resolved at compile time.',
      codeExample: '''extension StringExtensions on String {
  bool get isValidEmail => contains('@') && contains('.');
  String capitalize() => 
    isEmpty ? this : '\${this[0].toUpperCase()}\${substring(1)}';
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mq => MediaQuery.of(this);
  double get screenWidth => mq.size.width;
}

// Usage
"hello@world.com".isValidEmail // true
"hello".capitalize()           // "Hello"
context.screenWidth            // 390.0''',
      level: QuestionLevel.intermediate,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q30',
      question: 'How do you make HTTP requests in Flutter?',
      answer:
          'Use the http package (pub.dev) or dio for more features.\n\nBest practices:\n• Always handle errors with try/catch\n• Parse response in an Isolate (via compute) for large JSON\n• Cancel requests when the widget is disposed\n• Use an interceptor pattern (dio) for auth tokens',
      codeExample: '''// Using http package
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Post>> getPosts() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Authorization': 'Bearer \$token'},
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((j) => Post.fromJson(j)).toList();
  }
  throw HttpException('Failed: \${response.statusCode}');
}''',
      level: QuestionLevel.intermediate,
      category: 'Networking',
    ),

    // ─────────────── ADVANCED ───────────────
    InterviewQuestion(
      id: 'q31',
      question: 'What is the Flutter rendering pipeline?',
      answer:
          'Flutter\'s rendering pipeline per frame:\n\n1. Build — Widgets call build() to produce new widget descriptions\n2. Layout — RenderObjects measure and position themselves (constraints go down, sizes go up)\n3. Paint — RenderObjects paint themselves into layers using a Canvas\n4. Composite — Layers are sent to the GPU via the Skia/Impeller engine\n5. Rasterize — GPU converts the scene into pixels\n\nFlutter targets 60/120fps, so each frame has ~16ms/8ms budget.',
      level: QuestionLevel.advanced,
      category: 'Internals',
    ),
    InterviewQuestion(
      id: 'q32',
      question: 'What is RepaintBoundary and when should you use it?',
      answer:
          'RepaintBoundary creates a separate compositing layer for its child. This prevents the child\'s repaints from propagating to the parent layer (and vice versa).\n\nUse it for:\n• Widgets that animate frequently (particles, clocks, video)\n• Expensive widgets that rarely change but are siblings of frequently-changing ones\n• Cache GPU textures for static content\n\nDownside: Creates an extra compositing layer, which uses GPU memory. Use only when profiling shows it helps.',
      codeExample: '''RepaintBoundary(
  child: AnimatedParticleSystem(), // Repaints every frame
)''',
      level: QuestionLevel.advanced,
      category: 'Performance',
    ),
    InterviewQuestion(
      id: 'q33',
      question: 'What is the Bloc pattern?',
      answer:
          'BLoC (Business Logic Component) is a design pattern for Flutter that separates UI from business logic using Streams.\n\nCore concepts:\n• Event — input action from UI (LoginButtonPressed, SearchQueryChanged)\n• State — output state for UI (LoginLoading, LoginSuccess, LoginFailure)\n• Bloc — maps Events to States via an event handler\n\nCubit is a simplified BLoC without events — you call methods directly.\n\nAdvantages: Highly testable, clear separation of concerns, predictable state.',
      codeExample: '''// Cubit (simplified Bloc)
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// UI
BlocBuilder<CounterCubit, int>(
  builder: (context, count) => Text('\$count'),
)''',
      level: QuestionLevel.advanced,
      category: 'State',
    ),
    InterviewQuestion(
      id: 'q34',
      question: 'How do Platform Channels work in Flutter?',
      answer:
          'Platform Channels allow Flutter (Dart) to communicate with native code (Kotlin/Java on Android, Swift/ObjC on iOS).\n\nTypes:\n• MethodChannel — call native methods and get a response (most common)\n• EventChannel — receive a stream of events from native (sensors, location)\n• BasicMessageChannel — bidirectional message passing with custom codec\n\nFlow: Dart sends a message with a codec (JSON or binary), the native side handles it and replies, Dart receives the response.',
      codeExample: '''// Dart side
const channel = MethodChannel('com.example/battery');

Future<int> getBatteryLevel() async {
  final int level = await channel.invokeMethod('getBatteryLevel');
  return level;
}

// Android (Kotlin)
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, 
  "com.example/battery").setMethodCallHandler { call, result ->
  if (call.method == "getBatteryLevel") {
    result.success(getBatteryLevel())
  }
}''',
      level: QuestionLevel.advanced,
      category: 'Platform',
    ),
    InterviewQuestion(
      id: 'q35',
      question: 'What are CustomPainter and Canvas?',
      answer:
          'CustomPainter lets you draw anything on the canvas using low-level drawing operations — shapes, gradients, paths, images, text.\n\nKey methods in Canvas:\n• drawRect, drawCircle, drawOval\n• drawLine, drawPath\n• drawImage, drawParagraph\n• drawShadow, save/restore (layer stack)\n\nThe shouldRepaint() method controls when to re-draw. Return false if nothing visual changed to avoid wasted frames.',
      codeExample: '''class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50,
      paint,
    );
  }

  @override
  bool shouldRepaint(MyPainter old) => false;
}

// Usage
CustomPaint(painter: MyPainter(), size: Size(200, 200))''',
      level: QuestionLevel.advanced,
      category: 'Custom UI',
    ),
    InterviewQuestion(
      id: 'q36',
      question: 'How do you test Flutter apps?',
      answer:
          'Flutter has 3 levels of testing:\n\n1. Unit Tests — test individual functions/classes in isolation. Fast, no Flutter needed.\n2. Widget Tests — test individual widgets in isolation using WidgetTester. No real device needed.\n3. Integration Tests — test the whole app on a real device/emulator.\n\nPackages:\n• flutter_test — built-in for widget tests\n• mockito / mocktail — mocking dependencies\n• integration_test — for integration tests\n• golden_toolkit — snapshot/golden tests for visual regression',
      codeExample: '''// Widget test
testWidgets('Counter increments', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.text('0'), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});

// Unit test
test('UserModel fromJson works', () {
  final user = UserModel.fromJson({'id': 1, 'name': 'Alice'});
  expect(user.name, 'Alice');
});''',
      level: QuestionLevel.advanced,
      category: 'Testing',
    ),
    InterviewQuestion(
      id: 'q37',
      question: 'What is tree shaking in Flutter?',
      answer:
          'Tree shaking is a dead code elimination technique used during the release build. The Dart compiler (dart2js / AOT) analyzes the call graph and removes any code that is never reachable from the entry point.\n\nIn Flutter:\n• Unused widgets, methods, and classes are removed from the binary\n• Unused icon glyphs in icon fonts are stripped out\n• Unused packages that are imported but not called are eliminated\n\nThis makes Flutter release APKs/IPAs significantly smaller. Use flutter build apk --split-per-abi for further size reduction.',
      level: QuestionLevel.advanced,
      category: 'Performance',
    ),
    InterviewQuestion(
      id: 'q38',
      question: 'What is Impeller?',
      answer:
          'Impeller is Flutter\'s new rendering backend introduced as the default on iOS (Flutter 3.10+) and Android (Flutter 3.16+). It replaces the Skia-based renderer.\n\nKey improvements:\n• Eliminates shader compilation jank (Skia compiled shaders at runtime causing hitches)\n• Impeller pre-compiles a small set of shaders at engine build time\n• Smoother animations, especially on first run\n• Better Vulkan (Android) and Metal (iOS) utilization\n\nIf you see visual regressions, you can disable: flutter run --no-enable-impeller',
      level: QuestionLevel.advanced,
      category: 'Internals',
    ),
    InterviewQuestion(
      id: 'q39',
      question: 'What is Dependency Injection in Flutter?',
      answer:
          'Dependency Injection (DI) is a pattern where a class\'s dependencies are provided from outside rather than created internally. This improves testability and decoupling.\n\nWays to do DI in Flutter:\n• Constructor injection — pass dependencies in constructors (simplest)\n• InheritedWidget / Provider — inject via widget tree\n• GetIt (service locator) — global singleton registry\n• GetX — Get.put() / Get.find()\n• Riverpod — providers as dependencies\n\nFor testing, you swap real implementations with mocks at the injection point.',
      level: QuestionLevel.advanced,
      category: 'Architecture',
    ),
    InterviewQuestion(
      id: 'q40',
      question: 'What is Clean Architecture in Flutter?',
      answer:
          'Clean Architecture separates the app into concentric layers:\n\n1. Presentation — Widgets, BLoC/Controller, ViewModels (depends on Use Cases)\n2. Domain — Entities, Use Cases / Interactors, Repository interfaces (pure Dart, no Flutter)\n3. Data — Repository implementations, Data Sources (Remote/Local), Models (DTOs)\n\nDependency Rule: Outer layers depend on inner layers, never the reverse. The Domain layer has zero dependencies on Flutter or third-party packages.\n\nBenefits: Testability, replaceability of data sources, maintainability at scale.',
      level: QuestionLevel.advanced,
      category: 'Architecture',
    ),
    InterviewQuestion(
      id: 'q41',
      question: 'How do you optimize Flutter app performance?',
      answer:
          'Key performance optimization techniques:\n\n• Use const constructors — avoid unnecessary rebuilds\n• Use ListView.builder — lazy rendering for lists\n• Avoid building in build() — use initState or controllers\n• Use RepaintBoundary — isolate expensive paint operations\n• Cache network images (cached_network_image)\n• Profile with DevTools — identify janky frames\n• Use compute() for heavy work\n• Avoid overdraw — use opacity sparingly (prefer transparency in colors)\n• Use SliverList instead of Column in scrolling contexts\n• Minimize widget rebuilds with Selector (Provider) or Obx (GetX)',
      level: QuestionLevel.advanced,
      category: 'Performance',
    ),
    InterviewQuestion(
      id: 'q42',
      question: 'What is the difference between WidgetsApp and MaterialApp?',
      answer:
          'WidgetsApp: The minimal Flutter app wrapper. Provides Navigator, Localizations, MediaQuery, and basic routing. No Material Design.\n\nMaterialApp: Extends WidgetsApp with Material Design: Theme, Material widgets, Scaffold, AppBar, Snackbar, Dialog, and MaterialPageRoute transitions.\n\nCupertinoApp: Extends WidgetsApp with iOS-style Cupertino design.\n\nIn practice, always use MaterialApp (or CupertinoApp for iOS look). WidgetsApp is for custom design systems.',
      level: QuestionLevel.advanced,
      category: 'Basics',
    ),
    InterviewQuestion(
      id: 'q43',
      question: 'What is Flutter\'s approach to accessibility?',
      answer:
          'Flutter provides built-in accessibility support through the Semantics widget, which creates a semantics tree alongside the widget tree. Screen readers (TalkBack on Android, VoiceOver on iOS) use this tree.\n\nBuilt-in support:\n• Most Material widgets add semantics automatically\n• Images should have semanticLabel\n• Custom widgets need explicit Semantics()\n• Use ExcludeSemantics to hide decorative elements\n• MergeSemantics combines child semantics\n\nTest with: flutter test --accessibility-checker, or system accessibility settings.',
      codeExample: '''Semantics(
  label: 'User profile picture of John',
  button: false,
  child: CircleAvatar(backgroundImage: NetworkImage(url)),
)''',
      level: QuestionLevel.advanced,
      category: 'Accessibility',
    ),
    InterviewQuestion(
      id: 'q44',
      question: 'What are generics in Dart and how are they used in Flutter?',
      answer:
          'Generics allow you to write type-safe, reusable code. A generic class or function works with any type, while the compiler still enforces type safety.\n\nIn Flutter/Dart, generics are used extensively:\n• Future<T>, Stream<T> — typed async values\n• List<Widget>, Map<String, dynamic>\n• Provider<T>, BlocProvider<T>\n• GlobalKey<FormState>, ValueNotifier<T>',
      codeExample: '''// Generic repository
abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T> getById(String id);
  Future<void> save(T item);
}

// Generic API response wrapper
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  ApiResponse.success(this.data) 
    : error = null, isSuccess = true;
  ApiResponse.failure(this.error) 
    : data = null, isSuccess = false;
}''',
      level: QuestionLevel.advanced,
      category: 'Dart',
    ),
    InterviewQuestion(
      id: 'q45',
      question: 'What is a SliverAppBar and how do Slivers work?',
      answer:
          'Slivers are scrollable areas with lazy rendering that only build visible content. They form the backbone of CustomScrollView.\n\nCommon Slivers:\n• SliverAppBar — collapsible/pinned app bar\n• SliverList — lazy scrolling list\n• SliverGrid — lazy scrolling grid\n• SliverToBoxAdapter — wraps a regular widget\n• SliverFillRemaining — fills remaining space\n• SliverPersistentHeader — custom collapsing header\n\nSliverAppBar gives you expandedHeight (shows large image/title when scrolled to top) and pinned/floating/snap behavior.',
      codeExample: '''CustomScrollView(
  slivers: [
    SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('My App'),
        background: Image.network(headerUrl, fit: BoxFit.cover),
      ),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Item \$index')),
        childCount: 50,
      ),
    ),
  ],
)''',
      level: QuestionLevel.advanced,
      category: 'Layout',
    ),
  ];
}
