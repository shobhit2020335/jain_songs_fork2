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
        //Uncomment Below to create typed informationpage rather than webpage.
        // child: SingleChildScrollView(
        //   child: Container(
        //     padding: EdgeInsets.all(20),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             CircleAvatar(
        //               radius: 28,
        //               child: showLogo(),
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             RichText(
        //               text: TextSpan(
        //                 style: TextStyle(
        //                   fontSize: 40,
        //                   fontFamily: 'Pacifico',
        //                   fontWeight: FontWeight.w100,
        //                 ),
        //                 children: [
        //                   TextSpan(
        //                     text: 'S',
        //                     style: TextStyle(color: Colors.pink[300]),
        //                   ),
        //                   TextSpan(
        //                     text: 'T',
        //                     style: TextStyle(color: Colors.redAccent),
        //                   ),
        //                   TextSpan(
        //                     text: 'A',
        //                     style: TextStyle(color: Colors.amber),
        //                   ),
        //                   TextSpan(
        //                     text: 'V',
        //                     style: TextStyle(color: Colors.green),
        //                   ),
        //                   TextSpan(
        //                     text: 'A',
        //                     style: TextStyle(color: Colors.blue),
        //                   ),
        //                   TextSpan(
        //                     text: 'N',
        //                     style: TextStyle(color: Colors.deepOrange),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //         SizedBox(
        //           height: 20,
        //         ),
        //         Text(
        //           settingsDetails.subtitle,
        //           style: TextStyle(
        //               color: Colors.black,
        //               fontSize: 20,
        //               fontWeight: FontWeight.w500),
        //         ),
        //         SizedBox(
        //           height: 20,
        //         ),
        //         //This Text is main information text.
        //         Text(
        //           settingsDetails.information,
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 14,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
