import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
static const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCvT_h3TgBZhUzos06J751yuoUf-203YvU",
  appId: "1:661768757343:android:e314ff3dcde9e0906bfbea",
  messagingSenderId: "661768757343",
  projectId: "meatly-d190e",
  storageBucket: "meatly-d190e.appspot.com",
);

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvT_h3TgBZhUzos06J751yuoUf-203YvU',
    appId: '1:661768757343:android:e314ff3dcde9e0906bfbea',
    messagingSenderId: '661768757343',
    projectId: 'meatly-d190e',
    storageBucket: 'meatly-d190e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMQFX72rCxTcuz6Cz0xsLx_Ez_aFhNLPA',
    appId: '1:661768757343:ios:346f8b77c2a9d6f06bfbea',
    messagingSenderId: '661768757343',
    projectId: 'meatly-d190e',
    storageBucket: 'meatly-d190e.appspot.com',
    iosBundleId: 'us.meatly.meatly',
  );
}
