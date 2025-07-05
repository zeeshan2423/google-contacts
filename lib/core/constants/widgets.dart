import 'package:google_contacts/core/constants/imports.dart';

class AppWidgets {
  AppWidgets._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  customSnackBar({
    required BuildContext context,
    required String text,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        showCloseIcon: true,
        actionOverflowThreshold: 1,
        duration: duration,
      ),
    );
  }
}
