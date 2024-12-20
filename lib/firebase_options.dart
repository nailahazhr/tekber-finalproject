// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDfmB3tGxGTsB2EuYqQgTuywHLi8p6re8',
    appId: '1:126284977637:web:254b3ef448fb0df7174b0c',
    messagingSenderId: '126284977637',
    projectId: 'nutrismart-b7148',
    authDomain: 'nutrismart-b7148.firebaseapp.com',
    storageBucket: 'nutrismart-b7148.firebasestorage.app',
    measurementId: 'G-R2CHWQE6VX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAb599bgErAdg-64VF2KtXnnXH7ivRPEV8',
    appId: '1:126284977637:android:219456cbda8880f4174b0c',
    messagingSenderId: '126284977637',
    projectId: 'nutrismart-b7148',
    storageBucket: 'nutrismart-b7148.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfNyaYeog76mM-L8gb17zBJyN9cTsSsoE',
    appId: '1:126284977637:ios:3668731e07a5201d174b0c',
    messagingSenderId: '126284977637',
    projectId: 'nutrismart-b7148',
    storageBucket: 'nutrismart-b7148.firebasestorage.app',
    iosBundleId: 'com.example.nsApps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfNyaYeog76mM-L8gb17zBJyN9cTsSsoE',
    appId: '1:126284977637:ios:3668731e07a5201d174b0c',
    messagingSenderId: '126284977637',
    projectId: 'nutrismart-b7148',
    storageBucket: 'nutrismart-b7148.firebasestorage.app',
    iosBundleId: 'com.example.nsApps',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDDfmB3tGxGTsB2EuYqQgTuywHLi8p6re8',
    appId: '1:126284977637:web:cc4a0d07009b7d62174b0c',
    messagingSenderId: '126284977637',
    projectId: 'nutrismart-b7148',
    authDomain: 'nutrismart-b7148.firebaseapp.com',
    storageBucket: 'nutrismart-b7148.firebasestorage.app',
    measurementId: 'G-8C26XH959D',
  );

}