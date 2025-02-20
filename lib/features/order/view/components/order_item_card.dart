import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/configs/themes/main_color.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    super.key,
    required this.order,
    this.onTap,
    this.onOrderAgain,
    this.onGiveReview,
  });

  final Map<String, dynamic> order;
  final VoidCallback? onTap;
  final VoidCallback? onOrderAgain;
  final ValueChanged<int>? onGiveReview;

  @override
  Widget build(BuildContext context) {
    final firstMenuItem = order['data']['detail'][0];
    final secondMenuItem = order['data']['detail'].length > 1
        ? order['data']['detail'][1]
        : {'nama': ''};
    final totalMenuItems = (order['data']['detail'] as List<dynamic>)
        .map((item) => (item as Map<String, dynamic>)['jumlah'] as int)
        .reduce((sum, jumlah) => sum + jumlah);
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
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
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
                    _getStatusText(order['data']['order']['status']),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                  SizedBox(height: 10.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${firstMenuItem['nama']}\n',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: secondMenuItem['nama'].isNotEmpty
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
                        'Rp ${(order['data']['order']['total_bayar'].toString())}',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: MainColor.primary),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '($totalMenuItems menu)',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: MainColor.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              (order['data']['order']['tanggal'].toString()),
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: MainColor.grey),
            ),
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
        return 'Selesai';
      case 4:
        return 'Dibatalkan';
      default:
        return 'Unknown';
    }
  }
}
