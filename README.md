# Learn Flutter & Dart

A comprehensive Flutter learning application built with GetX state management and Material 3 design.

## 📱 About

**Learn Flutter & Dart** is a complete educational app designed to help developers master Flutter and Dart. From basics to advanced concepts, this app provides tutorials, code examples, UI patterns, and interview preparation materials.

**Package Name:** `com.uksolutions.learnflutter`

## ✨ Features

### Core Features
- 📚 **8 Main Learning Modules**
  - Flutter Basics (Installation, Project Structure, Dart fundamentals)
  - Flutter Widgets (Container, Text, Row, Column, Stack, ListView, etc.)
  - UI Examples (Login, Registration, OTP screens with full source code)
  - State Management (GetX, Provider, Riverpod, Bloc)
  - API Integration (HTTP, Dio, REST APIs, JSON parsing)
  - Firebase (Authentication, Firestore, Storage, Push Notifications)
  - Complete Projects (Todo, Notes, Expense Tracker, Weather, E-Commerce)
  - Interview Questions (50+ questions with detailed answers)

### User Experience
- 🎨 **Material 3 Design** - Modern, beautiful UI with gradient backgrounds
- 🌓 **Dark Mode** - Full dark mode support with theme persistence
- ❤️ **Favorites System** - Save your favorite tutorials with local storage
- 🔍 **Search Functionality** - Quick search with history tracking
- 📋 **Code Viewer** - Syntax-highlighted code examples with copy button
- 💾 **Data Persistence** - GetStorage for favorites, theme, and search history
- ⚡ **Fast Navigation** - Smooth transitions and optimized routing

## 🏗️ Architecture

### Clean Architecture with GetX
```
lib/
├── main.dart                 # App entry point with GetX MaterialApp
├── routes/
│   ├── app_routes.dart      # Route constants
│   └── app_pages.dart       # GetPage definitions with bindings
├── bindings/
│   ├── splash_binding.dart  # Splash screen dependencies
│   └── home_binding.dart    # Home screen dependencies
├── controllers/
│   ├── theme_controller.dart              # Dark mode management
│   ├── favorites_controller.dart          # Favorites management
│   ├── splash_controller.dart             # Splash screen logic
│   ├── home_controller.dart               # Home screen logic
│   ├── flutter_basics_controller.dart     # Flutter basics module
│   ├── widgets_controller.dart            # Widgets module
│   ├── ui_examples_controller.dart        # UI examples module
│   ├── interview_questions_controller.dart # Interview Q&A
│   └── search_controller.dart             # Search functionality
├── models/
│   ├── category_model.dart
│   ├── tutorial_model.dart
│   ├── widget_model.dart
│   ├── ui_example_model.dart
│   ├── interview_question_model.dart
│   └── project_model.dart
├── data/
│   ├── category_data.dart              # 8 main categories
│   ├── flutter_basics_data.dart        # 6 comprehensive tutorials
│   ├── widgets_data.dart               # 10 widget examples
│   ├── ui_examples_data.dart           # 8 complete UI screens
│   └── interview_questions_data.dart   # 50+ interview questions
├── views/
│   ├── splash/                         # Splash screen with 2s delay
│   ├── home/                          # Home with category grid
│   ├── flutter_basics/                # Basics list & detail screens
│   ├── widgets/                       # Widgets list & detail
│   ├── ui_examples/                   # UI examples list & detail
│   ├── state_management/              # State management topics
│   ├── api_integration/               # API integration topics
│   ├── firebase/                      # Firebase topics
│   ├── projects/                      # Project list
│   ├── interview_questions/           # Q&A with filtering
│   ├── search/                        # Search with history
│   └── favorites/                     # Favorites list
├── widgets/
│   ├── category_card.dart             # Grid card for categories
│   ├── tutorial_card.dart             # List card for tutorials
│   ├── code_viewer.dart               # Code display with copy
│   ├── empty_state.dart               # Empty state placeholder
│   └── loading_widget.dart            # Loading indicator
├── themes/
│   └── app_theme.dart                 # Light/Dark Material 3 themes
└── utils/
    ├── constants.dart                 # App constants & strings
    └── helpers.dart                   # Utility functions
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart 3.0.0 or higher
- iOS: Xcode 14.0+ (for iOS development)
- Android: Android Studio with SDK 21+ (for Android development)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd learnflutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

## 📦 Dependencies

```yaml
dependencies:
  get: ^4.6.6                    # State management & routing
  get_storage: ^2.1.1            # Local data persistence
  google_fonts: ^6.1.0           # Poppins font family
  flutter_syntax_view: ^4.0.0    # Code syntax highlighting
  flutter_svg: ^2.0.9            # SVG support
  url_launcher: ^6.2.2           # Launch URLs
```

## 🎯 Key Technologies

### State Management - GetX
- **Reactive Programming** with `Obx` and `.obs` variables
- **Route Management** with named routes and arguments
- **Dependency Injection** with bindings
- **Storage** with GetStorage for data persistence

### Material 3 Design
- **Color Scheme** - Flutter blue primary with accent orange
- **Typography** - Google Fonts Poppins throughout
- **Components** - Cards, Chips, Buttons with modern styling
- **Gradients** - Beautiful gradient backgrounds and overlays

## 📚 Content Overview

### Flutter Basics (6 Tutorials)
1. Introduction to Flutter - Features and benefits
2. Installation Guide - System requirements and setup
3. Project Structure - Understanding Flutter folders
4. Dart Basics - Variables, functions, classes, null safety
5. StatelessWidget - Immutable widgets and lifecycle
6. StatefulWidget - Mutable widgets with setState

### Flutter Widgets (10 Examples)
- Container, Text, Row, Column, Stack
- Card, ListView, GridView
- TextField, ElevatedButton
Each with parameters, descriptions, and code examples

### UI Examples (8 Complete Screens)
- Login Screen - Email/password with social login
- Registration Screen - Form validation
- OTP Verification - 6-digit input with timer
- Dashboard, Profile, Settings
- Chat UI, E-Commerce Home
All with full source code

### Interview Questions (50+ Questions)
- **Categories:** Flutter, Dart, GetX, Firebase
- **Difficulty Levels:** Beginner, Intermediate, Advanced
- **Includes:** Questions, detailed answers, code examples

## 🎨 Theme System

### Light Theme
- Primary: Flutter Blue `#02569B`
- Accent: Orange `#FFA726`
- Background: White with subtle gradients
- Card: White with soft shadows

### Dark Theme
- Primary: Light Blue
- Accent: Deep Orange
- Background: Dark grey `#121212`
- Card: Dark surface with elevation

### Theme Toggle
- Icon button in AppBar
- Instant theme switching
- Persistent across app restarts

## 💾 Data Persistence

Using **GetStorage** for:
- Theme preference (light/dark)
- Favorites list (tutorial IDs)
- Search history (recent queries)

## 🔍 Search Feature

- Real-time search input
- Search history tracking
- Clear individual or all history items
- Search across tutorials, widgets, and examples

## ❤️ Favorites System

- Add/remove favorites with heart icon
- Persistent storage with GetStorage
- Dedicated favorites screen
- Empty state when no favorites

## 📱 Screens

### Splash Screen
- App branding with logo
- 2-second delay
- Smooth transition to home

### Home Screen
- 2-column grid of categories
- Search, favorites, and theme toggle
- Gradient app bar

### Detail Screens
- Tutorial content with formatting
- Key points with checkmarks
- Code examples with syntax highlighting
- Copy code button
- Favorite toggle

### Interview Questions
- Horizontal category filter chips
- Question cards with category badges
- Difficulty level indicators
- Detailed answers with code

## 🏃 Running the App

### Debug Mode
```bash
flutter run
```

### Release Mode (Android)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Release Mode (iOS)
```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode to archive
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🐛 Troubleshooting

### Common Issues

**Issue:** Asset not found
```bash
# Solution: Run flutter clean and pub get
flutter clean
flutter pub get
```

**Issue:** GetStorage error
```bash
# Solution: Ensure GetStorage is initialized in main()
await GetStorage.init();
```

**Issue:** Theme not persisting
```bash
# Solution: Check GetStorage initialization
# Verify ThemeController is using Get.put()
```

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Developer

**UK Solutions**
- Package: com.uksolutions.learnflutter

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- GetX Package for state management
- Google Fonts for typography
- Material Design 3 guidelines

---

Made with ❤️ using Flutter & GetX
