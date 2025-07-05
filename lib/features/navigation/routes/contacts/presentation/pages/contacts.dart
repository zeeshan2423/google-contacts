import 'package:google_contacts/core/constants/imports.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(PAGES.createContact.screenName);
        },
        child: Icon(Icons.add, color: colorScheme.primary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await showSearch(
                    context: context,
                    delegate: ContactsSearchDelegate(),
                  );
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.only(left: 19, right: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search contacts',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.account_circle_outlined,
                        color: colorScheme.primary,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 36,
                  children: [
                    Lottie.asset(
                      AppTheme.isDarkMode.value
                          ? AppAssets.vaseNight
                          : AppAssets.vase,
                      repeat: false,
                      frameRate: const FrameRate(60),
                      animate: true,
                      height: 156,
                    ),
                    Text(
                      'No contacts yet',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
