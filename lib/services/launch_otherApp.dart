import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';

void launchURL(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    showToast(context, 'Starting YouTube!');
    await launch(url);
  } else {
    showToast(context, 'Could not launch the song!');
  }
}

void shareApp(String name) async {
  await FlutterShare.share(
    title: 'Google Play link',
    text: 'Find lyrics and listen to *$name* and other *Jain bhajans* on:',
    linkUrl: 'https://play.google.com/store/apps',
  );
}

void sendEmail() async {
  String subject = 'Feedback and Support: ';
  String email = 'stavan.co.j@gmail.com';

  // Code to get system info for android.
  //TODO: Include for IOS also.
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.model}');

  String body = '\n\n\nDO NOT DELETE\n{' +
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
      '}';
  var url = 'mailto:$email?subject=$subject&body=$body';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
