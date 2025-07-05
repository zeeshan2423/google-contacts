import 'package:google_contacts/core/constants/imports.dart';

Future<void> main() async {
  await AppInitializer.initialize();

  runApp(BlocProvider(create: (_) => NetworkCubit(), child: const MyApp()));
}
