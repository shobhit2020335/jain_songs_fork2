String removeWhiteSpaces(String input) {
  return input.replaceAll(' ', '');
}

String removeSpecialChars(String input) {
  return input.replaceAll(RegExp(r"[^\s\w]"), '');
}

String removeSpecificString(String input, String toRemove) {
  return input.replaceAll('$toRemove', '');
}

String trimSpecialChars(String str) {
  str = str.trim();
  if (str.contains('|  |')) {
    str = str.replaceAll('|  |', ' | ').trim();
  }
  if (str[0] == '|') {
    str = str.replaceFirst('|', '').trim();
  }
  if (str.length > 0 && str[str.length - 1] == '|') {
    str = str.substring(0, str.length - 1).trim();
  }
  return str;
}
