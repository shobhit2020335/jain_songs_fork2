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
  final String steps;
  //It has audio links in chronological order of listening in a day.
  List<String>? mp3Links = [];
  DateTime? lastModifiedTime;

  PachchhkhanModel({
    required this.id,
    required this.name,
    this.categoryName = '',
    this.additionSecondsInSunrise = 0,
    this.additionSecondsInSunset = 0,
    this.steps = '',
    this.mp3Links,
    this.lastModifiedTime,
  }) {
    mp3Links ??= [];
    lastModifiedTime ??= DateTime.now();
  }
}
