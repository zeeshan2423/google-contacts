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
                pageBuilder: (context, state) {
                  return buildPageWithDefaultTransition(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: sl<ContactsCubit>()),
                        BlocProvider.value(value: sl<FavoritesCubit>()),
                        BlocProvider.value(value: sl<NavigationCubit>()),
                      ],
                      child: const ContactsPage(),
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: PAGES.createContact.screenPath,
                    name: PAGES.createContact.screenName,
                    parentNavigatorKey: _rootNavigator,
                    pageBuilder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final contact = extra?['contact'] as Contact?;

                      return buildPageWithDefaultTransition(
                        child: BlocProvider.value(
                          value: sl<CreateContactCubit>(),
                          child: CreateContactPage(
                            key: state.pageKey,
                            contact: contact,
                          ),
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: PAGES.contactDetail.screenPath,
                    name: PAGES.contactDetail.screenName,
                    parentNavigatorKey: _rootNavigator,
                    pageBuilder: (context, state) =>
                        buildPageWithDefaultTransition(
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: sl<ContactsCubit>()),
                              BlocProvider.value(
                                value: sl<ContactDetailCubit>(),
                              ),
                            ],
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
              GoRoute(
                path: PAGES.favorites.screenPath,
                name: PAGES.favorites.screenName,
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: sl<FavoritesCubit>()),
                      BlocProvider.value(value: sl<ContactsCubit>()),
                      BlocProvider.value(value: sl<NavigationCubit>()),
                    ],
                    child: const FavoritesPage(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
