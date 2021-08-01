import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';

void launchURL(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    showSimpleToast(
      context,
      'Starting YouTube!',
    );
    await launch(url);
  } else {
    showSimpleToast(
      context,
      'Could not launch the song!',
    );
  }
}

void launchPlayStore(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    FirebaseCrashlytics.instance.log('Error on clicking update in dialog');
  }
}

String urlBeforeCode =
    'https://stavan.page.link/?link=https://stavan.com/song?route%3Dsong%26code%3D';
String urlAfterCode =
    '&apn=com.JainDevelopers.jain_songs&amv=4&st=Stavan+-+Jain+Bhajan+with+Lyrics&sd=Listen+to+Jain+stavan+along+with+lyrics.&si=https://pbs.twimg.com/media/EfXqpDHUwAAVQHa.jpg';

void shareApp(String? name, String? code) async {
  if (name != null && code != null) {
    await FlutterShare.share(
      title: 'Google Play link',
      text: 'Find lyrics and listen to *$name* and other *Jain bhajans* on:',
      linkUrl: '$urlBeforeCode$code$urlAfterCode',
    );
  }
}

void sendEmail() async {
  String subject = 'Feedback and Support: ';
  String email = 'stavan.co.j@gmail.com';

  // Code to get system info for android.
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.model}');

  String body = '\n\n\nDO NOT DELETE \n{' +
      androidInfo.androidId +
      '\n' +
      androidInfo.brand +
      '\n' +
      androidInfo.device +
      '\n' +
      androidInfo.manufacturer +
      '\n' +
      androidInfo.model +
      '\n' +
      androidInfo.version.sdkInt.toString() +
      '\n}';
  var url = 'mailto:$email?subject=$subject&body=$body';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
