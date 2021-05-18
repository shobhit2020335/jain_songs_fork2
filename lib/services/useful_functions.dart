String removeWhiteSpaces(String input) {
  return input.replaceAll(' ', '');
}

String removeSpecialChars(String input) {
  return input.replaceAll(RegExp(r"[^\s\w]"), '');
}

String removeSpecificString(String input, String toRemove) {
  return input.replaceAll('$toRemove', '');
}
