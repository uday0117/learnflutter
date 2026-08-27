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

    // ── More Widgets ──
    QuizQuestion(
      question: 'Which widget wraps its child in Material Design ink splash effects?',
      options: ['GestureDetector', 'InkWell', 'MaterialButton', 'SplashBox'],
      correctIndex: 1,
      explanation:
          'InkWell shows Material ink splash and highlight effects on tap.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'What widget is used to clip its child to a specific shape?',
      options: ['ClipRRect', 'ShapeClip', 'BorderClip', 'MaskWidget'],
      correctIndex: 0,
      explanation:
          'ClipRRect clips its child using rounded rectangle borders.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'Which widget provides a dropdown menu of items?',
      options: ['DropdownMenu', 'SelectBox', 'MenuButton', 'PopupMenu'],
      correctIndex: 0,
      explanation:
          'DropdownMenu (Material 3) provides a dropdown selection menu.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'What widget displays a circular progress indicator?',
      options: [
        'ProgressBar',
        'CircularProgressIndicator',
        'LoadingSpinner',
        'ActivityIndicator'
      ],
      correctIndex: 1,
      explanation:
          'CircularProgressIndicator shows Material Design circular loading progress.',
      category: QuizCategory.widgets,
    ),
    QuizQuestion(
      question: 'Which widget is used for swipe-to-dismiss behavior?',
      options: ['SwipeAction', 'Dismissible', 'SlideToDelete', 'SwipeBox'],
      correctIndex: 1,
      explanation:
          'Dismissible wraps a child that can be dismissed by swiping.',
      category: QuizCategory.widgets,
    ),

    // ── More Layout ──
    QuizQuestion(
      question: 'Which widget creates a grid of equally sized children?',
      options: ['GridView', 'TableView', 'GridLayout', 'MatrixView'],
      correctIndex: 0,
      explanation:
          'GridView displays items in a scrollable 2D grid layout.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'What does `Expanded` do inside a Row or Column?',
      options: [
        'Adds padding',
        'Fills remaining space along the main axis',
        'Centers the child',
        'Wraps content size'
      ],
      correctIndex: 1,
      explanation:
          'Expanded forces its child to fill available space in a Flex layout.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'Which widget stacks children on top of each other?',
      options: ['Layer', 'Stack', 'Overlay', 'ZIndex'],
      correctIndex: 1,
      explanation:
          'Stack positions children relative to the edges of the stack box.',
      category: QuizCategory.layout,
    ),
    QuizQuestion(
      question: 'What widget provides a fixed header while content scrolls?',
      options: ['StickyHeader', 'SliverAppBar', 'FixedBar', 'HeaderView'],
      correctIndex: 1,
      explanation:
          'SliverAppBar is a sliver that can pin or float while scrolling.',
      category: QuizCategory.layout,
    ),

    // ── More State ──
    QuizQuestion(
      question: 'What is the purpose of `initState()` in a StatefulWidget?',
      options: [
        'Build the UI',
        'One-time initialization before first build',
        'Dispose resources',
        'Update state on every rebuild'
      ],
      correctIndex: 1,
      explanation:
          'initState() is called once when the State object is created, ideal for setup.',
      category: QuizCategory.state,
    ),
    QuizQuestion(
      question: 'Which method is called when a StatefulWidget is removed from the tree?',
      options: ['onDestroy', 'dispose', 'deinit', 'cleanup'],
      correctIndex: 1,
      explanation:
          'dispose() is called when the State object is permanently removed.',
      category: QuizCategory.state,
    ),
    QuizQuestion(
      question: 'What does `setState()` do?',
      options: [
        'Rebuilds the entire app',
        'Notifies framework that state changed and triggers rebuild',
        'Saves state to disk',
        'Resets all variables'
      ],
      correctIndex: 1,
      explanation:
          'setState() marks the widget dirty so Flutter rebuilds it with new state.',
      category: QuizCategory.state,
    ),

    // ── More Dart ──
    QuizQuestion(
      question: 'What is a `mixin` in Dart?',
      options: [
        'A type of widget',
        'A way to reuse code across class hierarchies',
        'A database query',
        'An async function'
      ],
      correctIndex: 1,
      explanation:
          'Mixins let you reuse methods across multiple classes without inheritance.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'What does the `late` keyword do in Dart?',
      options: [
        'Makes a variable final',
        'Defers initialization but enforces it before use',
        'Creates a lazy widget',
        'Marks a variable as nullable'
      ],
      correctIndex: 1,
      explanation:
          'late allows non-nullable variables to be initialized later, with runtime check.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'Which collection type stores unique values in Dart?',
      options: ['List', 'Map', 'Set', 'Queue'],
      correctIndex: 2,
      explanation:
          'Set stores unique elements with no duplicates.',
      category: QuizCategory.dart,
    ),
    QuizQuestion(
      question: 'What is the output type of an async function in Dart?',
      options: ['Stream', 'Future', 'Promise', 'AsyncResult'],
      correctIndex: 1,
      explanation:
          'Async functions always return a Future (or Future<T> for typed returns).',
      category: QuizCategory.dart,
    ),

    // ── More Navigation ──
    QuizQuestion(
      question: 'What does `Get.back()` do in GetX?',
      options: [
        'Go to home screen',
        'Pop the current route off the navigation stack',
        'Close the app',
        'Show a snackbar'
      ],
      correctIndex: 1,
      explanation:
          'Get.back() pops the current screen, equivalent to Navigator.pop().',
      category: QuizCategory.navigation,
    ),
    QuizQuestion(
      question: 'Which widget is used for named route navigation in MaterialApp?',
      options: ['RouteManager', 'Navigator', 'ScreenRouter', 'PageStack'],
      correctIndex: 1,
      explanation:
          'Navigator manages a stack of Route objects for screen transitions.',
      category: QuizCategory.navigation,
    ),
  ];
}
