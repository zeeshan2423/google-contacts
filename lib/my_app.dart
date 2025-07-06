import 'package:google_contacts/core/constants/imports.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.isDarkMode,
      builder: (context, value, child) {
        return MaterialApp.router(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],

          supportedLocales: const [Locale('en', 'IN')],

          locale: const Locale('en', 'IN'),

          title: AppStrings.appTitle,

          theme: AppTheme.lightTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode: value ? ThemeMode.dark : ThemeMode.light,

          routeInformationProvider: AppRouter.router.routeInformationProvider,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,

          builder: (context, child) {
            return BlocListener<NetworkCubit, NetworkStatus>(
              listenWhen: (previous, current) =>
                  previous.status == ConnectivityStatus.disconnected ||
                  current.status == ConnectivityStatus.disconnected,
              listener: (context, state) {
                if (state ==
                    const NetworkStatus(ConnectivityStatus.disconnected)) {
                  AppWidgets.customSnackBar(
                    context: context,
                    text: AppStrings.noInternetMsg,
                  );
                } else {
                  AppWidgets.customSnackBar(
                    context: context,
                    text: AppStrings.restoredInternetMsg,
                  );
                }
              },
              child: child,
            );
          },
        );
      },
    );
  }
}
