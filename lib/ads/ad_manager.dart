import 'dart:io';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class AdManager {
  static void initializeFBAds() {
    print('Initialising FB ads.');
    FacebookAudienceNetwork.init();
  }

  static void loadAndShowFBInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: '491030148594375_491067548590635',
      listener: (result, value) {
        print(">> FB > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd();
        }
      },
    );
  }

  String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1265975785443681~2810280418";
    } else if (Platform.isIOS) {
      print('galat');
      return "Not yet defined";
    } else {
      print('galat');
      throw new UnsupportedError("Unsupported Platform");
    }
  }

  String get settingsNavigationBannerId {
    if (Platform.isAndroid) {
      print('returned correct');
      //TODO: Change this Banner ID when launching.
      return "ca-app-pub-3940256099942544/6300978111";
      //TODO: Uncomment below to see original ads. Above is test ad
      //return "ca-app-pub-1265975785443681/5970047796";
    } else if (Platform.isIOS) {
      return "Not yet defined";
    } else {
      throw new UnsupportedError("Unsupported Platform");
    }
  }

  String get songPageinterstitialId {
    if (Platform.isAndroid) {
      print('returned correct');
      return "ca-app-pub-1265975785443681/2850690740";
    } else if (Platform.isIOS) {
      return "Not yet defined";
    } else {
      throw new UnsupportedError("Unsupported Platform");
    }
  }
}
