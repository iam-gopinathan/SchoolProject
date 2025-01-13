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
    apiKey: 'AIzaSyDwE6-_vkurMwP4OQLoaHCiez-zHfxcJ0Y',
    appId: '1:221228979530:web:4db96da5b26f0ff5499db3',
    messagingSenderId: '221228979530',
    projectId: 'pushnotificationsfirebas-b598e',
    authDomain: 'pushnotificationsfirebas-b598e.firebaseapp.com',
    storageBucket: 'pushnotificationsfirebas-b598e.firebasestorage.app',
    measurementId: 'G-WEXY1R5K24',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArryIqC73ZSJ_-ue0y4dadAfFDjScRV94',
    appId: '1:221228979530:android:d5ac58adc09a89d2499db3',
    messagingSenderId: '221228979530',
    projectId: 'pushnotificationsfirebas-b598e',
    storageBucket: 'pushnotificationsfirebas-b598e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxvmi8-bs57lWgaGJHd8Aars-niBzjmpA',
    appId: '1:221228979530:ios:8fbeb007475fe39e499db3',
    messagingSenderId: '221228979530',
    projectId: 'pushnotificationsfirebas-b598e',
    storageBucket: 'pushnotificationsfirebas-b598e.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxvmi8-bs57lWgaGJHd8Aars-niBzjmpA',
    appId: '1:221228979530:ios:8fbeb007475fe39e499db3',
    messagingSenderId: '221228979530',
    projectId: 'pushnotificationsfirebas-b598e',
    storageBucket: 'pushnotificationsfirebas-b598e.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDwE6-_vkurMwP4OQLoaHCiez-zHfxcJ0Y',
    appId: '1:221228979530:web:cc856abd2250b18a499db3',
    messagingSenderId: '221228979530',
    projectId: 'pushnotificationsfirebas-b598e',
    authDomain: 'pushnotificationsfirebas-b598e.firebaseapp.com',
    storageBucket: 'pushnotificationsfirebas-b598e.firebasestorage.app',
    measurementId: 'G-2ZSS8PQ4FJ',
  );
}
