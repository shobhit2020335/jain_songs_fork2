//This file contains all the global variables for the app.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:jain_songs/utilities/song_details.dart';

List<SongDetails> songList = [];

List<SongDetails> listToShow = [];

final DateTime startDate = DateTime(2020, 11, 5);
DateTime todayDate;
int totalDays = 1;
int fetchedDays = 0;

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

void addElementsToList(String playlistTag) {
  listToShow.clear();
  playlistTag = playlistTag.toLowerCase();
  //This is for main list having all songs.
  if (playlistTag.contains('home')) {
    for (int i = 0; i < songList.length; i++) {
      listToShow.add(songList[i]);
    }
    listToShow.sort(trendComparison);
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
      if (songList[i].genre.toLowerCase().contains('bhakti')) {
        listToShow.add(songList[i]);
      }
    }
  }
  //This is for Parshwanath playlist.
  else if (playlistTag.contains('parshwanath')) {
    for (int i = 0; i < songList.length; i++) {
      if (songList[i].tirthankar.toLowerCase().contains('parshwanath')) {
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
  ),
  SettingsDetails(
    title: 'Privacy Policy',
    subtitle: 'Legal Information.',
  ),
  SettingsDetails(
    title: 'Feedback & Support',
    subtitle: 'Suggest us or get help from us.',
  ),
];

//TODO: Edit list for different playlist.
List<PlaylistDetails> playlistList = [
  PlaylistDetails(
    active: true,
    title: 'Favourites',
    subtitle: 'Likes Songs',
    leadIcon: FontAwesomeIcons.gratipay,
    color: Colors.pink[300],
  ),
  PlaylistDetails(
    active: true,
    title: 'Latest Releases',
    subtitle: 'New song lyrics',
    leadIcon: FontAwesomeIcons.calendarPlus,
    color: Colors.green,
  ),
  PlaylistDetails(
    active: true,
    title: 'Popular',
    subtitle: 'All time hits',
    leadIcon: FontAwesomeIcons.fire,
    color: Colors.amber,
  ),
  PlaylistDetails(
    active: true,
    title: 'Bhakti Special',
    subtitle: 'Playlist for Bhakti',
    leadIcon: Icons.ac_unit,
    color: Colors.redAccent,
  ),
  PlaylistDetails(
    active: true,
    title: 'Parshwanath',
    subtitle: 'Parasnath Bhajans',
    leadIcon: FontAwesomeIcons.prayingHands,
    color: Color(0xFF54BEE6),
  ),
];
