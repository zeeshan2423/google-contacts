import 'package:google_contacts/core/constants/imports.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  final selectedIndex = ValueNotifier<int>(0);

  Future<void> onDestinationSelected({
    required int value,
    required BuildContext context,
  }) async {
    selectedIndex.value = value;
    switch (value) {
      case 0:
        context.goNamed(PAGES.contacts.screenName);
      case 1:
        context.goNamed(PAGES.favorites.screenName);
    }
  }
}
