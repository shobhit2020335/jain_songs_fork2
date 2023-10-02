import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/settings_details.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InformationPage extends StatelessWidget {
  final SettingsDetails settingsDetails;
  final WebViewController webViewController = WebViewController();

  InformationPage(this.settingsDetails, {Key? key}) : super(key: key) {
    String uri;
    if (settingsDetails.title == 'About') {
      uri = 'https://stavancoj.wixsite.com/website/about';
    } else {
      uri = 'https://stavancoj.wixsite.com/website/privacypolicy';
    }

    webViewController.loadRequest(Uri.parse(uri));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsDetails.title),
      ),
      //TODO: Test this, as this is changed
      body: SafeArea(
        child: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}
