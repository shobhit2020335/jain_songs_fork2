import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/utilities/globals.dart';

class AdmobHelper {
  bool isTestAd = true;

  ///Set isTestAd false for using production Ads.
  AdmobHelper({this.isTestAd = true}) {
    if (Globals.isDebugMode) {
      isTestAd = true;
    }
  }

  ///This is test ID for banner ads.
  String admobBannerTestAdId = "ca-app-pub-3940256099942544/6300978111";

  ///THis ad id is for the banner ad at the bottom of the home page with low floor.
  ///Low floor means it will always be filled with ads even if the ad pays low prices.
  String admobHomePageBottomBannerLowFloorAdId =
      "ca-app-pub-1265975785443681/8577578224";

  ///THis ad id is for the banner ad at the bottom of the home page with medium floor.
  ///Medium floor means it will optimize with low paying and high paying ads.
  String admobHomePageBottomBannerMediumFloorAdId =
      "ca-app-pub-1265975785443681/6317126836";

  ///THis ad id is for the banner ad at the bottom of the home page with high floor.
  ///High floor means it will be filled with high paying ads but this doesnt
  ///guarantee ads will be filled.
  String admobHomePageBottomBannerHighFloorAdId =
      "ca-app-pub-1265975785443681/5297094175";

  ///This function initializes google mobile ads actually. For admob to work
  ///google mobile ads initialize is required
  Future<void> initAdmob() async {
    await MobileAds.instance.initialize();
  }

  ///Loads the home page bottom banner ad. Type of this ad can be changed with
  ///remote config. Options are: Low Floor, Medium Floor, High Floor, All.
  BannerAd loadHomePageBottomBannerAd({
    void Function(Ad)? onAdLoaded,
    void Function(Ad, LoadAdError)? onAdFailedToLoaded,
    void Function(Ad)? onAdClicked,
  }) {
    String currentAdmobId = isTestAd
        ? admobBannerTestAdId
        : admobHomePageBottomBannerMediumFloorAdId;

    return BannerAd(
      size: AdSize.banner,
      adUnitId: currentAdmobId,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoaded,
        onAdClicked: onAdClicked,
      ),
      request: const AdRequest(),
    )..load();
  }
}
