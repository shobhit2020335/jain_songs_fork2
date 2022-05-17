import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/services/database/cloud_storage.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jain_songs/utilities/lists.dart';

class ConstWidget {
  static Future showPostsForStatus(BuildContext context) {
    int postNumber = 1;

    BetterPlayerConfiguration _configuration = BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        errorBuilder: (BuildContext context, String? errorMessage) {
          return const Center(
            child: Text(
              'Error Loading Video!\nTry Again!',
              textAlign: TextAlign.center,
            ),
          );
        });

    BetterPlayerDataSource _dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      ListFunctions.postsToShow[postNumber].url,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,
      ),
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: ListFunctions.postsToShow[postNumber].descriptionTitle,
        author: ListFunctions.postsToShow[postNumber].uploadedBy,
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/jain-songs-29c85.appspot.com/o/ic_launcher.png?alt=media&token=b6272e93-293d-4dd5-89cf-ac413f92b2d0',
        activityName: "MainActivity",
      ),
    );

    BetterPlayerController _betterPlayerController = BetterPlayerController(
      _configuration,
      betterPlayerDataSource: _dataSource,
    );

    if (ListFunctions.postsToShow[postNumber].type.toLowerCase() != 'video') {
      _betterPlayerController.dispose();
    }

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Status',
        pageBuilder: (context, animation1, animation2) {
          return StatefulBuilder(builder: (context, setStateInsideDialog) {
            _betterPlayerController
                .addEventsListener((BetterPlayerEvent event) {
              if (event.betterPlayerEventType ==
                  BetterPlayerEventType.initialized) {
                print('Better player controller initialzed');
                _betterPlayerController.setOverriddenAspectRatio(
                    _betterPlayerController
                        .videoPlayerController!.value.aspectRatio);

                if (ListFunctions.postsToShow[postNumber].type.toLowerCase() !=
                    'video') {
                  _betterPlayerController.dispose();
                }

                setStateInsideDialog(() {});
              }
            });
            return DefaultTextStyle(
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        ListFunctions.postsToShow[postNumber].type
                                    .toLowerCase() ==
                                'video'
                            ? BetterPlayer(controller: _betterPlayerController)
                            : CachedNetworkImage(
                                imageUrl:
                                    ListFunctions.postsToShow[postNumber].url,
                                placeholder: (context, url) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorWidget: (BuildContext context,
                                    String? errorMessage, dynamic) {
                                  return const Center(
                                    child: Text(
                                      'Error Loading Image!\nTry Again!',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setStateInsideDialog(() {
                                  postNumber--;
                                  if (postNumber < 0) {
                                    postNumber =
                                        ListFunctions.postsToShow.length - 1;
                                  }

                                  NetworkHelper()
                                      .checkNetworkConnection()
                                      .then((isConnected) {
                                    if (!isConnected) {
                                      ConstWidget.showToast(
                                        'No Internet Connection',
                                        toastColor: Colors.red,
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                    }
                                  });

                                  _dataSource = BetterPlayerDataSource(
                                    BetterPlayerDataSourceType.network,
                                    ListFunctions.postsToShow[postNumber].url,
                                    cacheConfiguration:
                                        const BetterPlayerCacheConfiguration(
                                      useCache: true,
                                      preCacheSize: 10 * 1024 * 1024,
                                      maxCacheSize: 10 * 1024 * 1024,
                                      maxCacheFileSize: 10 * 1024 * 1024,
                                    ),
                                    notificationConfiguration:
                                        BetterPlayerNotificationConfiguration(
                                      showNotification: true,
                                      title: ListFunctions
                                          .postsToShow[postNumber]
                                          .descriptionTitle,
                                      author: ListFunctions
                                          .postsToShow[postNumber].uploadedBy,
                                      imageUrl:
                                          'https://firebasestorage.googleapis.com/v0/b/jain-songs-29c85.appspot.com/o/ic_launcher.png?alt=media&token=b6272e93-293d-4dd5-89cf-ac413f92b2d0',
                                      activityName: "MainActivity",
                                    ),
                                  );

                                  _betterPlayerController =
                                      BetterPlayerController(
                                    _configuration,
                                    betterPlayerDataSource: _dataSource,
                                  );
                                });
                              },
                              child: const Icon(
                                Icons.arrow_circle_left_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setStateInsideDialog(() {
                                  postNumber++;
                                  if (postNumber >=
                                      ListFunctions.postsToShow.length) {
                                    postNumber = 0;
                                  }

                                  NetworkHelper()
                                      .checkNetworkConnection()
                                      .then((isConnected) {
                                    if (!isConnected) {
                                      ConstWidget.showToast(
                                        'No Internet Connection',
                                        toastColor: Colors.red,
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                    }
                                  });

                                  _dataSource = BetterPlayerDataSource(
                                    BetterPlayerDataSourceType.network,
                                    ListFunctions.postsToShow[postNumber].url,
                                    cacheConfiguration:
                                        const BetterPlayerCacheConfiguration(
                                      useCache: true,
                                      preCacheSize: 10 * 1024 * 1024,
                                      maxCacheSize: 10 * 1024 * 1024,
                                      maxCacheFileSize: 10 * 1024 * 1024,
                                    ),
                                    notificationConfiguration:
                                        BetterPlayerNotificationConfiguration(
                                      showNotification: true,
                                      title: ListFunctions
                                          .postsToShow[postNumber]
                                          .descriptionTitle,
                                      author: ListFunctions
                                          .postsToShow[postNumber].uploadedBy,
                                      imageUrl:
                                          'https://firebasestorage.googleapis.com/v0/b/jain-songs-29c85.appspot.com/o/ic_launcher.png?alt=media&token=b6272e93-293d-4dd5-89cf-ac413f92b2d0',
                                      activityName: "MainActivity",
                                    ),
                                  );

                                  _betterPlayerController =
                                      BetterPlayerController(
                                    _configuration,
                                    betterPlayerDataSource: _dataSource,
                                  );
                                });
                              },
                              child: const Icon(
                                Icons.arrow_circle_right_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              bool isSuccess = await NetworkHelper()
                                  .checkNetworkConnection();

                              if (!isSuccess) {
                                ConstWidget.showToast(
                                  'No Internet Connection',
                                  toastColor: Colors.red,
                                  toastLength: Toast.LENGTH_LONG,
                                );
                                return;
                              }

                              ConstWidget.showToast(
                                'Applying Status!',
                                toastColor: Colors.green,
                              );

                              CloudStorage()
                                  .downloadPost(
                                      ListFunctions.postsToShow[postNumber])
                                  .then((value) {
                                if (value == false) {
                                  debugPrint(
                                      'Error in applying status, try again!');
                                  ConstWidget.showToast(
                                    'Error Applying Status!',
                                    toastColor: Colors.red,
                                  );
                                } else {
                                  print('Success downloading status');
                                }
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Icon(
                                    Icons.whatsapp_outlined,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Apply Status',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  //This card is shown in song page as a whatapp status button
  static Widget statusCard({required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.whatsapp_outlined,
              color: Colors.white,
            ),
            Text(
              'Whatsapp Status',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(),
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
        return AlertDialog(
          title: const Text('Update Available'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Newer Version of app is available.',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Press update to update the app now.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                Services.launchPlayStore(Globals.getAppPlayStoreUrl());
              },
            ),
          ],
        );
      },
    );
  }

  static Icon clearIcon = const Icon(
    Icons.close,
    size: 20,
  );

  static Color? signatureColors({int value = 4}) {
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
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.SNACKBAR,
      textColor: textColor,
      backgroundColor: toastColor,
    );
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
