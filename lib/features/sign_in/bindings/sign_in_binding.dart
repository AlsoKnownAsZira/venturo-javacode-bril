import 'package:get/get.dart';
import 'package:venturo_core/features/sign_in/controllers/sign_in_controller.dart';
    class SignInBinding extends Bindings {
      @override
      void dependencies() {
        Get.put(SignInController());
      }
    }
    