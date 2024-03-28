class PachchhkhanModel {
  final String id;
  final String name;
  //If category name is not blank then it will have a dropdown.
  //Timing for all items in a category should be same.
  final String categoryName;
  //Mostly +
  final int additionSecondsInSunrise;
  //Mostly -
  final int additionSecondsInSunset;
  String steps;
  //It has audio links in chronological order of listening in a day.
  List<String>? mp3Links = [];

  //Local varibles, not stored in firebase.
  //This is calculated after the sunrise and sunset data.
  DateTime? dateTimeOfOccurrence;

  ///Sets the date time occurrence as per the given +/-
  void setDateTimeOfOccurrence(
      {required DateTime sunriseDateTime, required DateTime sunsetDateTime}) {
    if (additionSecondsInSunrise != 0) {
      dateTimeOfOccurrence =
          sunriseDateTime.add(Duration(seconds: additionSecondsInSunrise));
    } else if (additionSecondsInSunset != 0) {
      dateTimeOfOccurrence =
          sunsetDateTime.add(Duration(seconds: additionSecondsInSunset));
    }

    if (dateTimeOfOccurrence != null) {
      steps = steps.replaceAll('HH:MM',
          '${dateTimeOfOccurrence!.hour}:${dateTimeOfOccurrence!.minute}');
    }
  }

  PachchhkhanModel({
    required this.id,
    required this.name,
    this.categoryName = '',
    this.additionSecondsInSunrise = 0,
    this.additionSecondsInSunset = 0,
    this.steps = '',
    this.mp3Links,
  }) {
    mp3Links ??= [];
    steps = steps.replaceAll('\\n', '\n');
  }
}
