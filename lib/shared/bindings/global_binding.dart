import 'package:get/get.dart';
import 'package:venturo_core/shared/controllers/global_controllers/initial_controller.dart';

class GlobalBinding implements Bindings {
 @override
 void dependencies() {
   Get.put(GlobalController());
 }
}