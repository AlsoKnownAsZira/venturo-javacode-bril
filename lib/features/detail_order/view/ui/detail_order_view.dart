import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/detail_order/controllers/detail_order_controller.dart';
import 'package:venturo_core/features/order/controllers/order_controller.dart';
import 'package:venturo_core/features/order/view/components/order_tracker.dart';

import 'package:venturo_core/features/order/view/components/detail_order_card.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailOrderView extends StatelessWidget {
  const DetailOrderView({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(
      screenName: 'Detail Order Screen',
      screenClassOverride: 'Trainee',
    );

    return Scaffold(
      bottomSheet: Obx(() {
        if (DetailOrderController.to.orderDetailState.value == 'loading' ||
            DetailOrderController.to.orderDetailState.value == 'error') {
          return const SizedBox.shrink();
        } else {
          final order = DetailOrderController.to.order.value!;
          final foodItems = DetailOrderController.to.foodItems;
          final drinkItems = DetailOrderController.to.drinkItems;
          final snackItems = DetailOrderController.to.snackItems;

          // Calculate total quantity and total price
          int totalQuantity = 0;
          int totalPrice = 0;

          void calculateTotals(List<Map<String, dynamic>> items) {
            for (var item in items) {
              totalQuantity += item['jumlah'] as int;
              totalPrice += (item['jumlah'] * int.parse(item['harga'])) as int;
            }
          }

          calculateTotals(foodItems);
          calculateTotals(drinkItems);
          calculateTotals(snackItems);

          return SizedBox(
            height: 300, // Set a fixed height for the bottom sheet
            child: OrderSummary(
                totalQuantity: totalQuantity,
                totalPrice: totalPrice,
                order: order),
          );
        }
      }),
      appBar: RoundedAppBar(
        title: 'pesanan'.tr,
        icon: Icons.arrow_back_ios,
        actions: [
          Obx(
            () => Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  DetailOrderController.to.order.value?['status'] == 0,
              widgetBuilder: (context) => Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
                child: TextButton(
                  onPressed: () {},
                  child: ElevatedButton(
                    onPressed: () {
                      final orderId =
                          DetailOrderController.to.order.value?['id_order'];
                      if (orderId != null) {
                        OrderController.to.cancelOrder(orderId);
                        Get.back();
                      } else {
                        Get.snackbar('Error', 'Order ID tidak ditemukan',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    // style: TextButton.styleFrom(
                    //   backgroundColor: Colors.white,
                    // ),
                    child: Text(
                      'batal_pesanan'.tr,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              fallbackBuilder: (context) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            if (DetailOrderController.to.orderDetailState.value == 'loading') {
              return const Center(child: CircularProgressIndicator());
            } else if (DetailOrderController.to.orderDetailState.value ==
                'error') {
              return const Center(child: Text('Failed to load order details'));
            } else {
              final order = DetailOrderController.to.order.value!;
              final foodItems = DetailOrderController.to.foodItems;
              final drinkItems = DetailOrderController.to.drinkItems;
              final snackItems = DetailOrderController.to.snackItems;

              // Calculate total quantity and total price
              int totalQuantity = 0;
              int totalPrice = 0;

              void calculateTotals(List<Map<String, dynamic>> items) {
                for (var item in items) {
                  totalQuantity += item['jumlah'] as int;
                  totalPrice +=
                      (item['jumlah'] * int.parse(item['harga'])) as int;
                }
              }

              calculateTotals(foodItems);
              calculateTotals(drinkItems);
              calculateTotals(snackItems);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    if (foodItems.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.fastfood, color: MainColor.primary),
                          Text(
                            'makanan'.tr,
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: MainColor.primary,
                            ),
                          ),
                        ],
                      ),
                      ...foodItems.map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: DetailOrderCard(item),
                          )),
                    ],
                    if (drinkItems.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.local_drink,
                              color: MainColor.primary),
                          Text(
                            'minuman'.tr,
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: MainColor.primary,
                            ),
                          ),
                        ],
                      ),
                      ...drinkItems.map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: DetailOrderCard(item),
                          )),
                    ],
                    if (snackItems.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.icecream, color: MainColor.primary),
                          Text(
                            'snack'.tr,
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: MainColor.primary,
                            ),
                          ),
                        ],
                      ),
                      ...snackItems.map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: DetailOrderCard(item),
                          )),
                    ],
                    const SizedBox(
                      height: 300,
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.totalQuantity,
    required this.totalPrice,
    required this.order,
  });

  final int totalQuantity;
  final int totalPrice;
  final Map<String, dynamic> order;

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
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'total_pesanan'.trParams({'totalQuantity': '$totalQuantity'}),
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "Rp $totalPrice",
                  style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold,
                      color: MainColor.primary),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Icon(
                  Icons.discount_sharp,
                  color: MainColor.primary,
                  size: 20.w,
                ),
                Text(
                  'Voucher',
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Rp ${totalPrice - order['total_bayar']}',
                  style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold,
                      color: MainColor.primary),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: MainColor.primary,
                  size: 20.w,
                ),
                Text(
                  'pembayaran'.tr,
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Paylater',
                  style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold,
                      color: MainColor.primary),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Text(
                  'total_pembayaran'.tr,
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Rp ${order['total_bayar']}',
                  style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold,
                      color: MainColor.primary),
                ),
              ],
            ),
            const Divider(),
            if (order['status'] == 3) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 40.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'pesanan_selesai'.tr,
                    style: TextStyle(
                      fontSize: 40.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ] else if (order['status'] == 4) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 40.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'pesanan_dibatalkan'.tr,
                    style: TextStyle(
                      fontSize: 40.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const OrderTracker(),
            ]
          ],
        ),
      ),
    );
  }
}

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final List<Widget>? actions;

  const RoundedAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 4,
      leading: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
