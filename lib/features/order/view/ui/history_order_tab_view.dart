import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/order/controllers/order_controller.dart';
import 'package:venturo_core/features/order/view/components/dropdown_status.dart';
import 'package:venturo_core/features/order/view/components/date_picker.dart';
import 'package:venturo_core/features/order/view/components/order_item_card.dart';
import 'package:venturo_core/features/order/view/components/primary_button_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderHistoryTabView extends StatelessWidget {
  const OrderHistoryTabView({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(
      screenName: 'Order History Screen',
      screenClassOverride: 'Trainee',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                SizedBox(width: 16),
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
          Expanded(
            child: RefreshIndicator(
              onRefresh: OrderController.to.getOrderHistories,
              child: Obx(
                () => ConditionalSwitch.single(
                  context: context,
                  valueBuilder: (context) =>
                      OrderController.to.orderHistoryState.value,
                  caseBuilders: {
                    'loading': (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                    'empty': (context) => Center(
                          child: Text('No orders found'),
                        ),
                    'error': (context) => Center(
                          child: Text('Failed to load orders'),
                        ),
                    'success': (context) => ListView.builder(
                          itemCount: OrderController.to.filteredHistoryOrder.length,
                          itemBuilder: (context, index) {
                            final order = OrderController.to.filteredHistoryOrder[index];
                            return OrderItemCard(
                              order: order,
                              onTap: () {
                                // Handle card tap
                              },
                              onOrderAgain: () {
                                // Handle order again
                              },
                              onGiveReview: (orderId) {
                                // Handle give review
                              },
                            );
                          },
                        ),
                  },
                  fallbackBuilder: (context) => CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: Center(
                          child: Text('No orders found'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () {
                final totalOrders = OrderController.to.totalHistoryOrder;
                return PrimaryButtonWithTitle(
                  title: 'Total Orders: Rp $totalOrders',
                  onPressed: () {
                    // Handle button press
                  },
                  backgroundColor: Colors.blue,
                  borderColor: Colors.blueAccent,
                  titleColor: Colors.white,
                  width: double.infinity,
                  height: 50.0,
                  isLoading: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}