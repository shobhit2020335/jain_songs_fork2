import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  //Format: type_premium_name_uploadedBy
  //Remember: File name is same as the code of the post and name is just a title
  //for the post
  late String code;
  late String name;
  //The title for description heading
  String? descriptionTitle;
  //The written content of the post
  String? descriptionSubtitle;
  //The URL for the post's image or video
  late String url;

  //Is the post available to be applied for status
  bool isAvailableForStatus = true;
  //Is the post available only to premium users
  bool isPremium = false;
  //The linked playlists to be rediredcted from the post page
  late List<String> linkedPlaylists;
  //The linked songs to be redirecited from the post page
  late List<String>? linkedSongs;

  //Users who successfully applied the post as their status
  int appliedOnStatusBy = 0;
  int likes = 0;
  int popularity = 0;
  int todayClicks = 0;
  int totalClicks = 0;
  int trendPoints = 0;

  //Types: Video, Image, Gif, etc
  late String type;
  late String uploadedBy;
  DateTime? lastModified;

  PostModel({
    required this.code,
    required this.name,
    required this.url,
    this.descriptionTitle,
    this.descriptionSubtitle,
    this.isAvailableForStatus = true,
    this.isPremium = false,
    required this.linkedPlaylists,
    required this.linkedSongs,
    this.appliedOnStatusBy = 0,
    this.likes = 0,
    this.popularity = 0,
    this.totalClicks = 0,
    this.todayClicks = 0,
    this.trendPoints = 0,
    this.type = 'Image',
    this.uploadedBy = 'Stavan Co.',
    this.lastModified,
  }) {
    lastModified ??= DateTime.now();
  }

  Map<String, dynamic> toMap() {
    descriptionTitle ??= '';
    descriptionSubtitle ??= '';
    lastModified ??= DateTime.now();

    return {
      'code': code,
      'name': name,
      'url': url,
      'descriptionTitle': descriptionTitle,
      'descriptionSubtitle': descriptionSubtitle,
      'isAvailableForStatus': isAvailableForStatus,
      'isPremium': isPremium,
      'linkedPlaylists': linkedPlaylists,
      'linkedSongs': linkedSongs,
      'appliedOnStatusBy': appliedOnStatusBy,
      'likes': likes,
      'popularity': popularity,
      'totalClicks': totalClicks,
      'todayClicks': todayClicks,
      'trendPoints': trendPoints,
      'type': type,
      'uploadedBy': uploadedBy,
      'lastModified': lastModified,
    };
  }

  PostModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    code = documentSnapshot['code'];
    name = documentSnapshot['name'];
    url = documentSnapshot['url'];
    descriptionTitle = documentSnapshot['descriptionTitle'];
    descriptionSubtitle = documentSnapshot['descriptionSubtitle'];
    isAvailableForStatus = documentSnapshot['isAvailableForStatus'];
    isPremium = documentSnapshot['isPremium'];
    linkedPlaylists = documentSnapshot['linkedPlaylists'] != null
        ? List<String>.from(documentSnapshot['linkedPlaylists'])
        : [];
    linkedSongs = documentSnapshot['linkedSongs'] != null
        ? List<String>.from(documentSnapshot['linkedSongs'])
        : [];
    appliedOnStatusBy = documentSnapshot['appliedOnStatusBy'];
    likes = documentSnapshot['likes'];
    popularity = documentSnapshot['popularity'];
    totalClicks = documentSnapshot['totalClicks'];
    todayClicks = documentSnapshot['todayClicks'];
    trendPoints = documentSnapshot['trendPoints'];
    type = documentSnapshot['type'];
    uploadedBy = documentSnapshot['uploadedBy'];
    lastModified = documentSnapshot['lastModified'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            documentSnapshot['lastModified'].millisecondsSinceEpoch)
        : null;
  }
}
