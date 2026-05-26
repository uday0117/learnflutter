import '../models/tutorial_model.dart';

class StateManagementData {
  static List<TutorialModel> getAllTutorials() {
    return [
      TutorialModel(
        id: 'sm1',
        categoryId: 'state_management',
        title: 'GetX State Management',
        description: 'Master GetX for reactive state management',
        category: 'State Management',
        difficulty: 'Beginner',
        content: r'''
# GetX State Management

## Setup

```yaml
dependencies:
  get: ^4.6.6
```

## Simple State Management

```dart
import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 0.obs;  // Observable variable

  void increment() => count++;
  void decrement() => count--;
}

// In your widget
class CounterPage extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => Text('Count: ${controller.count}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## GetX vs Obx

```dart
// Using GetX (includes controller)
GetX<CounterController>(
  init: CounterController(),
  builder: (controller) {
    return Text('${controller.count}');
  },
)

// Using Obx (finds existing controller)
Obx(() => Text('${controller.count}'))
```

## Reactive Lists and Maps

```dart
class TodoController extends GetxController {
  var todos = <String>[].obs;
  var userMap = <String, dynamic>{}.obs;

  void addTodo(String todo) {
    todos.add(todo);
  }

  void removeTodo(int index) {
    todos.removeAt(index);
  }
}
```
''',
      ),
      TutorialModel(
        id: 'sm2',
        categoryId: 'state_management',
        title: 'Provider Pattern',
        description: 'Learn Provider for state management',
        category: 'State Management',
        difficulty: 'Intermediate',
        content: r'''
# Provider State Management

## Setup

```yaml
dependencies:
  provider: ^6.1.1
```

## ChangeNotifier Provider

```dart
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

// In main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: MyApp(),
    ),
  );
}

// In your widget
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<CounterProvider>(context);
    
    return Scaffold(
      body: Center(
        child: Text('Count: ${counter.count}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Consumer Widget

```dart
Consumer<CounterProvider>(
  builder: (context, counter, child) {
    return Text('Count: ${counter.count}');
  },
)
```

## MultiProvider

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CounterProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ],
  child: MyApp(),
)
```
''',
      ),
      TutorialModel(
        id: 'sm3',
        categoryId: 'state_management',
        title: 'Riverpod',
        description: 'Next generation Provider',
        category: 'State Management',
        difficulty: 'Advanced',
        content: r'''
# Riverpod State Management

## Setup

```yaml
dependencies:
  flutter_riverpod: ^2.4.10
```

## Provider Types

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State Provider
final counterProvider = StateProvider<int>((ref) => 0);

// StateNotifier Provider
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

final counterNotifierProvider = 
    StateNotifierProvider<CounterNotifier, int>(
  (ref) => CounterNotifier(),
);

// Future Provider
final userProvider = FutureProvider<User>((ref) async {
  return await fetchUser();
});
```

## Using Providers

```dart
class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Scaffold(
      body: Center(
        child: Text('Count: $count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: Icon(Icons.add),
      ),
    );
  }
}
```
''',
      ),
      TutorialModel(
        id: 'sm4',
        categoryId: 'state_management',
        title: 'BLoC Pattern',
        description: 'Business Logic Component pattern',
        category: 'State Management',
        difficulty: 'Advanced',
        content: r'''
# BLoC (Business Logic Component)

## Setup

```yaml
dependencies:
  flutter_bloc: ^8.1.3
```

## Counter BLoC

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// States
class CounterState {
  final int count;
  CounterState(this.count);
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    on<Decrement>((event, emit) {
      emit(CounterState(state.count - 1));
    });
  }
}

// In main.dart
void main() {
  runApp(
    BlocProvider(
      create: (context) => CounterBloc(),
      child: MyApp(),
    ),
  );
}

// In your widget
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return Center(
            child: Text('Count: ${state.count}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterBloc>().add(Increment());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```
''',
      ),
    ];
  }
}
