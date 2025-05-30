import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';

class OrderTopBar extends StatelessWidget implements PreferredSizeWidget {
  const OrderTopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            spreadRadius: -1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TabBar(
        tabs: const [
          Tab(text: 'Sedang Berjalan'),
          Tab(text: 'Riwayat'),
        ],
        indicatorColor: MainColor.primary,
        indicatorWeight: 3.h,
        labelColor: MainColor.primary,
        unselectedLabelColor: Colors.black,
        labelStyle: Get.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        indicatorPadding: EdgeInsets.symmetric(horizontal: 20.w),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
