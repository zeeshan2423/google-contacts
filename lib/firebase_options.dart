import 'package:google_contacts/core/constants/imports.dart';

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

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['ANDROID_API_KEY'] ?? '',
    appId: '1:947406254230:android:10093a00beeb733ab252b7',
    messagingSenderId: '947406254230',
    projectId: 'contacts-c8880',
    storageBucket: 'contacts-c8880.firebasestorage.app',
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['IOS_API_KEY'] ?? '',
    appId: '1:947406254230:ios:c195d698c1ddc5ffb252b7',
    messagingSenderId: '947406254230',
    projectId: 'contacts-c8880',
    storageBucket: 'contacts-c8880.firebasestorage.app',
    iosBundleId: 'com.assignment.google.contacts.googleContacts',
  );
}
