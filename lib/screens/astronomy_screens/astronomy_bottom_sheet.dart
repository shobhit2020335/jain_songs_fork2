import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/services/ui_settings.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:skeleton_text/skeleton_text.dart';

class AstronomyBottomSheet extends StatefulWidget {
  final BuildContext context;

  const AstronomyBottomSheet(this.context, {super.key});

  @override
  State<AstronomyBottomSheet> createState() => _AstronomyBottomSheetState();
}

class _AstronomyBottomSheetState extends State<AstronomyBottomSheet> {
  Map<String, DateTime?>? sunriseSunsetData = {
    'date': null,
    'sunrise': null,
    'sunset': null,
  };

  DateTime? selectedDateTime;
  bool showProgress = true;
  bool isAnimatedOnce = false;

  int? currentlyPlayingIndex;

  //Fetches the data and shows loading
  Future<void> fetchData() async {
    try {
      setState(() {
        showProgress = true;
      });

      sunriseSunsetData = await NetworkHelper()
          .fetchAstronomyData(context, dateTime: selectedDateTime);

      if (sunriseSunsetData == null || sunriseSunsetData!.isEmpty) {
        // ignore: use_build_context_synchronously
        ConstWidget.showSimpleToast(
            context, "Error getting data. Try again later!");
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }

      setState(() {
        showProgress = false;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ConstWidget.showSimpleToast(context, "Error: $e");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Future<void> disposeAudioPlayers() async {
    for (int i = 0; i < ListFunctions.pachchhkhanList.length; i++) {
      ListFunctions.pachchhkhanList[i].disposeAudioPlayer();
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateTime ??= DateTime.now();
    fetchData();
  }

  @override
  void dispose() {
    disposeAudioPlayers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: UISettings.themeData(Globals.isDarkTheme, context)
                  .progressIndicatorTheme
                  .color,
            ),
            padding: const EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: 20,
            ),
            child: Column(
              children: [
                Container(
                  color: UISettings.themeData(Globals.isDarkTheme, context)
                      .progressIndicatorTheme
                      .color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Pachhkhan',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        height: 0,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (_) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/sunrise_white.png',
                                    height: 120,
                                  ),
                                  Text(
                                    UsefulFunction.getFormattedTime(
                                        sunriseSunsetData!.values
                                            .toList()[1]!
                                            .hour,
                                        sunriseSunsetData!.values
                                            .toList()[1]!
                                            .minute),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Touch anywhere to exit!',
                                    style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Globals.isDarkTheme
                              ? Image.asset(
                                  'images/sunrise_white.png',
                                  height: 40,
                                  // color: UISettings.themeData(Globals.isDarkTheme, context).primaryColorLight,
                                )
                              : Image.asset(
                                  'images/sunrise.png',
                                  height: 40,
                                ),
                          showProgress
                              ? SkeletonAnimation(
                                  shimmerDuration: 1300,
                                  child: Container(
                                    height: 12,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                    ),
                                    margin: const EdgeInsets.only(top: 5),
                                  ),
                                )
                              : Text(
                                  UsefulFunction.getFormattedTime(
                                      sunriseSunsetData!.values
                                          .toList()[1]!
                                          .hour,
                                      sunriseSunsetData!.values
                                          .toList()[1]!
                                          .minute),
                                  style: GoogleFonts.lato(
                                    color: UISettings.themeData(
                                            Globals.isDarkTheme, context)
                                        .primaryColorLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (_) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/sunset_white.png',
                                    height: 120,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    UsefulFunction.getFormattedTime(
                                        sunriseSunsetData!.values
                                            .toList()[2]!
                                            .hour,
                                        sunriseSunsetData!.values
                                            .toList()[2]!
                                            .minute),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Touch anywhere to exit!',
                                    style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Globals.isDarkTheme
                              ? Image.asset(
                                  'images/sunset_white.png',
                                  height: 40,
                                )
                              : Image.asset(
                                  'images/sunset.png',
                                  height: 40,
                                ),
                          showProgress
                              ? SkeletonAnimation(
                                  shimmerDuration: 1300,
                                  child: Container(
                                    height: 12,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                    ),
                                    margin: const EdgeInsets.only(top: 5),
                                  ),
                                )
                              : Text(
                                  UsefulFunction.getFormattedTime(
                                      sunriseSunsetData!.values
                                          .toList()[2]!
                                          .hour,
                                      sunriseSunsetData!.values
                                          .toList()[2]!
                                          .minute),
                                  style: GoogleFonts.lato(
                                    color: UISettings.themeData(
                                            Globals.isDarkTheme, context)
                                        .primaryColorLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    color: UISettings.themeData(Globals.isDarkTheme, context)
                        .backgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (content, index) {
                      return InkWell(
                        onTap: () async {
                          if (showProgress == false) {
                            if (ListFunctions
                                    .pachchhkhanList[index].steps.isNotEmpty &&
                                context.mounted) {
                              await showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder: (_) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // isAnimatedOnce
                                        //     ?
                                        Text(
                                          ListFunctions
                                              .pachchhkhanList[index].steps,
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        //     : AnimatedTextKit(
                                        //   isRepeatingAnimation: false,
                                        //   animatedTexts: [
                                        //     TyperAnimatedText(
                                        //       ListFunctions
                                        //           .pachchhkhanList[index]
                                        //           .steps,
                                        //       textStyle: GoogleFonts.lato(
                                        //         color: Colors.white,
                                        //         fontSize: 13,
                                        //         fontWeight:
                                        //         FontWeight.bold,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        const SizedBox(height: 30),
                                        Text(
                                          'Touch anywhere to exit!',
                                          style: GoogleFonts.lato(
                                            color: Colors.red,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              isAnimatedOnce = true;
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                showProgress
                                    ? SkeletonAnimation(
                                        shimmerDuration: 1300,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                ConstWidget.signatureColors(),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(14),
                                            ),
                                          ),
                                          width: 50,
                                          height: 50,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: ConstWidget.signatureColors(),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                        ),
                                        width: 80,
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            UsefulFunction.getFormattedTime(
                                                ListFunctions
                                                    .pachchhkhanList[index]
                                                    .dateTimeOfOccurrence!
                                                    .hour,
                                                ListFunctions
                                                    .pachchhkhanList[index]
                                                    .dateTimeOfOccurrence!
                                                    .minute),
                                            style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 10),
                                Text(
                                  ListFunctions.pachchhkhanList[index].name,
                                  style: GoogleFonts.lato(
                                    color: UISettings.themeData(
                                            Globals.isDarkTheme, context)
                                        .primaryColorLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: ListFunctions
                                          .pachchhkhanList[index].mp3Links !=
                                      null &&
                                  ListFunctions.pachchhkhanList[index].mp3Links!
                                      .isNotEmpty,
                              child:

                                  //     InkWell(
                                  //   onTap: () async {
                                  //     // Perform asynchronous operations here
                                  //     Duration? currentPosition;
                                  //     if (currentlyPlayingIndex != null) {
                                  //       currentPosition = await ListFunctions
                                  //           .pachchhkhanList[currentlyPlayingIndex!]
                                  //           .audioPlayer
                                  //           ?.getCurrentPosition();
                                  //       ListFunctions
                                  //               .pachchhkhanList[currentlyPlayingIndex!]
                                  //               .lastPlayedPosition =
                                  //           currentPosition ?? Duration.zero;
                                  //       await ListFunctions
                                  //           .pachchhkhanList[currentlyPlayingIndex!]
                                  //           .audioPlayer
                                  //           ?.pause();
                                  //     }
                                  //
                                  //     setState(() {
                                  //       if (currentlyPlayingIndex == index) {
                                  //         currentlyPlayingIndex =
                                  //             null; // No item is playing
                                  //       } else {
                                  //         // Resume playback from the last playback position if available
                                  //         Duration lastPosition = ListFunctions
                                  //             .pachchhkhanList[index]
                                  //             .lastPlayedPosition;
                                  //
                                  //         ListFunctions
                                  //             .pachchhkhanList[index].audioPlayer
                                  //             ?.play(
                                  //           UrlSource(ListFunctions
                                  //               .pachchhkhanList[index]
                                  //               .mp3Links![0]),
                                  //           position: lastPosition,
                                  //         );
                                  //
                                  //         // Update the currently playing item's index
                                  //         currentlyPlayingIndex = index;
                                  //         ListFunctions.pachchhkhanList[index]
                                  //             .audioPlayer?.onPlayerComplete
                                  //             .listen((event) {
                                  //           setState(() {
                                  //             currentlyPlayingIndex = null;
                                  //           });
                                  //         });
                                  //       }
                                  //     });
                                  //   },
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(10.0),
                                  //     child: Row(
                                  //       children: [
                                  //         CircleAvatar(
                                  //           radius: 16,
                                  //           backgroundColor:
                                  //               ConstWidget.signatureColors(),
                                  //           child: Center(
                                  //             child: Icon(
                                  //               currentlyPlayingIndex == index
                                  //                   ? Icons.pause
                                  //                   : Icons.play_arrow_rounded,
                                  //               color: Colors.white,
                                  //               size: 18,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         if (currentlyPlayingIndex ==
                                  //             index) // Render stop button only if this audio is playing
                                  //           SizedBox(width: 10),
                                  //         if (currentlyPlayingIndex == index)
                                  //           InkWell(
                                  //             onTap: () async {
                                  //               // Stop audio playback
                                  //               await ListFunctions
                                  //                   .pachchhkhanList[index]
                                  //                   .audioPlayer
                                  //                   ?.stop();
                                  //
                                  //               // Update state to reflect that no item is playing
                                  //               setState(() {
                                  //                 currentlyPlayingIndex = null;
                                  //               });
                                  //             },
                                  //             child: CircleAvatar(
                                  //               radius: 16,
                                  //               backgroundColor:
                                  //                   ConstWidget.signatureColors(),
                                  //               child: Center(
                                  //                 child: Icon(
                                  //                   Icons.stop,
                                  //                   color: Colors.white,
                                  //                   size: 18,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  InkWell(
                                onTap: () async {
                                  // Perform asynchronous operations here
                                  if (await NetworkHelper()
                                      .checkNetworkConnection()) {
                                    Duration? currentPosition;
                                    if (currentlyPlayingIndex != null) {
                                      currentPosition = await ListFunctions
                                          .pachchhkhanList[
                                              currentlyPlayingIndex!]
                                          .audioPlayer
                                          ?.getCurrentPosition();
                                      ListFunctions
                                              .pachchhkhanList[
                                                  currentlyPlayingIndex!]
                                              .lastPlayedPosition =
                                          currentPosition ?? Duration.zero;
                                      await ListFunctions
                                          .pachchhkhanList[
                                              currentlyPlayingIndex!]
                                          .audioPlayer
                                          ?.pause();
                                    }

                                    setState(() {
                                      if (currentlyPlayingIndex == index) {
                                        currentlyPlayingIndex =
                                            null; // No item is playing
                                      } else {
                                        ListFunctions.isAudioLoading[index] =
                                            true;
                                        Duration lastPosition = ListFunctions
                                            .pachchhkhanList[index]
                                            .lastPlayedPosition;

                                        ListFunctions
                                            .pachchhkhanList[index].audioPlayer
                                            ?.play(
                                          UrlSource(ListFunctions
                                              .pachchhkhanList[index]
                                              .mp3Links![0]),
                                          position: lastPosition,
                                        );

                                        currentlyPlayingIndex = index;
                                        ListFunctions.pachchhkhanList[index]
                                            .audioPlayer?.onPlayerComplete
                                            .listen((event) {
                                          setState(() {
                                            currentlyPlayingIndex = null;
                                          });
                                        });

                                        ListFunctions.pachchhkhanList[index]
                                            .audioPlayer?.onPlayerStateChanged
                                            .listen((state) {
                                          if (state == PlayerState.playing ||
                                              state == PlayerState.paused) {
                                            setState(() {
                                              ListFunctions
                                                      .isAudioLoading[index] =
                                                  false;
                                            });
                                          }
                                        });
                                      }
                                    });
                                  } else {
                                    // ConstWidget.showSimpleToast(context,
                                    //     "Please check your internet connection");
                                    ConstWidget.showToast(
                                        "Please check your internet connection");
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                ConstWidget.signatureColors(),
                                            child: Center(
                                              child: Icon(
                                                currentlyPlayingIndex ==
                                                            index &&
                                                        !ListFunctions
                                                                .isAudioLoading[
                                                            index]
                                                    ? Icons.pause
                                                    : Icons.play_arrow_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          if (ListFunctions
                                              .isAudioLoading[index])
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                              // valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                                            ),
                                        ],
                                      ),
                                      if (currentlyPlayingIndex == index &&
                                          !ListFunctions.isAudioLoading[index])
                                        SizedBox(width: 10),
                                      if (currentlyPlayingIndex == index &&
                                          !ListFunctions.isAudioLoading[index])
                                        InkWell(
                                          onTap: () async {
                                            // Stop audio playback
                                            await ListFunctions
                                                .pachchhkhanList[index]
                                                .audioPlayer
                                                ?.stop();
                                            ListFunctions.pachchhkhanList[index]
                                                    .lastPlayedPosition =
                                                Duration(
                                                    seconds: 0, minutes: 0);
                                            setState(() {
                                              currentlyPlayingIndex = null;
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                ConstWidget.signatureColors(),
                                            child: Center(
                                              child: Icon(
                                                Icons.stop,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (content, index) {
                      return const SizedBox(height: 5);
                    },
                    itemCount: ListFunctions.pachchhkhanList.length,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    children: [
                      TextSpan(text: 'Data as per you Location📍'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateTime,
                      firstDate: DateTime(2024, 1, 1),
                      lastDate: DateTime(2030, 12, 31),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: ConstWidget.signatureColors()!,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: ConstWidget.signatureColors()!,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null && context.mounted) {
                      if (await NetworkHelper().checkConnectionMode()) {
                        selectedDateTime = pickedDate;
                        fetchData();
                      } else {
                        ConstWidget.showToast(
                            "Please check your internet connection");
                      }
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.all(
                        Radius.circular(14),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          selectedDateTime == null ||
                                  (selectedDateTime!.day ==
                                          DateTime.now().day &&
                                      selectedDateTime!.month ==
                                          DateTime.now().month &&
                                      selectedDateTime!.year ==
                                          DateTime.now().year)
                              ? 'TODAY'
                              : '${selectedDateTime!.day} ${Globals.monthMapping[selectedDateTime!.month]} ${selectedDateTime!.year}',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Services.launchURL('https://sunrisesunset.io/');
                  },
                  child: RichText(
                      text: const TextSpan(
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(text: 'Powered By '),
                      TextSpan(
                        text: 'sunrisesunset.io',
                        style: TextStyle(
                          color: Color(0xFF3861F6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
