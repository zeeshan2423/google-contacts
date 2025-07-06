import 'package:google_contacts/core/constants/imports.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load();

    await init();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Bloc.observer = AppBlocObserver();

    await LocalDatabase.database;
  }
}
