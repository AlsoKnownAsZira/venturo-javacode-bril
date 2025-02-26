import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/features/profile/repositories/profile_repository.dart';
import 'package:venturo_core/features/sign_in/controllers/sign_in_controller.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  void privacyPolicyWebView() {
    Get.toNamed(MainRoute.privacyPolicy);
  }

  var userProfile = {}.obs;
  var isLoading = true.obs;
  final RxString deviceModel = ''.obs;
  final RxString deviceVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initDeviceInfo();
    loadUserProfile();
  }

  Future<void> _initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel.value = androidInfo.model;
        deviceVersion.value = androidInfo.version.release;
      } else if (GetPlatform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel.value = iosInfo.utsname.machine;
        deviceVersion.value = iosInfo.systemVersion;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get device info: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      var box = Hive.box('venturo');

      await box.clear();

      SignInController.to.emailCtrl.clear();
      SignInController.to.passwordCtrl.clear();

      userProfile.value = {};
      isLoading.value = true;

      Get.offAllNamed(MainRoute.signIn); 
    } catch (e) {
      Get.snackbar("Error", "Failed to sign out: $e");
    }
  }

  void fetchUserProfile() async {
    try {
      isLoading(true);
      var profile = await ProfileRepository().fetchUserProfile();
      userProfile.value = profile;
      saveUserProfile(profile); // Save profile locally
    } finally {
      isLoading(false);
    }
  }

  void saveUserProfile(Map<String, dynamic> profile) async {
    var box = Hive.box('venturo');
    await box.put('userProfile', profile);
  }

  void loadUserProfile() async {
    var box = Hive.box('venturo');
    var profile = box.get('userProfile');
    if (profile != null) {
      userProfile.value = profile;
      isLoading.value = false;
    } else {
      fetchUserProfile();
    }
  }

  void updateUserProfile(Map<String, dynamic> updatedProfile) async {
    userProfile.value = updatedProfile;
    saveUserProfile(updatedProfile);
  }
}