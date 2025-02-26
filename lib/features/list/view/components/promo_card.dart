import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/configs/themes/main_color.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({
    super.key,
    this.enableShadow,
    required this.promoName,
    this.discountNominal,
    this.nominal,
    required this.thumbnailUrl,
    required this.syaratKetentuan,
    this.width,
  });

  final bool? enableShadow;
  final String promoName;
  final int? discountNominal;
  final int? nominal;
  final String thumbnailUrl;
  final String syaratKetentuan;
  final double? width;

  static const String defaultImageUrl =
      'https://images.pexels.com/photos/5650026/pexels-photo-5650026.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(MainRoute.promo, arguments: {
          'nama': promoName,
          'diskon': discountNominal,
          'nominal': nominal,
          'foto': thumbnailUrl,
          'syarat_ketentuan': syaratKetentuan,
        });
      },
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: width ?? 282.w,
        height: 188.h,
        decoration: BoxDecoration(
          color: MainColor.primary,
          borderRadius: BorderRadius.circular(15.r),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              thumbnailUrl.isNotEmpty ? thumbnailUrl : defaultImageUrl,
            ),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Color.fromARGB(120, 0, 112, 127),
              BlendMode.srcATop,
            ),
          ),
          boxShadow: [
            if (enableShadow == true)
              const BoxShadow(
                color: Color.fromARGB(115, 71, 70, 70),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
          ],
        ),
        margin: EdgeInsets.only(right: 16.w),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (discountNominal != null)
                Text.rich(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'Diskon',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: ' $discountNominal %',
                        style: Get.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else if (nominal != null)
                Text(
                  ' Potongan Sebesar Rp $nominal',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              Text(
                promoName,
                textAlign: TextAlign.center,
                style: Get.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
