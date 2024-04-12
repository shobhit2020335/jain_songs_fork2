import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/playlist_details.dart';

import '../playlist_page.dart';
import '../screens/astronomy_screens/astronomy_bottom_sheet.dart';
import '../youtube_player_configured/src/utils/youtube_player_controller.dart';

class ConstWidget {
  //This card is shown in song page as a whatapp status button
  // add dynamic banner

  static Widget buildPlaylistCard(
    // show ad if return null

    //priority :
    // category stotra- open pachhkhan
    //liked - favourites
    // ongoing
    //ad
    String? category,
    String? genre,
    String? tirthankar,
    BuildContext context,
    bool isLiked,
    YoutubePlayerController controller,
  ) {
    print('category is $category, $genre, $tirthankar');

    if (category != null &&
        category.isNotEmpty &&
        category.toLowerCase().contains('stotra')) {
      List<PlaylistDetails?> stotraPlaylist = ListFunctions.playlistList
          .where((PlaylistDetails? playlist) =>
              playlist!.playlistTag.toLowerCase() == 'stotra')
          .toList();
      return statusCard(stotraPlaylist.isNotEmpty ? stotraPlaylist.first : null,
          context, controller);
    } else if (isLiked) {
      List<PlaylistDetails?> favouritesPlaylist = ListFunctions.playlistList
          .where((PlaylistDetails? playlist) =>
              playlist!.playlistTag.toLowerCase() == 'favourites')
          .toList();
      return statusCard(
          favouritesPlaylist.isNotEmpty ? favouritesPlaylist.first : null,
          context,
          controller);
    }

    List<PlaylistDetails?> filteredPlaylists =
        ListFunctions.playlistList.where((PlaylistDetails? playlist) {
      String tag = playlist!.playlistTag.toLowerCase();
      return (category != null &&
              category.isNotEmpty &&
              category.toLowerCase().contains(tag.toLowerCase())) ||
          (genre != null &&
              genre.isNotEmpty &&
              genre.toLowerCase().contains(tag.toLowerCase())) ||
          (tirthankar != null &&
              tirthankar.isNotEmpty &&
              tirthankar.toLowerCase().contains(tag.toLowerCase()));
    }).toList();

    PlaylistDetails? matchedPlaylist =
        filteredPlaylists.isNotEmpty ? filteredPlaylists.first : null;

    return statusCard(matchedPlaylist, context, controller);
  }

  static Widget statusCard(PlaylistDetails? details, BuildContext context,
      YoutubePlayerController controller) {
    print('got details is $details');
    int advertisementNumber =
        Random().nextInt(ListFunctions.advertisementList.length);

    return InkWell(
      onTap: () async {
        controller.pause();
        if (details == null) {
          Services.launchURL(
            ListFunctions.advertisementList[advertisementNumber].companyURL,
          );
        } else {
          if (details.playlistTag == 'stotra') {
            await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              isScrollControlled: true,
              builder: (_) => Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.9), // Adjust the value as needed
                child: AstronomyBottomSheet(context),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlaylistPage(
                        currentPlaylist: details,
                      )),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: details == null
                  ? Colors.indigo
                  : details.playlistTag == 'stotra'
                      ? Colors.deepOrange
                      : details.color!),
          color: details == null
              ? ListFunctions
                  .advertisementList[advertisementNumber].backgroundColor
              : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            details == null
                ? Image(
                    image: AssetImage(
                      ListFunctions.advertisementList[advertisementNumber].icon,
                    ),
                    width: ListFunctions
                        .advertisementList[advertisementNumber].iconSize,
                    height: ListFunctions
                        .advertisementList[advertisementNumber].iconSize,
                    color: ListFunctions
                        .advertisementList[advertisementNumber].iconColor,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  )
                : details.playlistTag == 'stotra'
                    ? Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.deepOrange,
                        size: details.iconSize,
                      )
                    : Icon(
                        details.leadIcon,
                        color: details.color,
                        size: details.iconSize,
                      ),
            Text(
              details == null
                  ? ListFunctions.advertisementList[advertisementNumber].title
                  : details.playlistTag == 'stotra'
                      ? 'Pachhkhan'
                      : 'More From ${details.title}',
              style: GoogleFonts.lato(
                color: details == null
                    ? ListFunctions
                        .advertisementList[advertisementNumber].textColor
                    : details.playlistTag == 'stotra'
                        ? Colors.deepOrange
                        : details.color,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: details == null
                  ? ListFunctions
                      .advertisementList[advertisementNumber].textColor
                  : details.playlistTag == 'stotra'
                      ? Colors.deepOrange
                      : details.color,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  static Future<void> showUpdateDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Update Available'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Newer Version of app is available.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Press update button.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Services.launchURL(Globals.getAppPlayStoreUrl());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Icon clearIcon = const Icon(
    Icons.close,
    size: 20,
  );

  static Color? signatureColors({int value = 5}) {
    if (value == 0) {
      return Colors.amber;
    } else if (value == 1) {
      return Colors.pink[300];
    } else if (value == 2) {
      return Colors.green;
    } else if (value == 3) {
      return Colors.redAccent;
    } else {
      return Colors.indigo;
    }
  }

  static Widget showLogo({double scale = 0.6}) {
    return Transform.scale(
        scale: scale,
        child: Image.asset(
          'images/Logo.png',
          color: Globals.isDarkTheme ? Colors.white : Colors.indigo,
        ));
  }

  static void showToast(
    String message, {
    Toast toastLength = Toast.LENGTH_LONG,
    Color toastColor = Colors.indigo,
    Color textColor = Colors.white,
  }) {
    if (message.toLowerCase().contains("internet")) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: ToastGravity.SNACKBAR,
        textColor: textColor,
        backgroundColor: Colors.red,
      );
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: ToastGravity.SNACKBAR,
        textColor: textColor,
        backgroundColor: toastColor,
      );
    }
  }

  static void showSimpleToast(BuildContext context, String message,
      {int duration = 4}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      action: SnackBarAction(
        label: 'HIDE',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    );
    scaffold.showSnackBar(snackBar);
  }

  static Widget mainAppTitle() {
    return Text(
      'Stavan',
      style: GoogleFonts.itim(
        color: Globals.isDarkTheme ? Colors.white : Colors.indigo,
        fontSize: 30,
      ),
    );
  }
}
