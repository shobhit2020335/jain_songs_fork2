import 'package:cloud_firestore/cloud_firestore.dart';

class SongSuggestions {
  String? fcmToken;
  String? oneSignalPlayerId;
  String songName;
  String otherDetails;
  List<String>? imagesLink;
  Timestamp? submissionTime;
  Map<String, dynamic> songSuggestionMap = <String, String?>{};

  SongSuggestions(this.songName, this.otherDetails,
      {this.imagesLink,
      this.submissionTime,
      this.fcmToken = 'NA',
      this.oneSignalPlayerId = 'NA'}) {
    submissionTime = Timestamp.now();
    songSuggestionMap = {
      'oneSignalPlayerId': oneSignalPlayerId,
      'fcmToken': fcmToken,
      'imagesLink': imagesLink,
      'otherDetails': otherDetails,
      'songName': songName,
      'submissionTime': submissionTime,
    };
  }

  void addImagesLink(String link) {
    imagesLink ??= [];
    if (imagesLink != null) {
      imagesLink?.add(link);
    }
    songSuggestionMap['imagesLink'] = imagesLink;
  }

  void setFCMToken(String? fcmToken) {
    this.fcmToken = fcmToken;
    songSuggestionMap['fcmToken'] = fcmToken;
  }

  void setOneSignalPlayerId(String? playerId) {
    oneSignalPlayerId = playerId;
    songSuggestionMap['oneSignalPlayerId'] = playerId;
  }

  void setSubmissionTime(Timestamp time) {
    submissionTime = time;
    songSuggestionMap['submissionTime'] = time;
  }
}
