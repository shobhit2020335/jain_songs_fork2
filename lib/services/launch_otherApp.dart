import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

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
