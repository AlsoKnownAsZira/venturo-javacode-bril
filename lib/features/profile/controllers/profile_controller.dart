import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:device_info_plus/device_info_plus.dart';
class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  void privacyPolicyWebView() {
    Get.toNamed(MainRoute.privacyPolicy);
  }
    final RxString deviceModel = ''.obs;
  final RxString deviceVersion = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _getDeviceInfo();
  }
  void _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceModel.value = androidInfo.model;
    deviceVersion.value = androidInfo.version.release;
  }
}
