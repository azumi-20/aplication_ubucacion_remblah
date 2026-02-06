import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC802Ee7H1lUEGCGf578Lu5-Hc-yXBzWa4',
    appId: '1:6160819303:web:0b99f6772b1885a8a9e0c2',
    messagingSenderId: '6160819303',
    projectId: 'remblah-cs',
    authDomain: 'remblah-cs.firebaseapp.com',
    storageBucket: 'remblah-cs.firebasestorage.app',
    measurementId: 'G-BW3JGMZSJD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC802Ee7H1lUEGCGf578Lu5-Hc-yXBzWa4',
    appId: '1:6160819303:android:03d8e94a8d8bc6fca9e0c2',
    messagingSenderId: '6160819303',
    projectId: 'remblah-cs',
    storageBucket: 'remblah-cs.firebasestorage.app',
  );
}