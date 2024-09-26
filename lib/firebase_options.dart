// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCLnYt7-73k6Gm5-cxmsdS3HD9h8JCSNwI',
    appId: '1:832603898327:web:34956b867a768054768b92',
    messagingSenderId: '832603898327',
    projectId: 'hellohome-f58d5',
    authDomain: 'hellohome-f58d5.firebaseapp.com',
    storageBucket: 'hellohome-f58d5.appspot.com',
    measurementId: 'G-L98CT8515W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD28bJm-LdOCDv-oSrlIxvCBU5LqWqY8UI',
    appId: '1:832603898327:android:1bb009f608f91710768b92',
    messagingSenderId: '832603898327',
    projectId: 'hellohome-f58d5',
    storageBucket: 'hellohome-f58d5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2a1b5rHbA3SgyAgFEePiCmDPsI2Iye6o',
    appId: '1:832603898327:ios:adeb32c2546b47d8768b92',
    messagingSenderId: '832603898327',
    projectId: 'hellohome-f58d5',
    storageBucket: 'hellohome-f58d5.appspot.com',
    iosBundleId: 'com.foodly',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2a1b5rHbA3SgyAgFEePiCmDPsI2Iye6o',
    appId: '1:832603898327:ios:675bf760fb10cdc2768b92',
    messagingSenderId: '832603898327',
    projectId: 'hellohome-f58d5',
    storageBucket: 'hellohome-f58d5.appspot.com',
    iosBundleId: 'casa.hellohome.nicesolution',
  );
}
