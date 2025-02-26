import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/order/controllers/order_controller.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard(
      {super.key,
      required this.order,
      this.onTap,
      this.onOrderAgain,
      this.onGiveReview,
      this.showButtons = false});

  final Map<String, dynamic> order;
  final VoidCallback? onTap;
  final VoidCallback? onOrderAgain;
  final ValueChanged<int>? onGiveReview;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> menu = order['menu'] ?? [];
    final OrderController orderController = Get.find<OrderController>();

    // Ensure there's at least one item
    final firstMenuItem =
        menu.isNotEmpty ? menu[0] : {'nama': 'Unknown', 'foto': null};
    final secondMenuItem = menu.length > 1 ? menu[1] : {'nama': ''};

    // Safe total item count calculation
    final totalMenuItems =
        menu.fold(0, (sum, item) => sum + (item['jumlah'] as int? ?? 0));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Ink(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  height: 100.h,
                  width: 100.w,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: Image.network(
                    firstMenuItem['foto'] ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, _, __) => Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusText(order['status'] as int? ?? -1),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${firstMenuItem['nama'] ?? 'Unknown'}\n',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: secondMenuItem['nama']?.isNotEmpty == true
                                  ? '${secondMenuItem['nama']}...'
                                  : '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Rp ${(order['total_bayar'] as int? ?? 0).toString()}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: MainColor.primary,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            '($totalMenuItems menu)',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: MainColor.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  order['tanggal']?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: MainColor.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80.w,
                ),
                if (showButtons)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.white,
                      side:
                          const BorderSide(color: MainColor.primary, width: 2),
                    ),
                    onPressed: () =>
                        onGiveReview?.call(order['id'] as int? ?? 0),
                    child: const Text(
                      'Beri Penilaian',
                      style: TextStyle(color: MainColor.primary),
                    ),
                  ),
                SizedBox(
                  width: 10.w,
                ),
                if (showButtons)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.primary,
                      side: const BorderSide(color: MainColor.black, width: 2),
                    ),
                    onPressed: () {

                      Get.snackbar('Pesan lagi sukses!', 'Silahkan cek pesanan berjalan',backgroundColor: Colors.green,colorText: Colors.white);
                      orderController.orderAgain(order);
                    },
                    child: const Text(
                      'Pesan Lagi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Dalam Antrian';
      case 1:
        return 'Sedang Disiapkan';
      case 2:
        return 'Bisa Diambil';
      case 3:
        return 'Dibatalkan';
      case 4:
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }
}
