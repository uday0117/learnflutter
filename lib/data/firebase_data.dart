import '../models/tutorial_model.dart';

class FirebaseData {
  static List<TutorialModel> getAllTutorials() {
    return [
      TutorialModel(
        id: 'fb1',
        categoryId: 'firebase',
        title: 'Firebase Setup',
        description:
            'Complete guide to setting up Firebase in your Flutter app',
        category: 'Firebase',
        difficulty: 'Beginner',
        content: r'''
# Firebase Setup in Flutter

## Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name
4. Enable Google Analytics (optional)
5. Create project

## Step 2: Add Flutter App
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure
```

## Step 3: Add Dependencies
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
```

## Step 4: Initialize Firebase
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

## Common Issues
- Make sure google-services.json is in android/app/
- Verify SHA-1 fingerprint is added in Firebase Console
- Check minimum SDK version is 21 or higher
''',
      ),
      TutorialModel(
        id: 'fb2',
        categoryId: 'firebase',
        title: 'Firebase Authentication',
        description: 'Implement user authentication with Firebase Auth',
        category: 'Firebase',
        difficulty: 'Intermediate',
        content: r'''
# Firebase Authentication

## Email/Password Authentication

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  // Sign in
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
```

## Google Sign In

```dart
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  
  if (googleUser == null) return null;
  
  final GoogleSignInAuthentication googleAuth = 
      await googleUser.authentication;
  
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
```
''',
      ),
      TutorialModel(
        id: 'fb3',
        categoryId: 'firebase',
        title: 'Cloud Firestore',
        description: 'Learn how to use Cloud Firestore database',
        category: 'Firebase',
        difficulty: 'Intermediate',
        content: r'''
# Cloud Firestore

## Basic CRUD Operations

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Future<void> addUser(String id, Map<String, dynamic> data) async {
    await _db.collection('users').doc(id).set(data);
  }

  // Read
  Future<DocumentSnapshot> getUser(String id) async {
    return await _db.collection('users').doc(id).get();
  }

  // Read All
  Future<QuerySnapshot> getAllUsers() async {
    return await _db.collection('users').get();
  }

  // Update
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.collection('users').doc(id).update(data);
  }

  // Delete
  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }

  // Real-time Stream
  Stream<QuerySnapshot> usersStream() {
    return _db.collection('users').snapshots();
  }
}
```

## Queries

```dart
// Where clause
final query = _db
    .collection('users')
    .where('age', isGreaterThan: 18)
    .where('city', isEqualTo: 'New York');

// Order by
final query = _db
    .collection('users')
    .orderBy('name', descending: false);

// Limit
final query = _db
    .collection('users')
    .limit(10);

// Compound queries
final query = _db
    .collection('users')
    .where('age', isGreaterThan: 18)
    .orderBy('age')
    .limit(20);
```
''',
      ),
      TutorialModel(
        id: 'fb4',
        categoryId: 'firebase',
        title: 'Cloud Storage',
        description: 'Upload and download files with Firebase Storage',
        category: 'Firebase',
        difficulty: 'Intermediate',
        content: r'''
# Firebase Cloud Storage

## Upload File

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> deleteFile(String path) async {
    await _storage.ref().child(path).delete();
  }

  Future<String?> getDownloadUrl(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      print('Get URL error: $e');
      return null;
    }
  }
}
```

## Upload with Progress

```dart
Future<void> uploadWithProgress(File file, String path) async {
  final ref = _storage.ref().child(path);
  final uploadTask = ref.putFile(file);

  uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
    final progress = snapshot.bytesTransferred / snapshot.totalBytes;
    print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
  });

  await uploadTask;
  print('Upload complete!');
}
```
''',
      ),
      TutorialModel(
        id: 'fb5',
        categoryId: 'firebase',
        title: 'Push Notifications (FCM)',
        description: 'Send and receive push notifications',
        category: 'Firebase',
        difficulty: 'Advanced',
        content: r'''
# Firebase Cloud Messaging (FCM)

## Setup

```yaml
dependencies:
  firebase_messaging: ^14.7.10
```

## Initialize FCM

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // Get FCM token
      String? token = await _messaging.getToken();
      print('FCM Token: $token');

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message: ${message.notification?.title}');
    // Show local notification here
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.data}');
    // Navigate to specific screen
  }
}

// Top-level function for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.notification?.title}');
}
```
''',
      ),
    ];
  }
}
