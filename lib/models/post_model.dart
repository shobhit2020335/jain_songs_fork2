import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: Feature add posts and detecting songs which should be linked to the post
// on the basis of the keywords

class PostModel {
  //Format: type_premium_descriptionTitle_uploadedBy. Note it must not contain
  //any special characters other than _.
  //Remember: File name is same as the code of the post with its extension and name is just a title
  //for the post
  late String code;
  late String fileName;
  //The title for description heading
  late String descriptionTitle;
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
  //Users who successfully downloaded the post.
  int downloadedBy = 0;
  //Popularity is totalViews + 3 * number of downloads + 2 * number of status applied
  int popularity = 0;
  int todayViews = 0;
  int totalViews = 0;
  //This trend point algo is different from song trend point algo
  //TrendPoint is todayClicks/totalClicks * 100
  int trendPoints = 0;

  //Types: Video, Image, Gif, etc
  late String type;
  String uploadedBy = 'Stavan Co.';
  DateTime? lastModified;

  PostModel({
    required this.code,
    required this.fileName,
    required this.url,
    required this.descriptionTitle,
    this.descriptionSubtitle,
    this.isAvailableForStatus = true,
    this.isPremium = false,
    required this.linkedPlaylists,
    required this.linkedSongs,
    this.appliedOnStatusBy = 0,
    this.downloadedBy = 0,
    this.popularity = 0,
    this.totalViews = 0,
    this.todayViews = 0,
    this.trendPoints = 0,
    this.type = 'Image',
    this.uploadedBy = 'Stavan Co.',
    this.lastModified,
  }) {
    lastModified ??= DateTime.now();
  }

  void createCode() {
    //TODO:
  }

  Map<String, dynamic> toMap() {
    descriptionSubtitle ??= '';
    lastModified ??= DateTime.now();

    return {
      'code': code,
      'fileName': fileName,
      'url': url,
      'descriptionTitle': descriptionTitle,
      'descriptionSubtitle': descriptionSubtitle,
      'isAvailableForStatus': isAvailableForStatus,
      'isPremium': isPremium,
      'linkedPlaylists': linkedPlaylists,
      'linkedSongs': linkedSongs,
      'appliedOnStatusBy': appliedOnStatusBy,
      'downloadedBy': downloadedBy,
      'popularity': popularity,
      'totalViews': totalViews,
      'todayViews': todayViews,
      'trendPoints': trendPoints,
      'type': type,
      'uploadedBy': uploadedBy,
      'lastModified': lastModified,
    };
  }

  PostModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    code = documentSnapshot['code'];
    fileName = documentSnapshot['fileName'];
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
    downloadedBy = documentSnapshot['downloadedBy'];
    popularity = documentSnapshot['popularity'];
    totalViews = documentSnapshot['totalViews'];
    todayViews = documentSnapshot['todayViews'];
    trendPoints = documentSnapshot['trendPoints'];
    type = documentSnapshot['type'];
    uploadedBy = documentSnapshot['uploadedBy'];
    lastModified = documentSnapshot['lastModified'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            documentSnapshot['lastModified'].millisecondsSinceEpoch)
        : null;
  }
}
