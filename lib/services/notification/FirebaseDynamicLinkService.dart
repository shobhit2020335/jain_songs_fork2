import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinkService {
  static FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  //To create Dynamic link like when someone is sharing product to other person.
  static Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://stavan.page.link',
      link: Uri.parse('https://stavan.com/song?code=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.JainDevelopers.jain_songs',
        minimumVersion: 4,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Stavan - Jain Bhajan with Lyrics',
        imageUrl: Uri.parse(
            'https://w7.pngwing.com/pngs/189/60/png-transparent-om-jain-symbols-jainism-tirthankara-religion-jain-blue-angle-text.png'),
        description: 'Listen to Jain stavan along with lyrics.',
      ),
    );

    final Uri dynamicUrl = await _dynamicLinks.buildLink(parameters);

    return dynamicUrl;
  }

  //Retreieves the dynamic link if fetched when app is terminated
  static Future<void> retrieveInitialDynamicLink(BuildContext context) async {
    final PendingDynamicLinkData? data = await _dynamicLinks.getInitialLink();
    final Uri? deepLink = data?.link;
    print(deepLink);

    if (deepLink != null) {
      // print('route from DL: ${deepLink.queryParameters['route']}');
      // print('code from DL: ${deepLink.queryParameters['code']}');
      Navigator.pushNamed(context, '/${deepLink.queryParameters['route']}',
          arguments: {
            'code': deepLink.queryParameters['code'],
          });
    }
  }

  //Retrieve dynamic link from stream when in foreground/background
  static Future<void> retrieveDynamicLink(BuildContext context) async {
    _dynamicLinks.onLink.listen((data) {
      final Uri? deepLink = data.link;
      if (deepLink != null) {
        Navigator.pushNamed(context, '/${deepLink.queryParameters['route']}',
            arguments: {
              'code': deepLink.queryParameters['code'],
            });
      }
    }).onError((error) {
      print('Error in retireve dynamic link foregroun/backgroun: $error');
    });
  }
}
