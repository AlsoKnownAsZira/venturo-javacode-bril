import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/shared/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class CheckoutSummary extends StatelessWidget {
  CheckoutSummary({
    super.key,
    required this.totalPayment,
    required this.cartBox,
    required this.selectedVoucherAmount,
    required this.userId,
  });

  final double totalPayment;
  final Box<CartItem> cartBox;
  final int selectedVoucherAmount;
  final int userId;

  final String token = '5b90e85d28255df4e6c4e57053d0a87063157de3';
  final Logger logger = Logger();

  Future<void> postOrder() async {
    var headers = {
      'token': token,
      'Content-Type': 'application/json'
    };

    var order = {
      "order": {
        "id_user": userId,
        "id_voucher": 1,
        "potongan": selectedVoucherAmount,
        "total_bayar": totalPayment.toInt()
      },
      "menu": cartBox.values.map((item) => {
        "id_menu": item.menu.idMenu,
        "harga": item.menu.harga,
        "level": item.level ?? 0,
        "topping": item.topping ?? [],
        "jumlah": item.quantity
      }).toList()
    };

    var request = http.Request('POST', Uri.parse('https://trainee.landa.id/javacode/order/add'));
    request.body = json.encode(order);
    request.headers.addAll(headers);

    logger.d('Sending request to ${request.url}');
    logger.d('Request body: ${request.body}');
    logger.d('Request headers: ${request.headers}');

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      logger.d('Response body: $responseBody');
      print(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
      logger.e('Failed to post order: ${response.reasonPhrase}');
      logger.e('Response body: $responseBody');
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Icon(
              Icons.monetization_on,
              color: MainColor.primary,
              size: 20.w,
            ),
            Column(
              children: [
                Text(
                  'Total Pembayaran',
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
                ),
                Text(
                  totalPayment == 0
                      ? "Rp 0 (Free)"
                      : "Rp ${totalPayment.toInt()}",
                  style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold,
                      color: MainColor.primary),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MainColor.primary),
                onPressed: () async {
                  if (cartBox.isEmpty) {
                    Get.snackbar(
                      'Cart is empty',
                      'Please add items to the cart before checking out.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  await postOrder();
                  Get.defaultDialog(
                    title: 'Rincian Diskon',
                    titleStyle: const TextStyle(
                        color: MainColor.primary, fontWeight: FontWeight.bold),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(ImageConstant.confirm),
                        const SizedBox(height: 10),
                        const Text('Pesanan Sedang Disiapkan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text(
                            'Kamu dapat melacak pesananmu di fitur Pesanan'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.offAndToNamed(MainRoute.order),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                  cartBox.clear();
                },
                child: Text(
                  "Pesan Sekarang",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.w,
                      color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}