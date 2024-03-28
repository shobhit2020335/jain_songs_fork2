import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:skeleton_text/skeleton_text.dart';

class AstronomyBottomSheet extends StatefulWidget {
  final BuildContext context;

  const AstronomyBottomSheet(this.context, {super.key});

  @override
  State<AstronomyBottomSheet> createState() => _AstronomyBottomSheetState();
}

class _AstronomyBottomSheetState extends State<AstronomyBottomSheet> {
  Map<String, DateTime?>? astronomyData = {
    'date': null,
    'sunrise': null,
    'sunset': null,
    'navkarsi': null,
    'porsi': null,
    'sadhporsi': null,
    'chovihar': null,
  };

  DateTime? selectedDateTime;
  bool showProgress = true;
  bool isAnimatedOnce = false;

  //Fetches the data and shows loading
  Future<void> fetchData() async {
    setState(() {
      showProgress = true;
    });

    astronomyData = await NetworkHelper()
        .fetchAstronomyData(context, dateTime: selectedDateTime);

    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDateTime ??= DateTime.now();
    fetchData();
    initializeList();
    audioPlayer = AudioPlayer();
  }

  List<bool> isPlayingList = [];
  List<AudioPlayer> audioPlayers = [];

  void initializeList() {
    isPlayingList = List.generate(
      (astronomyData != null && astronomyData!.length > 3)
          ? astronomyData!.length - 3
          : 0,
      (index) => false,
    );

    // audioPlayers=List.generate(
    //   (astronomyData != null && astronomyData!.length > 3)
    //       ? astronomyData!.length - 3
    //       : 0,
    //       (index) => AudioPlayer(),
    // );
  }

  late AudioPlayer audioPlayer;

  // void disposeAudioPlayers(){}
  @override
  void dispose() {
    audioPlayer.dispose();
    // audioPlayers.
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
              color: Colors.grey[50]!,
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
                  color: Colors.white,
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
                                    'images/cat.gif',
                                    height: 200,
                                  ),
                                  isAnimatedOnce
                                      ? Text(
                                          'information',
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : AnimatedTextKit(
                                          isRepeatingAnimation: false,
                                          animatedTexts: [
                                            TyperAnimatedText(
                                              'information',
                                              textStyle: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
                          Image.asset(
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
                                  '${astronomyData!.values.toList()[1]?.hour}:${astronomyData!.values.toList()[1]?.minute}',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
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
                                    'images/cat.gif',
                                    height: 200,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  isAnimatedOnce
                                      ? Text(
                                          'information',
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : AnimatedTextKit(
                                          isRepeatingAnimation: false,
                                          animatedTexts: [
                                            TyperAnimatedText(
                                              'information',
                                              textStyle: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
                          Image.asset(
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
                                  '${astronomyData!.values.toList()[2]?.hour}:${astronomyData!.values.toList()[2]?.minute}',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
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
                    color: Colors.white,
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
                            String? information = await NetworkHelper()
                                .fetchDetailsForAstronomy(
                                    context,
                                    astronomyData!.keys.toList()[index + 3],
                                    '${astronomyData!.values.toList()[index + 3]?.hour}:${astronomyData!.values.toList()[index + 3]?.minute}');
                            if (information != null &&
                                information.isNotEmpty &&
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
                                        isAnimatedOnce
                                            ? Text(
                                                information,
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : AnimatedTextKit(
                                                isRepeatingAnimation: false,
                                                animatedTexts: [
                                                  TyperAnimatedText(
                                                    information,
                                                    textStyle: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
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
                                        width: 50,
                                        height: 50,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${astronomyData!.values.toList()[index + 3]?.hour}:${astronomyData!.values.toList()[index + 3]?.minute}',
                                            style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 5),
                                Text(
                                  UsefulFunction.toCamelCase(
                                      astronomyData!.keys.toList()[index + 3]),
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // InkWell(
                            //   onTap: () async {
                            //     setState(() {
                            //       // Toggle the play state for the corresponding item
                            //       isPlayingList[index] = !isPlayingList[index];
                            //     });
                            //     if (isPlayingList[index]) {
                            //       String url =
                            //           'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3';
                            //       await audioPlayer.play(UrlSource(url));
                            //     } else {
                            //       audioPlayer.pause();
                            //     }
                            //
                            //     // if (audioPlayer.state == PlayerState.playing) {
                            //     //   audioPlayer.pause();
                            //     // } else {
                            //     //   String url =
                            //     //       'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3';
                            //     //   await audioPlayer.play(UrlSource(url));
                            //     // }
                            //     // setState(() {});
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(10.0),
                            //     child: CircleAvatar(
                            //       radius: 16,
                            //       backgroundColor:
                            //           ConstWidget.signatureColors(),
                            //       child: Center(
                            //         child: Icon(
                            //           isPlayingList[index]
                            //               ? Icons.pause
                            //               : Icons.play_arrow_rounded,
                            //           color: Colors.white,
                            //           size: 18,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )

                            InkWell(
                              // onTap: () async {
                              //   setState(() {
                              //     // If the clicked item is already playing, pause it
                              //     if (currentlyPlayingIndex == index) {
                              //       audioPlayer.pause();
                              //       currentlyPlayingIndex =
                              //           null; // No item is playing
                              //     } else {
                              //       // If another item is playing, pause it
                              //       if (currentlyPlayingIndex != null) {
                              //         audioPlayer.pause();
                              //       }
                              //       // Start playing the new item's audio
                              //       String url = audioUrls[
                              //           index]; // Get the URL for the clicked item
                              //       audioPlayer.play(UrlSource(url));
                              //       currentlyPlayingIndex =
                              //           index; // Update the currently playing item's index
                              //     }
                              //   });
                              // },
                              onTap: () async {
                                // Perform asynchronous operations here
                                Duration? currentPosition;
                                if (currentlyPlayingIndex != null) {
                                  currentPosition =
                                      await audioPlayer.getCurrentPosition();
                                  playbackPositions[currentlyPlayingIndex!] =
                                      currentPosition ?? Duration.zero;
                                  await audioPlayer.pause();
                                }

                                setState(() {
                                  if (currentlyPlayingIndex == index) {
                                    currentlyPlayingIndex =
                                        null; // No item is playing
                                  } else {
                                    // Start playing the new item's audio
                                    String url = audioUrls[
                                        index]; // Get the URL for the clicked item
                                    // Resume playback from the last playback position if available
                                    Duration? lastPosition =
                                        playbackPositions[index];
                                    if (lastPosition != null) {
                                      audioPlayer.seek(lastPosition);
                                    }
                                    audioPlayer.play(UrlSource(url));
                                    currentlyPlayingIndex =
                                        index; // Update the currently playing item's index
                                  }
                                });
                              },

                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      ConstWidget.signatureColors(),
                                  child: Center(
                                    child: Icon(
                                      currentlyPlayingIndex == index
                                          ? Icons.pause
                                          : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
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
                    itemCount:
                        (astronomyData != null && astronomyData!.length > 3)
                            ? astronomyData!.length - 3
                            : 0,
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
                      selectedDateTime = pickedDate;
                      fetchData();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ConstWidget.signatureColors()!,
                      borderRadius: const BorderRadius.all(
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

  int? currentlyPlayingIndex;

  Map<int, Duration> playbackPositions = {};
  List<String> audioUrls = [
    'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3',
    'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3',
    'https://codeskulptor-demos.commondatastorage.googleapis.com/pang/paza-moduless.mp3',
    'https://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.mp3'
    // Add more URLs as needed
  ];
}
