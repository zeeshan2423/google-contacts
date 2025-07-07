import 'package:google_contacts/core/constants/imports.dart';

part 'create_contact_state.dart';

class CreateContactCubit extends Cubit<CreateContactState> {
  CreateContactCubit({
    required AddContact addContact,
    required UpdateContact updateContact,
  }) : _addContact = addContact,
       _updateContact = updateContact,
       super(const CreateContactInitial()) {
    phoneNode.requestFocus();
  }

  final AddContact _addContact;
  final UpdateContact _updateContact;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final notesController = TextEditingController();
  final middleNameController = TextEditingController();
  final addressController = TextEditingController();
  final jobTitleController = TextEditingController();
  final departmentController = TextEditingController();

  final phoneNode = FocusNode();
  final middleNameNode = FocusNode();
  final addressNode = FocusNode();
  final jobTitleNode = FocusNode();
  final departmentNode = FocusNode();
  final emailNode = FocusNode();
  final birthdayNode = FocusNode();

  final isEmailVisible = ValueNotifier<bool>(false);
  final isBirthdayVisible = ValueNotifier<bool>(false);
  final isMiddleNameVisible = ValueNotifier<bool>(false);
  final isAddressVisible = ValueNotifier<bool>(false);
  final isJobTitleVisible = ValueNotifier<bool>(false);
  final isDepartmentVisible = ValueNotifier<bool>(false);
  final isAddTitleVisible = ValueNotifier<bool>(true);
  final isSaving = ValueNotifier<bool>(false);

  String? selectedDialCode;
  Contact? contact;

  Future<void> addNewContact() async {
    emit(const CreateContactInProgress());
    try {
      isSaving.value = true;
      final now = DateTime.now();
      final contactModel = ContactModel(
        id: const Uuid().v4(),
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        surname: lastNameController.text,
        phoneNumber: phoneController.text.isNotEmpty
            ? '${selectedDialCode ?? '+91'} ${phoneController.text}'
            : null,
        email: emailController.text,
        birthday: birthdayController.text,
        address: addressController.text,
        company: companyController.text,
        title: jobTitleController.text,
        department: departmentController.text,
        notes: notesController.text,
        createdAt: now,
        updatedAt: now,
      );
      final contactsResult = await _addContact(
        AddContactParams(contact: contactModel),
      );
      contactsResult.fold(
        (failure) => emit(CreateContactFailure(failure.message)),
        (contact) => emit(const CreateContactSuccess()),
      );
      contact = contactModel;
    } on Exception catch (e) {
      emit(CreateContactFailure(e.toString()));
    } finally {
      isSaving.value = false;
    }
  }

  void populateFieldsFromContact(Contact contact) {
    this.contact = contact;

    firstNameController.text = contact.firstName ?? '';
    middleNameController.text = contact.middleName ?? '';
    lastNameController.text = contact.surname ?? '';
    companyController.text = contact.company ?? '';
    if (contact.phoneNumber != null && contact.phoneNumber!.trim().isNotEmpty) {
      final parts = contact.phoneNumber!.trim().split(' ');
      if (parts.length >= 2) {
        selectedDialCode = parts.first;
        phoneController.text = parts.sublist(1).join(' ').trim();
      } else {
        phoneController.text = contact.phoneNumber!;
      }
    }
    emailController.text = contact.email ?? '';
    birthdayController.text = contact.birthday ?? '';
    notesController.text = contact.notes ?? '';
    addressController.text = contact.address ?? '';
    jobTitleController.text = contact.title ?? '';
    departmentController.text = contact.department ?? '';

    isMiddleNameVisible.value = contact.middleName?.isNotEmpty ?? false;
    isAddressVisible.value = contact.address?.isNotEmpty ?? false;
    isJobTitleVisible.value = contact.title?.isNotEmpty ?? false;
    isDepartmentVisible.value = contact.department?.isNotEmpty ?? false;
    isEmailVisible.value = contact.email?.isNotEmpty ?? false;
    isBirthdayVisible.value = contact.birthday?.isNotEmpty ?? false;

    isAddTitleVisible.value =
        !(isMiddleNameVisible.value &&
            isJobTitleVisible.value &&
            isDepartmentVisible.value &&
            isAddressVisible.value);
  }

  Future<void> editContact(Contact contact) async {
    emit(const CreateContactInProgress());
    try {
      isSaving.value = true;
      final now = DateTime.now();
      final contactModel = ContactModel(
        id: contact.id,
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        surname: lastNameController.text,
        phoneNumber: phoneController.text.isNotEmpty
            ? '${selectedDialCode ?? '+91'} ${phoneController.text}'
            : null,
        email: emailController.text,
        birthday: birthdayController.text,
        address: addressController.text,
        company: companyController.text,
        title: jobTitleController.text,
        department: departmentController.text,
        notes: notesController.text,
        createdAt: contact.createdAt,
        updatedAt: now,
      );
      final contactsResult = await _updateContact(
        UpdateContactParams(contact: contactModel),
      );
      contactsResult.fold(
        (failure) => emit(CreateContactFailure(failure.message)),
        (contact) => emit(const CreateContactSuccess()),
      );
      this.contact = contactModel;
    } on Exception catch (e) {
      emit(CreateContactFailure(e.toString()));
    } finally {
      isSaving.value = false;
    }
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    notesController.dispose();
    middleNameController.dispose();
    addressController.dispose();
    jobTitleController.dispose();
    departmentController.dispose();
    return super.close();
  }
}
