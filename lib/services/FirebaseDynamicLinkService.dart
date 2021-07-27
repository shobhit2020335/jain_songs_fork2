import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinkService {
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
    var dynamicUrl = await parameters.buildUrl();
    print(dynamicUrl);
    parameters.buildShortLink().then((value) => print(value.shortUrl));

    return dynamicUrl;
  }

  static Future<void> retrieveInitialDynamicLink(BuildContext context) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    print(deepLink);

    if (deepLink != null) {
      print('route from DL: ${deepLink.queryParameters['route']}');
      print('code from DL: ${deepLink.queryParameters['code']}');
      Navigator.pushNamed(context, '/${deepLink.queryParameters['route']}',
          arguments: {
            'code': deepLink.queryParameters['code'],
          });
    }
  }

  static Future<void> retrieveDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          print('route from DL: ${deepLink.queryParameters['route']}');
          print('code from DL: ${deepLink.queryParameters['code']}');
          Navigator.pushNamed(context, '/${deepLink.queryParameters['route']}',
              arguments: {
                'code': deepLink.queryParameters['code'],
              });
        }
      },
      onError: (error) async {
        print('ghusa in on link errors');
      },
    );
  }
}
