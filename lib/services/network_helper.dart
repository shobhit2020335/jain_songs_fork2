import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NetworkHelper {
  NetworkHelper();

  //This fetches the sunrise and sunset timings from API with lat and long data
  Future<Map<String, DateTime>?> fetchAstronomyData(BuildContext context,
      {DateTime? dateTime}) async {
    try {
      bool isInternetConnected = await checkNetworkConnection();

      if (!isInternetConnected && context.mounted) {
        ConstWidget.showSimpleToast(
            context, 'Please check your internet connection!');
      }

      var (double latitude, double longitude) =
          await Services.fetchLatitudeLongitudeData();

      dateTime ??= DateTime.now();

      final dio = Dio();
      Response response = await dio.get(
        'https://api.sunrisesunset.io/json',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'timezone': 'IST',
          'date': DateFormat('yyyy-MM-dd')
              .parse(dateTime.toString())
              .toString()
              .split(' ')[0]
        },
      );

      Map<String, dynamic> astronomyResponse = (response.data
          as Map<String, dynamic>)['results'] as Map<String, dynamic>;

      String sunriseTimeString = UsefulFunction.convertTimeTo24HourFormat(
          astronomyResponse['sunrise']);
      DateTime sunriseDateTime =
          DateTime.parse(astronomyResponse['date'] + ' ' + sunriseTimeString);

      String sunsetTimeString =
          UsefulFunction.convertTimeTo24HourFormat(astronomyResponse['sunset']);
      DateTime sunsetDateTime =
          DateTime.parse(astronomyResponse['date'] + ' ' + sunsetTimeString);

      Map<String, DateTime> sunriseSunsetData = {};
      sunriseSunsetData['date'] = DateTime.now();
      sunriseSunsetData['sunrise'] = sunriseDateTime;
      sunriseSunsetData['sunset'] = sunsetDateTime;

      if (ListFunctions.pachchhkhanList.isEmpty && context.mounted) {
        bool isSuccess = await DatabaseController().fetchPachchhkhans(context);
        if (isSuccess == false) {
          print("Data fetching issue from database for pachchhkhan");
          throw ("check internet and try again!");
        }
      }

      for (int i = 0; i < ListFunctions.pachchhkhanList.length; i++) {
        ListFunctions.pachchhkhanList[i].setDateTimeOfOccurrence(
            sunriseDateTime: sunriseDateTime, sunsetDateTime: sunsetDateTime);
      }

      return sunriseSunsetData;
    } catch (e) {
      debugPrint("Error fetching astronomy data: $e");
      return null;
    }
  }

  Future<void> changeDateAndVersion() async {
    Globals.todayDate = DateTime.now();
    var diffDate = Globals.todayDate.difference(Globals.startDate);
    Globals.totalDays = diffDate.inDays;
    await FireStoreHelper().fetchDaysAndVersion();
  }

  //Package_info is used to get the information about the app name and version.
  //It is not used anywhere. Dont know where it was used previously.
  Future<String> getPackageInfo(String appInfoName) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    if (appInfoName == 'appName') {
      return appName;
    } else if (appInfoName == 'packageName') {
      return packageName;
    } else if (appInfoName == 'version') {
      return version;
    } else {
      return buildNumber;
    }
  }

  //This function check if we are on wifi or mobile data.
  //It is currently not used anywhere.
  Future<bool> checkConnectionMode() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (error) {
      debugPrint('Net not connected due to: ${error.toString()}');
      return false;
    }
    return false;
  }
}
