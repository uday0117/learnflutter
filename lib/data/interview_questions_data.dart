import '../models/interview_question_model.dart';

class InterviewQuestionsData {
  static List<InterviewQuestionModel> getAllQuestions() {
    return [
      // Flutter Questions
      InterviewQuestionModel(
        id: 'iq1',
        category: 'Flutter',
        question: 'What is Flutter and why is it used?',
        answer: '''
Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, and the web from a single codebase.

Key advantages:
• Single codebase for multiple platforms
• Fast development with hot reload
• Beautiful and customizable UI
• Native performance
• Rich widget library
• Strong community support
• Backed by Google
        ''',
        difficulty: 'beginner',
      ),
      InterviewQuestionModel(
        id: 'iq2',
        category: 'Flutter',
        question:
            'Explain the difference between StatelessWidget and StatefulWidget',
        answer: '''
StatelessWidget:
• Immutable widget
• Cannot change state
• Rebuilds only when parent rebuilds
• Used for static content
• Simple lifecycle
• Better performance for static UIs

StatefulWidget:
• Has mutable state
• Can change state using setState()
• Complex lifecycle with methods like initState(), dispose()
• Used for dynamic content
• Maintains state across rebuilds
• Slightly slower due to state management

Example use cases:
- StatelessWidget: Text, Icon, Image display
- StatefulWidget: Forms, animations, user interactions
        ''',
        codeExample: '''
// StatelessWidget
class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('I am immutable');
  }
}

// StatefulWidget
class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: \$counter'),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
''',
        difficulty: 'beginner',
      ),
      InterviewQuestionModel(
        id: 'iq3',
        category: 'Flutter',
        question: 'What is the widget tree in Flutter?',
        answer: '''
The widget tree is a hierarchical structure of widgets in Flutter. Every Flutter app is built using a tree of widgets, where:

• Each widget is a node in the tree
• Parent widgets contain child widgets
• Root widget is typically MaterialApp or CupertinoApp
• Widgets describe what their view should look like given their current configuration and state

Types of trees in Flutter:
1. Widget Tree: The configuration/blueprint
2. Element Tree: Manages the widget instances
3. RenderObject Tree: Handles layout and painting

Benefits:
• Declarative UI
• Easy composition
• Efficient updates
• Hot reload support
        ''',
        difficulty: 'intermediate',
      ),
      InterviewQuestionModel(
        id: 'iq4',
        category: 'Flutter',
        question: 'Explain Flutter\'s build process and widget lifecycle',
        answer: '''
Flutter Build Process:
1. Widget tree is created
2. Element tree is built (manages widgets)
3. RenderObject tree is created (handles rendering)
4. Layout is computed
5. Painting occurs
6. Compositing layers are created
7. Screen is updated

StatefulWidget Lifecycle:
1. createState() - Creates the State object
2. initState() - Called once when widget is created
3. didChangeDependencies() - Called after initState and when dependencies change
4. build() - Builds the widget tree
5. didUpdateWidget() - Called when widget configuration changes
6. setState() - Triggers rebuild
7. deactivate() - Called when widget is removed from tree
8. dispose() - Called when widget is permanently removed
        ''',
        codeExample: '''
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    print('1. initState called');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('2. didChangeDependencies called');
  }

  @override
  Widget build(BuildContext context) {
    print('3. build called');
    return Container();
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('4. didUpdateWidget called');
  }

  @override
  void dispose() {
    print('5. dispose called');
    super.dispose();
  }
}
''',
        difficulty: 'intermediate',
      ),
      InterviewQuestionModel(
        id: 'iq5',
        category: 'Flutter',
        question: 'What are Keys in Flutter and when should you use them?',
        answer: '''
Keys are identifiers for widgets, elements, and semantic nodes. They help Flutter identify which widgets have changed, been added, or removed.

Types of Keys:
1. ValueKey: Uses a value (int, string, etc.)
2. ObjectKey: Uses an object
3. UniqueKey: Always creates a unique key
4. GlobalKey: Provides access to widget state across the app

When to use Keys:
• Reordering list items
• Maintaining state when widget order changes
• Accessing widget state from another widget (GlobalKey)
• Preserving scroll position
• Form validation

Example use cases:
- ListView with reorderable items
- Tab navigation preserving state
- Form fields maintaining focus
        ''',
        codeExample: '''
// Using ValueKey in ListView
ListView(
  children: items.map((item) => 
    ListTile(
      key: ValueKey(item.id),
      title: Text(item.name),
    )
  ).toList(),
)

// Using GlobalKey to access state
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Process form
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
''',
        difficulty: 'intermediate',
      ),

      // Dart Questions
      InterviewQuestionModel(
        id: 'iq6',
        category: 'Dart',
        question: 'What is null safety in Dart and why is it important?',
        answer: '''
Null safety is a feature in Dart that helps prevent null reference errors at compile time rather than runtime.

Key concepts:
• Non-nullable types by default
• Nullable types marked with ?
• Null-aware operators (??, ?., ?.., !)
• late keyword for delayed initialization
• required keyword for named parameters

Benefits:
• Catch null errors at compile time
• Cleaner, safer code
• Better IDE support
• Fewer runtime crashes
• More confident refactoring

Types:
- String (non-nullable)
- String? (nullable)
- late String (non-nullable, initialized later)
        ''',
        codeExample: '''
// Non-nullable
String name = 'Flutter'; // Cannot be null

// Nullable
String? optionalName; // Can be null

// Null-aware operators
String displayName = optionalName ?? 'Guest'; // Default value
int? length = optionalName?.length; // Safe navigation
optionalName ??= 'Default'; // Assign if null

// late keyword
late String apiKey;

void initializeApiKey() {
  apiKey = 'abc123'; // Must initialize before use
}

// required keyword
class User {
  final String name;
  final String? email;
  
  User({
    required this.name, // Must be provided
    this.email, // Optional
  });
}
''',
        difficulty: 'intermediate',
      ),
      InterviewQuestionModel(
        id: 'iq7',
        category: 'Dart',
        question: 'Explain async/await and Futures in Dart',
        answer: '''
Future represents a value that will be available at some point in the future. async/await makes asynchronous code look synchronous.

Key concepts:
• Future: Represents a potential value or error
• async: Marks a function as asynchronous
• await: Waits for a Future to complete
• then(): Chain multiple async operations
• catchError(): Handle errors

States of a Future:
1. Uncompleted: Operation in progress
2. Completed with value: Success
3. Completed with error: Failure

Best practices:
• Use async/await for readability
• Handle errors with try-catch
• Use FutureBuilder for UI
• Avoid blocking the main thread
        ''',
        codeExample: '''
// Future with async/await
Future<String> fetchUserData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'User Data';
}

// Using the Future
void loadData() async {
  try {
    String data = await fetchUserData();
    print(data);
  } catch (e) {
    print('Error: \$e');
  }
}

// Future with then()
fetchUserData()
  .then((data) => print(data))
  .catchError((error) => print(error));

// Multiple Futures
Future<void> loadMultipleData() async {
  final results = await Future.wait([
    fetchUserData(),
    fetchSettings(),
    fetchPreferences(),
  ]);
  print('All data loaded: \$results');
}

// FutureBuilder in UI
FutureBuilder<String>(
  future: fetchUserData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: \${snapshot.error}');
    }
    return Text('Data: \${snapshot.data}');
  },
)
''',
        difficulty: 'intermediate',
      ),

      // GetX Questions
      InterviewQuestionModel(
        id: 'iq8',
        category: 'GetX',
        question: 'What is GetX and what are its main features?',
        answer: '''
GetX is a lightweight and powerful state management, dependency injection, and route management solution for Flutter.

Main Features:
1. State Management: Reactive programming with minimal boilerplate
2. Route Management: Navigation without context
3. Dependency Injection: Smart dependency management
4. Internationalization: Easy translation support
5. Utilities: Snackbars, dialogs, bottom sheets without context

Advantages:
• Minimal boilerplate code
• High performance
• No code generators needed
• Easy to learn
• Decouples business logic from UI
• Memory efficient

State Management Approaches:
1. Simple State Manager (GetBuilder)
2. Reactive State Manager (Obx, GetX)
3. Get State Manager (GetX widget)
        ''',
        codeExample: '''
// Controller
class CounterController extends GetxController {
  var count = 0.obs; // Observable
  
  void increment() => count++;
  void decrement() => count--;
}

// View with Obx
class CounterView extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GetX Counter')),
      body: Center(
        child: Obx(() => Text(
          'Count: \${controller.count}',
          style: TextStyle(fontSize: 32),
        )),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: controller.increment,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: controller.decrement,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

// Navigation
Get.to(NextScreen());
Get.back();
Get.off(ReplacementScreen());
Get.offAll(HomeScreen());

// SnackBar without context
Get.snackbar('Title', 'Message');
''',
        difficulty: 'intermediate',
      ),

      // Firebase Questions
      InterviewQuestionModel(
        id: 'iq9',
        category: 'Firebase',
        question: 'What is Firebase and what services does it provide?',
        answer: '''
Firebase is a Backend-as-a-Service (BaaS) platform by Google that provides various services for mobile and web applications.

Core Services:
1. Authentication: Email, phone, social logins
2. Firestore: NoSQL cloud database
3. Realtime Database: Real-time data sync
4. Cloud Storage: File storage
5. Cloud Messaging (FCM): Push notifications
6. Analytics: User behavior tracking
7. Crashlytics: Crash reporting
8. Cloud Functions: Serverless functions
9. Hosting: Web app hosting
10. Remote Config: Dynamic app configuration

Benefits:
• Reduces backend development time
• Scalable infrastructure
• Real-time capabilities
• Easy integration
• Free tier available
• Google's infrastructure

Common Use Cases:
- User authentication
- Real-time chat apps
- Data synchronization
- File uploads
- Push notifications
- Analytics tracking
        ''',
        difficulty: 'beginner',
      ),
      InterviewQuestionModel(
        id: 'iq10',
        category: 'Firebase',
        question: 'Explain Firebase Authentication and its methods',
        answer: '''
Firebase Authentication provides backend services and SDKs to authenticate users to your app.

Authentication Methods:
1. Email/Password: Traditional authentication
2. Phone Authentication: SMS verification
3. Google Sign-In: Google account
4. Facebook Login: Facebook account
5. Apple Sign-In: Apple ID
6. Anonymous Auth: Temporary accounts
7. Custom Auth: Your own system

Key Features:
• Secure authentication
• Multi-factor authentication
• Email verification
• Password reset
• Account linking
• User management

Benefits:
• Drop-in UI components
• Security built-in
• Cross-platform
• Token-based auth
• Session management
        ''',
        codeExample: '''
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email/Password Sign Up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error: \$e');
      return null;
    }
  }

  // Email/Password Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error: \$e');
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Auth State Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
''',
        difficulty: 'intermediate',
      ),
    ];
  }
}
