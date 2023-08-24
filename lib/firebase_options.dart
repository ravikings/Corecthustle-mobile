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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFV8_bYMe_SUbS8-TGoXoqqlHjy1fV_7I',
    appId: '1:59361698308:android:880fed3e965ccee20e0b51',
    messagingSenderId: '59361698308',
    projectId: 'project-schoolbo-1597491385360',
    databaseURL: 'https://project-schoolbo-1597491385360.firebaseio.com',
    storageBucket: 'project-schoolbo-1597491385360.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATTeOoxg0vrQdpiUu0j0u7vs6E472sdWQ',
    appId: '1:59361698308:ios:6bacd338e8420ad60e0b51',
    messagingSenderId: '59361698308',
    projectId: 'project-schoolbo-1597491385360',
    databaseURL: 'https://project-schoolbo-1597491385360.firebaseio.com',
    storageBucket: 'project-schoolbo-1597491385360.appspot.com',
    iosClientId: '59361698308-ag42uk3bqrdkgv88r43l80p9pkhcg82o.apps.googleusercontent.com',
    iosBundleId: 'com.correct.hustle.app.correctHustle',
  );
}