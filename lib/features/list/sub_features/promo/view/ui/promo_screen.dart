import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/list/constants/list_assets_constant.dart';
import 'package:venturo_core/features/list/view/components/promo_card.dart';

class PromoScreen extends StatelessWidget {
  PromoScreen({super.key});

  final assetsConstant = ListAssetsConstant();

  @override
  Widget build(BuildContext context) {
    final promo = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Promo'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PromoCard(
              promoName: promo['nama'] ?? 'Unknown',
              discountNominal: promo['diskon'] as int?,
              nominal: promo['nominal'] as int?,
              thumbnailUrl: promo['foto'] ?? '',
              syaratKetentuan: promo['syarat_ketentuan'] ??
                  'No terms and conditions provided.',
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Nama Promo',
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    promo['nama'] ?? 'Unknown',
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: MainColor.primary),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.list_alt, color: MainColor.primary),
                      const SizedBox(width: 10.0),
                      Text(
                        'Syarat dan ketentuan',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    promo['syarat_ketentuan'] ??
                        'No terms and conditions provided.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
