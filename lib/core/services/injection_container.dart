import 'package:google_contacts/core/constants/imports.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerFactory(NavigationCubit.new)
    ..registerFactory(() => ContactsCubit(getContacts: sl()))
    ..registerLazySingleton(() => GetContacts(sl()))
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
    );
}
