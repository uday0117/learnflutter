import '../models/tutorial_model.dart';

class ProjectsData {
  static List<TutorialModel> getAllProjects() {
    return [
      TutorialModel(
        id: 'proj1',
        categoryId: 'projects',
        title: 'Todo App with GetX',
        description: 'Build a complete todo app using GetX state management',
        category: 'Projects',
        difficulty: 'Beginner',
        content: r'''
# Todo App with GetX

## Project Structure
```
lib/
  ├── controllers/
  │   └── todo_controller.dart
  ├── models/
  │   └── todo_model.dart
  ├── views/
  │   └── todo_page.dart
  └── main.dart
```

## Todo Model

```dart
class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, this.completed = false});

  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
```

## Todo Controller

```dart
import 'package:get/get.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  void addTodo(String title) {
    todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
    ));
  }

  void toggleTodo(String id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = todos[index];
      todos[index] = todo.copyWith(completed: !todo.completed);
    }
  }

  void deleteTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
  }

  int get completedCount => todos.where((todo) => todo.completed).length;
  int get pendingCount => todos.where((todo) => !todo.completed).length;
}
```

## Todo Page

```dart
class TodoPage extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Obx(() => Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Pending: ${controller.pendingCount}'),
                Text('Completed: ${controller.completedCount}'),
              ],
            ),
          )),
        ),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.todos.length,
        itemBuilder: (context, index) {
          final todo = controller.todos[index];
          return ListTile(
            leading: Checkbox(
              value: todo.completed,
              onChanged: (_) => controller.toggleTodo(todo.id),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => controller.deleteTodo(todo.id),
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: Text('Add Todo'),
              content: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Enter todo'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      controller.addTodo(textController.text);
                      textController.clear();
                      Get.back();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```
''',
      ),
      TutorialModel(
        id: 'proj2',
        categoryId: 'projects',
        title: 'Weather App with API',
        description: 'Fetch and display weather data from API',
        category: 'Projects',
        difficulty: 'Intermediate',
        content: r'''
# Weather App

## Features
- Search cities
- Display current weather
- 5-day forecast
- Beautiful UI with animations

## Weather Model

```dart
class Weather {
  final String city;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}
```

## Weather Service

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String apiKey = 'YOUR_API_KEY';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
```

## Weather Controller

```dart
class WeatherController extends GetxController {
  final WeatherService _service = WeatherService();
  
  var weather = Rxn<Weather>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      weather.value = await _service.getWeather(city);
    } catch (e) {
      errorMessage.value = 'City not found';
    } finally {
      isLoading.value = false;
    }
  }
}
```
''',
      ),
      TutorialModel(
        id: 'proj3',
        categoryId: 'projects',
        title: 'E-Commerce App',
        description: 'Full-featured shopping app with cart and checkout',
        category: 'Projects',
        difficulty: 'Advanced',
        content: r'''
# E-Commerce App

## Features
- Product listing with categories
- Product details with image gallery
- Shopping cart with quantities
- Order checkout
- User authentication
- Order history

## Models

```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}
```

## Cart Controller

```dart
class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(Product product) {
    final index = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
    }

    Get.snackbar('Success', 'Added to cart');
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int quantity) {
    final index = cartItems.indexWhere(
      (item) => item.product.id == productId,
    );
    
    if (index != -1) {
      if (quantity > 0) {
        cartItems[index].quantity = quantity;
        cartItems.refresh();
      } else {
        removeFromCart(productId);
      }
    }
  }

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount => cartItems.length;

  void clearCart() {
    cartItems.clear();
  }
}
```

## Product List Page

```dart
class ProductListPage extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Badge(
              label: Obx(() => Text('${Get.find<CartController>().itemCount}')),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () => Get.to(() => CartPage()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ProductCard(product: product);
          },
        );
      }),
    );
  }
}
```
''',
      ),
      TutorialModel(
        id: 'proj4',
        categoryId: 'projects',
        title: 'Chat App with Firebase',
        description: 'Real-time messaging app using Firestore',
        category: 'Projects',
        difficulty: 'Advanced',
        content: r'''
# Chat App with Firebase

## Features
- User authentication
- One-on-one messaging
- Real-time updates
- Message history
- Online status
- Typing indicators

## Message Model

```dart
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}
```

## Chat Service

```dart
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(Message message) async {
    await _firestore.collection('messages').add(message.toMap());
  }

  Stream<List<Message>> getMessages(String userId, String receiverId) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [userId, receiverId])
        .where('receiverId', whereIn: [userId, receiverId])
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromFirestore(doc))
            .toList());
  }

  Future<void> markAsRead(String messageId) async {
    await _firestore
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }
}
```

## Chat Controller

```dart
class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final TextEditingController messageController = TextEditingController();
  
  var messages = <Message>[].obs;
  String? currentUserId;
  String? receiverId;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() {
    _chatService
        .getMessages(currentUserId!, receiverId!)
        .listen((messageList) {
      messages.value = messageList;
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final message = Message(
      id: '',
      senderId: currentUserId!,
      receiverId: receiverId!,
      text: messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    await _chatService.sendMessage(message);
    messageController.clear();
  }
}
```
''',
      ),
    ];
  }
}
