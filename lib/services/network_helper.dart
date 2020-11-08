import 'package:connectivity/connectivity.dart';
import 'package:jain_songs/utilities/lists.dart';

class NetworkHelper {
  NetworkHelper();

  void changeDate() {
    todayDate = DateTime.now();
    print(todayDate);
    var diffDate = todayDate.difference(startDate);
    totalDays = diffDate.inDays;
    print(totalDays);
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
