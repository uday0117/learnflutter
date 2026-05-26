import '../models/tutorial_model.dart';

class ApiIntegrationData {
  static List<TutorialModel> getAllTutorials() {
    return [
      TutorialModel(
        id: 'api1',
        categoryId: 'api_integration',
        title: 'HTTP Requests Basics',
        description: 'Learn to make API calls with http package',
        category: 'API Integration',
        difficulty: 'Beginner',
        content: r'''
# HTTP Requests in Flutter

## Setup

```yaml
dependencies:
  http: ^1.1.2
```

## GET Request

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
```

## POST Request

```dart
Future<User> createUser(String name, String email) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'email': email,
    }),
  );

  if (response.statusCode == 201) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create user');
  }
}
```

## PUT Request

```dart
Future<User> updateUser(int id, String name) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name}),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update user');
  }
}
```

## DELETE Request

```dart
Future<void> deleteUser(int id) async {
  final response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete user');
  }
}
```
''',
      ),
      TutorialModel(
        id: 'api2',
        categoryId: 'api_integration',
        title: 'Dio Package',
        description: 'Advanced HTTP client for Flutter',
        category: 'API Integration',
        difficulty: 'Intermediate',
        content: r'''
# Dio - Powerful HTTP Client

## Setup

```yaml
dependencies:
  dio: ^5.4.0
```

## Basic Usage

```dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> createUser(User user) async {
    try {
      final response = await _dio.post('/users', data: user.toJson());
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error';
    }
  }
}
```

## Interceptors

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Response: ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('Error: ${err.message}');
    super.onError(err, handler);
  }
}

// Add interceptor
_dio.interceptors.add(AuthInterceptor());
```
''',
      ),
      TutorialModel(
        id: 'api3',
        categoryId: 'api_integration',
        title: 'REST API with GetX',
        description: 'Combine GetX with API calls',
        category: 'API Integration',
        difficulty: 'Intermediate',
        content: r'''
# REST API with GetX

## API Service

```dart
import 'package:get/get.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://jsonplaceholder.typicode.com';
    httpClient.timeout = Duration(seconds: 10);
    
    // Add interceptor
    httpClient.addRequestModifier<void>((request) {
      request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }

  Future<Response> getUsers() => get('/users');
  Future<Response> getUser(int id) => get('/users/$id');
  Future<Response> createUser(Map data) => post('/users', data);
  Future<Response> updateUser(int id, Map data) => put('/users/$id', data);
  Future<Response> deleteUser(int id) => delete('/users/$id');
}
```

## Controller with API

```dart
class UserController extends GetxController {
  final ApiService _apiService = Get.find();
  
  var users = <User>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getUsers();
      if (response.hasError) {
        Get.snackbar('Error', 'Failed to load users');
      } else {
        users.value = (response.body as List)
            .map((json) => User.fromJson(json))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(String name, String email) async {
    final response = await _apiService.createUser({
      'name': name,
      'email': email,
    });
    
    if (response.statusCode == 201) {
      users.add(User.fromJson(response.body));
      Get.snackbar('Success', 'User created');
    }
  }
}
```

## UI with Obx

```dart
class UserPage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchUsers(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```
''',
      ),
      TutorialModel(
        id: 'api4',
        categoryId: 'api_integration',
        title: 'JSON Serialization',
        description: 'Handle JSON data efficiently',
        category: 'API Integration',
        difficulty: 'Intermediate',
        content: r'''
# JSON Serialization

## Manual Serialization

```dart
class User {
  final int id;
  final String name;
  final String email;
  final Address address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: Address.fromJson(json['address']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address.toJson(),
    };
  }
}

class Address {
  final String street;
  final String city;

  Address({required this.street, required this.city});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
    };
  }
}
```

## Using json_serializable

```yaml
dependencies:
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.8
  json_serializable: ^6.7.1
```

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

Run code generation:
```bash
flutter pub run build_runner build
```
''',
      ),
    ];
  }
}
