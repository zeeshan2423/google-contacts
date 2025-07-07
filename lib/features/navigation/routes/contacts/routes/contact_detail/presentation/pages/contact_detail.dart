import 'package:google_contacts/core/constants/imports.dart';

class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({required this.contact, super.key});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final cubit = context.contactDetailCubit;
    final contactsCubit = context.contactsCubit;
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;
    cubit.isFavorite.value = contact.isFavorite;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ContactDetailCubit, ContactDetailState>(
          listenWhen: (previous, current) =>
              current is ContactDetailInProgress ||
              current is ContactDeleteSuccess ||
              current is ContactDetailFailure ||
              current is ContactDetailSuccess,
          buildWhen: (previous, current) => current is! ContactDetailInProgress,
          listener: (context, state) async {
            if (state is ContactDetailFailure) {
              AppWidgets.customSnackBar(
                context: context,
                text: state.message,
              );
            }
            if (state is ContactDetailSuccess) {
              AppWidgets.customSnackBar(
                context: context,
                text:
                    '''${cubit.isFavorite.value ? 'Saved as' : 'Removed from'} favorite''',
              );
            }
            if (state is ContactDeleteSuccess) {
              AppWidgets.customSnackBar(
                context: context,
                text: '1 Contact deleted',
              );
              await contactsCubit.loadContacts();
              if (context.mounted) context.pop();
            }
          },
          builder: (context, state) => CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 372,
                backgroundColor: colorScheme.surface,
                surfaceTintColor: colorScheme.surface,
                leading: IconButton(
                  onPressed: () async {
                    await contactsCubit.loadContacts();
                    if (context.mounted) context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.goNamed(
                        PAGES.createContact.screenName,
                        extra: {'contact': contact},
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  ValueListenableBuilder(
                    valueListenable: cubit.isFavorite,
                    builder: (context, value, child) => IconButton(
                      onPressed: () async {
                        await cubit.toggleContactFavorite(contact.id);
                      },
                      icon: Icon(value ? Icons.star : Icons.star_outline),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.manage_accounts_outlined),
                  ),
                ],
                titleSpacing: 0,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final top = constraints.biggest.height;
                    final isCollapsed =
                        top <=
                        kToolbarHeight + MediaQuery.of(context).padding.top;
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
                    final organization =
                        [
                              contact.title,
                              contact.department,
                              contact.company,
                            ]
                            .where(
                              (part) => part != null && part.trim().isNotEmpty,
                            )
                            .join(' • ');

                    return FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: isCollapsed
                          ? const EdgeInsetsDirectional.only(
                              start: 60,
                              bottom: 6,
                            )
                          : const EdgeInsets.only(
                              bottom: 36,
                            ),
                      title: Align(
                        alignment: isCollapsed
                            ? Alignment.centerLeft
                            : Alignment.bottomCenter,
                        child: SizedBox(
                          width: isCollapsed
                              ? MediaQuery.of(context).size.width * 0.5
                              : null,
                          child: Text(
                            fullName.isEmpty
                                ? (contact.phoneNumber ?? '').isNotEmpty
                                      ? (contact.phoneNumber ?? '')
                                      : '(No name)'
                                : fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 72),
                          CircleAvatar(
                            radius: 90,
                            backgroundColor: getAvatarColor(
                              fullName,
                              context,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: fullName.isEmpty
                                  ? Icon(
                                      Icons.person,
                                      size: 84,
                                      color: colorScheme.surface,
                                    )
                                  : FittedBox(
                                      child: Text(
                                        getInitials(fullName),
                                        style: textTheme.displayLarge?.copyWith(
                                          fontSize: 84,
                                          color: colorScheme.surface,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 96),
                          if (organization.isNotEmpty)
                            Text(
                              organization,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium,
                            ),
                        ],
                      ),
                      collapseMode: CollapseMode.pin,
                    );
                  },
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedActionsHeader(
                  child: Container(
                    color: colorScheme.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton.filledTonal(
                              onPressed: (contact.phoneNumber ?? '').isNotEmpty
                                  ? () async {
                                      await FlutterPhoneDirectCaller.callNumber(
                                        contact.phoneNumber ?? '',
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.phone_outlined),
                            ),
                            Text(
                              'Call',
                              style: textTheme.labelLarge,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const IconButton.filledTonal(
                              onPressed: null,
                              icon: Icon(Icons.chat_bubble_outline),
                            ),
                            Text(
                              'Message',
                              style: textTheme.labelLarge,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const IconButton.filledTonal(
                              onPressed: null,
                              icon: Icon(Icons.videocam_outlined),
                            ),
                            Text(
                              'Video',
                              style: textTheme.labelLarge,
                            ),
                          ],
                        ),
                        if ((contact.email ?? '').isNotEmpty)
                          Column(
                            children: [
                              const IconButton.filledTonal(
                                onPressed: null,
                                icon: Icon(Icons.email_outlined),
                              ),
                              Text(
                                'Email',
                                style: textTheme.labelLarge,
                              ),
                            ],
                          ),
                        if ((contact.address ?? '').isNotEmpty)
                          Column(
                            children: [
                              const IconButton.filledTonal(
                                onPressed: null,
                                icon: Icon(Icons.directions_outlined),
                              ),
                              Text(
                                'Directions',
                                style: textTheme.labelLarge,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card.filled(
                        color: colorScheme.surfaceBright,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Contact info',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if ((contact.phoneNumber ?? '').isNotEmpty)
                                ListTile(
                                  dense: true,
                                  onTap: () async {
                                    await FlutterPhoneDirectCaller.callNumber(
                                      contact.phoneNumber ?? '',
                                    );
                                  },
                                  title: Text(contact.phoneNumber ?? ''),
                                  leading: const Icon(Icons.phone_outlined),
                                  subtitle: const Text('Phone'),
                                )
                              else
                                ListTile(
                                  dense: true,
                                  onTap: () {
                                    context.goNamed(
                                      PAGES.createContact.screenName,
                                      extra: {'contact': contact},
                                    );
                                  },
                                  title: Text(
                                    'Add phone number',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.phone_outlined,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              if ((contact.email ?? '').isNotEmpty)
                                ListTile(
                                  dense: true,
                                  onTap: () {},
                                  title: Text(contact.email ?? ''),
                                  leading: const Icon(Icons.email_outlined),
                                  subtitle: const Text('Email'),
                                )
                              else
                                ListTile(
                                  dense: true,
                                  onTap: () {
                                    context.goNamed(
                                      PAGES.createContact.screenName,
                                      extra: {'contact': contact},
                                    );
                                  },
                                  title: Text(
                                    'Add email',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.email_outlined,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              if ((contact.address ?? '').isNotEmpty)
                                ListTile(
                                  dense: true,
                                  onTap: () {},
                                  title: Text(
                                    contact.address ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                  ),
                                  subtitle: const Text('Address'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if ((contact.birthday ?? '').isNotEmpty ||
                        (contact.notes ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card.filled(
                          color: colorScheme.surfaceContainer,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'About ${contact.firstName}',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if ((contact.birthday ?? '').trim().isNotEmpty)
                                  Builder(
                                    builder: (context) {
                                      final birthdayStr = contact.birthday!
                                          .trim();
                                      DateTime? parsedDate;
                                      var displayFormat = 'MMMM d';

                                      final formatsToTry = [
                                        'M/d/yy',
                                        'MMMM d',
                                        'MMMM d, yyyy',
                                      ];

                                      for (final format in formatsToTry) {
                                        try {
                                          parsedDate = DateFormat(
                                            format,
                                          ).parseStrict(birthdayStr);
                                          if (format.contains('y')) {
                                            displayFormat = 'MMMM d, yyyy';
                                          }
                                          break;
                                        } on Exception catch (_) {}
                                      }

                                      if (parsedDate == null) {
                                        return const SizedBox.shrink();
                                      }

                                      return ListTile(
                                        dense: true,
                                        onTap: () {},
                                        leading: const Icon(
                                          Icons.cake_outlined,
                                        ),
                                        title: Text(
                                          DateFormat(
                                            displayFormat,
                                          ).format(parsedDate),
                                        ),
                                        subtitle: const Text('Birthday'),
                                      );
                                    },
                                  ),

                                if ((contact.notes ?? '').isNotEmpty)
                                  ListTile(
                                    dense: true,
                                    onTap: () {},
                                    title: Text(contact.notes ?? ''),
                                    leading: const Icon(Icons.note_outlined),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const Divider(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Contact settings',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () {
                            showDialog<AlertDialog>(
                              context: context,
                              builder: (context) {
                                return _buildAlertDialog(
                                  textTheme,
                                  context,
                                  contact,
                                  cubit,
                                );
                              },
                            );
                          },
                          title: Text(
                            'Delete',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                          leading: Icon(
                            Icons.delete_outline,
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card.filled(
                        color: colorScheme.onPrimary,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            spacing: 6,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Contact info from',
                                style: textTheme.bodyLarge,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.surfaceContainerHighest,
                                ),
                                child: const Icon(
                                  Icons.phone_android_outlined,
                                  size: 12,
                                ),
                              ),
                              Text(
                                'Device',
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '''Added ${DateFormat('MMM d, yyyy').format(contact.createdAt ?? DateTime(0))} (Device)''',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 96),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog _buildAlertDialog(
    TextTheme textTheme,
    BuildContext context,
    Contact contact,
    ContactDetailCubit cubit,
  ) {
    return AlertDialog(
      title: const Text('Delete contact?'),
      actionsPadding: const EdgeInsets.only(
        bottom: 12,
        right: 12,
      ),
      content: Text(
        'This contact will be permanently deleted from your device',
        style: textTheme.labelMedium,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await cubit.removeContact(contact.id);
            if (context.mounted) context.pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class _PinnedActionsHeader extends SliverPersistentHeaderDelegate {
  _PinnedActionsHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 100;

  @override
  double get maxExtent => 100;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: Material(
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedActionsHeader oldDelegate) => false;
}
