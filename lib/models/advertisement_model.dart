import 'package:flutter/material.dart';

class AdvertisementModel {
  final String advertisementId;
  final String companyName;
  final String companyURL;

  ///Number of times your ad appeared on the screen.
  int impressions;
  int clicks;

  ///The percentage of user engaged with your ad. Clicks/Impressions %.
  int engagement;

  final String title;
  final String icon;
  final Color? iconColor;
  final Color backgroundColor;
  final Color textColor;
  final double iconSize;

  final DateTime? advertisementStartDate;
  final DateTime? expectedEndAdvertisementEndDate;
  final int payment;

  AdvertisementModel({
    required this.advertisementId,
    required this.companyName,
    required this.companyURL,
    required this.title,
    required this.icon,
    this.clicks = 0,
    this.impressions = 0,
    this.engagement = 0,
    this.iconColor,
    this.backgroundColor = Colors.indigo,
    this.textColor = Colors.white,
    this.iconSize = 45,
    this.advertisementStartDate,
    this.expectedEndAdvertisementEndDate,
    this.payment = 0,
  });
}
