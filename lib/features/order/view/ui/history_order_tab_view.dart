import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/order/controllers/order_controller.dart';
import 'package:venturo_core/features/order/view/components/dropdown_status.dart';
import 'package:venturo_core/features/order/view/components/date_picker.dart';
import 'package:venturo_core/features/order/view/components/order_item_card.dart';

class OrderHistoryTabView extends StatelessWidget {
  const OrderHistoryTabView({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(
      screenName: 'Order History Screen',
      screenClassOverride: 'Trainee',
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => DropdownStatus(
                    items: OrderController.to.dateFilterStatus,
                    selectedItem: OrderController.to.selectedCategory.value,
                    onChanged: (value) {
                      OrderController.to.setDateFilter(category: value);
                      OrderController.to.getOrderHistories();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => DatePicker(
                    selectedDate: OrderController.to.selectedDateRange.value,
                    onChanged: (dateRange) {
                      OrderController.to.setDateFilter(range: dateRange);
                      OrderController.to.getOrderHistories();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Order List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => OrderController.to.getOrderHistories(),
            child: Obx(
              () {
                final orders = OrderController.to.filteredHistoryOrder;

                if (OrderController.to.orderHistoryState.value == 'loading') {
                  return const Center(child: CircularProgressIndicator());
                }

                if (orders.isEmpty) {
                  return Center(
                      child: Stack(
                    children: [
                      const Image(image: AssetImage(ImageConstant.loading)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(image: AssetImage(ImageConstant.noOrder)),
                          Text(
                            "Mulai Buat Pesanan",
                            style: TextStyle(fontSize: 26.w),
                          ),
                          Text(
                            "Makanan yang kamu opesan akan muncul disini agar kamu bisa menemukan menu favoritmu lagi!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26.w),
                          )
                        ],
                      )
                    ],
                  ));
                }

                return ListView.separated(
                  padding: EdgeInsets.all(25.r),
                  itemCount: OrderController.to.filteredHistoryOrder.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderItemCard(
                      showButtons: true,
                      order: order,
                      onTap: () {
                        Get.toNamed(
                          '${MainRoute.order}/${order['id_order']}',
                        );
                      },
                      onOrderAgain: () {},
                      onGiveReview: (orderId) {},
                    );
                  },
                  separatorBuilder: (context, index) => 16.verticalSpace,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
