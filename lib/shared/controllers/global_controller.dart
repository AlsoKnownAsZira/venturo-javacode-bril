import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:venturo_core/constants/api_constant.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find<GlobalController>();

  var baseUrl = ApiConstant.production;
  var isStaging = false.obs;
  var isConnect = true.obs; // Track internet connection status

  /// Check internet connection
  Future<void> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      isConnect.value = false;
    } else {
      isConnect.value = true;
    }
  }
}
