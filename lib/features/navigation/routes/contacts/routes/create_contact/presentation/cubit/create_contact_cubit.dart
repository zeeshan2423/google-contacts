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

  final selectedDialCode = '+91';

  Future<void> addNewContact() async {
    emit(const CreateContactInProgress());
    try {
      isSaving.value = true;
      final now = DateTime.now();
      final contact = ContactModel(
        id: const Uuid().v4(),
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        surname: lastNameController.text,
        phoneNumber: '$selectedDialCode ${phoneController.text}',
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
        AddContactParams(contact: contact),
      );
      contactsResult.fold(
        (failure) => emit(CreateContactFailure(failure.message)),
        (contact) => emit(const CreateContactSuccess()),
      );
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
