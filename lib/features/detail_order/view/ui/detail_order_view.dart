import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/detail_order/controllers/detail_order_controller.dart';

import 'package:venturo_core/features/order/view/components/primary_button_title.dart';
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
      appBar: RoundedAppBar(
        title: 'Order',
        icon: Icons.shopping_bag_outlined,
        actions: [
          Obx(
            () => Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  DetailOrderController.to.order.value?['status'] == 0,
              widgetBuilder: (context) => Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
                child: TextButton(
                  onPressed: () {
                    // Handle cancel order
                  },
                  child: Text(
                    'Cancel Order',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              fallbackBuilder: (context) => SizedBox.shrink(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(
          () {
            if (DetailOrderController.to.orderDetailState.value == 'loading') {
              return Center(child: CircularProgressIndicator());
            } else if (DetailOrderController.to.orderDetailState.value == 'error') {
              return Center(child: Text('Failed to load order details'));
            } else {
              final order = DetailOrderController.to.order.value!;
              final foodItems = DetailOrderController.to.foodItems;
              final drinkItems = DetailOrderController.to.drinkItems;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details',
                    style: Get.textTheme.titleMedium,
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView(
                      children: [
                        ...foodItems.map((item) => DetailOrderCard(item)),
                        ...drinkItems.map((item) => DetailOrderCard(item)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Order: Rp ${order['total_order']}',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          'Voucher: Rp ${order['voucher']}',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          'Payment: Rp ${order['payment']}',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          'Total Payment: Rp ${order['total_payment']}',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  PrimaryButtonWithTitle(
                    title: 'Order Status: ${order['status']}',
                    onPressed: () {
                      // Handle button press
                    },
                    backgroundColor: Colors.blue,
                    borderColor: Colors.blueAccent,
                    titleColor: Colors.white,
                    width: double.infinity,
                    height: 50.0,
                    isLoading: false,
                  ),
                ],
              );
            }
          },
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
    Key? key,
    required this.title,
    required this.icon,
    this.actions,
  }) : super(key: key);

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