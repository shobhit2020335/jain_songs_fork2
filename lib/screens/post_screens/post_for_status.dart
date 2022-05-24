import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/services/database/cloud_storage.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/lists.dart';

class PostForStatus extends StatefulWidget {
  const PostForStatus({Key? key}) : super(key: key);

  @override
  State<PostForStatus> createState() => _PostForStatusState();
}

class _PostForStatusState extends State<PostForStatus> {
  bool showProgress = false;
  double betterPlayerAspectRatio = 1;

  final PageController _pageController = PageController(
    keepPage: false,
  );

  final BetterPlayerConfiguration _configuration = BetterPlayerConfiguration(
      autoPlay: true,
      looping: true,
      fit: BoxFit.contain,
      errorBuilder: (BuildContext context, String? errorMessage) {
        return const Center(
          child: Text(
            'Error Loading Video!\nTry Again!',
            textAlign: TextAlign.center,
          ),
        );
      });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget visibleWigetFromType(String type, int postNumber) {
    type = type.toLowerCase();
    if (type == 'video') {
      return BetterPlayer.network(
        ListFunctions.postsToShow[postNumber].url,
        betterPlayerConfiguration: _configuration,
      );
    } else if (type == 'image') {
      return CachedNetworkImage(
        imageUrl: ListFunctions.postsToShow[postNumber].url,
        placeholder: (context, url) {
          debugPrint('Loading image');
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorWidget: (BuildContext context, String? errorMessage, dynamic) {
          return const Center(
            child: Text(
              'Error Loading Image!\nTry Again!',
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: ListFunctions.postsToShow.length,
      onPageChanged: (postNumber) {},
      itemBuilder: (context, postNumber) {
        return DefaultTextStyle(
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
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
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              color: Colors.white,
                            ),
                          )
                        : visibleWigetFromType(
                            ListFunctions.postsToShow[postNumber].type,
                            postNumber),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: postNumber > 0,
                          child: GestureDetector(
                            onTap: () async {
                              _pageController.previousPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.ease,
                              );

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
                            },
                            child: const Icon(
                              Icons.arrow_circle_left_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              postNumber < ListFunctions.postsToShow.length - 1,
                          child: GestureDetector(
                            onTap: () async {
                              _pageController.nextPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.ease,
                              );

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
                            },
                            child: const Icon(
                              Icons.arrow_circle_right_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
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
                          bool isSuccess =
                              await NetworkHelper().checkNetworkConnection();

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
                                'Error, Try Again!',
                                toastColor: Colors.red,
                              );
                            } else {
                              debugPrint('Success downloading status');
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      },
    );
  }
}
