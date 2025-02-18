import 'package:get/get.dart';
    class ListCheckoutVoucherController extends GetxController {
    static ListCheckoutVoucherController get to => Get.find();
      var selectedVoucher = ''.obs;
  var selectedVoucherAmount = 0.obs;

  void selectVoucher(String voucher,int amount) {
    selectedVoucher.value = voucher;
        selectedVoucherAmount.value = amount;

  }
    }