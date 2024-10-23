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
    apiKey: 'AIzaSyAMKn_k76RhwNqDc3sstYeHNZMRL_4rq9I',
    appId: '1:1075573021742:web:e6dfd0d3c913f3a2cb93bf',
    messagingSenderId: '1075573021742',
    projectId: 'blueatt1',
    authDomain: 'blueatt1.firebaseapp.com',
    storageBucket: 'blueatt1.appspot.com',
    measurementId: 'G-888PZ68TKB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZ1qvAtyDdR8dUxMmfCm4A8kfOoUFF9nM',
    appId: '1:1075573021742:android:a1c56c240916d0a0cb93bf',
    messagingSenderId: '1075573021742',
    projectId: 'blueatt1',
    storageBucket: 'blueatt1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3NXy2lWD8mnqxOYVeRdKJBURSy1i5hpI',
    appId: '1:1075573021742:ios:6a4ce013de558c35cb93bf',
    messagingSenderId: '1075573021742',
    projectId: 'blueatt1',
    storageBucket: 'blueatt1.appspot.com',
    iosBundleId: 'com.example.bluetoothAttendance',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA3NXy2lWD8mnqxOYVeRdKJBURSy1i5hpI',
    appId: '1:1075573021742:ios:6a4ce013de558c35cb93bf',
    messagingSenderId: '1075573021742',
    projectId: 'blueatt1',
    storageBucket: 'blueatt1.appspot.com',
    iosBundleId: 'com.example.bluetoothAttendance',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAMKn_k76RhwNqDc3sstYeHNZMRL_4rq9I',
    appId: '1:1075573021742:web:4d600c151a1d998bcb93bf',
    messagingSenderId: '1075573021742',
    projectId: 'blueatt1',
    authDomain: 'blueatt1.firebaseapp.com',
    storageBucket: 'blueatt1.appspot.com',
    measurementId: 'G-MWCVX16HSX',
  );

}