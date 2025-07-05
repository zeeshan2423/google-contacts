import 'package:google_contacts/core/constants/imports.dart';

class FirstLetterUppercaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.isEmpty
          ? ''
          : newValue.text
                .split(' ')
                .map((word) {
                  if (word.isNotEmpty) {
                    return word[0].toUpperCase() + word.substring(1);
                  } else {
                    return '';
                  }
                })
                .join(' '),
      selection: newValue.selection,
    );
  }
}
