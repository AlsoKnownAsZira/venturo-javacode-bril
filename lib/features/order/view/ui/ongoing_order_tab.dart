import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/features/order/controllers/order_controller.dart';
import 'package:venturo_core/features/order/view/components/order_item_card.dart';

class OnGoingOrderTabView extends StatelessWidget {
  const OnGoingOrderTabView({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(
      screenName: 'Ongoing Order Screen',
      screenClassOverride: 'Trainee',
    );

    return RefreshIndicator(
      onRefresh: () async => OrderController.to.getOngoingOrders(),
      child: Obx(
        () => ListView.separated(
          padding: EdgeInsets.all(25.r),
          itemBuilder: (context, index) => OrderItemCard(
            order: OrderController.to.onGoingOrders[index],
            onTap: () {
              Get.toNamed(
                '${MainRoute.order}/${OrderController.to.onGoingOrders[index]['data']['order']['id_order']}',
              );
            },
            onOrderAgain: () {},
          ),
          separatorBuilder: (context, index) => 16.verticalSpace,
          itemCount: OrderController.to.onGoingOrders.length,
        ),
      ),
    );
  }
}
