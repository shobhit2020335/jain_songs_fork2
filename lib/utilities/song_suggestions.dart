import 'package:cloud_firestore/cloud_firestore.dart';

class SongSuggestions {
  String fcmToken;
  String oneSignalPlayerId;
  String name;
  String email;
  String songName;
  String lyrics;
  String otherDetails;
  Timestamp submissionTime;
  Map<String, dynamic> songSuggestionMap = Map<String, String>();

  SongSuggestions(
      this.name, this.email, this.songName, this.lyrics, this.otherDetails,
      {this.submissionTime,
      this.fcmToken: 'NA',
      this.oneSignalPlayerId: 'NA'}) {
    this.submissionTime = Timestamp.now();
    songSuggestionMap = {
      'oneSignalPlayerId': this.oneSignalPlayerId,
      'fcmToken': this.fcmToken,
      'email': this.email,
      'lyrics': this.lyrics,
      'name': this.name,
      'otherDetails': this.otherDetails,
      'songName': this.songName,
      'submissionTime': this.submissionTime,
    };
  }

  void setFCMToken(String fcmToken) {
    this.fcmToken = fcmToken;
    this.songSuggestionMap['fcmToken'] = fcmToken;
  }

  void setOneSignalPlayerId(String playerId) {
    this.oneSignalPlayerId = playerId;
    this.songSuggestionMap['oneSignalPlayerId'] = playerId;
  }

  void setSubmissionTime(Timestamp time) {
    this.submissionTime = time;
    this.songSuggestionMap['submissionTime'] = time;
  }
}
