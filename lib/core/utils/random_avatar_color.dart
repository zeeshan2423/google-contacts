import 'package:google_contacts/core/constants/imports.dart';

Color getAvatarColor(String name, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final colors = isDark
      ? [
          const Color(0xFFFFF59D),
          const Color(0xFFFFAB91),
          const Color(0xFF80DEEA),
          const Color(0xFFA5D6A7),
          const Color(0xFF90CAF9),
          const Color(0xFFCE93D8),
          const Color(0xFFEF9A9A),
          const Color(0xFFFFCC80),
          const Color(0xFFE6EE9C),
          const Color(0xFFB39DDB),
        ]
      : [
          const Color(0xFFD32F2F),
          const Color(0xFF388E3C),
          const Color(0xFF1976D2),
          const Color(0xFF00796B),
          const Color(0xFF512DA8),
          const Color(0xFFF57C00),
          const Color(0xFF303F9F),
          const Color(0xFF455A64),
          const Color(0xFF7B1FA2),
          const Color(0xFF0288D1),
        ];

  final index = name.hashCode % colors.length;
  return colors[index];
}
