import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:venturo_core/constants/api_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/utils/services/location_service.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:geolocator/geolocator.dart';
import 'package:venturo_core/features/initial/views/ui/get_location_screen.dart';

class GlobalController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    fetchLocation();
    LocationServices.streamService.listen((status) => fetchLocation());

    id.value = Hive.box('venturo').get("id", defaultValue: "");
    name.value = Hive.box('venturo').get("name", defaultValue: "");
    photo.value = Hive.box('venturo').get("photo", defaultValue: "");
  }

  var id = ''.obs;
  var name = ''.obs;
  var photo = ''.obs;
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

  /// Location
  RxString statusLocation = RxString('loading');
  RxString messageLocation = RxString('');
  Rxn<Position> position = Rxn<Position>();
  RxnString address = RxnString();

  Future<LocationResult> fetchLocation() async {
    try {
      statusLocation.value = 'loading';
      final locationResult = await LocationServices.getCurrentPosition();

      if (locationResult.success) {
        position.value = locationResult.position;
        address.value = locationResult.address;
        statusLocation.value = 'success';
      } else if (locationResult.far) {
        statusLocation.value = 'far';
        position.value = locationResult.position;
        address.value = locationResult.address;
      } else {
        statusLocation.value = 'error';
        messageLocation.value = locationResult.message!;
      }
      return locationResult;
    } catch (e) {
      statusLocation.value = 'error';
      messageLocation.value = 'Server error'.tr;
      return LocationResult.error(message: 'Server error'.tr);
    }
  }

  Future<void> getLocation() async {
    if (Get.isDialogOpen == false) {
      Get.dialog(const GetLocationScreen(), barrierDismissible: false);
    }

    try {
      final locationResult = await fetchLocation();

      if (locationResult.success) {
        await Future.delayed(const Duration(seconds: 3));
        Get.offAllNamed(MainRoute.list);
      } else if (locationResult.far) {
        await Future.delayed(const Duration(seconds: 3));
        Get.snackbar("Lokasi tidak dekat!",
            "Lokasi anda tidak dekat dengan lokasi Venturo");
        Get.offAllNamed(MainRoute.list);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("error ngambil lokasi!",
          "Pastikan lokasi anda aktif dan izin lokasi diaktifkan");
    }
  }
}
