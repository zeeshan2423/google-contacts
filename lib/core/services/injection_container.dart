import 'package:google_contacts/core/constants/imports.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerFactory(NavigationCubit.new)
    ..registerFactory(ContactsCubit.new)
    ..registerFactory(CreateContactCubit.new);
}
