import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/list/sub_features/checkout_voucher/controllers/list_checkout_voucher_controller.dart';
class CheckoutVoucher extends StatelessWidget {
  final String title;
  final int amount;
  final String imageUrl;
  final String description;
  final String expiredIn;


  CheckoutVoucher({
    required this.title,
    required this.amount,
    required this.imageUrl,
    required this.description,
    required this.expiredIn,

  });

  final ListCheckoutVoucherController controller = Get.find<ListCheckoutVoucherController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
              ),
              Spacer(),
     
                   Obx(() => Checkbox(
                value: controller.selectedVoucher.value == title,
                onChanged: (bool? value) {
                  if (value == true) {
                    controller.selectVoucher(title);
                  } else {
                    controller.selectVoucher('');
                  }
                },
              )),
            ],
          ),
          SizedBox(height: 10.h),
          Image.asset(imageUrl),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}