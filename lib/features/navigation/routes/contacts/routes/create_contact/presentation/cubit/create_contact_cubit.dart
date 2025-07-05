import 'package:google_contacts/core/constants/imports.dart';

part 'create_contact_state.dart';

class CreateContactCubit extends Cubit<CreateContactState> {
  CreateContactCubit() : super(CreateContactInitial());

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
