import 'package:cloud_firestore/cloud_firestore.dart';

class SongSuggestions {
  String aaa;
  String name;
  String email;
  String songName;
  String lyrics;
  String otherDetails;
  Timestamp submissionTime;
  Map<String, dynamic> songSuggestionMap = Map<String, String>();

  SongSuggestions(
      this.name, this.email, this.songName, this.lyrics, this.otherDetails,
      {this.submissionTime}) {
    this.aaa = "incomplete";
    this.submissionTime = Timestamp.now();
    songSuggestionMap = {
      'aaa': this.aaa,
      'email': this.email,
      'lyrics': this.lyrics,
      'name': this.name,
      'otherDetails': this.otherDetails,
      'songName': this.songName,
      'submissionTime': this.submissionTime,
    };
  }

  void setSubmissionTime(Timestamp time) {
    this.submissionTime = time;
    this.songSuggestionMap['submissionTime'] = time;
  }
}
