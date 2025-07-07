import 'package:google_contacts/core/constants/imports.dart';

class CreateContactPage extends StatelessWidget {
  const CreateContactPage({this.contact, super.key});

  final Contact? contact;

  @override
  Widget build(BuildContext context) {
    final cubit = context.createContactCubit;
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;
    if (contact != null) {
      cubit.populateFieldsFromContact(contact!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(contact == null ? 'Create contact' : 'Edit Contact'),
        leading: IconButton(
          onPressed: () {
            if (contact == null) {
              context.pop();
            } else {
              context.goNamed(
                PAGES.contactDetail.screenName,
                extra: {'contact': contact},
              );
            }
          },
          icon: const Icon(Icons.clear),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
            child: ValueListenableBuilder(
              valueListenable: cubit.isSaving,
              builder: (context, value, child) => FilledButton(
                onPressed: value
                    ? null
                    : () async {
                        if (cubit.firstNameController.text.isEmpty &&
                            cubit.lastNameController.text.isEmpty &&
                            cubit.companyController.text.isEmpty &&
                            cubit.phoneController.text.isEmpty &&
                            cubit.emailController.text.isEmpty &&
                            cubit.birthdayController.text.isEmpty &&
                            cubit.notesController.text.isEmpty &&
                            cubit.middleNameController.text.isEmpty &&
                            cubit.addressController.text.isEmpty &&
                            cubit.jobTitleController.text.isEmpty &&
                            cubit.departmentController.text.isEmpty) {
                          if (contact == null) {
                            context.pop();
                          } else {
                            await showDialog<AlertDialog>(
                              context: context,
                              builder: (context) => AlertDialog(
                                contentPadding: const EdgeInsets.all(24),
                                actionsPadding: const EdgeInsets.only(
                                  bottom: 12,
                                  right: 12,
                                ),
                                content: Text(
                                  'Add info to save as a contact.',
                                  style: textTheme.labelLarge,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          if (contact == null) {
                            await cubit.addNewContact();
                          } else {
                            await cubit.editContact(contact!);
                          }
                        }
                      },
                child: Text(
                  'Save',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: BlocConsumer<CreateContactCubit, CreateContactState>(
              listenWhen: (previous, current) =>
                  current is CreateContactInProgress ||
                  current is CreateContactFailure ||
                  current is CreateContactSuccess ||
                  current is EditContactSuccess,
              buildWhen: (previous, current) =>
                  current is! CreateContactInProgress,
              listener: (context, state) {
                if (state is CreateContactFailure) {
                  AppWidgets.customSnackBar(
                    context: context,
                    text: state.message,
                  );
                }
                if (state is CreateContactSuccess ||
                    state is EditContactSuccess) {
                  final fullName =
                      [
                            cubit.firstNameController.text,
                            cubit.middleNameController.text,
                            cubit.lastNameController.text,
                          ]
                          .where(
                            (part) => part.trim().isNotEmpty,
                          )
                          .join(' ');
                  context.goNamed(
                    PAGES.contactDetail.screenName,
                    extra: {'contact': cubit.contact},
                  );
                  AppWidgets.customSnackBar(
                    context: context,
                    text: '${fullName.isEmpty ? 'Contact' : fullName} saved',
                  );
                }
              },
              builder: (context, state) => Form(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42),
                          child: AppWidgets.customTextFormField(
                            context: context,
                            type: FIELDS.firstName,
                            controller: cubit.firstNameController,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder(
                          valueListenable: cubit.isMiddleNameVisible,
                          builder: (context, value, child) => Visibility(
                            visible: value,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 42,
                                bottom: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppWidgets.customTextFormField(
                                      context: context,
                                      type: FIELDS.middleName,
                                      controller: cubit.middleNameController,
                                      focusNode: cubit.middleNameNode,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 42,
                                    child: IconButton(
                                      onPressed: () {
                                        cubit.isMiddleNameVisible.value = false;
                                        cubit.isAddTitleVisible.value = true;
                                        cubit.middleNameController.clear();
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: colorScheme.error,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42),
                          child: AppWidgets.customTextFormField(
                            context: context,
                            type: FIELDS.lastName,
                            controller: cubit.lastNameController,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 42),
                            child: AppWidgets.customTextFormField(
                              context: context,
                              type: FIELDS.company,
                              controller: cubit.companyController,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: cubit.isDepartmentVisible,
                            builder: (context, value, child) => Visibility(
                              visible: value,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 42,
                                  top: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppWidgets.customTextFormField(
                                        context: context,
                                        type: FIELDS.department,
                                        controller: cubit.departmentController,
                                        focusNode: cubit.departmentNode,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 42,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.isDepartmentVisible.value =
                                              false;
                                          cubit.isAddTitleVisible.value = true;
                                          cubit.departmentController.clear();
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: colorScheme.error,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: cubit.isJobTitleVisible,
                            builder: (context, value, child) => Visibility(
                              visible: value,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 42,
                                  top: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppWidgets.customTextFormField(
                                        context: context,
                                        type: FIELDS.jobTitle,
                                        controller: cubit.jobTitleController,
                                        focusNode: cubit.jobTitleNode,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 42,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.isJobTitleVisible.value = false;
                                          cubit.isAddTitleVisible.value = true;
                                          cubit.jobTitleController.clear();
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: colorScheme.error,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: AppWidgets.customTextFormField(
                        context: context,
                        type: FIELDS.phone,
                        controller: cubit.phoneController,
                        focusNode: cubit.phoneNode,
                        selectedDialCode: cubit.selectedDialCode,
                        onChanged: (e) {
                          cubit.selectedDialCode = e.dialCode;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 24),
                      child: Column(
                        spacing: 8,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: cubit.isEmailVisible,
                            builder: (context, value, child) => Padding(
                              padding: EdgeInsets.only(
                                left: 42,
                                right: value ? 0 : 42,
                                top: value ? 12 : 24,
                              ),
                              child: Visibility(
                                visible: value,
                                replacement: Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton.tonalIcon(
                                        onPressed: () {
                                          cubit.isEmailVisible.value = true;
                                          cubit.emailNode.requestFocus();
                                        },
                                        icon: Icon(
                                          Icons.email_outlined,
                                          size: 20,
                                          color:
                                              colorScheme.onSecondaryContainer,
                                        ),
                                        label: Text(
                                          'Add email',
                                          style: textTheme.labelLarge?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppWidgets.customTextFormField(
                                        context: context,
                                        type: FIELDS.email,
                                        controller: cubit.emailController,
                                        focusNode: cubit.emailNode,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 42,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.isEmailVisible.value = false;
                                          cubit.emailController.clear();
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: colorScheme.error,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: cubit.isBirthdayVisible,
                            builder: (context, value, child) => Padding(
                              padding: EdgeInsets.only(
                                left: 42,
                                right: value ? 0 : 42,
                                top: value ? 12 : 0,
                              ),
                              child: Visibility(
                                visible: value,
                                replacement: Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton.tonalIcon(
                                        onPressed: () async {
                                          cubit.isBirthdayVisible.value = true;
                                          cubit.birthdayNode.requestFocus();
                                          await AppWidgets.showCustomDatePickerDialog(
                                            context: context,
                                            controller:
                                                cubit.birthdayController,
                                          );
                                          if (context.mounted) {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.cake_outlined,
                                          size: 20,
                                          color:
                                              colorScheme.onSecondaryContainer,
                                        ),
                                        label: Text(
                                          'Add birthday',
                                          style: textTheme.labelLarge?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppWidgets.customTextFormField(
                                        context: context,
                                        type: FIELDS.birthday,
                                        controller: cubit.birthdayController,
                                        focusNode: cubit.birthdayNode,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 42,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.isBirthdayVisible.value = false;
                                          cubit.birthdayController.clear();
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: colorScheme.error,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: cubit.isAddressVisible,
                            builder: (context, value, child) => Visibility(
                              visible: value,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 42,
                                  bottom: 8,
                                  top: value ? 12 : 0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppWidgets.customTextFormField(
                                        context: context,
                                        type: FIELDS.address,
                                        controller: cubit.addressController,
                                        focusNode: cubit.addressNode,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 42,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.isAddressVisible.value = false;
                                          cubit.isAddTitleVisible.value = true;
                                          cubit.addressController.clear();
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: colorScheme.error,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: AppWidgets.customTextFormField(
                        context: context,
                        type: FIELDS.notes,
                        controller: cubit.notesController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 42,
                        vertical: 12,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: cubit.isAddTitleVisible,
                        builder: (context, value, child) => Visibility(
                          visible: value,
                          child: Row(
                            children: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: colorScheme.outlineVariant,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet<Widget>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    sheetAnimationStyle: const AnimationStyle(
                                      curve: Curves.easeIn,
                                    ),
                                    useSafeArea: true,
                                    builder: (context) {
                                      return _AddFieldsBottomSheet(cubit);
                                    },
                                  );
                                },
                                child: Text(
                                  'Add fields',
                                  style: textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddFieldsBottomSheet extends StatelessWidget {
  const _AddFieldsBottomSheet(this.cubit);

  final CreateContactCubit cubit;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final colorScheme = context.theme.colorScheme;

    final fieldMap = {
      'Middle name': cubit.isMiddleNameVisible,
      'Address': cubit.isAddressVisible,
      'Job title': cubit.isJobTitleVisible,
      'Department': cubit.isDepartmentVisible,
    };

    final availableFields = fieldMap.entries
        .where((entry) => entry.value.value == false)
        .map((entry) => entry.key)
        .toList();

    var childSize = (availableFields.length * 0.12) + 0.25;
    childSize = childSize.clamp(0.25, 0.6);

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: childSize,
        minChildSize: childSize,
        maxChildSize: childSize,
        builder: (context, controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Choose fields to add',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: availableFields.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                  isThreeLine: false,
                  dense: true,
                  title: Text(
                    availableFields[index],
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    switch (availableFields[index]) {
                      case 'Middle name':
                        cubit.isMiddleNameVisible.value = true;
                        cubit.middleNameNode.requestFocus();
                      case 'Address':
                        cubit.isAddressVisible.value = true;
                        cubit.addressNode.requestFocus();
                      case 'Job title':
                        cubit.isJobTitleVisible.value = true;
                        cubit.jobTitleNode.requestFocus();
                      case 'Department':
                        cubit.isDepartmentVisible.value = true;
                        cubit.departmentNode.requestFocus();
                    }
                    if (cubit.isMiddleNameVisible.value &&
                        cubit.isAddressVisible.value &&
                        cubit.isJobTitleVisible.value &&
                        cubit.isDepartmentVisible.value) {
                      cubit.isAddTitleVisible.value = false;
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
