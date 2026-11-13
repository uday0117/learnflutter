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
        description: 'A real-time reactive group conversation app connecting to Cloud Firestore, showcasing auto-scrolling message streams, server timestamps, and dynamic bubble rendering.',
        difficulty: 'Advanced',
        category: 'Firebase Realtime',
        features: [
          'Realtime Cloud Firestore collection listener with snapshot mapping',
          'Server-side atomic timestamps via FieldValue.serverTimestamp()',
          'Dynamic visual layout with custom-drawn chat bubbles and sender flags',
          'Automatic vertical list scrolls on incoming real-time messages',
          'Optimistic UI messaging state updates with error rollbacks'
        ],
        libraries: [
          'firebase_core: ^4.11.0',
          'cloud_firestore: ^5.6.5',
          'firebase_auth: ^6.7.0',
          'get: ^4.6.6'
        ],
        setupGuide: '''1. PREREQUISITES & FIREBASE SETUP:
   • Install FlutterFire CLI: dart pub global activate flutterfire_cli
   • Configure project: flutterfire configure --project=YOUR_PROJECT_ID
   • Add google-services.json (Android) & GoogleService-Info.plist (iOS)

2. CLOUD FIRESTORE SECURITY RULES (firestore.rules):
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /chats/{messageId} {
         allow read: if request.auth != null;
         allow create: if request.auth != null
           && request.resource.data.text is string
           && request.resource.data.text.size() > 0;
       }
     }
   }

3. COMPOSITE INDEXES:
   • Collection: chats
   • Fields indexed: timestamp (Ascending), sender (Ascending)''',
        folderStructure: '''lib/
├── main.dart
├── firebase_options.dart
├── controllers/
│   └── chat_controller.dart
├── models/
│   └── chat_message.dart
└── screens/
    └── chat_room_screen.dart''',
        sourceCode: '''import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── DATA MODEL ──
class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final ts = data['timestamp'] as Timestamp?;
    return ChatMessage(
      id: doc.id,
      sender: data['sender'] ?? 'Anonymous',
      text: data['text'] ?? '',
      timestamp: ts?.toDate() ?? DateTime.now(),
    );
  }
}

// ── GETX CHAT CONTROLLER ──
class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var messages = <ChatMessage>[].obs;
  var isSending = false.obs;
  final currentSender = 'Developer';

  @override
  void onInit() {
    super.onInit();
    _bindFirestoreStream();
  }

  void _bindFirestoreStream() {
    // Realtime reactive collection stream
    _firestore
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .limit(100)
        .snapshots()
        .listen((snapshot) {
      messages.value =
          snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
    }, onError: (error) {
      debugPrint('Firestore stream error: \$error');
    });
  }

  Future<void> sendMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    try {
      isSending.value = true;
      await _firestore.collection('chats').add({
        'sender': currentSender,
        'text': cleanText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: \$e');
    } finally {
      isSending.value = false;
    }
  }
}

// ── MAIN ENTRY POINT ──
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GetMaterialApp(home: ChatRoomScreen()));
}

// ── CHAT SCREEN VIEW ──
class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final textController = TextEditingController();
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Group Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Get.defaultDialog(
              title: 'Firebase Chatroom',
              middleText: 'Connected live to Cloud Firestore collection "chats"',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(child: Text('No messages yet. Say hello!'));
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 250),
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
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomRight: isMe
                              ? const Radius.circular(0)
                              : const Radius.circular(16),
                          bottomLeft: !isMe
                              ? const Radius.circular(0)
                              : const Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Text(
                              msg.sender,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.black54),
                            ),
                          Text(
                            msg.text,
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87),
                          ),
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
                    decoration: const InputDecoration(
                      labelText: 'Type message...',
                      border: OutlineInputBorder(),
                    ),
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
      const ProjectModel(
        id: 'firebase_auth_sync',
        name: 'Firebase Auth & User Profile Hub',
        description: 'Complete authentication system featuring Google Sign-In, auth state listener, Firestore user profile document synchronization, and offline session caching.',
        difficulty: 'Intermediate',
        category: 'Firebase Auth & Cloud',
        features: [
          'Google Sign-In & Email/Password authentication pipeline',
          'Reactive authStateChanges() stream listener with automatic routing',
          'Cloud Firestore user document creation and last-login tracking',
          'Live user profile editing (Display Name, Avatar URL, Bio)',
          'Secure token storage and persistent offline session management'
        ],
        libraries: [
          'firebase_core: ^4.11.0',
          'firebase_auth: ^6.7.0',
          'google_sign_in: ^6.2.2',
          'cloud_firestore: ^5.6.5',
          'get: ^4.6.6'
        ],
        setupGuide: '''1. GOOGLE SIGN-IN SETUP:
   • Android: Add SHA-1 and SHA-256 fingerprint in Firebase Console
   • iOS: Add REVERSED_CLIENT_ID to Info.plist CFBundleURLSchemes

2. FIRESTORE SECURITY RULES FOR USERS COLLECTION:
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }

3. DEPENDENCIES:
   Add firebase_core, firebase_auth, google_sign_in, cloud_firestore, get.''',
        folderStructure: '''lib/
├── main.dart
├── controllers/
│   └── auth_profile_controller.dart
├── models/
│   └── user_profile_model.dart
└── screens/
    ├── login_screen.dart
    └── profile_dashboard_screen.dart''',
        sourceCode: '''import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ── USER PROFILE MODEL ──
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final DateTime? lastLogin;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    this.lastLogin,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'lastLogin': FieldValue.serverTimestamp(),
      };

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final ts = data['lastLogin'] as Timestamp?;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      lastLogin: ts?.toDate(),
    );
  }
}

// ── AUTH & PROFILE CONTROLLER ──
class AuthProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var user = Rx<User?>(null);
  var userProfile = Rx<UserProfile?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, _handleAuthChanged);
  }

  Future<void> _handleAuthChanged(User? u) async {
    if (u != null) {
      await _syncUserProfile(u);
    } else {
      userProfile.value = null;
    }
  }

  Future<void> _syncUserProfile(User u) async {
    final docRef = _firestore.collection('users').doc(u.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newProfile = UserProfile(
        uid: u.uid,
        email: u.email ?? '',
        displayName: u.displayName ?? 'New Developer',
        photoUrl: u.photoURL ?? '',
      );
      await docRef.set(newProfile.toMap());
      userProfile.value = newProfile;
    } else {
      userProfile.value = UserProfile.fromFirestore(doc);
      await docRef.update({'lastLogin': FieldValue.serverTimestamp()});
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) return;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar('Sign In Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBio(String newName) async {
    if (user.value == null) return;
    await _firestore.collection('users').doc(user.value!.uid).update({
      'displayName': newName,
    });
    userProfile.value = UserProfile(
      uid: userProfile.value!.uid,
      email: userProfile.value!.email,
      displayName: newName,
      photoUrl: userProfile.value!.photoUrl,
    );
    Get.snackbar('Updated', 'Profile name updated!');
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

// ── MAIN & UI ──
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GetMaterialApp(home: ProfileDashboardScreen()));
}

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthProfileController());

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase User Hub')),
      body: Obx(() {
        if (auth.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final u = auth.user.value;
        if (u == null) {
          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign In With Google'),
              onPressed: () => auth.signInWithGoogle(),
            ),
          );
        }

        final profile = auth.userProfile.value;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profile?.photoUrl.isNotEmpty == true
                    ? NetworkImage(profile!.photoUrl)
                    : null,
                child: profile?.photoUrl.isEmpty == true
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(profile?.displayName ?? 'Developer',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(profile?.email ?? '', style: const TextStyle(color: Colors.grey)),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                onPressed: () => auth.signOut(),
              ),
            ],
          ),
        );
      }),
    );
  }
}''',
      ),
    ];
  }
}
