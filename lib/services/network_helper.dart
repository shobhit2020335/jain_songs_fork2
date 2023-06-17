import 'dart:io';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NetworkHelper {
  NetworkHelper();

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

  // Future<bool> checkConnectionMode() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     return true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> checkNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (error) {
      debugPrint('Net not connected due to: ' + error.toString());
      return false;
    }
    return false;
  }
}
