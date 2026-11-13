# Firebase Integration & Operations Guide 🔥

This document outlines the complete Firebase infrastructure, event taxonomy, observability tools, and educational Firebase blueprints integrated into the **LearnFlutter** application.

---

## 1. ⚙️ Firebase Project Configuration

- **Firebase Project ID:** `learn-flutter-8f6d1`
- **Android App ID:** `1:746629996575:android:f41470cce92167325b752a`
- **iOS App ID:** `1:746629996575:ios:0aaaf7e954c7cc645b752a`
- **iOS Bundle Identifier:** `com.uksolutions.learnflutter`
- **Storage Bucket:** `learn-flutter-8f6d1.firebasestorage.app`
- **Configuration Files:**
  - Dart: `lib/firebase_options.dart`
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`
  - CLI: `firebase.json`

---

## 2. 🚀 Active Firebase Services

| Service | Package | Operational Purpose |
|---|---|---|
| **Firebase Core** | `firebase_core: ^4.11.0` | Initialization and platform binding |
| **Firebase Analytics** | `firebase_analytics: ^12.4.3` | User journey, engagement funnels, ad revenue attribution |
| **Firebase Crashlytics** | `firebase_crashlytics: ^5.2.4` | Fatal/non-fatal crash logging with breadcrumbs |
| **Firebase Auth** | `firebase_auth: ^6.7.0` | Google Sign-In & user session management |
| **Cloud Firestore** | Supported in Blueprints | Realtime chat stream & user profile synchronization |

---

## 3. 📊 Analytics Event Taxonomy & Funnels

All events are routed centrally via `AnalyticsService` (`lib/services/analytics_service.dart`):

### 🎯 Primary Learning Funnel
1. `app_start`: Fired upon app launch and Firebase initialization.
2. `category_selected`: User enters a widget category directory.
3. `widget_viewed`: User explores a widget detail screen (`widget_id`, `widget_name`, `category`).
4. `code_copied`: User copies Dart code from playgrounds, interview questions, or projects.
5. `quiz_completed`: User completes a quiz session (`score`, `total_questions`, `lifetime_played`).
6. `certificate_earned`: User generates a milestone completion certificate.

### 💼 Project Blueprints & Monetization Tracking
- `project_blueprint_viewed`: Triggered when exploring sample architectures (`project_id`, `project_name`).
- `project_blueprint_unlocked`: Triggered after rewarded ad unlock.
- `ad_impression`: AdMob paid event logging (`ad_format`, `ad_unit_name`, `value`, `currency`, `precision`).
- `ad_reward_prompt_shown` / `ad_reward_accepted` / `ad_reward_completed`: Tracks user willingness to watch rewarded video ads.
- `ad_failure`: Logs non-fatal ad network errors to diagnose ad fill drops.

### 🧠 Interview Preparation Mastery
- `interview_question_viewed`: Logs which questions learners study most (`question_id`, `category`, `level`, `questionIndex`).
- `interview_question_mastered`: Logs spaced-repetition mastery completion (when reviewed ≥ 3 times).

---

## 4. 🐞 Testing Analytics Live in DebugView

To verify events in real time without the standard 24-hour Firebase processing delay:

### Android:
```bash
adb shell setprop debug.firebase.analytics.app com.uksolutions.learnflutter
```
To turn off debug mode:
```bash
adb shell setprop debug.firebase.analytics.app .none.
```

### iOS:
In Xcode, navigate to:
**Product → Scheme → Edit Scheme → Run (Debug) → Arguments → Arguments Passed On Launch**
Add:
```
-FIRDebugEnabled
```

Once enabled, open **Firebase Console → Analytics → DebugView** to observe events appearing instantly as you navigate the app.

---

## 5. 🛠️ Crashlytics Breadcrumbs & Error Tracking

`AnalyticsService` binds fatal and non-fatal errors to Crashlytics:
- **Fatal Flutter Errors:** Caught by `FlutterError.onError` and forwarded to `recordFlutterFatalError`.
- **Async Uncaught Errors:** Caught by `PlatformDispatcher.instance.onError` and `runZonedGuarded`.
- **Breadcrumbs:** Appended automatically via `AnalyticsService().logBreadcrumb(msg)`:
  - User navigation transitions
  - Screen changes
  - Milestone unlocks and ad interactions

---

## 6. 📚 In-App Firebase Project Blueprints

Learners can explore two production-grade Firebase architectures in the app (`lib/data/projects_data.dart`):

1. **Firebase Group Chat UI (`firebase_chat`)**:
   - Real-time `cloud_firestore` collection stream
   - Atomic server timestamps via `FieldValue.serverTimestamp()`
   - Auto-scrolling chat room with custom-drawn chat bubbles
   - Includes full Firestore security rules walkthrough

2. **Firebase Auth & User Profile Hub (`firebase_auth_sync`)**:
   - Google Sign-In & Email/Password authentication
   - Reactive `authStateChanges()` listener
   - Automatic Firestore user document creation and profile updates
   - Offline token persistence and error recovery

