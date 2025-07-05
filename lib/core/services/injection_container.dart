import 'package:google_contacts/core/constants/imports.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(ContactsCubit.new);
}
