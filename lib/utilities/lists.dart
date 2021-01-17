//This file contains all the global variables and functions for the app.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/flutter_list_configured/filters.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:jain_songs/utilities/song_details.dart';

List<SongDetails> songList = [];
List<SongDetails> sortedSongList = [];
//TODO: if not working properly change [] to List() and try.
List<SongDetails> listToShow = [];

//Lists for applying filters.
List<Filters> filtersAll = [
  Filters('genre', 'Paryushan', color: Colors.green),
  Filters('genre', 'Diksha', color: Colors.green),
  Filters('genre', 'Tapasya', color: Colors.green),
  Filters('genre', 'Latest', color: Colors.green),
  Filters('tirthankar', '24', color: Colors.redAccent),
  Filters('tirthankar', 'Parshwanath', color: Colors.redAccent),
  Filters('tirthankar', 'Mahavir', color: Colors.redAccent),
  Filters('tirthankar', 'Adinath', color: Colors.redAccent),
  Filters('tirthankar', 'Adeshwar', color: Colors.redAccent),
  Filters('tirthankar', 'Shanti Gurudev', color: Colors.redAccent),
  Filters('tirthankar', 'Nakoda', color: Colors.redAccent),
  Filters('tirthankar', 'Shantinath', color: Colors.redAccent),
  Filters('category', 'Bhakti', color: Colors.amber),
  Filters('category', 'Stavan', color: Colors.amber),
  Filters('category', 'Garba', color: Colors.amber),
  Filters('category', 'Aarti', color: Colors.amber),
  Filters('category', 'Stotra', color: Colors.amber),
  Filters('language', 'Hindi', color: Colors.blue),
  Filters('language', 'Gujarati', color: Colors.blue),
  Filters('language', 'Marwadi', color: Colors.blue),
];
List<Filters> filtersSelected = [];

//Algo for applying filters.
Future<void> applyFilter() async {
  listToShow.clear();
  int l = filtersSelected.length;
  int n = sortedSongList.length;
  if (filtersSelected != null && l > 0 && l < filtersAll.length) {
    List<String> genreSelected = [];
    List<String> tirthankarSelected = [];
    List<String> categorySelected = [];
    List<String> languageSelected = [];
    UserFilters userFilters = UserFilters();

    for (int i = 0; i < l; i++) {
      if (filtersSelected[i].category == 'genre') {
        genreSelected.add(filtersSelected[i].name.toLowerCase());
        userFilters.genre = userFilters.genre + " " + filtersSelected[i].name;
      } else if (filtersSelected[i].category == 'tirthankar') {
        tirthankarSelected.add(filtersSelected[i].name.toLowerCase());
        userFilters.tirthankar = userFilters.tirthankar + " "+ filtersSelected[i].name;
      } else if (filtersSelected[i].category == 'category') {
        categorySelected.add(filtersSelected[i].name.toLowerCase());
        userFilters.category = userFilters.category + " " +filtersSelected[i].name;
      } else if (filtersSelected[i].category == 'language') {
        languageSelected.add(filtersSelected[i].name.toLowerCase());
        userFilters.language =  userFilters.language+ " "+ filtersSelected[i].name;
      }
    }

    FireStoreHelper().userSelectedFilters(userFilters);

    for (int i = 0; i < n; i++) {
      bool toAdd = true;
      for (int j = 0; j < genreSelected.length; j++) {
        if (sortedSongList[i].genre.toLowerCase().contains(genreSelected[j]) ==
            true) {
          toAdd = true;
          break;
        } else {
          toAdd = false;
        }
      }
      if (toAdd == false) {
        continue;
      }

      for (int j = 0; j < tirthankarSelected.length; j++) {
        if (sortedSongList[i]
                .tirthankar
                .toLowerCase()
                .contains(tirthankarSelected[j]) ==
            true) {
          toAdd = true;
          break;
        } else {
          toAdd = false;
        }
      }
      if (toAdd == false) {
        continue;
      }

      for (int j = 0; j < categorySelected.length; j++) {
        if (sortedSongList[i]
                .category
                .toLowerCase()
                .contains(categorySelected[j]) ==
            true) {
          toAdd = true;
          break;
        } else {
          toAdd = false;
        }
      }
      if (toAdd == false) {
        continue;
      }

      for (int j = 0; j < languageSelected.length; j++) {
        if (sortedSongList[i]
                .language
                .toLowerCase()
                .contains(languageSelected[j]) ==
            true) {
          toAdd = true;
          break;
        } else {
          toAdd = false;
        }
      }
      if (toAdd == false) {
        continue;
      }

      listToShow.add(sortedSongList[i]);
    }
  } else {
    listToShow = List.from(sortedSongList);
  }
}

final DateTime startDate = DateTime(2020, 12, 23);
String appURL =
    'https://play.google.com/store/apps/details?id=com.JainDevelopers.jain_songs';
DateTime todayDate;
int totalDays = 1;
int fetchedDays = 0;

//TODO: update app version for new app.
double appVersion = 1.001;
double fetchedVersion;
//Anonymous user's variable.
UserCredential userCredential;

int popularityComparison(SongDetails a, SongDetails b) {
  final propertyA = a.popularity;
  final propertyB = b.popularity;
  if (propertyA < propertyB) {
    return 1;
  } else if (propertyA > propertyB) {
    return -1;
  } else {
    return 0;
  }
}

int trendComparison(SongDetails a, SongDetails b) {
  final propertyA = a.trendPoints;
  final propertyB = b.trendPoints;
  if (propertyA < propertyB) {
    return 1;
  } else if (propertyA > propertyB) {
    return -1;
  } else {
    return 0;
  }
}

void searchInList(String query) {
  listToShow.clear();
  query = query.toLowerCase();
  for (int i = 0; i < sortedSongList.length; i++) {
    if (sortedSongList[i].searchKeywords.contains(query)) {
      listToShow.add(sortedSongList[i]);
    }
    // listToShow.sort(trendComparison);
  }
}

void addElementsToList(String playlistTag) {
  listToShow.clear();
  playlistTag = playlistTag.toLowerCase();
  //This is for main list having all songs. It is called only when home page loads the songs after refreshing.
  if (playlistTag.contains('home')) {
    for (int i = 0; i < songList.length; i++) {
      sortedSongList.add(songList[i]);
    }
    sortedSongList.sort(trendComparison);
    listToShow = List.from(sortedSongList);
  }
  //This is for likes page.
  else if (playlistTag.contains('favourites')) {
    for (int i = 0; i < songList.length; i++) {
      if (songList[i].isLiked == true) {
        listToShow.add(songList[i]);
      }
    }
  }
  //This is for latest playlist.
  else if (playlistTag.contains('latest')) {
    for (int i = 0; i < songList.length; i++) {
      if (songList[i].genre.toLowerCase().contains('latest')) {
        listToShow.add(songList[i]);
      }
    }
  }
  //This is for popular playlist.
  else if (playlistTag.contains('popular')) {
    for (int i = 0; i < songList.length; i++) {
      if (songList[i].popularity > 5 && songList[i].likes > 0) {
        listToShow.add(songList[i]);
      }
    }
    listToShow.sort(popularityComparison);
  }
  //This is for bhakti special playlist.
  else if (playlistTag.contains('bhakti')) {
    for (int i = 0; i < songList.length; i++) {
      if (songList[i].category.toLowerCase().contains('bhakti')) {
        listToShow.add(songList[i]);
      }
    }
  }
  //This is Tirthankar playlist.
  else {
    for (int i = 0; i < songList.length; i++) {
      if (songList[i].tirthankar.toLowerCase().contains(playlistTag)) {
        listToShow.add(songList[i]);
      } else if (songList[i].genre.toLowerCase().contains(playlistTag)) {
        listToShow.add(songList[i]);
      }
    }
  }
}

//List for settings page.
List<SettingsDetails> settingsList = [
  SettingsDetails(
    title: 'About',
    subtitle: 'Know about us.',
    information:
        'The STAVAN app provides the lyrics and links of Jain Stavans, Bhakti and Stotras.\nRate and review us on PlayStore.',
  ),
  SettingsDetails(
    title: 'Terms Of Use',
    subtitle: 'Legal Information & Privacy Policies',
    information:
        'This is a legal agreement between you and STAVAN application and its related services. Your use of these services is conditioned on your acceptance, without modification, of these Terms of Service. Please read these terms carefully. If you do not agree to these terms, you can contact us for further details (although we do not gurantee a solution).\n\nBy using this app, you acknowledge and confirm that:\n\n1. We are constantly making changes in our app to provide the best possible experience. You acknowledge and agree that form and nature of service that we provides, may change from time to time without prior notice.\n\n2. In order to provide a suggestion for a new song, stavan, stotra or any related services, you may be required to provide your name and email. (The name and email is necessary to provide you with the credit of the song, to contact you about the suggestion you have made or for any other informational use. We declare that we won’t be selling the private information provided by you to any third-party companies or organizations.) You promise to provide us with accurate, complete, and updated information which is asked for.\n\n3. Credit for the song is given in the form of a name (provided by you when suggesting) when the song is uploaded. If the information is not up to date then the credit for the song shall not be given and you couldn’t ask for the credit after the submission is made. If there is more than one suggestion for the same song then the credit will be given to the earliest submission user who had provided the correct name.\n\n4. You understand that all the information which you may have access to, is the sole responsibility of the source from which the content is originated. STAVAN does its best to give proper credit to the source from which the data was indexed. STAVAN lay no claim to the ownership of the content originated at these sites. If some content is cached, it is done for the sole purpose of providing users with the best possible service. If you think that Content is objectionable, please inform us.\n\n5. If you believe that your work is used in a way that constitutes copyright infringement, or your intellectual property rights have been otherwise violated, please send a notice of copyright infringement to Add email here.\n\n6. Some of the Services may be supported by advertising revenue and may display advertisements and promotions. These advertisements may be targeted to the content of information stored on the Services, queries made through the Services, or other information.\n\n7. The Services may include hyperlinks to other web sites or content or resources. We may have no control over any web sites or resources which are provided by companies or persons other than ours. You acknowledge and agree that STAVAN is not responsible for the availability of any such external sites or resources, and does not endorse any advertising, products, or other materials on or available from such web sites or resources. You acknowledge and agree that STAVAN is not liable for any loss or damage which may be incurred by you as a result of the availability of those external sites or resources, or as a result of any reliance placed by you on the completeness, accuracy or existence of any advertising, products or other materials on, or available from, such web sites or resources.',
  ),
  SettingsDetails(
    title: 'Feedback & Support',
    subtitle: 'Suggest us or get help from us.',
    information: '',
  ),
];

//List for different playlist.
List<PlaylistDetails> playlistList = [
  PlaylistDetails(
    active: true,
    title: 'Favourites',
    subtitle: 'Likes Songs',
    playlistTag: 'favourites',
    leadIcon: FontAwesomeIcons.gratipay,
    color: Colors.pink[300],
  ),
  PlaylistDetails(
    active: true,
    title: 'Latest Releases',
    subtitle: 'New song lyrics',
    playlistTag: 'latest',
    leadIcon: FontAwesomeIcons.calendarPlus,
    color: Colors.green,
  ),
  PlaylistDetails(
    active: true,
    title: 'Popular',
    subtitle: 'All time hits',
    playlistTag: 'popular',
    leadIcon: FontAwesomeIcons.fire,
    color: Colors.amber,
  ),
  PlaylistDetails(
    active: true,
    title: 'Bhakti Special',
    subtitle: 'Playlist for Bhakti',
    playlistTag: 'bhakti',
    leadIcon: Icons.ac_unit,
    color: Colors.redAccent,
  ),
  PlaylistDetails(
    active: true,
    title: 'Parshwanath',
    subtitle: 'Parasnath Bhajans',
    playlistTag: 'parshwanath',
    leadIcon: FontAwesomeIcons.prayingHands,
    color: Colors.blue,
  ),
  PlaylistDetails(
    active: true,
    title: 'Mahaveer Swami',
    subtitle: 'Mahaveer Swami Bhajans',
    playlistTag: 'mahavir',
    leadIcon: FontAwesomeIcons.prayingHands,
    color: Colors.blue[700],
  ),
  PlaylistDetails(
    active: true,
    title: 'Adinath Swami',
    subtitle: 'Adinath Swami Bhajans',
    playlistTag: 'adinath',
    leadIcon: FontAwesomeIcons.prayingHands,
    color: Colors.blue[900],
  ),
];
