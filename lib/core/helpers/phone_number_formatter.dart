import 'package:google_contacts/core/constants/imports.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    final isValid = RegExp(r'^\+?\d*$').hasMatch(newText);

    if (isValid) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
