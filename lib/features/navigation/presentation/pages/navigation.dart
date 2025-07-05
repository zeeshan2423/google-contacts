import 'package:google_contacts/core/constants/imports.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = context.navigationCubit;
    final textTheme = context.theme.textTheme;

    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: cubit.selectedIndex,
        builder: (context, value, child) => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          ),
          child: NavigationBar(
            selectedIndex: value,
            onDestinationSelected: (value) {
              cubit.onDestinationSelected(value: value, context: context);
            },
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outlined),
                label: 'Contacts',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.star),
                icon: Icon(Icons.star_border_outlined),
                label: 'Favorites',
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }
}
