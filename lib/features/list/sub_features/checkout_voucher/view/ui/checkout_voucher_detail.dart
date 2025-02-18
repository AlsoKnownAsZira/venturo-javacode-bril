import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/sub_features/checkout_voucher/view/components/checkout_voucher_card.dart';

class CheckoutVoucherDetail extends StatelessWidget {
  CheckoutVoucherDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final voucher = Get.arguments;

    // Log the arguments to debug
    print("Voucher arguments: $voucher");

    // Ensure the arguments are not null
    final String title = voucher['title'] ?? 'Unknown';
    final int amount = voucher['amount'] ?? 0;
    final String imageUrl = voucher['imageUrl'] ?? '';
    final String description =
        voucher['description'] ?? 'No description provided.';
    final String expiredIn = voucher['expiredIn'] ?? 'Unknown';

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
        title: const Text('Voucher Detail'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CheckoutVoucher(
              title: title,
              amount: amount,
              imageUrl: imageUrl,
              description: description,
              expiredIn: expiredIn,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined,
                          color: MainColor.primary),
                      Text(
                        'Expired In',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const Spacer(),
                      Text(
                        ' $expiredIn',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
