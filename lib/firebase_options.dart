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
    apiKey: 'AIzaSyDQ9RgQAEN4qBInijZs5Nn5LFUsXz1x40k',
    appId: '1:812607055228:web:74d3f102cc6e227e55b0f9',
    messagingSenderId: '812607055228',
    projectId: 'schoolmate-8244a',
    authDomain: 'schoolmate-8244a.firebaseapp.com',
    storageBucket: 'schoolmate-8244a.firebasestorage.app',
    measurementId: 'G-241L40Z6C8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdslpH1XFFGZ6llglh2k8m0zi2cp-Zi7Q',
    appId: '1:812607055228:android:085ae2d8012682ba55b0f9',
    messagingSenderId: '812607055228',
    projectId: 'schoolmate-8244a',
    storageBucket: 'schoolmate-8244a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiJDK3yh9pUfGjX-w-rZ3zlBHU1w0cK0A',
    appId: '1:812607055228:ios:8763acbf4276d13955b0f9',
    messagingSenderId: '812607055228',
    projectId: 'schoolmate-8244a',
    storageBucket: 'schoolmate-8244a.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDiJDK3yh9pUfGjX-w-rZ3zlBHU1w0cK0A',
    appId: '1:812607055228:ios:8763acbf4276d13955b0f9',
    messagingSenderId: '812607055228',
    projectId: 'schoolmate-8244a',
    storageBucket: 'schoolmate-8244a.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDQ9RgQAEN4qBInijZs5Nn5LFUsXz1x40k',
    appId: '1:812607055228:web:18984c0c2536423c55b0f9',
    messagingSenderId: '812607055228',
    projectId: 'schoolmate-8244a',
    authDomain: 'schoolmate-8244a.firebaseapp.com',
    storageBucket: 'schoolmate-8244a.firebasestorage.app',
    measurementId: 'G-HXCGPGH0H8',
  );
}
