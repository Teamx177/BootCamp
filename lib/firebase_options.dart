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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAsEGgiLT7SBG3F032iUT5feXmtcF4AX3A',
    appId: '1:568059364547:web:86405527f38468c9b10e76',
    messagingSenderId: '568059364547',
    projectId: 'hrms-b5777',
    authDomain: 'hrms-b5777.firebaseapp.com',
    storageBucket: 'hrms-b5777.appspot.com',
    measurementId: 'G-JV37Q0FZQX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRMMANg79Ix4fswbCCscIzg0aQ8zED-Us',
    appId: '1:568059364547:android:c60d09448bb1a3d3b10e76',
    messagingSenderId: '568059364547',
    projectId: 'hrms-b5777',
    storageBucket: 'hrms-b5777.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0MHQ5JpUOhNnyIbHhKvkW2AxAn8sPyYk',
    appId: '1:568059364547:ios:b79c9145328d7d22b10e76',
    messagingSenderId: '568059364547',
    projectId: 'hrms-b5777',
    storageBucket: 'hrms-b5777.appspot.com',
    androidClientId: '568059364547-1lcjkauta2rife7failjtkgk9gjihjc4.apps.googleusercontent.com',
    iosClientId: '568059364547-o6dcplu84nmb4v4vn0lf6ksfi2l3n5gf.apps.googleusercontent.com',
    iosBundleId: 'com.hrmst177.hrms',
  );
}
