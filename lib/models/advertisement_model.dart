import 'package:flutter/material.dart';

class AdvertisementModel {
  final String advertisementId;
  final String companyName;
  final String companyURL;

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
    this.iconColor,
    this.backgroundColor = Colors.indigo,
    this.textColor = Colors.white,
    this.iconSize = 45,
    this.advertisementStartDate,
    this.expectedEndAdvertisementEndDate,
    this.payment = 0,
  });
}
