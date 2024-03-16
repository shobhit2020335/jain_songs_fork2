import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';

class AstronomyBottomSheet {
  final BuildContext context;
  Map<String, DateTime>? astronomyData;
  DateTime? selectedDateTime;

  AstronomyBottomSheet(this.context, {this.selectedDateTime}) {
    selectedDateTime ??= DateTime.now();
  }

  //Fetches the data and shows loading
  Future<void> fetchData() async {
    //Shows loading
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context2) {
        return Padding(
          padding: MediaQuery.of(context2).viewInsets,
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
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          ),
        );
      },
    );

    if (context.mounted) {
      astronomyData = await NetworkHelper()
          .fetchAstronomyData(context, dateTime: selectedDateTime);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> show() async {
    await fetchData();

    if (context.mounted && astronomyData != null && astronomyData!.isNotEmpty) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context2) {
          return Padding(
            padding: MediaQuery.of(context2).viewInsets,
            child: StatefulBuilder(builder: (context, setStateInsideSheet) {
              return SingleChildScrollView(
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
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
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ConstWidget.signatureColors(
                                              value: index % 5),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${astronomyData!.values.toList()[index + 3].hour}:${astronomyData!.values.toList()[index + 3].minute}',
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
                                            astronomyData!.keys
                                                .toList()[index + 3]),
                                        style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        ConstWidget.signatureColors(),
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (content, index) {
                              return const SizedBox(height: 5);
                            },
                            itemCount: astronomyData!.length - 3,
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
                                        foregroundColor:
                                            ConstWidget.signatureColors()!,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null && context.mounted) {
                              selectedDateTime = pickedDate;
                              Navigator.of(context).pop();
                              show();
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
                            child: Center(
                              child: Text(
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
              );
            }),
          );
        },
      );
    }
  }
}
