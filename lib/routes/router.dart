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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => BlocProvider.value(
          value: sl<NavigationCubit>(),
          child: NavigationPage(key: state.pageKey, child: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PAGES.contacts.screenPath,
                name: PAGES.contacts.screenName,
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  child: BlocProvider.value(
                    value: sl<ContactsCubit>(),
                    child: const ContactsPage(),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: PAGES.createContact.screenPath,
                    name: PAGES.createContact.screenName,
                    parentNavigatorKey: _rootNavigator,
                    pageBuilder: (context, state) =>
                        buildPageWithDefaultTransition(
                          child: BlocProvider.value(
                            value: sl<CreateContactCubit>(),
                            child: CreateContactPage(
                              key: state.pageKey,
                              contact:
                                  (state.extra!
                                          as Map<String, dynamic>)['contact']
                                      as Contact,
                            ),
                          ),
                        ),
                  ),
                  GoRoute(
                    path: PAGES.contactDetail.screenPath,
                    name: PAGES.contactDetail.screenName,
                    parentNavigatorKey: _rootNavigator,
                    pageBuilder: (context, state) =>
                        buildPageWithDefaultTransition(
                          child: BlocProvider.value(
                            value: sl<ContactDetailCubit>(),
                            child: ContactDetailPage(
                              key: state.pageKey,
                              contact:
                                  (state.extra!
                                          as Map<String, dynamic>)['contact']
                                      as Contact,
                            ),
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
