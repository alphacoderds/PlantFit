import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyATPI0LPRdNYncX_J-KAcwzawId1fw_wdo',
    appId: '1:364500172149:web:a52f44547e8277cdaa273c',
    messagingSenderId: '364500172149',
    projectId: 'plantfit-3f2ee',
    authDomain: 'plantfit-3f2ee.firebaseapp.com',
    storageBucket: 'plantfit-3f2ee.firebasestorage.app',
    measurementId: 'G-2XM6VLTYX1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBE-cAaMYeGmbu8IELlqRgcDUvBzPDLDZo',
    appId: '1:364500172149:android:d9d7453d98ee6d61aa273c',
    messagingSenderId: '364500172149',
    projectId: 'plantfit-3f2ee',
    storageBucket: 'plantfit-3f2ee.firebasestorage.app',
  );

  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyCc1wLUqYh9VqyqnxJmGbEr-hNlWPfEe0w',
  //   appId: '1:364500172149:ios:14b681f9fbc67f98aa273c',
  //   messagingSenderId: '364500172149',
  //   projectId: 'plantfit-3f2ee',
  //   storageBucket: 'plantfit-3f2ee.firebasestorage.app',
  //   iosBundleId: 'com.example.plantfit',
  // );

  // static const FirebaseOptions macos = FirebaseOptions(
  //   apiKey: 'AIzaSyCc1wLUqYh9VqyqnxJmGbEr-hNlWPfEe0w',
  //   appId: '1:364500172149:ios:14b681f9fbc67f98aa273c',
  //   messagingSenderId: '364500172149',
  //   projectId: 'plantfit-3f2ee',
  //   storageBucket: 'plantfit-3f2ee.firebasestorage.app',
  //   iosBundleId: 'com.example.plantfit',
  // );

  // static const FirebaseOptions windows = FirebaseOptions(
  //   apiKey: 'AIzaSyATPI0LPRdNYncX_J-KAcwzawId1fw_wdo',
  //   appId: '1:364500172149:web:3a51238c71a233d1aa273c',
  //   messagingSenderId: '364500172149',
  //   projectId: 'plantfit-3f2ee',
  //   authDomain: 'plantfit-3f2ee.firebaseapp.com',
  //   storageBucket: 'plantfit-3f2ee.firebasestorage.app',
  //   measurementId: 'G-FW1BCFTVF4',
  // );
}
