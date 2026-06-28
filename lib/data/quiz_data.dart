enum QuizCategory { widgets, layout, state, dart, navigation }

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final QuizCategory category;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
  });
}

class QuizData {
  static const List<QuizQuestion> all = [
    // ── Widgets ──
    QuizQuestion(
      question: 'Which widget is used to display text in Flutter?',
      options: ['Label', 'Text', 'TextView', 'Paragraph'],
      correctIndex: 1,
      explanation:
          'The Text widget displays a string of text with a single style.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'What widget creates a scrollable list of items?',
      options: ['ScrollView', 'ListView', 'RecyclerView', 'ListWidget'],
      correctIndex: 1,
      explanation:
          'ListView creates a linear, scrollable list of widgets.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'Which widget provides Material Design scaffold functionality?',
      options: ['Container', 'MaterialApp', 'Scaffold', 'Widget'],
      correctIndex: 2,
      explanation:
          'Scaffold provides the basic Material Design visual layout structure (AppBar, Body, FAB, etc.).',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'What widget detects touch gestures on its child?',
      options: ['TouchDetector', 'GestureDetector', 'InkWell', 'TapListener'],
      correctIndex: 1,
      explanation:
          'GestureDetector detects gestures like tap, double tap, long press, drag, and more.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'Which widget adds padding around its child?',
      options: ['Margin', 'Spacing', 'Padding', 'Insets'],
      correctIndex: 2,
      explanation:
          'The Padding widget insets its child by the given EdgeInsets.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'What widget is used for shared element animations between screens?',
      options: ['AnimatedWidget', 'Hero', 'Transition', 'SharedElement'],
      correctIndex: 1,
      explanation:
          'Hero animates a widget from one screen to another using a shared tag.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'Which widget creates a Material Design card with elevation?',
      options: ['Box', 'Panel', 'Card', 'Surface'],
      correctIndex: 2,
      explanation:
          'Card is a Material Design surface with elevation and rounded corners.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'What widget is used to display a network image?',
      options: ['NetworkImage', 'Image.network', 'RemoteImage', 'WebImage'],
      correctIndex: 1,
      explanation:
          'Image.network() is the constructor used to load and display images from the internet.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'Which widget creates a floating action button?',
      options: ['ActionButton', 'FloatingButton', 'FloatingActionButton', 'FAB'],
      correctIndex: 2,
      explanation:
          'FloatingActionButton (FAB) is a circular button that floats above the content.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'What widget makes a widget fill available space in Row/Column?',
      options: ['Flexible', 'Expanded', 'Spacer', 'Fill'],
      correctIndex: 1,
      explanation:
          'Expanded forces its child to fill all available space along the main axis.',
      category: QuizCategory.layout,
    ),

    // ── Layout ──
    QuizQuestion(
      question: 'Which widget arranges children horizontally?',
      options: ['Column', 'Row', 'Stack', 'Wrap'],
      correctIndex: 1,
      explanation: 'Row lays out its children in a horizontal array.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'Which widget arranges children vertically?',
      options: ['Row', 'Vertical', 'Column', 'Stack'],
      correctIndex: 2,
      explanation: 'Column lays out its children in a vertical array.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'Which widget places children on top of each other?',
      options: ['Overlap', 'Layer', 'Stack', 'Overlay'],
      correctIndex: 2,
      explanation:
          'Stack overlaps its children, painting them in order from bottom to top.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'What does `mainAxisAlignment: MainAxisAlignment.center` do in a Column?',
      options: [
        'Centers children horizontally',
        'Centers children vertically',
        'Adds spacing between children',
        'Makes the column take full width'
      ],
      correctIndex: 1,
      explanation:
          'In a Column, the main axis is vertical, so center aligns children along the vertical axis.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'Which widget wraps its children to the next line when there is no space?',
      options: ['FlexBox', 'Wrap', 'FlowLayout', 'WrapRow'],
      correctIndex: 1,
      explanation:
          'Wrap lays children out like a Row but continues to the next line when out of space.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'What widget is used to create a custom scroll view with slivers?',
      options: ['ScrollView', 'CustomScrollView', 'SliverList', 'NestedScrollView'],
      correctIndex: 1,
      explanation:
          'CustomScrollView uses slivers to create scrollable effects like collapsible headers.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'Which widget constrains its child to a specific size?',
      options: ['SizeBox', 'SizedBox', 'ConstrainedBox', 'FixedBox'],
      correctIndex: 1,
      explanation:
          'SizedBox constrains its child to have a specific width and/or height.',
      category: QuizCategory.layout,
    ),

    // ── State Management ──
    QuizQuestion(
      question: 'Which method triggers a UI rebuild in StatefulWidget?',
      options: ['rebuild()', 'refresh()', 'setState()', 'update()'],
      correctIndex: 2,
      explanation:
          'setState() notifies the framework that state has changed and schedules a rebuild.',
      category: QuizCategory.state,
    ),
    QuizQuestion(
      question: 'What is the difference between StatefulWidget and StatelessWidget?',
      options: [
        'StatefulWidget is faster',
        'StatelessWidget cannot have children',
        'StatefulWidget has mutable state that can trigger rebuilds',
        'StatelessWidget cannot use themes'
      ],
      correctIndex: 2,
      explanation:
          'StatefulWidget has associated State objects that hold mutable data and can rebuild.',
      category: QuizCategory.state,
    ),
    QuizQuestion(
      question: 'In GetX, which widget rebuilds when an observable changes?',
      options: ['GetWidget', 'Obx', 'Observer', 'ReactiveWidget'],
      correctIndex: 1,
      explanation:
          'Obx wraps a builder that automatically rebuilds when any Rx variable inside changes.',
      category: QuizCategory.state,
    ),
    QuizQuestion(
      question: 'What suffix makes a variable observable in GetX?',
      options: ['.watch', '.rx', '.obs', '.live'],
      correctIndex: 2,
      explanation:
          'The .obs extension on any value creates an Rx (reactive/observable) variable.',
      category: QuizCategory.state,
    ),
    QuizQuestion(
      question: 'Which lifecycle method is called once when a GetX controller initialises?',
      options: ['onCreate()', 'onStart()', 'onInit()', 'start()'],
      correctIndex: 2,
      explanation:
          'onInit() is called once after the controller is created and registered.',
      category: QuizCategory.state,
    ),

    // ── Dart ──
    QuizQuestion(
      question: 'What does the `async` keyword do in Dart?',
      options: [
        'Makes the function run on a background thread',
        'Allows using `await` inside the function',
        'Creates a new isolate',
        'Runs the function immediately'
      ],
      correctIndex: 1,
      explanation:
          'async marks a function so it can use the await keyword to pause execution.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'What is a `Future` in Dart?',
      options: [
        'A scheduled widget build',
        'A value that will be available at some point in the future',
        'A deprecated API',
        'A synchronous value'
      ],
      correctIndex: 1,
      explanation:
          'A Future represents an asynchronous computation that will complete with a value or error.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'What does `final` mean in Dart?',
      options: [
        'The variable is constant at compile time',
        'The variable can only be assigned once at runtime',
        'The variable is private',
        'The variable is nullable'
      ],
      correctIndex: 1,
      explanation:
          'final variables can only be set once; unlike const they can be assigned at runtime.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'What is a `Stream` in Dart?',
      options: [
        'A file input stream',
        'A sequence of asynchronous data events',
        'A network request',
        'A list of Futures'
      ],
      correctIndex: 1,
      explanation:
          'A Stream provides a sequence of async events, like an asynchronous Iterable.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'Which operator is used for null-aware access in Dart?',
      options: ['?:', '??', '?.', '!.'],
      correctIndex: 2,
      explanation:
          'The ?. operator safely calls a method on a nullable object, returning null if it is null.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'What does `??` do in Dart?',
      options: [
        'Checks if a value is null',
        'Returns the right value if the left is null',
        'Negates a boolean',
        'Casts a type'
      ],
      correctIndex: 1,
      explanation:
          'The ?? operator returns the left-hand value if non-null, otherwise the right-hand value.',
      category: QuizCategory.dart,
    ),

    // ── Navigation ──
    QuizQuestion(
      question: 'How do you navigate to a new screen using GetX?',
      options: [
        'Navigator.push(context, route)',
        'Get.to(() => MyScreen())',
        'Router.go(MyScreen)',
        'navigate(MyScreen)'
      ],
      correctIndex: 1,
      explanation:
          'Get.to() navigates to a new screen without needing context.',
      category: QuizCategory.navigation,
    ),
    QuizQuestion(
      question: 'Which GetX method navigates and removes all previous routes?',
      options: ['Get.push()', 'Get.off()', 'Get.offAll()', 'Get.clear()'],
      correctIndex: 2,
      explanation:
          'Get.offAll() navigates to a new screen and removes all previous routes from the stack.',
      category: QuizCategory.navigation,
    ),
    QuizQuestion(
      question: 'What does `Navigator.pop(context)` do?',
      options: [
        'Opens a new screen',
        'Removes the current screen from the navigation stack',
        'Shows a dialog',
        'Restarts the app'
      ],
      correctIndex: 1,
      explanation:
          'Navigator.pop() removes the current route from the stack, returning to the previous screen.',
      category: QuizCategory.navigation,
    ),
  ];
}
