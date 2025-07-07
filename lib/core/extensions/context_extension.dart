import 'package:google_contacts/core/constants/imports.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  GoRouterState get goRouterState => GoRouterState.of(this);

  NavigationCubit get navigationCubit => read<NavigationCubit>();

  ContactsCubit get contactsCubit => read<ContactsCubit>();

  CreateContactCubit get createContactCubit => read<CreateContactCubit>();

  ContactDetailCubit get contactDetailCubit => read<ContactDetailCubit>();
}
