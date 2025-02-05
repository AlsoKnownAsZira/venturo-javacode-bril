import 'package:get/get.dart';

class SplashController extends GetxController {
  var opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    animateLogo();
  }

  void animateLogo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    opacity.value = 1.0;
    await Future.delayed(const Duration(seconds: 2));
    navigateToProfile();
  }

  void navigateToProfile() {
    Get.offAndToNamed('/sign_in');
  }
}