import 'package:google_contacts/core/constants/imports.dart';

class AppRouter {
  const AppRouter._();

  static final _rootNavigator = GlobalKey<NavigatorState>(debugLabel: 'root');

  static final String _initialLocation = PAGES.contacts.screenPath;

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigator,
    initialLocation: _initialLocation,
    observers: [MyRouteObserver()],
    routes: [
      GoRoute(
        path: PAGES.contacts.screenPath,
        name: PAGES.contacts.screenName,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ContactsCubit>(),
          child: const ContactsPage(),
        ),
      ),
    ],
  );

  static GoRouter get router => _router;
}
