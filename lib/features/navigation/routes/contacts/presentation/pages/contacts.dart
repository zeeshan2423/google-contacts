import 'package:google_contacts/core/constants/imports.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;

    Map<String, List<Contact>> groupContacts(List<Contact> contacts) {
      final grouped = <String, List<Contact>>{};

      for (final contact in contacts) {
        final name =
            '''${contact.firstName ?? ''}${contact.middleName ?? ''}${contact.surname ?? ''}'''
                .trim();
        final firstChar = name.isEmpty
            ? '#'
            : RegExp('^[A-Za-z]').hasMatch(name[0])
            ? name[0].toUpperCase()
            : '#';

        grouped.putIfAbsent(firstChar, () => []).add(contact);
      }

      final sortedKeys = grouped.keys.toList()
        ..sort((a, b) {
          if (a == '#') return -1;
          if (b == '#') return 1;
          return a.compareTo(b);
        });

      return {
        for (final key in sortedKeys) key: grouped[key]!,
      };
    }

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<ContactsCubit, ContactsState>(
                listenWhen: (previous, current) =>
                    current is ContactsInProgress,
                buildWhen: (previous, current) =>
                    current is! ContactsInProgress,
                listener: (context, state) {
                  if (state is ContactsFailure) {
                    AppWidgets.customSnackBar(
                      context: context,
                      text: state.message,
                    );
                  }
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case ContactsInProgress:
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case ContactsSuccess:
                      final contacts = (state! as ContactsSuccess).contacts;
                      if (contacts.isEmpty) {
                        return _buildNoContacts(textTheme, colorScheme);
                      } else {
                        return Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: _SliverSearchBarDelegate(
                                  colorScheme,
                                  textTheme,
                                ),
                              ),
                              ...groupContacts(contacts).entries
                                  .map(
                                    (entry) => [
                                      SliverPersistentHeader(
                                        delegate: _SliverHeaderDelegate(
                                          entry.key,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final contact = entry.value[index];
                                            final fullName =
                                                [
                                                      contact.firstName,
                                                      contact.middleName,
                                                      contact.surname,
                                                    ]
                                                    .where(
                                                      (part) =>
                                                          part != null &&
                                                          part
                                                              .trim()
                                                              .isNotEmpty,
                                                    )
                                                    .join(' ');

                                            return ListTile(
                                              onTap: () {
                                                context.goNamed(
                                                  PAGES
                                                      .contactDetail
                                                      .screenName,
                                                  extra: {
                                                    'contact': contact,
                                                  },
                                                );
                                              },
                                              leading: CircleAvatar(
                                                backgroundColor: getAvatarColor(
                                                  fullName,
                                                  context,
                                                ),
                                                child: fullName.isEmpty
                                                    ? Icon(
                                                        Icons.person,
                                                        color:
                                                            colorScheme.surface,
                                                      )
                                                    : FittedBox(
                                                        child: Text(
                                                          getInitials(fullName),
                                                          style: textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color:
                                                                    colorScheme
                                                                        .surface,
                                                              ),
                                                        ),
                                                      ),
                                              ),
                                              title: Text(
                                                fullName.isEmpty
                                                    ? (contact.phoneNumber ??
                                                                  '')
                                                              .isNotEmpty
                                                          ? contact.phoneNumber ??
                                                                ''
                                                          : '(No name)'
                                                    : fullName,
                                              ),
                                              titleTextStyle: textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                              subtitle:
                                                  (fullName.isNotEmpty &&
                                                      (contact
                                                              .phoneNumber
                                                              ?.isNotEmpty ??
                                                          false))
                                                  ? Text(contact.phoneNumber!)
                                                  : null,
                                            );
                                          },
                                          childCount: entry.value.length,
                                        ),
                                      ),
                                    ],
                                  )
                                  .expand((e) => e),
                            ],
                          ),
                        );
                      }
                    default:
                      return _buildNoContacts(textTheme, colorScheme);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildNoContacts(TextTheme textTheme, ColorScheme colorScheme) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverSearchBarDelegate(
              colorScheme,
              textTheme,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(height: 36),
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
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate(this.label, this.colorScheme, this.textTheme);

  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: Text(
        label,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) => false;
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverSearchBarDelegate(this.colorScheme, this.textTheme);

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
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
              Icon(Icons.search, color: colorScheme.onSurfaceVariant),
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
    );
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant _SliverSearchBarDelegate oldDelegate) => false;
}
