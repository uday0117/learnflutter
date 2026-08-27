import '../models/project_model.dart';

class ProjectsData {
  static List<ProjectModel> getAll() {
    return [
      const ProjectModel(
        id: 'todo_app',
        name: 'Smart Task Manager',
        description: 'A clean GetX Todo application utilizing GetStorage for offline data persistence, filtering, and theme integration.',
        difficulty: 'Beginner',
        features: [
          'Create, Read, Update, and Delete (CRUD) tasks',
          'Task completion toggle with slide animations',
          'Filter tasks by All, Active, and Completed states',
          'Persistent offline storage using GetStorage',
          'Light and Dark mode visual consistency'
        ],
        libraries: ['get: ^4.6.6', 'get_storage: ^2.1.1'],
        folderStructure: '''lib/
├── main.dart
├── controllers/
│   └── task_controller.dart
├── models/
│   └── task_model.dart
├── screens/
│   └── task_home_screen.dart
└── widgets/
    └── task_item_tile.dart''',
        sourceCode: '''import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ── TASK MODEL ──
class Task {
  String id;
  String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'isCompleted': isCompleted};
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'] ?? false,
      );
}

// ── TASK CONTROLLER ──
class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  final _box = GetStorage();
  static const _storageKey = 'saved_tasks';

  @override
  void onInit() {
    super.onInit();
    List? stored = _box.read<List>(_storageKey);
    if (stored != null) {
      tasks.assignAll(stored.map((e) => Task.fromJson(e)).toList());
    }
  }

  void addTask(String title) {
    tasks.add(Task(id: DateTime.now().toString(), title: title));
    _save();
  }

  void toggleTask(String id) {
    var task = tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    tasks.refresh();
    _save();
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    _save();
  }

  void _save() => _box.write(_storageKey, tasks.map((t) => t.toJson()).toList());
}

// ── MAIN APP VIEW ──
void main() async {
  await GetStorage.init();
  runApp(const MaterialApp(home: TaskHomeScreen()));
}

class TaskHomeScreen extends StatelessWidget {
  const TaskHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskController());
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Tasks')),
      body: Obx(() => ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => controller.toggleTask(task.id),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => controller.deleteTask(task.id),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.defaultDialog(
          title: 'New Task',
          content: TextField(controller: textController),
          onConfirm: () {
            if (textController.text.isNotEmpty) {
              controller.addTask(textController.text);
              textController.clear();
              Get.back();
            }
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}''',
      ),
      const ProjectModel(
        id: 'weather_app',
        name: 'REST API Weather App',
        description: 'A weather forecasting app connecting to online REST APIs, featuring custom JSON serialization, error boundaries, and loading pull gestures.',
        difficulty: 'Intermediate',
        features: [
          'Dynamic city-based weather query integrations',
          'HTTP connection management and response decoding',
          'Shimmer loading screens and retry state handlings',
          'Swipe down refresher indicators',
          'Beautiful custom weather condition mapping cards'
        ],
        libraries: ['http: ^1.2.0', 'get: ^4.6.6'],
        folderStructure: '''lib/
├── main.dart
├── controllers/
│   └── weather_controller.dart
├── models/
│   └── weather_model.dart
└── screens/
    └── weather_home_screen.dart''',
        sourceCode: '''import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ── WEATHER MODEL ──
class Weather {
  final String city;
  final double temp;
  final String condition;
  final int humidity;

  Weather({required this.city, required this.temp, required this.condition, required this.humidity});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Unknown',
      temp: (json['main']['temp'] as num).toDouble() - 273.15, // Kelvin to Celsius
      condition: json['weather'][0]['main'] ?? 'Clear',
      humidity: json['main']['humidity'] ?? 0,
    );
  }
}

// ── WEATHER CONTROLLER ──
class WeatherController extends GetxController {
  var weather = Rxn<Weather>();
  var isLoading = false.obs;
  var hasError = false.obs;

  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final apiKey = 'YOUR_API_KEY_HERE'; // Replace with OpenWeatherMap API Key
      final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=\$city&appid=\$apiKey',
      ));
      if (response.statusCode == 200) {
        weather.value = Weather.fromJson(jsonDecode(response.body));
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}

// ── WEATHER UI ──
class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeatherController());
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Live Weather Forecast')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(labelText: 'Enter City'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => controller.fetchWeather(searchController.text),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }
              if (controller.hasError.value) {
                return const Text('Error loading weather data. Check API key/connection.');
              }
              final data = controller.weather.value;
              if (data == null) {
                return const Text('Search for a city to see forecast');
              }
              return Column(
                children: [
                  Text(data.city, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('\${data.temp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 48)),
                  Text(data.condition, style: const TextStyle(fontSize: 20, color: Colors.blue)),
                  const SizedBox(height: 12),
                  Text('Humidity: \${data.humidity}%', style: const TextStyle(color: Colors.grey)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}''',
      ),
      const ProjectModel(
        id: 'ecommerce_kit',
        name: 'E-Commerce Screen Suite',
        description: 'A modular e-commerce storefront layout featuring category filters, animated grids, visual product detail cards, and an interactive drawer cart.',
        difficulty: 'Advanced',
        features: [
          'Beautiful Product list showcasing customizable Hero images',
          'Responsive horizontal filter chips',
          'Clean layout integration with custom rating indicators',
          'Stateful inline shopping cart counter incrementers',
          'Visual detail page with sliding transitions'
        ],
        libraries: ['get: ^4.6.6'],
        folderStructure: '''lib/
├── main.dart
├── models/
│   └── product.dart
└── screens/
    ├── product_list_screen.dart
    └── product_detail_screen.dart''',
        sourceCode: '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── PRODUCT MODEL ──
class Product {
  final String id;
  final String name;
  final String price;
  final String imageUrl;

  Product({required this.id, required this.name, required this.price, required this.imageUrl});
}

// ── CART STATE ──
class CartController extends GetxController {
  var items = <Product>[].obs;
  double get total => items.fold(0, (sum, item) => sum + double.parse(item.price.replaceAll('\$', '')));

  void addToCart(Product p) {
    items.add(p);
    Get.snackbar('Cart Updated', '\${p.name} added to cart!', snackPosition: SnackPosition.BOTTOM);
  }
}

// ── MAIN UI CATALOG ──
class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.put(CartController());
    final products = [
      Product(id: '1', name: 'Premium Wireless Headphones', price: '\$129.99', imageUrl: ''),
      Product(id: '2', name: 'Modern Smart Watch', price: '\$199.99', imageUrl: ''),
      Product(id: '3', name: 'Sleek Laptop Stand', price: '\$39.99', imageUrl: ''),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Get.defaultDialog(
              title: 'Shopping Bag',
              content: Obx(() => Column(
                    children: [
                      ...cart.items.map((i) => ListTile(title: Text(i.name), trailing: Text(i.price))),
                      const Divider(),
                      Text('Total: \$\${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.grey.shade100, child: const Icon(Icons.image, size: 50))),
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(p.price),
                TextButton(onPressed: () => cart.addToCart(p), child: const Text('Add to Cart')),
              ],
            ),
          );
        },
      ),
    );
  }
}''',
      ),
      const ProjectModel(
        id: 'firebase_chat',
        name: 'Firebase Group Chat UI',
        description: 'A real-time reactive group conversation app connecting to cloud databases, showcasing auto-scrolling message streams and dynamic bubble rendering.',
        difficulty: 'Advanced',
        features: [
          'Dynamic visual layout with custom-drawn chat bubbles',
          'Firestore collections streams fetching realtime logs',
          'Automatic vertical list scrolls on message sends',
          'Local user identity caching persistence'
        ],
        libraries: ['firebase_core: ^4.11.0', 'cloud_firestore: ^4.14.0', 'get: ^4.6.6'],
        folderStructure: '''lib/
├── main.dart
├── controllers/
│   └── chat_controller.dart
└── screens/
    └── chat_room_screen.dart''',
        sourceCode: '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

// NOTE: Ensure Firebase is initialized in main() before executing.
// await Firebase.initializeApp();

class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({required this.sender, required this.text, required this.timestamp});
}

class ChatController extends GetxController {
  var messages = <Message>[].obs;
  final currentSender = 'Developer';

  @override
  void onInit() {
    super.onInit();
    // Simulate initial messages. In production, connect to real Firestore stream:
    // FirebaseFirestore.instance.collection('chats').orderBy('timestamp').snapshots().map(...)
    messages.assignAll([
      Message(sender: 'Admin', text: 'Welcome to the Flutter chat room!', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
      Message(sender: 'User', text: 'Does this app connect to Firebase?', timestamp: DateTime.now().subtract(const Duration(minutes: 3))),
    ]);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add(Message(sender: currentSender, text: text, timestamp: DateTime.now()));
  }
}

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final textController = TextEditingController();
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(title: const Text('Group Chatroom')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Auto-scroll to bottom when new message arrives
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: scrollController,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.sender == controller.currentSender;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                          bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe) Text(msg.sender, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
                          Text(msg.text, style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(labelText: 'Type message...', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.sendMessage(textController.text);
                    textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}''',
      ),
    ];
  }
}
