//This file contains all list related function and data.
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/flutter_list_configured/filters.dart';
import 'package:jain_songs/models/advertisement_model.dart';
import 'package:jain_songs/models/post_model.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:jain_songs/utilities/song_details.dart';

class ListFunctions {
  //Contains all the songs in alphabetical order.
  static List<SongDetails?> songList = [];
  static List<SongDetails?> sortedSongList = [];
  static List<SongDetails?> listToShow = [];
  static Set<String?> songsVisited = {};
  //Stores the codes songs whose posts are fetched fetched
  static Set<String> postsFetchedForSongs = {};
  //Stores the codes of the posts fetched;
  static Set<String> postsFetched = {};
  //All posts sorted by modified time
  static List<PostModel> allPosts = [];
  //List for the posts which are visible
  static List<PostModel> postsToShow = [];

  ///Advertisement list which is shown in the song page screen
  static List<AdvertisementModel> advertisementList = [
    AdvertisementModel(
      advertisementId: 'ritesh',
      companyName: 'Ritesh Sarees & Kurtis',
      companyURL: 'https://www.instagram.com/ritesh_saree_kurtis/',
      title: 'Shop for Sarees & Kurtis',
      icon: 'images/rs_logo.png',
      backgroundColor: Colors.black,
    ),
    AdvertisementModel(
      advertisementId: 'almanac_of_wisdom',
      companyName: 'Almanac Of Wisdom',
      companyURL:
          'https://play.google.com/store/apps/details?id=com.JainDevelopers.almanac_of_wisdom',
      title: 'Read Blogs, Article & More',
      icon: 'images/almanac_of_wisdom_icon_transparent.png',
      backgroundColor: Colors.white,
      textColor: Colors.indigo,
    ),
    AdvertisementModel(
      advertisementId: 'stavan_co_buymeacoffee',
      companyName: 'Stavan Co.',
      companyURL: 'https://www.buymeacoffee.com/stavan',
      title: 'Donate us to improve this app!',
      icon: 'images/Logo.png',
      iconColor: Colors.indigo,
      backgroundColor: Colors.white,
      textColor: Colors.indigo,
      iconSize: 35,
    ),
  ];

  //Lists for applying filters.
  static final List<Filters> filtersAll = [
    Filters('genre', 'Paryushan', color: Colors.green),
    Filters('genre', 'Diksha', color: Colors.green),
    Filters('genre', 'Tapasya', color: Colors.green),
    Filters('genre', 'Chaturmas', color: Colors.green),
    Filters('genre', 'Palitana', color: Colors.green),
    Filters('genre', 'Girnar', color: Colors.green),
    Filters('genre', 'Jin Shashan', color: Colors.green),
    Filters('genre', 'Navkar Mantra', color: Colors.green),
    // Filters('genre', 'Bollywood', color: Colors.green),
    Filters('genre', 'Latest', color: Colors.green),
    Filters('genre', 'Janam Kalyanak', color: Colors.green),
    Filters('tirthankar', '24', color: Colors.redAccent),
    Filters('tirthankar', 'Parshwanath', color: Colors.redAccent),
    Filters('tirthankar', 'Mahavir', color: Colors.redAccent),
    Filters('tirthankar', 'Adinath', color: Colors.redAccent),
    Filters('tirthankar', 'Adeshwar', color: Colors.redAccent),
    Filters('tirthankar', 'Neminath', color: Colors.redAccent),
    // Filters('tirthankar', 'Sumtinath', color: Colors.redAccent),
    Filters('tirthankar', 'Bhikshu', color: Colors.redAccent),
    Filters('tirthankar', 'Nakoda', color: Colors.redAccent),
    Filters('tirthankar', 'Shanti Gurudev', color: Colors.redAccent),
    Filters('tirthankar', 'Sambhavnath', color: Colors.redAccent),
    Filters('tirthankar', 'Shantinath', color: Colors.redAccent),
    Filters('category', 'Bhakti', color: Colors.amber),
    Filters('category', 'Stavan', color: Colors.amber),
    Filters('category', 'Adhyatmik', color: Colors.amber),
    // Filters('category', 'Stuti', color: Colors.amber),
    Filters('category', 'Garba', color: Colors.amber),
    Filters('category', 'Aarti', color: Colors.amber),
    Filters('category', 'Stotra', color: Colors.amber),
    Filters('category', 'Chalisa', color: Colors.amber),
    Filters('language', 'Hindi', color: Colors.blue),
    Filters('language', 'Gujarati', color: Colors.blue),
    Filters('language', 'Marwadi', color: Colors.blue),
  ];
  static List<Filters> filtersSelected = [];

//Algo for applying filters.
  Future<void> applyFilter() async {
    listToShow.clear();
    int l = filtersSelected.length;
    int n = sortedSongList.length;
    if (l > 0 && l < filtersAll.length) {
      List<String> genreSelected = [];
      List<String> tirthankarSelected = [];
      List<String> categorySelected = [];
      List<String> languageSelected = [];
      UserFilters userFilters = UserFilters();

      for (int i = 0; i < l; i++) {
        if (filtersSelected[i].category == 'genre') {
          genreSelected.add(filtersSelected[i].name.toLowerCase());
          userFilters.genre = "${userFilters.genre} ${filtersSelected[i].name}";
        } else if (filtersSelected[i].category == 'tirthankar') {
          tirthankarSelected.add(filtersSelected[i].name.toLowerCase());
          userFilters.tirthankar =
              "${userFilters.tirthankar} ${filtersSelected[i].name}";
        } else if (filtersSelected[i].category == 'category') {
          categorySelected.add(filtersSelected[i].name.toLowerCase());
          userFilters.category =
              "${userFilters.category} ${filtersSelected[i].name}";
        } else if (filtersSelected[i].category == 'language') {
          languageSelected.add(filtersSelected[i].name.toLowerCase());
          userFilters.language =
              "${userFilters.language} ${filtersSelected[i].name}";
        }
      }

      //Disabled storing of user filters for now.
      // FireStoreHelper().userSelectedFilters(userFilters);

      for (int i = 0; i < n; i++) {
        bool toAdd = true;
        for (int j = 0; j < genreSelected.length; j++) {
          if (sortedSongList[i]!
                  .genre!
                  .toLowerCase()
                  .contains(genreSelected[j]) ==
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
          if (sortedSongList[i]!
                  .tirthankar!
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
          if (sortedSongList[i]!
                  .category!
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
          if (sortedSongList[i]!
                  .language!
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

//This is used in all playlists
  static int popularityComparison(SongDetails? a, SongDetails? b) {
    final propertyA = a!.popularity!;
    final propertyB = b!.popularity!;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }

  static int trendComparison(SongDetails? a, SongDetails? b) {
    final propertyA = a!.trendPoints!;
    final propertyB = b!.trendPoints!;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }

  void addElementsToList(String playlistTag) {
    listToShow.clear();
    playlistTag = playlistTag.toLowerCase();
    //This is for main list having all songs. It is called only when home page loads the songs after refreshing.
    if (playlistTag.contains('home')) {
      sortedSongList.clear();
      for (int i = 0; i < songList.length; i++) {
        if (songList[i]?.aaa == 'valid') {
          sortedSongList.add(songList[i]);
        }
      }
      sortedSongList.sort(trendComparison);
      listToShow = List.from(sortedSongList);
    }
    //This is for likes page.
    else if (playlistTag.contains('favourites')) {
      for (int i = 0; i < songList.length; i++) {
        if (songList[i]!.isLiked == true) {
          listToShow.add(songList[i]);
        }
      }
    }
    //This is for latest playlist.
    else if (playlistTag.contains('latest')) {
      for (int i = 0; i < songList.length; i++) {
        if (songList[i]!.genre!.toLowerCase().contains('latest')) {
          listToShow.add(songList[i]);
        }
      }
      listToShow.sort(trendComparison);
    }
    //This is for popular playlist.
    else if (playlistTag.contains('popular')) {
      for (int i = 0; i < songList.length; i++) {
        if (songList[i]!.popularity! > 80 && songList[i]!.likes! > 5) {
          listToShow.add(songList[i]);
        }
      }
      listToShow.sort(popularityComparison);
      listToShow = listToShow.take(30).toList();
    }
    //This is for bhakti special playlist.
    else if (playlistTag.contains('bhakti')) {
      for (int i = 0; i < songList.length; i++) {
        if (songList[i]!.category!.toLowerCase().contains('bhakti')) {
          listToShow.add(songList[i]);
        }
      }
      listToShow.sort(popularityComparison);
      listToShow = listToShow.take(30).toList();
    }
    //This is for stotra playlist
    else if (playlistTag.contains('stotra')) {
      for (int i = 0; i < songList.length; i++) {
        if (songList[i]!.category!.toLowerCase().contains('stotra')) {
          listToShow.add(songList[i]);
        }
      }
      listToShow.sort(popularityComparison);
    }
    //This is Tirthankar, diksha, singer and paryushan playlist
    else {
      for (int i = 0; i < songList.length; i++) {
        if (songList[i]!.tirthankar!.toLowerCase().contains(playlistTag)) {
          listToShow.add(songList[i]);
        } else if (songList[i]!.genre!.toLowerCase().contains(playlistTag)) {
          listToShow.add(songList[i]);
        } else if (songList[i]!.singer!.toLowerCase().contains(playlistTag)) {
          listToShow.add(songList[i]);
        }
      }
      listToShow.sort(popularityComparison);
    }
  }

//List for settings page.
  static final List<SettingsDetails> settingsList = [
    SettingsDetails(
      title: 'Autoplay Video',
      subtitle: 'Autoplay song and video when a song is clicked',
      isSetting: true,
      dependentValue: Globals.isVideoAutoPlay,
    ),
    SettingsDetails(
      title: 'Dark Mode',
      subtitle: 'Using dark mode reduces strain on eyes',
      isSetting: true,
      dependentValue: false,
    ),
    SettingsDetails(
      title: 'About',
      subtitle: 'Know about us.',
    ),
    SettingsDetails(
      title: 'Terms Of Use',
      subtitle: 'Legal Information & Privacy Policies',
    ),
    SettingsDetails(
      title: 'Feedback & Support',
      subtitle: 'Suggest us or get help from us.',
    ),
  ];

  //List for different playlist.
  static final List<PlaylistDetails?> playlistList = [
    //DO not change sequence of favourite playlist from 0, it is connected to likes page.
    PlaylistDetails(
      active: true,
      title: 'Favourites',
      subtitle: 'Liked Songs',
      playlistTag: 'favourites',
      playlistTagType: '',
      leadIcon: FontAwesomeIcons.gratipay,
      color: ConstWidget.signatureColors(value: 1),
    ),
    PlaylistDetails(
      active: true,
      title: 'Latest Releases',
      subtitle: 'New song lyrics',
      playlistTag: 'latest',
      playlistTagType: 'genre',
      leadIcon: FontAwesomeIcons.calendarPlus,
      color: ConstWidget.signatureColors(value: 2),
    ),
    PlaylistDetails(
      active: true,
      title: 'Popular',
      subtitle: 'Most Popular Bhajan Special.',
      playlistTag: 'popular',
      playlistTagType: '',
      leadIcon: FontAwesomeIcons.fire,
      color: ConstWidget.signatureColors(value: 0),
    ),
    PlaylistDetails(
      active: true,
      title: 'Bhakti Special',
      subtitle: 'All time Favourite Bhakti',
      playlistTag: 'bhakti',
      playlistTagType: 'category',
      leadIcon: Icons.ac_unit,
      color: ConstWidget.signatureColors(value: 3),
    ),
    PlaylistDetails(
      active: true,
      title: 'Paryushan Stavans',
      subtitle: 'Paryushan Mahaparv Playlist',
      playlistTag: 'paryushan',
      playlistTagType: 'genre',
      leadIcon: FontAwesomeIcons.personPraying,
      iconSize: 32,
      color: Colors.teal,
    ),
    PlaylistDetails(
      active: true,
      title: 'Tapasya Geet',
      subtitle: 'Varitap parna, Navtap & others',
      playlistTag: 'tapasya',
      playlistTagType: 'genre',
      leadIcon: Icons.self_improvement_rounded,
      iconSize: 40,
      color: Colors.lime,
    ),
    PlaylistDetails(
      active: true,
      title: 'Diksha Stavans',
      subtitle: 'Diksha playlist',
      playlistTag: 'diksha',
      playlistTagType: 'genre',
      leadIcon: Icons.cleaning_services_rounded,
      iconSize: 32,
      color: Colors.blueGrey,
    ),
    PlaylistDetails(
      active: true,
      title: 'Vicky Parekh Hits',
      subtitle: "Vicky Parekh's best songs",
      playlistTag: 'vicky',
      playlistTagType: 'singer',
      leadIcon: Icons.music_note_rounded,
      color: Colors.indigo,
    ),
    PlaylistDetails(
      active: true,
      title: 'Rishabh Sambhav Jain Hits',
      subtitle: "RSJ's best songs",
      playlistTag: 'rsj',
      playlistTagType: 'singer',
      leadIcon: Icons.music_note_rounded,
      color: Colors.indigo,
    ),
    PlaylistDetails(
      active: true,
      title: 'Stotra',
      subtitle: 'Famous Stotra',
      playlistTag: 'stotra',
      playlistTagType: 'category',
      leadIcon: Icons.menu_book_rounded,
      color: Colors.brown,
    ),
    PlaylistDetails(
      active: true,
      title: 'Neminath and Girnar',
      subtitle: 'Neminath and Girnar Bhajans',
      playlistTag: 'neminath',
      playlistTagType: 'tirthankar',
      leadIcon: FontAwesomeIcons.handsPraying,
      color: Colors.pink[300],
    ),
    PlaylistDetails(
      active: true,
      title: 'Parshwanath',
      subtitle: 'Parasnath Bhajans',
      playlistTag: 'parshwanath',
      playlistTagType: 'tirthankar',
      leadIcon: FontAwesomeIcons.handsPraying,
      color: Colors.green,
    ),
    PlaylistDetails(
      active: true,
      title: 'Mahaveer Swami',
      subtitle: 'Mahaveer Swami Bhajans',
      playlistTag: 'mahavir',
      playlistTagType: 'tirthankar',
      leadIcon: FontAwesomeIcons.handsPraying,
      color: Colors.amber,
    ),
    PlaylistDetails(
      active: true,
      title: 'Adinath Swami',
      subtitle: 'Rishabh dev Bhajans',
      playlistTag: 'adinath',
      playlistTagType: 'tirthankar',
      leadIcon: FontAwesomeIcons.handsPraying,
      color: Colors.redAccent,
    ),
    PlaylistDetails(
      active: true,
      title: 'Nakoda Bheruji',
      subtitle: 'Nakoda Bhairav Bhajans',
      playlistTag: 'nakoda',
      playlistTagType: 'tirthankar',
      leadIcon: FontAwesomeIcons.handsPraying,
      color: Colors.blue,
    ),
  ];
}
