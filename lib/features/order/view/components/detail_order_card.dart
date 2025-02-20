import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DetailOrderCard extends StatelessWidget {
  final Map<String, dynamic> detailOrder;

  const DetailOrderCard(this.detailOrder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: EdgeInsets.all(7.r),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        children: [
          /* Image */
          Container(
            height: 90.h,
            width: 90.w,
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            child: CachedNetworkImage(
              imageUrl: detailOrder['foto'] ??
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
              fit: BoxFit.contain,
              errorWidget: (context, _, __) => CachedNetworkImage(
                imageUrl:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detailOrder['nama'],
                  style: Get.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Rp ${int.parse(detailOrder['harga'])}',
                  style: Get.textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 75.r,
              padding: EdgeInsets.only(left: 12.w, right: 5.w),
              child: Center(
                child: Text(
                  detailOrder['jumlah'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
