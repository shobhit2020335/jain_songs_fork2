import 'package:animated_text_kit/animated_text_kit.dart';
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
                    Column(
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
                    Column(
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
                            InkWell(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: ConstWidget.signatureColors(),
                                child: const Center(
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 18,
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
}
