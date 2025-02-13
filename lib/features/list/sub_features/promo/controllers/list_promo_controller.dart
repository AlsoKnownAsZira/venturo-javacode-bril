import 'package:get/get.dart';
import 'package:venturo_core/features/list/sub_features/promo/repositories/promo_repository.dart';
    class ListPromoController extends GetxController {
    static ListPromoController get to => Get.find();
    var promoList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPromoList();
    super.onInit();
  }

  void fetchPromoList() async {
    try {
      isLoading(true);
      var promos = await PromoRepository().fetchPromoList();
      if (promos != null) {
        promoList.assignAll(promos);
      }
    } finally {
      isLoading(false);
    }
  }
    }