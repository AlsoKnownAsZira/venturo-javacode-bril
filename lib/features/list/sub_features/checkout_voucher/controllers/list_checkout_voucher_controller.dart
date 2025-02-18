import 'package:get/get.dart';
    class ListCheckoutVoucherController extends GetxController {
    static ListCheckoutVoucherController get to => Get.find();
      var selectedVoucher = ''.obs;

  void selectVoucher(String voucher) {
    selectedVoucher.value = voucher;
  }
    }