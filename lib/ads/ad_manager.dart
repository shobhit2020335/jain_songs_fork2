import 'dart:io';

class AdManager {
  String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1265975785443681~2810280418";
    } else if (Platform.isIOS) {
      return "Not yet defined";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get settingsNavigationBannerId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
      //TODO: Uncomment below to see original ads. Above is test ad
      //return "ca-app-pub-1265975785443681/5970047796";
    } else if (Platform.isIOS) {
      return "Not yet defined";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get songPageinterstitialId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1265975785443681/2850690740";
    } else if (Platform.isIOS) {
      return "Not yet defined";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  String get testInterstitialId {
    return "ca-app-pub-3940256099942544/1033173712";
  }

  String get testInterstitialVideoId {
    return 'ca-app-pub-3940256099942544/8691691433';
  }
}
