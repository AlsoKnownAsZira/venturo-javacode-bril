import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/sub_features/checkout/view/ui/edit_menu_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/shared/models/cart_item.dart';

class CheckoutItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final ValueChanged<int> onQuantityChanged;

  CheckoutItemCard({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menu = item['menu'];
    final quantity = RxInt(item['quantity']);
    final level = item['level'];
    final topping = item['topping'];
    final note = item['note'];
    final cartBox = Hive.box<CartItem>('cartBox');

    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () {
        Get.to(() => EditMenu(
              item: item,
              onQuantityChanged: onQuantityChanged,
            ));
      },
      child: Ink(
        padding: EdgeInsets.all(7.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Colors.transparent,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
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
                    menu['nama'] ?? 'Unknown',
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
                  if (level != null && level.isNotEmpty)
                    Text(
                      "Level: $level",
                      style: Get.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  else
                    Text(
                      'Level: -',
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  if (topping != null && topping.isNotEmpty)
                    Text(
                      "Topping: $topping",
                      style: Get.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  else
                    Text(
                      'Topping: -',
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  if (note != null && note.isNotEmpty)
                    Text(
                      note,
                      style: Get.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  else
                    Text(
                      'Tambahkan Catatan',
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity.value > 1) {
                      quantity.value--;
                      onQuantityChanged(quantity.value);
                    } else {
                      cartBox.delete(item['key']);
                      onQuantityChanged(0);
                    }
                  },
                  icon: Icon(Icons.remove, color: MainColor.primary),
                ),
                Obx(() => Text(
                      "${quantity.value}",
                      style: TextStyle(fontSize: 20.w),
                    )),
                IconButton(
                  onPressed: () {
                    quantity.value++;
                    onQuantityChanged(quantity.value);
                  },
                  icon: Icon(Icons.add, color: MainColor.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}