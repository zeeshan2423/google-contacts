import 'package:google_contacts/core/constants/imports.dart';

TextSpan highlightQuery(
  String text,
  String query,
  TextStyle normalStyle,
  TextStyle highlightStyle,
) {
  if (query.isEmpty) {
    return TextSpan(text: text, style: normalStyle);
  }

  final matches = RegExp(
    RegExp.escape(query),
    caseSensitive: false,
  ).allMatches(text);

  if (matches.isEmpty) {
    return TextSpan(text: text, style: normalStyle);
  }

  final spans = <TextSpan>[];
  var lastMatchEnd = 0;

  for (final match in matches) {
    if (match.start > lastMatchEnd) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: normalStyle,
        ),
      );
    }

    spans.add(TextSpan(text: match.group(0), style: highlightStyle));
    lastMatchEnd = match.end;
  }

  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(text: text.substring(lastMatchEnd), style: normalStyle));
  }

  return TextSpan(children: spans);
}
