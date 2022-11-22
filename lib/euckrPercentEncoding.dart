import 'package:cp949_codec/cp949_codec.dart';

String eucKrEncodeUri(String text) {
  RegExp exceptionPattern = RegExp(r"[A-Za-z0-9\-_\.\!~\*'\(\)]");
  String result = '';
  for (var i = 0; i < text.length; i++) {
    final char = text[i];
    if (!exceptionPattern.hasMatch(char)) {
      final bytes = cp949.encode(char);
      for (final byte in bytes) {
        result += '%${byte.toRadixString(16).toUpperCase()}';
      }
    } else {
      result += char;
    }
  }

  return result;
}

String eucKrDecodeUri(String text) {
  final decoded = Uri.decodeComponent(text);

  return cp949.decodeString(decoded);
}
