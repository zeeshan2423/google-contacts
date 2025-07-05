import 'package:google_contacts/core/constants/imports.dart';

class AppTheme {
  const AppTheme._();

  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(
    PlatformDispatcher.instance.platformBrightness == Brightness.dark,
  );

  static final lightTheme = ThemeData(
    colorSchemeSeed: const Color(0xFF86A9FF),

    brightness: Brightness.light,

    useMaterial3: true,

    textTheme: AppTextTheme.textTheme,
  );

  static final darkTheme = ThemeData(
    colorSchemeSeed: const Color(0xFF86A9FF),

    brightness: Brightness.dark,

    useMaterial3: true,

    textTheme: AppTextTheme.textTheme,
  );
}
