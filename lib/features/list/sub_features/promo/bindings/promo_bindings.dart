import 'package:get/get.dart';
import 'package:venturo_core/features/list/sub_features/promo/controllers/list_promo_controller.dart';
    class PromoBindings extends Bindings {
      @override
      void dependencies() {
        Get.put(ListPromoController());
      }
    }
    