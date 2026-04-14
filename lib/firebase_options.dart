// ╔══════════════════════════════════════════════════════════════╗
// ║  FIREBASE SETUP INSTRUCTIONS                                 ║
// ║                                                              ║
// ║  1. Go to: https://console.firebase.google.com              ║
// ║  2. Create a new project: "PlasticBusiness"                  ║
// ║  3. Add Android app with package: com.plasticbusiness.app    ║
// ║  4. Download google-services.json → put in android/app/      ║
// ║  5. Add iOS app → download GoogleService-Info.plist          ║
// ║  6. Run: dart pub global activate flutterfire_cli            ║
// ║  7. Run: flutterfire configure                               ║
// ║     This will auto-generate this file correctly              ║
// ║                                                              ║
// ║  Enable in Firebase Console:                                 ║
// ║  → Authentication → Email/Password (enable)                  ║
// ║  → Firestore Database → Create database (start in test mode) ║
// ╚══════════════════════════════════════════════════════════════╝

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('DefaultFirebaseOptions not supported for this platform.');
    }
  }

  // ── REPLACE THESE VALUES with your own from Firebase Console ──
  // After running `flutterfire configure`, this file is auto-generated

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.plasticbusiness.app',
  );
}
