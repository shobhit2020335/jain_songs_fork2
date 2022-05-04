import 'dart:io';

class AdManager {
  static Future<InitialiaztionStatus> initAdmob() {
    return MobileAds().instance.initialize();
  }

  String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1265975785443681~2810280418";
    } else if (Platform.isIOS) {
      return "Not yet defined";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get nativeAdvanceSongPageId {
    return "ca-app-pub-1265975785443681/2637037904";
  }

  String get nativeAdvancedTestId {
    return "ca-app-pub-3940256099942544/2247696110";
  }

  String get nativeAdvancedVideoTestId {
    return "ca-app-pub-3940256099942544/1044960115";
  }

  String get interstitialTestId {
    return "ca-app-pub-3940256099942544/1033173712";
  }

  String get interstitialVideoTestId {
    return 'ca-app-pub-3940256099942544/8691691433';
  }
}
