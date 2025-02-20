import 'package:flutter/material.dart';
import 'package:venturo_core/features/order/constants/order_assets_constant.dart';
import 'package:venturo_core/features/order/view/components/order_top_bar.dart';
import 'package:venturo_core/features/order/view/ui/history_order_tab_view.dart';
import 'package:venturo_core/features/order/view/ui/ongoing_order_tab.dart';
import 'package:venturo_core/shared/widgets/custom_navbar.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: CustomNavbar(currentIndex: 1),
          appBar: OrderTopBar(),
          body: TabBarView(
            children: [
              OnGoingOrderTabView(),
              OrderHistoryTabView(),
            ],
          ),
        ),
      ),
    );
  }
}
