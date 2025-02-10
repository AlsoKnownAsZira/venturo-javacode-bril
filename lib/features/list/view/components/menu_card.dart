import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/controllers/list_controller.dart';

class MenuCard extends StatelessWidget {
  final Map<String, dynamic> menu;
  final bool isSelected;
  final void Function()? onTap;

  MenuCard({
    Key? key,
    required this.menu,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Ink(
        padding: EdgeInsets.all(7.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2.w,
          ),
        ),
        child: Row(
          children: [
            // menu image
            Container(
              height: 90.h,
              width: 90.w,
              margin: EdgeInsets.only(right: 12.r),
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.grey[100],
              ),
              child: CachedNetworkImage(
                imageUrl: menu['foto'] != null && menu['foto'].isNotEmpty
                    ? menu['foto']
                    : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                useOldImageOnUrlChange: true,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // menu info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu['nama'],
                    style: Get.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Rp ${menu['harga'].toString()}',
                    style: Get.textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                SizedBox(width: 7.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: MainColor.primary),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        ListController.to.decrement();
                      },
                      icon: Icon(Icons.minimize, color: MainColor.primary),
                    ),
                  ),
                ),
                SizedBox(width: 7.w),
                Obx(() => Text(
                      '${ListController.to.quantity.value}',
                      style: TextStyle(fontSize: 20.w),
                    )),
                SizedBox(width: 7.w),
                Container(
                  decoration: BoxDecoration(
                    color: MainColor.primary,
                    border: Border.all(color: MainColor.primary),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: IconButton(
                    onPressed: () {
                      ListController.to.increment();
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
