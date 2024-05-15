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
    apiKey: 'AIzaSyAnGYkV1HFJLC7UEHIvAyKMOHCO9OKGQcQ',
    appId: '1:502918946593:web:acf7128e0fda5c190b2860',
    messagingSenderId: '502918946593',
    projectId: 'flutter-e05d8',
    authDomain: 'flutter-e05d8.firebaseapp.com',
    storageBucket: 'flutter-e05d8.appspot.com',
    measurementId: 'G-KL1DP7RKMJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqKL3bWboNCUIOAk2xui_BP4Tx8FFgcHs',
    appId: '1:502918946593:android:8db9e764f44b0f990b2860',
    messagingSenderId: '502918946593',
    projectId: 'flutter-e05d8',
    storageBucket: 'flutter-e05d8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_7AB0ESsQ4zSqWH5pOODrMDACxMSF79Q',
    appId: '1:502918946593:ios:ea20f8ca67ea903a0b2860',
    messagingSenderId: '502918946593',
    projectId: 'flutter-e05d8',
    storageBucket: 'flutter-e05d8.appspot.com',
    androidClientId: '502918946593-f3scfqe0of98gr0ghfmvpch2sq3un8tc.apps.googleusercontent.com',
    iosClientId: '502918946593-rp2d1krud96s1c45gjh63p6c4rn4k50o.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterProject6402262',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_7AB0ESsQ4zSqWH5pOODrMDACxMSF79Q',
    appId: '1:502918946593:ios:ea20f8ca67ea903a0b2860',
    messagingSenderId: '502918946593',
    projectId: 'flutter-e05d8',
    storageBucket: 'flutter-e05d8.appspot.com',
    androidClientId: '502918946593-f3scfqe0of98gr0ghfmvpch2sq3un8tc.apps.googleusercontent.com',
    iosClientId: '502918946593-rp2d1krud96s1c45gjh63p6c4rn4k50o.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterProject6402262',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnGYkV1HFJLC7UEHIvAyKMOHCO9OKGQcQ',
    appId: '1:502918946593:web:df9dabd7898cb7040b2860',
    messagingSenderId: '502918946593',
    projectId: 'flutter-e05d8',
    authDomain: 'flutter-e05d8.firebaseapp.com',
    storageBucket: 'flutter-e05d8.appspot.com',
    measurementId: 'G-J2N0DMWEFK',
  );

}