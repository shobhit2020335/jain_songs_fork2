import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/services/database/cloud_storage.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/lists.dart';

class PostForStatus {
  int postNumber = 0;
  bool showProgress = true;

  BetterPlayerController? _betterPlayerController;
  final BetterPlayerConfiguration _configuration = BetterPlayerConfiguration(
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
  BetterPlayerDataSource? _dataSource;

  //Initiliazes the better player and other things required for the dialog
  void _initState() async {
    showProgress = true;
    postNumber = 0;

    await _initializeNewPost();

    showProgress = false;
  }

  //Disposes the better player when song is changed or dialog is cleared
  Future<void> _dispose() async {
    await _betterPlayerController?.pause();
    _betterPlayerController?.removeEventsListener((p0) {
      debugPrint('Removing existing better player controller listener: $p0');
    });
    //Try force dispose
    _betterPlayerController?.dispose();
    _betterPlayerController = null;
    debugPrint('Better player controller disposed for postNumber: $postNumber');
  }

  Future<bool> _initializeNewPost() async {
    try {
      await _dispose();
      if (ListFunctions.postsToShow[postNumber].type.toLowerCase() == 'video') {
        debugPrint('Initializing new video');
        _dataSource = BetterPlayerDataSource(
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

        _betterPlayerController = BetterPlayerController(
          _configuration,
          betterPlayerDataSource: _dataSource,
        );

        _betterPlayerController!.addEventsListener((BetterPlayerEvent event) {
          if (event.betterPlayerEventType ==
              BetterPlayerEventType.initialized) {
            _betterPlayerController?.setOverriddenAspectRatio(
                _betterPlayerController!
                    .videoPlayerController!.value.aspectRatio);
          }
        });
      }
      return true;
    } catch (e) {
      print('Error initializing new video: $e');
      return false;
    }
  }

  Future showPostsForStatus(BuildContext context) {
    _initState();

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Status',
        pageBuilder: (context, animation1, animation2) {
          return StatefulBuilder(builder: (context, setStateInsideDialog) {
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
                        showProgress
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListFunctions.postsToShow[postNumber].type
                                        .toLowerCase() ==
                                    'video'
                                ? BetterPlayer(
                                    controller: _betterPlayerController!)
                                : CachedNetworkImage(
                                    imageUrl: ListFunctions
                                        .postsToShow[postNumber].url,
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
                              onTap: () async {
                                showProgress = true;
                                setStateInsideDialog(() {});
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

                                bool isSuccess = await _initializeNewPost();

                                showProgress = false;
                                setStateInsideDialog(() {});
                              },
                              child: const Icon(
                                Icons.arrow_circle_left_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                showProgress = true;
                                setStateInsideDialog(() {});
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

                                bool isSuccess = await _initializeNewPost();

                                showProgress = false;
                                setStateInsideDialog(() {});
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
                              showProgress = true;
                              setStateInsideDialog(() {});
                              _dispose();
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
}
