import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_interstitial.dart';
import '../song_page.dart';

class BuildRow extends StatefulWidget {
  final SongDetails currentSong;
  final Color color;

  BuildRow({
    @required this.currentSong,
    this.color: Colors.grey,
  });

  @override
  _BuildRowState createState() => _BuildRowState();
}

class _BuildRowState extends State<BuildRow> {
  //Below full code is for Mopub.
  // MoPubInterstitialAd interstitialAd;

  // void _loadMopubInterstitialAd() async {
  //   interstitialAd = MoPubInterstitialAd(
  //     '7e9b62190a1f4a6ab748342e6dd012a6',
  //     (result, args) {
  //       print('Interstitial $result');
  //     },
  //     reloadOnClosed: true,
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   try {
  //     MoPub.init('7e9b62190a1f4a6ab748342e6dd012a6', testMode: false).then((_) {
  //       _loadMopubInterstitialAd();
  //     });
  //   } on PlatformException {}
  // }

  // @override
  // void dispose() {
  //   interstitialAd.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    SongDetails currentSong = widget.currentSong;
    return ListTileTheme(
      selectedColor: Colors.blue[300],
      style: ListTileStyle.drawer,
      child: ListTile(
        title: Text(
          currentSong.songNameEnglish,
          style: TextStyle(color: Color(0xFF212323)),
        ),
        subtitle: Text(currentSong.originalSong),
        trailing: IconButton(
          icon: Icon(
            currentSong.isLiked == true
                ? FontAwesomeIcons.solidHeart
                : FontAwesomeIcons.heart,
            color: widget.color,
          ),
          onPressed: () async {
            if (currentSong.isLiked == true) {
              currentSong.isLiked = false;
              setState(() {});
              FireStoreHelper fireStoreHelper = FireStoreHelper();
              await fireStoreHelper.changeLikes(context, currentSong, false);
            } else {
              currentSong.isLiked = true;
              setState(() {});
              FireStoreHelper fireStoreHelper = FireStoreHelper();
              await fireStoreHelper.changeLikes(context, currentSong, true);
            }
            setState(() {});
          },
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongPage(
                currentSong: currentSong,
                // interstitialAd: interstitialAd,
              ),
            ),
          );
          setState(() {});
        },
      ),
    );
  }
}
