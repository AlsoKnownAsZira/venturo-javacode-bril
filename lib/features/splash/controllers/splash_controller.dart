import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/shared/controllers/global_controllers/initial_controller.dart';

class SplashController extends GetxController {
  var opacity = 0.0.obs;

  @override
  void onInit() {
    _navigateBasedOnSession();

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

  void _navigateBasedOnSession() async {
    await Future.delayed(
        const Duration(seconds: 3)); 
    var box = Hive.box('venturo');
    bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
    if (isLoggedIn) {
      Get.offAllNamed(MainRoute.checkloc); 
    } else {
      Get.offAllNamed(
          MainRoute.signIn); 
    }
  }
}
