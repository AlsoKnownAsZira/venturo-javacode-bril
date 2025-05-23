import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/list/sub_features/checkout_voucher/controllers/list_checkout_voucher_controller.dart';
import '../components/checkout_voucher_card.dart';

class CheckoutVoucherScreen extends StatelessWidget {
  CheckoutVoucherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ListCheckoutVoucherController());

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Pilih Voucher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(MainRoute.checkoutVoucherDetail, arguments: {
                    'title': "Birthday",
                    'amount': 100000,
                    'imageUrl': ImageConstant.promoco1,
                    'description':
                        "Selamat ulang tahun, teman-teman sekantor selalu mendoakanmu sehat, bahagia, panjang umur, agar bisa jadi pribadi yang lebih baik dari tahun-tahun sebelumnya",
                    'expiredIn': "1 Day",
                  });
                },
                child: CheckoutVoucher(
                  title: "Birthday",
                  amount: 100000,
                  imageUrl: ImageConstant.promoco1,
                  description:
                      "Selamat ulang tahun, teman-teman sekantor selalu mendoakanmu sehat, bahagia, panjang umur, agar bisa jadi pribadi yang lebih baik dari tahun-tahun sebelumnya",
                  expiredIn: "1 Day",
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(MainRoute.checkoutVoucherDetail, arguments: {
                    'title': "Koordinator Program Kekompakan",
                    'amount': 100000,
                    'imageUrl': ImageConstant.promoco2,
                    'description':
                        "Berkat Kamu teman - teman sehat dan bahagia , terima kasih koordinator olahraga Ku",
                    'expiredIn': "1 Month",
                  });
                },
                child: CheckoutVoucher(
                  title: "Koordinator Program Kekompakan",
                  amount: 100000,
                  imageUrl: ImageConstant.promoco2,
                  description:
                      "Berkat Kamu teman - teman sehat dan bahagia , terima kasih koordinator olahraga Ku",
                  expiredIn: "1 Month",
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(MainRoute.checkoutVoucherDetail, arguments: {
                    'title': "Friend Referral Retention",
                    'amount': 200000,
                    'imageUrl': ImageConstant.promoco3,
                    'description':
                        "Temen Mu ternyata betah disini, makasih ya udah buat dia bertahan dengan kita",
                    'expiredIn': "1 Month",
                  });
                },
                child: CheckoutVoucher(
                  title: "Friend Referral Retention",
                  amount: 200000,
                  imageUrl: ImageConstant.promoco3,
                  description:
                      "Temen Mu ternyata betah disini, makasih ya udah buat dia bertahan dengan kita",
                  expiredIn: "1 Month",
                ),
              ),
              const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: MainColor.primary,
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "Penggunaan voucher tidak dapat digabung dengan ",
                        children: [
                          TextSpan(
                            text: "discount employee reward program",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MainColor.primary),
                          ),
                        ],
                      ),
                      maxLines: 2, // Allow the text to wrap to the next line
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Get.back(result: {
                      'voucher': Get.find<ListCheckoutVoucherController>()
                          .selectedVoucher
                          .value,
                      'amount': Get.find<ListCheckoutVoucherController>()
                          .selectedVoucherAmount
                          .value,
                    });
                  },
                  child: const Text(
                    "Pakai Voucher",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
