import 'package:audioplayers/audioplayers.dart';
import 'package:jain_songs/services/useful_functions.dart';

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
  AudioPlayer? audioPlayer;
  Duration lastPlayedPosition = Duration.zero;

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
      steps = steps.replaceAll(
          'HH:MM',
          UsefulFunction.getFormattedTime(
              dateTimeOfOccurrence!.hour, dateTimeOfOccurrence!.minute));
    }
  }

  ///Initializes the audio players for each of the Audios.
  void initAudioPlayer() async {
    lastPlayedPosition = Duration.zero;
    if (mp3Links != null && mp3Links!.isNotEmpty) {
      audioPlayer = AudioPlayer();
      audioPlayer!.setSourceUrl(mp3Links![0]);


    }
  }

  ///Disposes the audio player.
  void disposeAudioPlayer() async {
    if (audioPlayer != null) {
      audioPlayer?.dispose();
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
