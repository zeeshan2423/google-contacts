import 'package:google_contacts/core/constants/imports.dart';

class ContactsSearchDelegate extends SearchDelegate<String> {
  ContactsSearchDelegate({
    required this.cubit,
    required this.navigationCubit,
    super.searchFieldLabel = 'Search contacts',
  });

  final ContactsCubit cubit;
  final NavigationCubit navigationCubit;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.zero,
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHigh,
        border: InputBorder.none,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colorScheme.surfaceContainerHigh,
        titleSpacing: 0,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(Icons.arrow_back, color: colorScheme.onSurfaceVariant),
      onPressed: () {
        query = '';
        cubit.loadContacts();
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;
    final highlightStyle = textTheme.bodyLarge?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final normalStyle = textTheme.bodyLarge;

    cubit.searchForContacts(query);

    return BlocBuilder<ContactsCubit, ContactsState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is ContactsSearchInProgress || state is ContactsInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ContactsSearchSuccess) {
          if (state.contacts.isEmpty) {
            return const Center(child: Text('No contacts found.'));
          }

          return ColoredBox(
            color: colorScheme.surfaceContainerHigh,
            child: ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                final fullName =
                    [
                          contact.firstName,
                          contact.middleName,
                          contact.surname,
                        ]
                        .where(
                          (part) => part != null && part.trim().isNotEmpty,
                        )
                        .join(' ');

                return ListTile(
                  title: RichText(
                    text: highlightQuery(
                      fullName.isNotEmpty
                          ? fullName
                          : (contact.phoneNumber ?? ''),
                      query,
                      normalStyle!,
                      highlightStyle!,
                    ),
                  ),
                  subtitle:
                      fullName.isNotEmpty &&
                          (contact.phoneNumber?.isNotEmpty ?? false)
                      ? RichText(
                          text: highlightQuery(
                            contact.phoneNumber!,
                            query,
                            textTheme.bodyMedium!,
                            highlightStyle,
                          ),
                        )
                      : null,
                  leading: CircleAvatar(
                    backgroundColor: getAvatarColor(
                      fullName,
                      context,
                    ),
                    child: fullName.isEmpty
                        ? Icon(
                            Icons.person,
                            color: colorScheme.surface,
                          )
                        : FittedBox(
                            child: Text(
                              getInitials(fullName),
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.surface,
                              ),
                            ),
                          ),
                  ),
                  onTap: () {
                    query = '';
                    cubit.loadContacts();
                    close(context, '');
                    context.pushNamed(
                      PAGES.contactDetail.screenName,
                      extra: {'contact': contact},
                    );
                  },
                );
              },
            ),
          );
        }

        if (state is ContactsFailure) {
          return Center(child: Text(state.message));
        }

        return Container(
          color: colorScheme.surfaceContainerHigh,
        );
      },
    );
  }
}
