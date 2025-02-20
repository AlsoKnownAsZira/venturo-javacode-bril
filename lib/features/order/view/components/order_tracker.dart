import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:get/get.dart';
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
          'Your order is being prepared'.tr,
          style: Get.textTheme.titleSmall,
          textAlign: TextAlign.left,
        ),
        18.verticalSpace,
        Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 2.h,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(flex: 10),
                Expanded(
                  flex: 10,
                  child: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        DetailOrderController.to.order.value?['status'] == 0 ||
                        DetailOrderController.to.order.value?['status'] == 1,
                    widgetBuilder: (context) => const CheckedStep(),
                    fallbackBuilder: (context) => const UncheckedStep(),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        DetailOrderController.to.order.value?['status'] == 1,
                    widgetBuilder: (context) => const CheckedStep(),
                    fallbackBuilder: (context) => const UncheckedStep(),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        DetailOrderController.to.order.value?['status'] == 2,
                    widgetBuilder: (context) => const CheckedStep(),
                    fallbackBuilder: (context) => const UncheckedStep(),
                  ),
                ),
                const Spacer(flex: 10),
              ],
            ),
          ],
        ),
        18.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pesanan diterima'.tr,
              style: Get.textTheme.bodySmall,
            ),
            Text(
              'Silahkan DIambil'.tr,
              style: Get.textTheme.bodySmall,
            ),
            Text(
              'Pesanan Selesai'.tr,
              style: Get.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
