import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/constants/image_constant.dart';
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
        () {
          if (OrderController.to.onGoingOrders.isEmpty) {
            return Center(
                child: Stack(
              children: [
                const Image(image: AssetImage(ImageConstant.loading)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage(ImageConstant.noOrder)),
                    Text(
                      "Sudah Pesan?",
                      style: TextStyle(fontSize: 26.w),
                    ),
                    Text(
                      "Lacak Pesananmu Disini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26.w),
                    )
                  ],
                )
              ],
            ));
          } else {
            return ListView.separated(
              padding: EdgeInsets.all(25.r),
              itemBuilder: (context, index) => OrderItemCard(
                showButtons: false,
                order: OrderController.to.onGoingOrders[index],
                onTap: () {
                  Get.toNamed(
                    '${MainRoute.order}/${OrderController.to.onGoingOrders[index]['id_order']}',
                  );
                },
                onOrderAgain: () {},
              ),
              separatorBuilder: (context, index) => 16.verticalSpace,
              itemCount: OrderController.to.onGoingOrders.length,
            );
          }
        },
      ),
    );
  }
}
