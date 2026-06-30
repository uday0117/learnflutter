// Generated from android/app/google-services.json for project learn-flutter-8f6d1.
// Run `flutterfire configure` after adding an iOS app in Firebase Console to
// regenerate this file with full platform support.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for Firebase.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Add an iOS app in Firebase Console and run `flutterfire configure`.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS is not configured for Firebase.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows is not configured for Firebase.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux is not configured for Firebase.');
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCR1zqFmGbQhgl7JXbVKI3HqTxywQMo6zs',
    appId: '1:746629996575:android:f41470cce92167325b752a',
    messagingSenderId: '746629996575',
    projectId: 'learn-flutter-8f6d1',
    storageBucket: 'learn-flutter-8f6d1.firebasestorage.app',
  );

  // Reserved for `flutterfire configure` after iOS app registration.
  // ignore: unused_field
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCR1zqFmGbQhgl7JXbVKI3HqTxywQMo6zs',
    appId: '1:746629996575:ios:0000000000000000000000',
    messagingSenderId: '746629996575',
    projectId: 'learn-flutter-8f6d1',
    storageBucket: 'learn-flutter-8f6d1.firebasestorage.app',
    iosBundleId: 'com.uksolutions.learnflutter',
  );
}
