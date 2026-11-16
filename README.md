# Learn Flutter & Dart 🚀

[![Flutter Version](https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![Version](https://img.shields.io/badge/Version-1.1.1%2B12-success.svg)](pubspec.yaml)
[![State Management](https://img.shields.io/badge/State-GetX%204.6.6-8A2BE2)](https://pub.dev/packages/get)
[![Backend & Auth](https://img.shields.io/badge/Firebase-Auth%20%7C%20Analytics%20%7C%20Crashlytics-FFA611?logo=firebase)](https://firebase.google.com)
[![Code Push](https://img.shields.io/badge/OTA-Shorebird-2C3E50)](https://shorebird.dev)
[![Platform](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-blue)](#-platform-support)
[![Languages](https://img.shields.io/badge/Locales-13%20Languages-brightgreen)](#-internationalization)

> **Learn Flutter & Dart** is an interactive educational mobile application developed and maintained by **UK Solutions** (`com.uksolutions.learnflutter`). The app provides a gamified, hands-on learning ecosystem designed to take developers from initial Dart fundamentals to advanced Flutter architecture, real-world production projects, motion animations, and technical interview mastery.

---

## 📑 Table of Contents

- [📱 Application Overview](#-application-overview)
- [✨ Core Features & Modules](#-core-features--modules)
- [🏗️ Codebase Architecture & Directory Structure](#️-codebase-architecture--directory-structure)
- [📦 Technology Stack & Third-Party Integrations](#-technology-stack--third-party-integrations)
- [🌐 Internationalization (13 Languages)](#-internationalization-13-languages)
- [🚀 Getting Started & Build Commands](#-getting-started--build-commands)
- [🔥 Firebase Setup & Analytics Observability](#-firebase-setup--analytics-observability)
- [🛡️ Comprehensive Technical Audit & Health Report](#️-comprehensive-technical-audit--health-report)
  - [1. Executive Health Scorecard](#1-executive-health-scorecard)
  - [2. Codebase Metrics & Statistics](#2-codebase-metrics--statistics)
  - [3. Architecture & State Management Review](#3-architecture--state-management-review)
  - [4. Security, Credentials & Privacy Audit](#4-security-credentials--privacy-audit)
  - [5. Platform Integration Analysis](#5-platform-integration-analysis)
  - [6. Identified Technical Debt & Code Smells](#6-identified-technical-debt--code-smells)
  - [7. Prioritized Remediation Roadmap](#7-prioritized-remediation-roadmap)
- [📄 Documentation Index](#-documentation-index)
- [👨‍💻 Maintainers & License](#-maintainers--license)

---

## 📱 Application Overview

- **Application ID / Package:** `com.uksolutions.learnflutter`
- **Current Version:** `1.1.1+12`
- **Target SDK / Platforms:**
  - **Android:** `minSdkVersion 21`, `targetSdkVersion 34+`, Gradle Kotlin DSL with Java 17 & `desugar_jdk_libs:2.1.4`
  - **iOS:** `iOS 15.0+` deployment target, CocoaPods with dynamic frameworks (`use_frameworks!`), unified URL schemes (`learnflutter://` + Google Sign-In)
  - **Web & Desktop:** Multi-platform scaffolding ready
- **Target Audience:** Aspiring Flutter developers, cross-platform engineers preparing for technical interviews, and Flutter practitioners seeking quick syntax references, interactive UI recipes, and project blueprints.

---

## ✨ Core Features & Modules

### 1. 🧩 Comprehensive Flutter Widget Catalog (127 Widgets)
- **13 Distinct Categories:** Basic, Layout, Input, Button, List & Display, Navigation, Animation, Async & State, Effects & Painting, Interaction, Dialogs & Overlays, Cupertino (iOS), and Sliver Widgets.
- **Interactive Deep Dives:** Every widget includes property references, syntax summaries, interactive live preview playgrounds, and syntax-highlighted copyable source code.

### 2. 🎨 Animation Lab & Interactive Playground
- **Animation Playground:** Real-time interactive tweaking of curves (`Curves.bounceOut`, `elasticOut`, `easeInOut`, etc.), duration, scale, rotation, opacity, elevation, and border radius.
- **Preset Motion Gallery:** Pulsing Heart, Shake/Error, Floating Card, 3D Flip Card, Shimmer, Pop-In, and Spinner.
- **Live Dart Code Generation:** Dynamically generates copy-pasteable Dart animation code reflecting current playground slider values.

### 3. 🛠️ Live Widget Customizer
- Visual playground allowing developers to manipulate Container padding, margins, borders, shadows, alignments, and child widgets.
- Generates production-ready Flutter code and exports visual snapshots via native device sharing sheets (`screenshot` + `share_plus`).

### 4. 🍳 UI Cookbook (Modern UI Patterns)
- Production-ready implementation of contemporary UI paradigms:
  - **Glassmorphism:** Frosted blur effect with gradient borders.
  - **Neumorphism:** Soft 3D extruded/recessed interactive buttons.
  - **Shimmer Skeletons:** Animated placeholder skeleton screens for content loading.
  - **OTP Input Field:** 6-digit PIN input with automatic focus shifting.
  - **Gradient Progress Ring:** Custom-painted circular progress indicator.

### 5. 🎯 Technical Interview Preparation & Flashcard Swipe
- **55 Curated Interview Questions:** Filterable by Beginner, Intermediate, and Advanced tiers, complete with code snippets, detailed explanations, and instant bookmarking.
- **Tinder-Style Swipe Mode:** Flashcard review mode with spaced repetition tracking (Mastered vs. Review Later, with mastery confirmed upon 3+ successful reviews).

### 6. 🏆 Gamification, Streaks & Rewards Hub
- **Daily Streak System:** Tracks consecutive learning days with automatic midnight evaluations and streak restoration logic.
- **Streak Shields:** Consumable shields protecting against streak loss when a day is missed.
- **Daily Learning Goals:** View 3 widgets and complete the daily quiz session.
- **Weekly Challenges:** Tiered weekly learning milestones with reward unlocks.
- **Interactive Quiz Engine:** 51 questions, 4 options each, detailed explanations, lifetime stats (win rate, best score), and a **50/50 lifeline hint**.
- **Certification Generator:** Unlockable certificate tracks (*Flutter UI Specialist*, *Quiz Master*) with customizable learner names, prestige gold themes, and social milestone sharing.

### 7. 📘 Developer Roadmap & Dart Cheatsheet
- **Interactive 6-Stage Roadmap:** Dart Foundations → UI & Layout → State Management → APIs & Networking → Animations & Graphics → Testing & Deployment.
- **Dart Cheatsheet:** Concise syntax references covering Variables & Null Safety, Collections, Functions, OOP & Mixins, Async & Streams, and Extensions.
- **Packages Guide Screen:** Curated directory of essential pub.dev packages for state management, networking, storage, UI styling, and utilities.

### 8. 💼 Real-World Project Blueprints (5 Full Apps)
Complete architectural blueprints with project descriptions, required libraries, folder trees, and full source code:
1. **Smart Task Manager** (Beginner - GetX, GetStorage)
2. **REST API Weather App** (Intermediate - HTTP, JSON parsing, error boundaries)
3. **E-Commerce Screen Suite** (Advanced - Cart drawer, animated grids)
4. **Firebase Group Chat UI** (Advanced - Real-time streaming, chat bubbles)
5. **Firebase Auth & User Profile Hub** (Intermediate - Google Sign-In, reactive auth listener, Firestore user document sync, offline session caching)

### 9. 📱 Native Platform Extensions
- **Home Screen Widget:** Displays daily learning streak and overall curriculum progress directly on Android and iOS home screens via `home_widget`.
- **App Links & Deep Linking:** Smooth URL routing supporting `learnflutter://` and HTTPS App Links (`https://ukrsolutions.in/learnflutter/...`).

---

## 🏗️ Codebase Architecture & Directory Structure

The project employs a reactive GetX architecture backed by `GetStorage` offline-first persistence and modular singleton services.

```
learnflutter/
├── android/                         # Android native project (Kotlin DSL, Gradle 8+, Desugaring)
│   ├── app/
│   │   ├── build.gradle.kts        # App build configuration (minSdk 21, Java 17, desugar_jdk_libs)
│   │   ├── google-services.json    # Firebase Android configuration
│   │   └── src/main/
│   │       ├── AndroidManifest.xml # AdMob App ID, App Links, deep links & permissions
│   │       └── kotlin/.../         # LearnFlutterWidgetProvider.kt (Home screen widget)
├── ios/                             # iOS native project (Deployment Target: iOS 15.0)
│   ├── Runner/
│   │   ├── Info.plist              # AdMob App ID, SKAdNetwork, Google Sign-In & learnflutter schemes
│   │   └── GoogleService-Info.plist # Firebase iOS configuration
│   └── Podfile                     # CocoaPods dependency specification (use_frameworks!)
├── assets/
│   ├── images/                     # App icons, illustrations, and milestone badges
│   └── icons/                      # Category and action icons
├── lib/                             # Application Dart source code (30,740 LOC across 60 files)
│   ├── main.dart                   # Zoned app entry point, service initialization, bindings
│   ├── firebase_options.dart       # FlutterFire CLI generated configuration
│   ├── controllers/                # 12 GetX reactive state controllers (1,421 LOC)
│   │   ├── auth_controller.dart             # Firebase Auth & Google Sign-In session state
│   │   ├── customizer_controller.dart       # Live widget customizer playground state
│   │   ├── engagement_controller.dart       # Daily goals, in-app reviews & milestones
│   │   ├── favorites_controller.dart        # Saved widgets and interview questions
│   │   ├── interview_review_controller.dart # Spaced repetition review memory & mastery
│   │   ├── onboarding_controller.dart       # First-launch walkthrough state
│   │   ├── progress_controller.dart         # Overall learning completion metrics
│   │   ├── quiz_controller.dart             # Quiz challenge logic, 50/50 lifeline & stats
│   │   ├── streak_controller.dart           # Daily login streak & shield protection
│   │   ├── theme_controller.dart            # Material 3 light/dark mode & font scaling
│   │   ├── update_controller.dart           # App update management
│   │   └── weekly_challenge_controller.dart # Weekly gamified challenge goals
│   ├── models/                     # Data models (91 LOC)
│   │   ├── interview_question.dart # Interview Q&A model & QuestionLevel enum
│   │   ├── project_model.dart      # Real-world project blueprint model
│   │   ├── widget_category.dart    # Widget category metadata
│   │   └── widget_model.dart       # Widget definitions, properties & syntax
│   ├── data/                       # Static educational content & datasets (8,010 LOC)
│   │   ├── dart_cheatsheet_data.dart        # Dart syntax reference topics
│   │   ├── extra_widgets_data.dart          # 52 advanced widgets (Animation, Cupertino, Slivers)
│   │   ├── interview_data.dart              # 55 curated interview questions
│   │   ├── projects_data.dart               # 5 production project blueprints
│   │   ├── quiz_data.dart                   # 51 interactive quiz questions
│   │   └── widgets_data.dart                # Core 75 widgets & 6 base categories
│   ├── screens/                    # 21 UI views and full-screen modules (15,624 LOC)
│   │   ├── animation_lab_screen.dart        # Motion lab with 7 presets & live code generation
│   │   ├── certificate_screen.dart          # Milestone completion certificate generator
│   │   ├── dart_cheatsheet_screen.dart      # Dart syntax viewer & code examples
│   │   ├── favorites_screen.dart            # Bookmarked widgets & interview questions
│   │   ├── home_screen.dart                 # Main dashboard with stats & category grid
│   │   ├── interview_screen.dart            # Categorized interview Q&A directory
│   │   ├── interview_swipe_screen.dart      # Spaced-repetition flashcard swipe interface
│   │   ├── onboarding_screen.dart           # First-launch carousel & permissions
│   │   ├── packages_guide_screen.dart       # Essential pub.dev packages directory
│   │   ├── project_detail_screen.dart       # Project blueprint viewer with full source
│   │   ├── projects_list_screen.dart        # Real-world projects directory
│   │   ├── quiz_screen.dart                 # Quiz challenge interface with 50/50 hint
│   │   ├── rewards_hub_screen.dart          # Streaks, shields & rewards center
│   │   ├── roadmap_screen.dart              # Interactive 6-stage career roadmap
│   │   ├── search_screen.dart               # Global full-text content search
│   │   ├── settings_screen.dart             # Appearance, 13 languages, notifications & updates
│   │   ├── splash_screen.dart               # Animated branding splash & App Open Ad trigger
│   │   ├── ui_cookbook_screen.dart          # Neumorphism, Glassmorphism, Shimmer, OTP patterns
│   │   ├── widget_customizer_screen.dart    # Container & layout playground
│   │   ├── widget_detail_screen.dart        # Live widget preview & property viewer
│   │   └── widgets_list_screen.dart         # Categorized widget directory
│   ├── services/                   # Modular singleton service layer (2,096 LOC)
│   │   ├── ad_service.dart                  # Google AdMob (App Open, Banner, Interstitial, Rewarded)
│   │   ├── analytics_service.dart           # Firebase Analytics & Crashlytics
│   │   ├── deep_link_service.dart           # App Links & custom URI schemes (learnflutter://)
│   │   ├── home_widget_service.dart         # Android/iOS home screen widget updates
│   │   ├── in_app_update_service.dart       # Google Play in-app updates
│   │   ├── notification_service.dart        # Scheduled daily learning notifications
│   │   └── share_card_service.dart          # Milestone card generation & sharing
│   ├── translations/               # Internationalization (2,013 LOC)
│   │   └── app_translations.dart           # 13 localized language dictionaries
│   ├── utils/                      # Helper utilities (96 LOC)
│   │   └── url_launcher_helper.dart         # Safe URL and web opening utilities
│   └── widgets/                    # Reusable UI components (1,197 LOC)
│       ├── achievement_card.dart            # Gamified badge & achievement widget
│       ├── banner_ad_widget.dart            # Centered adaptive banner ad container
│       ├── flutter_glow_logo.dart           # Glowing animated Flutter brand logo
│       ├── highlighted_text.dart            # Search keyword highlighter
│       ├── in_app_update_banner.dart        # Non-intrusive update prompt banner
│       └── share_milestone_dialog.dart      # Social celebration dialog
├── docs/                            # GitHub Pages & documentation
│   ├── FIREBASE_GUIDE.md           # Firebase configuration, event taxonomy & DebugView guide
│   ├── index.html                  # Landing page
│   ├── privacy_policy.html         # Live privacy policy
│   ├── README.md                   # Docs deployment instructions
│   └── terms_and_conditions.html   # Terms and conditions
├── shorebird.yaml                   # Shorebird OTA Code Push configuration
├── firebase.json                    # Firebase CLI configuration
├── analysis_options.yaml            # Dart static analysis configuration
└── pubspec.yaml                     # Dependencies & asset declarations
```

---

## 📦 Technology Stack & Third-Party Integrations

| Service / Package | Version | Purpose in Application |
|---|---|---|
| **GetX** | `^4.6.6` | Reactive state management, dependency injection, and snackbar/dialog triggers |
| **GetStorage** | `^2.1.1` | High-speed, synchronous key-value persistent storage for offline-first state |
| **Firebase Core** | `^4.11.0` | Cross-platform Firebase initialization and platform bindings |
| **Firebase Auth** | `^6.7.0` | Authentication supporting Google Sign-In (`google_sign_in: ^6.2.2`) |
| **Firebase Analytics** | `^12.4.3` | Usage telemetry, screen tracking, and user event funnels |
| **Firebase Crashlytics** | `^5.2.4` | Fatal/non-fatal crash logging, platform exception handling, and breadcrumbs |
| **Google Mobile Ads (AdMob)** | `^5.1.0` | Monetization via Banner, Interstitial, Rewarded, and App Open ads |
| **Shorebird Code Push** | `00bab334-...` | Over-The-Air (OTA) instantaneous Flutter updates without app store review |
| **Flutter Local Notifications** | `^19.0.0` | Scheduled daily notifications powered by `timezone: ^0.10.0` |
| **Home Widget** | `^0.7.0` | Synchronizes streak and learning progress to Android/iOS home widgets |
| **In-App Update** | `^4.2.5` | Flexible and immediate Google Play in-app application updates |
| **App Links** | `^6.4.0` | Deep linking via `learnflutter://` and HTTPS Android App Links |
| **Screenshot & Share Plus** | `^3.0.0` / `^10.0.0` | Milestone snapshot rendering and native sharing sheet integration |
| **Flutter Syntax View** | `^4.0.0` | Code snippet syntax highlighting with copy-to-clipboard |
| **Google Fonts** | `^6.1.0` | Typography rendering (Poppins font family) |
| **Package Info Plus** | `^9.0.1` | Retrieves dynamic application version and build number for display |

---

## 🌐 Internationalization (13 Languages)

`AppTranslations` provides end-to-end localization covering:
- 🇺🇸 **English** (`en_US`)
- 🇪🇸 **Spanish** (`es_ES`)
- 🇧🇷 **Portuguese** (`pt_BR`)
- 🇸🇦 **Arabic** (`ar_SA` - RTL layout ready)
- 🇮🇳 **Hindi** (`hi_IN`)
- 🇫🇷 **French** (`fr_FR`)
- 🇩🇪 **German** (`de_DE`)
- 🇨🇳 **Chinese** (`zh_CN`)
- 🇯🇵 **Japanese** (`ja_JP`)
- 🇰🇷 **Korean** (`ko_KR`)
- 🇮🇩 **Indonesian** (`id_ID`)
- 🇹🇷 **Turkish** (`tr_TR`)
- 🇷🇺 **Russian** (`ru_RU`)

Language preferences persist across app restarts using `ThemeController` and `GetStorage`.

---

## 🚀 Getting Started & Build Commands

### Prerequisites
- **Flutter SDK:** 3.10.4 or higher
- **Dart SDK:** 3.0.0 or higher
- **JDK:** Java 17
- **Android Studio / Xcode:** Latest versions with Android SDK 34 and iOS 15+ support

### 1. Installation
```bash
# Clone the repository
git clone https://github.com/uksolutions/learnflutter.git
cd learnflutter

# Fetch dependencies
flutter pub get
```

### 2. Running in Debug Mode
> [!NOTE]
> In debug mode, `AdService` automatically activates official Google test ad units to prevent accidental invalid traffic strikes on your AdMob account.

```bash
flutter run
```

### 3. Release Builds (Android)
```bash
# Build Android App Bundle (AAB) for Google Play Store
flutter build appbundle --release

# Build standalone APK
flutter build apk --release
```

### 4. Shorebird OTA Code Push Releases & Patches
```bash
# Create an initial Shorebird release (AAB)
shorebird release android

# Push an instant OTA patch to active users
shorebird patch android
```

---

## 🔥 Firebase Setup & Analytics Observability

For detailed Firebase architectural notes, event schemas, and production checklist, consult [docs/FIREBASE_GUIDE.md](docs/FIREBASE_GUIDE.md).

### Testing Analytics in Real Time with DebugView:

**Android:**
```bash
adb shell setprop debug.firebase.analytics.app com.uksolutions.learnflutter
```
*(To disable: `adb shell setprop debug.firebase.analytics.app .none.`)*

**iOS:**
In Xcode, navigate to:
`Product → Scheme → Edit Scheme → Run (Debug) → Arguments → Arguments Passed On Launch`
Add `-FIRDebugEnabled`.

---

## 🛡️ Comprehensive Technical Audit & Health Report

### 1. Executive Health Scorecard

| Assessment Dimension | Rating | Status | Summary |
|---|---|:---:|---|
| **Feature Completeness** | **9.8 / 10** | 🟢 Excellent | 127 widgets across 13 categories, 5 full app blueprints, motion lab, UI cookbook, quiz engine, and certifications. |
| **UI & UX Quality** | **9.2 / 10** | 🟢 Excellent | Fluid Material 3 styling, dynamic light/dark mode, font scaling, glowing animations, and responsive feedback. |
| **Offline First & Storage** | **9.2 / 10** | 🟢 Excellent | Zero-friction boot; full core functionality works offline with persistent GetStorage cache. |
| **Platform Integration** | **9.0 / 10** | 🟢 Excellent | Android App Links, Home Widget & desugaring fully configured. iOS deep linking (`learnflutter://`) registered. |
| **Monetization & Ad Safety** | **9.0 / 10** | 🟢 Excellent | Production unit IDs isolated; automated test-ad fallback in debug mode prevents policy strikes. |
| **Security & Privacy** | **8.8 / 10** | 🟢 Good | Keystore properly git-ignored; published privacy policy; only client-safe keys in client code. |
| **Code Architecture & Structure**| **6.8 / 10** | 🟡 Moderate | Clean GetX separation, but contains massive monolithic screen files (God widgets) that need sub-widget extraction. |
| **Test Coverage & CI/CD** | **1.0 / 10** | 🔴 Critical | Zero automated tests (`test/` missing); no automated GitHub Actions CI pipeline. |

---

### 2. Codebase Metrics & Statistics

- **Total Dart Lines of Code:** `30,740` lines across `60` files in `lib/`
- **Largest Code Contributors:**
  - `lib/data/widgets_data.dart`: 2,889 lines (Core widget catalog)
  - `lib/screens/home_screen.dart`: 2,329 lines (Main dashboard)
  - `lib/data/extra_widgets_data.dart`: 2,260 lines (Advanced widget catalog)
  - `lib/translations/app_translations.dart`: 2,013 lines (13 localized language sets)
  - `lib/screens/widget_detail_screen.dart`: 1,792 lines (Detail & playground preview)
  - `lib/screens/settings_screen.dart`: 1,606 lines (Settings, updates, translations)
  - `lib/screens/interview_screen.dart`: 1,223 lines (Categorized interview Q&A directory)
  - `lib/screens/ui_cookbook_screen.dart`: 952 lines (Interactive UI patterns)
  - `lib/screens/quiz_screen.dart`: 866 lines (Quiz challenge engine)
  - `lib/data/projects_data.dart`: 863 lines (5 production project blueprints)
- **Component Distribution:**
  - `lib/screens/`: 21 files (~15.6k LOC)
  - `lib/data/`: 6 files (~8.0k LOC)
  - `lib/services/`: 7 files (~2.1k LOC)
  - `lib/translations/`: 1 file (~2.0k LOC)
  - `lib/controllers/`: 12 files (~1.4k LOC)
  - `lib/widgets/`: 6 files (~1.2k LOC)
  - `lib/utils/`: 1 file (~0.1k LOC)
  - `lib/models/`: 4 files (~0.1k LOC)
  - Root `lib/`: `main.dart` (142 LOC) & `firebase_options.dart` (141 LOC)

---

### 3. Architecture & State Management Review

#### Strengths:
1. **Separation of Concerns:** Business logic for streaks, onboarding, authentication, and progress is isolated inside dedicated `GetxController` classes.
2. **Synchronous Bootstrapping:** `GetStorage.init()` executes synchronously before `runApp()`, preventing flash-of-unstyled-theme or null-preference crashes during startup.
3. **Zoned Error Boundary:** `runZonedGuarded` in `main.dart` captures unhandled asynchronous errors and dispatches them directly to Firebase Crashlytics.
4. **Deep Linking Parity:** Android (`AndroidManifest.xml`) and iOS (`ios/Runner/Info.plist`) both register the `learnflutter://` scheme, enabling symmetric universal links.

#### Architecture Observations:
1. **Direct Navigation vs. Named Routes:** Navigation across the app is performed directly using imperative calls (`Get.to(() => const Screen())`). While functional and rapid to develop, migrating to declarative named routes (`GetPage` with bindings) would streamline universal deep-link routing and allow granular lazy-loading of controllers.
2. **Stateful vs. Reactive Hybridization:** Several large screens (`HomeScreen`, `SettingsScreen`) mix local `setState()` with `Obx()` reactive streams. Standardizing state logic into controllers will simplify widget rebuilding.

---

### 4. Security, Credentials & Privacy Audit

- **Keystore Security:** `android/app/key.properties` and `*.jks` are properly excluded in `.gitignore` and are not committed to source control.
- **API Keys Review:** The Firebase API keys present in `lib/firebase_options.dart` and `google-services.json` are client app identifiers meant for distribution in client binaries. Firebase security rules should remain enforced on the backend.
- **AdMob Safety:** Ad unit IDs switch automatically between production IDs and Google's official test IDs based on `kReleaseMode`. This prevents inadvertent click fraud or invalid traffic flags during local development.
- **Permissions:** Android permissions requested (`INTERNET`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE`) match app functionality (notifications and connectivity).
- **Privacy Policy:** Active privacy policy hosted at `docs/privacy_policy.html` and compliant with Google Play Store standards.

---

### 5. Platform Integration Analysis

#### Android:
- **Build Toolchain:** Modern Gradle Kotlin DSL (`build.gradle.kts`) with Java 17 and `desugar_jdk_libs:2.1.4`.
- **App Links & Deep Linking:** Fully registered in `AndroidManifest.xml` supporting both `learnflutter://` and `https://ukrsolutions.in/learnflutter/...`.
- **Home Widget:** Custom `LearnFlutterWidgetProvider.kt` and XML widget layouts configured to display streak counts and learning progress on Android home screens.

#### iOS:
- **Deployment Baseline:** Upgraded to `platform :ios, '15.0'`.
- **Deep Linking:** Synchronized: both Google Sign-In redirect and `learnflutter` custom URL schemes are declared in `ios/Runner/Info.plist` under `CFBundleURLTypes`.
- **Dynamic Frameworks:** CocoaPods configured with `use_frameworks!` for modern dynamic library linkage.

---

### 6. Identified Technical Debt & Code Smells

```
[HIGH]    🚨 Zero Automated Tests: No unit, widget, or integration tests exist in the project (test/ directory missing).
[HIGH]    ⚠️ Monolithic Screens: home_screen.dart (2.3k LOC), widget_detail_screen.dart (1.8k LOC),
             and settings_screen.dart (1.6k LOC) are oversized and should be decomposed into smaller sub-widgets.
[MEDIUM]  📂 Tracked Build Artifact: android/build/reports/problems/problems-report.html is tracked in Git.
[MEDIUM]  📋 File Duplication: privacy_policy.html and terms_and_conditions.html exist in both root and docs/.
[LOW]     💾 In-Memory Data Scale: Over 5,000 lines of static Dart data loaded in memory on launch.
             Consider JSON assets with lazy parsing for faster memory reclamation.
[LOW]     🔄 CI/CD Automation: Missing GitHub Actions workflow for linting, testing, and automated release builds.
```

---

### 7. Prioritized Remediation Roadmap

#### Phase 1: Cleanliness & Immediate Housekeeping (Sprint 1)
- [x] Remove obsolete backup files from version control (`widgets_data.dart.backup` removed).
- [x] Add `learnflutter` custom URL scheme to `ios/Runner/Info.plist` under `CFBundleURLTypes`.
- [ ] Remove `android/build/reports/problems/problems-report.html` from version control (`git rm`).
- [ ] Consolidate duplicated legal files (keep `docs/privacy_policy.html` and `docs/terms_and_conditions.html`, remove duplicates from project root).

#### Phase 2: Testing Infrastructure & CI/CD (Sprint 2)
- [ ] Create `test/` directory and implement unit tests for core controllers:
  - `StreakControllerTest`: Verify streak increments, midnight resets, and shield consumption.
  - `QuizControllerTest`: Test scoring, 50/50 lifeline logic, and edge cases.
  - `ProgressControllerTest`: Test percentage calculation and persistence.
- [ ] Configure GitHub Actions workflow (`.github/workflows/ci.yml`) to run `flutter analyze` and `flutter test` on all pull requests.

#### Phase 3: Architectural Refactoring & Decomposition (Sprint 3)
- [ ] Refactor `home_screen.dart`: Extract `StreakBanner`, `DailyGoalsCard`, `CategoryGrid`, and `RecentWidgetsSection` into standalone widget files in `lib/widgets/home/`.
- [ ] Refactor `widget_detail_screen.dart`: Extract interactive preview tabs and code viewer sections.
- [ ] Refactor `settings_screen.dart`: Extract language modal and appearance setting tiles.

#### Phase 4: Scalability & Performance Optimization (Sprint 4)
- [ ] Transition static `widgets_data.dart` and `extra_widgets_data.dart` into bundled JSON assets loaded on demand.
- [ ] Migrate imperative routing to declarative `GetPage` definitions for seamless deep link resolution.

---

## 📄 Documentation Index

- [AdMob Integration & Testing Guide](ADMOB_TEST_GUIDE.md) - Details on ad unit IDs, frequency capping, and test modes.
- [Firebase Guide & Analytics Taxonomy](docs/FIREBASE_GUIDE.md) - Complete Firebase setup, Google Sign-In, Analytics event schemas, and DebugView instructions.
- [Shorebird OTA Integration Guide](SHOREBIRD_GUIDE.md) - Instructions for over-the-air code push releases and patches.
- [Google Play Store Deployment Guide](PLAY_STORE_DEPLOYMENT.md) - Production release checklist and keystore notes.
- [Docs & Web Deployment](docs/README.md) - GitHub Pages setup for privacy policy and landing page.

---

## 👨‍💻 Maintainers & License

- **Developer & Publisher:** **UK Solutions**
- **Contact & Support:** contact@ukrsolutions.in
- **Website:** [ukrsolutions.in](https://ukrsolutions.in)
- **License:** Proprietary - All rights reserved by UK Solutions.

---
*Updated & Verified against Codebase • Learn Flutter & Dart v1.1.1+12*
