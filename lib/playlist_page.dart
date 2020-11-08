import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/buildRow.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'utilities/lists.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistDetails currentPlaylist;

  PlaylistPage(this.currentPlaylist);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  bool showProgress = false;
  PlaylistDetails currentPlaylist;
  final _firestore = FirebaseFirestore.instance;

  void getSongs() async {
    setState(() {
      showProgress = true;
    });
    await FireStoreHelper().getSongs('');

    addElementsToList('Popular');

    // bool isInternetConnected = await NetworkHelper().check();
    // if (isInternetConnected == false) {
    //   showToast(context, 'Please check your Internet connection!');
    //   return;
    // }

    // QuerySnapshot songs;
    // songs = await _firestore
    //     .collection('songs')
    //     .where('popularity', isGreaterThan: 4)
    //     .orderBy('popularity', descending: true)
    //     .get();
    // for (var song in songs.docs) {
    //   Map<String, dynamic> currentSong = song.data();
    //   String state = currentSong['aaa'];
    //   if (state != 'Invalid' && state != 'invalid') {
    //     SongDetails currentSongDetails = SongDetails(
    //         album: currentSong['album'],
    //         code: currentSong['code'],
    //         genre: currentSong['genre'],
    //         lyrics: currentSong['lyrics'],
    //         songNameEnglish: currentSong['songNameEnglish'],
    //         songNameHindi: currentSong['songNameHindi'],
    //         originalSong: currentSong['originalSong'],
    //         popularity: currentSong['popularity'],
    //         production: currentSong['production'],
    //         searchKeywords: currentSong['searchKeywords'],
    //         singer: currentSong['singer'],
    //         tirthankar: currentSong['tirthankar'],
    //         totalClicks: currentSong['totalClicks'],
    //         likes: currentSong['likes'],
    //         share: currentSong['share'],
    //         youTubeLink: currentSong['youTubeLink']);
    //     bool valueIsliked = await getisLiked(currentSong['code']);
    //     if (valueIsliked == null) {
    //       setisLiked(currentSong['code'], false);
    //       valueIsliked = false;
    //     }
    //     currentSongDetails.isLiked = valueIsliked;
    //     listToShow.add(
    //       currentSongDetails,
    //     );
    //   }
    // }

    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    listToShow.clear();
    currentPlaylist = widget.currentPlaylist;
    if (currentPlaylist.title.contains('Popular')) {
      getSongs();
    } else {
      addElementsToList(currentPlaylist.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // title: Text('Liked Songs'),
            centerTitle: true,
            pinned: true,
            expandedHeight: 200,
            elevation: 20,
            flexibleSpace: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      currentPlaylist.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    currentPlaylist.color,
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (showProgress) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: currentPlaylist.color,
                        ),
                      ],
                    ),
                  );
                } else if (index < songList.length) {
                  return BuildRow(
                    currentSong: listToShow[index],
                    color: currentPlaylist.color,
                  );
                }

                // return Container(height: 40, width: 40, color: Colors.red);
              },
              childCount: showProgress ? 1 : listToShow.length,
            ),
          ),
        ],
      ),
    );
  }
}
