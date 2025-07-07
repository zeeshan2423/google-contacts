import 'package:google_contacts/core/constants/imports.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton(NavigationCubit.new)
    ..registerFactory(
      () => ContactsCubit(getContacts: sl(), searchContacts: sl()),
    )
    ..registerLazySingleton(() => GetContacts(sl()))
    ..registerLazySingleton(() => SearchContacts(sl()))
    ..registerLazySingleton<ContactsRepository>(
      () => ContactsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<LocalDatabase>(LocalDatabase.new)
    ..registerFactory(
      () => CreateContactCubit(addContact: sl(), updateContact: sl()),
    )
    ..registerLazySingleton(() => AddContact(sl()))
    ..registerLazySingleton(() => UpdateContact(sl()))
    ..registerLazySingleton<CreateContactRepository>(
      () => CreateContactRepositoryImpl(sl()),
    )
    ..registerFactory(
      () => ContactDetailCubit(toggleFavorite: sl(), deleteContact: sl()),
    )
    ..registerLazySingleton(() => ToggleFavorite(sl()))
    ..registerLazySingleton(() => DeleteContact(sl()))
    ..registerLazySingleton<ContactDetailRepository>(
      () => ContactDetailRepositoryImpl(sl()),
    )
    ..registerFactory(() => FavoritesCubit(getContacts: sl()));
}
