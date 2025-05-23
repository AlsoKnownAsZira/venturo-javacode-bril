import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/detail_order/controllers/detail_order_controller.dart';
import 'package:venturo_core/features/order/view/components/checked_step.dart';
import 'package:venturo_core/features/order/view/components/unchecked_step.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTracker extends StatelessWidget {
  const OrderTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pesananmu sedang disiapkan:'.tr,
          style:
              Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        18.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 10),
            Expanded(
              flex: 10,
              child: Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    DetailOrderController.to.order.value?['status'] >= 0,
                widgetBuilder: (context) => const CheckedStep(),
                fallbackBuilder: (context) => const UncheckedStep(),
              ),
            ),
            Expanded(
              flex: 35,
              child: Container(
                height: 2.h,
                color: DetailOrderController.to.order.value?['status'] >= 1
                    ? MainColor.primary
                    : Colors.grey,
              ),
            ),
            Expanded(
              flex: 10,
              child: Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    DetailOrderController.to.order.value?['status'] >= 1,
                widgetBuilder: (context) => const CheckedStep(),
                fallbackBuilder: (context) => const UncheckedStep(),
              ),
            ),
            Expanded(
              flex: 35,
              child: Container(
                height: 2.h,
                color: DetailOrderController.to.order.value?['status'] >= 2
                    ? Get.theme.primaryColor
                    : Colors.grey,
              ),
            ),
            Expanded(
              flex: 10,
              child: Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    DetailOrderController.to.order.value?['status'] >= 2,
                widgetBuilder: (context) => const CheckedStep(),
                fallbackBuilder: (context) => const UncheckedStep(),
              ),
            ),
            const Spacer(flex: 10),
          ],
        ),
        18.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Pesanan Diterima'.tr,
                style: Get.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 2,
              child: Text(
                'Sedang disiapkan'.tr,
                style: Get.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 2,
              child: Text(
                'Siap Diambil'.tr,
                style: Get.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
