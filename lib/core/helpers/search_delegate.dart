import 'package:google_contacts/core/constants/imports.dart';

class ContactsSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search contacts';

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
      textTheme: theme.textTheme.copyWith(
        titleMedium: theme.textTheme.titleMedium,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colorScheme.surfaceContainerHigh,
        titleSpacing: 0,
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
      Padding(
        padding: const EdgeInsets.only(right: 4),
        child: IconButton(
          icon: Icon(
            Icons.mic_none_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {},
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(Icons.arrow_back, color: colorScheme.onSurfaceVariant),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border(
          top: BorderSide(color: colorScheme.outline),
        ),
      ),
    );
  }
}
