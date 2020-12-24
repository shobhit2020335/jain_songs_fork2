import 'package:connectivity/connectivity.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/lists.dart';

class NetworkHelper {
  NetworkHelper();

  Future<void> changeDate() async {
    todayDate = DateTime.now();
    var diffDate = todayDate.difference(startDate);
    totalDays = diffDate.inDays;
    await FireStoreHelper().fetchDays();
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
