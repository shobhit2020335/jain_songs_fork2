import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/models/pachchhkhan_model.dart';
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
  int? currentlyPlayingIndex1;
  int? currentlyPlayingIndex2;
  bool isMorningOpen = false;
  bool isTapOpen = false;
  bool isEveningOpen = false;

  void initializeTime() {
    DateTime currentTime = DateTime.now();

    // Desired time to compare against (11:15 AM)
    TimeOfDay morningTime = const TimeOfDay(hour: 11, minute: 15);
    TimeOfDay noonTime = const TimeOfDay(hour: 15, minute: 30);
    TimeOfDay eveTime = const TimeOfDay(hour: 23, minute: 59);

    TimeOfDay currentTimeOfDay = TimeOfDay.fromDateTime(currentTime);

    bool isMorningTime = currentTimeOfDay.hour < morningTime.hour ||
        (currentTimeOfDay.hour == morningTime.hour &&
            currentTimeOfDay.minute <= morningTime.minute);
    bool isNoonTime = (currentTimeOfDay.hour < noonTime.hour ||
        (currentTimeOfDay.hour == noonTime.hour &&
                currentTimeOfDay.minute <= noonTime.minute) &&
            (currentTimeOfDay.hour > morningTime.hour ||
                (currentTimeOfDay.hour == morningTime.hour &&
                    currentTimeOfDay.minute > morningTime.minute)));

    // bool isBetweenMorningAndNoon = isMorningTime && !isBeforeNoonTime;

    bool isEveTime = (currentTimeOfDay.hour < eveTime.hour ||
        (currentTimeOfDay.hour == eveTime.hour &&
                currentTimeOfDay.minute < eveTime.minute) &&
            (currentTimeOfDay.hour > noonTime.hour ||
                (currentTimeOfDay.hour == noonTime.hour &&
                    currentTimeOfDay.minute > noonTime.minute)));

    if (isMorningTime) {
      isMorningOpen = true;
    } else if (isNoonTime) {
      isTapOpen = true;
    } else if (isEveTime) {
      isEveningOpen = true;
    }
    setState(() {});
  }

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

  String formatDate(DateTime dateTime) {
    String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
    return formattedDate;
  }

  // String formatDate(DateTime dateTime) {
  //   // Format the date
  //   String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
  //   // Add the suffix to the day
  //   formattedDate = '${dateTime.day}${_addSuffix(dateTime.day)} $formattedDate';
  //   return formattedDate;
  // }

  // String _addSuffix(int day) {
  //   if (day >= 11 && day <= 13) {
  //     return 'th';
  //   }
  //   switch (day % 10) {
  //     case 1:
  //       return 'st';
  //     case 2:
  //       return 'nd';
  //     case 3:
  //       return 'rd';
  //     default:
  //       return 'th';
  //   }
  // }
  Future<void> disposeAudioPlayers() async {
    for (int i = 0; i < ListFunctions.morningList.length; i++) {
      ListFunctions.morningList[i].disposeAudioPlayer();
      ListFunctions.tapList[i].disposeAudioPlayer();
      ListFunctions.eveningList[i].disposeAudioPlayer();
    }
  }

  void pauseOtherCategories(String category) {
    print('pause other called');
    print('category : $category');

    switch (category) {
      case 'Morning':
        for (PachchhkhanModel model in ListFunctions.tapList) {
          model.audioPlayer!.pause();
        }
        for (PachchhkhanModel model in ListFunctions.eveningList) {
          model.audioPlayer!.pause();
        }
        currentlyPlayingIndex1 = null;
        currentlyPlayingIndex2 = null;

      case 'Tap':
        for (PachchhkhanModel model in ListFunctions.morningList) {
          model.audioPlayer!.pause();
        }
        for (PachchhkhanModel model in ListFunctions.eveningList) {
          model.audioPlayer!.pause();
        }
        currentlyPlayingIndex = null;
        currentlyPlayingIndex2 = null;
      case 'Evening':
        for (PachchhkhanModel model in ListFunctions.tapList) {
          model.audioPlayer!.pause();
        }
        for (PachchhkhanModel model in ListFunctions.morningList) {
          model.audioPlayer!.pause();
        }
        currentlyPlayingIndex1 = null;
        currentlyPlayingIndex = null;
    }
    setState(() {});
  }

  // void initializeLists() {
  //
  //   for (int i = 0; i < ListFunctions.pachchhkhanList.length; i++) {
  //     PachchhkhanModel model = ListFunctions.pachchhkhanList[i];
  //     String cat = model.categoryName;
  //     if (cat == 'Morning') {
  //       morningList.add(model);
  //     } else if (cat == 'Tap') {
  //       tapList.add(model);
  //     } else {
  //       eveningList.add(model);
  //     }
  //   }
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    selectedDateTime ??= DateTime.now();
    fetchData();
    initializeTime();
    // initializeLists();
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
                      if (selectedDateTime != null)
                        Text(
                          formatDate(selectedDateTime!),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        )
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMorningOpen = false;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Morning',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        if (isMorningOpen)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Transform.rotate(
                              angle: -1.57, // 90 degrees in radians
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
                  child: isMorningOpen
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (content, index) {
                            return InkWell(
                              onTap: () async {
                                if (showProgress == false) {
                                  if (ListFunctions.morningList[index].steps
                                          .isNotEmpty &&
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
                                                    .morningList[index].steps,
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 13,
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
                                    isAnimatedOnce = true;
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (ListFunctions.morningList[index]
                                              .dateTimeOfOccurrence !=
                                          null)
                                        showProgress
                                            ? SkeletonAnimation(
                                                shimmerDuration: 1300,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ConstWidget
                                                        .signatureColors(),
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
                                                  color: ConstWidget
                                                      .signatureColors(),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(14),
                                                  ),
                                                ),
                                                width: 80,
                                                height: 50,
                                                child: Center(
                                                  child: ListFunctions
                                                              .morningList[
                                                                  index]
                                                              .dateTimeOfOccurrence !=
                                                          null
                                                      ? Text(
                                                          UsefulFunction.getFormattedTime(
                                                              ListFunctions
                                                                  .morningList[
                                                                      index]
                                                                  .dateTimeOfOccurrence!
                                                                  .hour,
                                                              ListFunctions
                                                                  .morningList[
                                                                      index]
                                                                  .dateTimeOfOccurrence!
                                                                  .minute),
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      : Text('hi'),
                                                ),
                                              ),
                                      const SizedBox(width: 10),
                                      Text(
                                        ListFunctions.morningList[index].name,
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
                                                .morningList[index].mp3Links !=
                                            null &&
                                        ListFunctions.morningList[index]
                                            .mp3Links!.isNotEmpty,
                                    child: InkWell(
                                      onTap: () async {
                                        HapticFeedback.lightImpact();
                                        // Perform asynchronous operations here
                                        if (await NetworkHelper()
                                            .checkNetworkConnection()) {
                                          Duration? currentPosition;
                                          if (currentlyPlayingIndex != null) {
                                            currentPosition =
                                                await ListFunctions
                                                    .morningList[
                                                        currentlyPlayingIndex!]
                                                    .audioPlayer
                                                    ?.getCurrentPosition();
                                            ListFunctions
                                                    .morningList[
                                                        currentlyPlayingIndex!]
                                                    .lastPlayedPosition =
                                                currentPosition ??
                                                    Duration.zero;
                                            await ListFunctions
                                                .morningList[
                                                    currentlyPlayingIndex!]
                                                .audioPlayer
                                                ?.pause();
                                          }

                                          setState(() {
                                            if (currentlyPlayingIndex ==
                                                index) {
                                              currentlyPlayingIndex =
                                                  null; // No item is playing
                                            } else {
                                              pauseOtherCategories('Morning');
                                              ListFunctions.morningAudioLoading[
                                                  index] = true;

                                              Duration lastPosition =
                                                  ListFunctions
                                                      .morningList[index]
                                                      .lastPlayedPosition;

                                              ListFunctions.morningList[index]
                                                  .audioPlayer
                                                  ?.play(
                                                UrlSource(ListFunctions
                                                    .morningList[index]
                                                    .mp3Links![0]),
                                                position: lastPosition,
                                              );

                                              currentlyPlayingIndex = index;
                                              ListFunctions.morningList[index]
                                                  .audioPlayer?.onPlayerComplete
                                                  .listen((event) {
                                                setState(() {
                                                  currentlyPlayingIndex = null;
                                                });
                                              });

                                              ListFunctions
                                                  .morningList[index]
                                                  .audioPlayer
                                                  ?.onPlayerStateChanged
                                                  .listen((state) {
                                                if (state ==
                                                        PlayerState.playing ||
                                                    state ==
                                                        PlayerState.paused) {
                                                  setState(() {
                                                    ListFunctions
                                                            .morningAudioLoading[
                                                        index] = false;
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
                                                  backgroundColor: ConstWidget
                                                      .signatureColors(),
                                                  child: Center(
                                                    child: Icon(
                                                      currentlyPlayingIndex ==
                                                                  index &&
                                                              !ListFunctions
                                                                      .morningAudioLoading[
                                                                  index]
                                                          ? Icons.pause
                                                          : Icons
                                                              .play_arrow_rounded,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                                if (ListFunctions
                                                    .morningAudioLoading[index])
                                                  CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                    // valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                                                  ),
                                              ],
                                            ),
                                            if (currentlyPlayingIndex ==
                                                    index &&
                                                !ListFunctions
                                                    .morningAudioLoading[index])
                                              SizedBox(width: 10),
                                            if (currentlyPlayingIndex ==
                                                    index &&
                                                !ListFunctions
                                                    .morningAudioLoading[index])
                                              InkWell(
                                                onTap: () async {
                                                  HapticFeedback.lightImpact();
                                                  // Stop audio playback
                                                  await ListFunctions
                                                      .morningList[index]
                                                      .audioPlayer
                                                      ?.stop();
                                                  ListFunctions
                                                          .morningList[index]
                                                          .lastPlayedPosition =
                                                      Duration(
                                                          seconds: 0,
                                                          minutes: 0);
                                                  setState(() {
                                                    currentlyPlayingIndex =
                                                        null;
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: ConstWidget
                                                      .signatureColors(),
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
                          itemCount: ListFunctions.morningList.length,
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isMorningOpen = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              (ListFunctions
                                                          .morningList.length >
                                                      2
                                                  ? 2
                                                  : ListFunctions
                                                      .morningList.length);
                                          i++)
                                        Text(
                                          ListFunctions.morningList[i].name +
                                              (i <
                                                      (ListFunctions.morningList
                                                                  .length >
                                                              2
                                                          ? 1
                                                          : 0)
                                                  ? ', '
                                                  : ''),
                                          style: GoogleFonts.lato(
                                            color: UISettings.themeData(
                                                    Globals.isDarkTheme,
                                                    context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      if (ListFunctions.morningList.length > 2)
                                        Text(
                                          '  +${ListFunctions.morningList.length - 2} more',
                                          style: GoogleFonts.lato(
                                            color: UISettings.themeData(
                                                    Globals.isDarkTheme,
                                                    context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Transform.rotate(
                                  angle: 1.57, // 90 degrees in radians
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isTapOpen = false;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Tap',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        if (isTapOpen)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Transform.rotate(
                              angle: -1.57, // 90 degrees in radians
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
                  child: isTapOpen
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (content, index) {
                            return InkWell(
                              onTap: () async {
                                if (showProgress == false) {
                                  if (ListFunctions
                                          .tapList[index].steps.isNotEmpty &&
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
                                                    .tapList[index].steps,
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 13,
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
                                    isAnimatedOnce = true;
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (ListFunctions.tapList[index]
                                              .dateTimeOfOccurrence !=
                                          null)
                                        showProgress
                                            ? SkeletonAnimation(
                                                shimmerDuration: 1300,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ConstWidget
                                                        .signatureColors(),
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
                                                  color: ConstWidget
                                                      .signatureColors(),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(14),
                                                  ),
                                                ),
                                                width: 80,
                                                height: 50,
                                                child: Center(
                                                  child: ListFunctions
                                                              .tapList[index]
                                                              .dateTimeOfOccurrence !=
                                                          null
                                                      ? Text(
                                                          UsefulFunction
                                                              .getFormattedTime(
                                                                  ListFunctions
                                                                      .tapList[
                                                                          index]
                                                                      .dateTimeOfOccurrence!
                                                                      .hour,
                                                                  ListFunctions
                                                                      .tapList[
                                                                          index]
                                                                      .dateTimeOfOccurrence!
                                                                      .minute),
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      : Text('hi'),
                                                ),
                                              ),
                                      const SizedBox(width: 10),
                                      Text(
                                        ListFunctions.tapList[index].name,
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
                                    visible:
                                        ListFunctions.tapList[index].mp3Links !=
                                                null &&
                                            ListFunctions.tapList[index]
                                                .mp3Links!.isNotEmpty,
                                    child: InkWell(
                                      onTap: () async {
                                        HapticFeedback.lightImpact();
                                        // Perform asynchronous operations here
                                        if (await NetworkHelper()
                                            .checkNetworkConnection()) {
                                          Duration? currentPosition;
                                          if (currentlyPlayingIndex1 != null) {
                                            currentPosition =
                                                await ListFunctions
                                                    .tapList[
                                                        currentlyPlayingIndex1!]
                                                    .audioPlayer
                                                    ?.getCurrentPosition();
                                            ListFunctions
                                                    .tapList[
                                                        currentlyPlayingIndex1!]
                                                    .lastPlayedPosition =
                                                currentPosition ??
                                                    Duration.zero;
                                            await ListFunctions
                                                .tapList[
                                                    currentlyPlayingIndex1!]
                                                .audioPlayer
                                                ?.pause();
                                          }

                                          setState(() {
                                            if (currentlyPlayingIndex1 ==
                                                index) {
                                              currentlyPlayingIndex1 =
                                                  null; // No item is playing
                                            } else {
                                              pauseOtherCategories('Tap');
                                              ListFunctions
                                                      .tapAudioLoading[index] =
                                                  true;
                                              Duration lastPosition =
                                                  ListFunctions.tapList[index]
                                                      .lastPlayedPosition;

                                              ListFunctions
                                                  .tapList[index].audioPlayer
                                                  ?.play(
                                                UrlSource(ListFunctions
                                                    .tapList[index]
                                                    .mp3Links![0]),
                                                position: lastPosition,
                                              );

                                              currentlyPlayingIndex1 = index;
                                              ListFunctions.tapList[index]
                                                  .audioPlayer?.onPlayerComplete
                                                  .listen((event) {
                                                setState(() {
                                                  currentlyPlayingIndex1 = null;
                                                });
                                              });

                                              ListFunctions
                                                  .tapList[index]
                                                  .audioPlayer
                                                  ?.onPlayerStateChanged
                                                  .listen((state) {
                                                if (state ==
                                                        PlayerState.playing ||
                                                    state ==
                                                        PlayerState.paused) {
                                                  setState(() {
                                                    ListFunctions
                                                            .tapAudioLoading[
                                                        index] = false;
                                                  });
                                                }
                                              });
                                            }
                                          });
                                        } else {
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
                                                  backgroundColor: ConstWidget
                                                      .signatureColors(),
                                                  child: Center(
                                                    child: Icon(
                                                      currentlyPlayingIndex1 ==
                                                                  index &&
                                                              !ListFunctions
                                                                      .tapAudioLoading[
                                                                  index]
                                                          ? Icons.pause
                                                          : Icons
                                                              .play_arrow_rounded,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                                if (ListFunctions
                                                    .tapAudioLoading[index])
                                                  CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                              ],
                                            ),
                                            if (currentlyPlayingIndex1 ==
                                                    index &&
                                                !ListFunctions
                                                    .tapAudioLoading[index])
                                              SizedBox(width: 10),
                                            if (currentlyPlayingIndex1 ==
                                                    index &&
                                                !ListFunctions
                                                    .tapAudioLoading[index])
                                              InkWell(
                                                onTap: () async {
                                                  HapticFeedback.lightImpact();
                                                  // Stop audio playback
                                                  await ListFunctions
                                                      .tapList[index]
                                                      .audioPlayer
                                                      ?.stop();
                                                  ListFunctions.tapList[index]
                                                          .lastPlayedPosition =
                                                      Duration(
                                                          seconds: 0,
                                                          minutes: 0);
                                                  setState(() {
                                                    currentlyPlayingIndex1 =
                                                        null;
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: ConstWidget
                                                      .signatureColors(),
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
                          itemCount: ListFunctions.tapList.length,
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isTapOpen = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              (ListFunctions.tapList.length > 2
                                                  ? 2
                                                  : ListFunctions
                                                      .tapList.length);
                                          i++)
                                        Text(
                                          (i == 1
                                                  ? ListFunctions
                                                          .tapList[i].name
                                                          .substring(0, 9) +
                                                      '...'
                                                  : ListFunctions
                                                      .tapList[i].name) +
                                              (i <
                                                      (ListFunctions.tapList
                                                                  .length >
                                                              2
                                                          ? 1
                                                          : 0)
                                                  ? ', '
                                                  : ''),
                                          style: GoogleFonts.lato(
                                            color: UISettings.themeData(
                                                    Globals.isDarkTheme,
                                                    context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      if (ListFunctions.tapList.length > 2)
                                        Text(
                                          '  +${ListFunctions.tapList.length - 2} more',
                                          style: GoogleFonts.lato(
                                            color: UISettings.themeData(
                                                    Globals.isDarkTheme,
                                                    context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Transform.rotate(
                                  angle: 1.57, // 90 degrees in radians
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEveningOpen = false;
                        // expandMap[categoryName] = false;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Evening',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        if (isEveningOpen)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Transform.rotate(
                              angle: -1.57, // 90 degrees in radians
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
                  child: isEveningOpen
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (content, index) {
                            return InkWell(
                              onTap: () async {
                                if (showProgress == false) {
                                  if (ListFunctions.eveningList[index].steps
                                          .isNotEmpty &&
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
                                              Text(
                                                ListFunctions
                                                    .eveningList[index].steps,
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 13,
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
                                    isAnimatedOnce = true;
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (ListFunctions.eveningList[index]
                                              .dateTimeOfOccurrence !=
                                          null)
                                        showProgress
                                            ? SkeletonAnimation(
                                                shimmerDuration: 1300,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ConstWidget
                                                        .signatureColors(),
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
                                                  color: ConstWidget
                                                      .signatureColors(),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(14),
                                                  ),
                                                ),
                                                width: 80,
                                                height: 50,
                                                child: Center(
                                                  child: ListFunctions
                                                              .eveningList[
                                                                  index]
                                                              .dateTimeOfOccurrence !=
                                                          null
                                                      ? Text(
                                                          UsefulFunction.getFormattedTime(
                                                              ListFunctions
                                                                  .eveningList[
                                                                      index]
                                                                  .dateTimeOfOccurrence!
                                                                  .hour,
                                                              ListFunctions
                                                                  .eveningList[
                                                                      index]
                                                                  .dateTimeOfOccurrence!
                                                                  .minute),
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      : Text('hi'),
                                                ),
                                              ),
                                      const SizedBox(width: 10),
                                      Text(
                                        ListFunctions.eveningList[index].name,
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
                                                .eveningList[index].mp3Links !=
                                            null &&
                                        ListFunctions.eveningList[index]
                                            .mp3Links!.isNotEmpty,
                                    child: InkWell(
                                      onTap: () async {
                                        HapticFeedback.lightImpact();
                                        if (await NetworkHelper()
                                            .checkNetworkConnection()) {
                                          Duration? currentPosition;
                                          if (currentlyPlayingIndex2 != null) {
                                            currentPosition =
                                                await ListFunctions
                                                    .eveningList[
                                                        currentlyPlayingIndex2!]
                                                    .audioPlayer
                                                    ?.getCurrentPosition();
                                            ListFunctions
                                                    .eveningList[
                                                        currentlyPlayingIndex2!]
                                                    .lastPlayedPosition =
                                                currentPosition ??
                                                    Duration.zero;
                                            await ListFunctions
                                                .eveningList[
                                                    currentlyPlayingIndex2!]
                                                .audioPlayer
                                                ?.pause();
                                          }

                                          setState(() {
                                            if (currentlyPlayingIndex2 ==
                                                index) {
                                              currentlyPlayingIndex2 = null;
                                            } else {
                                              pauseOtherCategories('Evening');
                                              ListFunctions.eveningAudioLoading[
                                                  index] = true;
                                              Duration lastPosition =
                                                  ListFunctions
                                                      .eveningList[index]
                                                      .lastPlayedPosition;

                                              ListFunctions.eveningList[index]
                                                  .audioPlayer
                                                  ?.play(
                                                UrlSource(ListFunctions
                                                    .eveningList[index]
                                                    .mp3Links![0]),
                                                position: lastPosition,
                                              );

                                              currentlyPlayingIndex2 = index;
                                              ListFunctions.eveningList[index]
                                                  .audioPlayer?.onPlayerComplete
                                                  .listen((event) {
                                                setState(() {
                                                  currentlyPlayingIndex2 = null;
                                                });
                                              });

                                              ListFunctions
                                                  .eveningList[index]
                                                  .audioPlayer
                                                  ?.onPlayerStateChanged
                                                  .listen((state) {
                                                if (state ==
                                                        PlayerState.playing ||
                                                    state ==
                                                        PlayerState.paused) {
                                                  setState(() {
                                                    ListFunctions
                                                            .eveningAudioLoading[
                                                        index] = false;
                                                  });
                                                }
                                              });
                                            }
                                          });
                                        } else {
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
                                                  backgroundColor: ConstWidget
                                                      .signatureColors(),
                                                  child: Center(
                                                    child: Icon(
                                                      currentlyPlayingIndex2 ==
                                                                  index &&
                                                              !ListFunctions
                                                                      .eveningAudioLoading[
                                                                  index]
                                                          ? Icons.pause
                                                          : Icons
                                                              .play_arrow_rounded,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                                if (ListFunctions
                                                    .eveningAudioLoading[index])
                                                  CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                              ],
                                            ),
                                            if (currentlyPlayingIndex2 ==
                                                    index &&
                                                !ListFunctions
                                                    .eveningAudioLoading[index])
                                              SizedBox(width: 10),
                                            if (currentlyPlayingIndex2 ==
                                                    index &&
                                                !ListFunctions
                                                    .eveningAudioLoading[index])
                                              InkWell(
                                                onTap: () async {
                                                  HapticFeedback.lightImpact();
                                                  await ListFunctions
                                                      .eveningList[index]
                                                      .audioPlayer
                                                      ?.stop();
                                                  ListFunctions
                                                          .eveningList[index]
                                                          .lastPlayedPosition =
                                                      Duration(
                                                          seconds: 0,
                                                          minutes: 0);
                                                  setState(() {
                                                    currentlyPlayingIndex2 =
                                                        null;
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: ConstWidget
                                                      .signatureColors(),
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
                          itemCount: ListFunctions.eveningList.length,
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isEveningOpen = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              (ListFunctions
                                                          .eveningList.length >
                                                      2
                                                  ? 2
                                                  : ListFunctions
                                                      .eveningList.length);
                                          i++)
                                        Text(
                                          ListFunctions.eveningList[i].name +
                                              (i <
                                                      (ListFunctions.eveningList
                                                                  .length >
                                                              1
                                                          ? 1
                                                          : 0)
                                                  ? ', '
                                                  : ''),
                                          style: GoogleFonts.lato(
                                            color: UISettings.themeData(
                                                    Globals.isDarkTheme,
                                                    context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      if (ListFunctions.eveningList.length > 2)
                                        Text(
                                          '  +${ListFunctions.eveningList.length - 2} more',
                                          style: GoogleFonts.lato(
                                            color: UISettings.themeData(
                                                    Globals.isDarkTheme,
                                                    context)
                                                .primaryColorLight,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Transform.rotate(
                                  angle: 1.57, // 90 degrees in radians
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    HapticFeedback.lightImpact();
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
                              ? 'Calendar'
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
