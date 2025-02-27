import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/profile/sub_features/rating/view/components/rating_card.dart';

class RatingScreen extends StatelessWidget {
  RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
          title: Text(
            "Daftar Penilaian",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MainColor.black,
                fontSize: 35.sp,
                decoration: TextDecoration.underline,
                decorationColor: MainColor.primary),
          ),
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.loading),
            ),
          ),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                RatingCard(
                    category: "Rasa", rating: 4.5, description: "UENAK BRUTAL"),
                RatingCard(
                    category: "Fasilitas",
                    rating: 3,
                    description:
                        "Meja sedikt kotor, mohon untuk dibersihkan secara berkala demi kenyamanan pelanggan"),
                RatingCard(
                    category: "Pelayanan",
                    rating: 5,
                    description: "Mbaknya cantik UWU"),
                RatingCard(
                    category: "Rasa",
                    rating: 2.5,
                    description:
                        "Saya mesen nasgor rasa yang pernah ada malah dikasih micin"),
                RatingCard(
                    category: "Fasilitas",
                    rating: 5,
                    description:
                        "Tempat NYAMAN, bersih, estetik 10/10 NO DRAMA ABSOLUTE CINEMA"),
                RatingCard(
                    category: "Harga",
                    rating: 5,
                    description: "bang mahalin dikit bang, kemurahan ini"),
                RatingCard(
                    category: "Pelayanan",
                    rating: 4,
                    description:
                        "Pelayan mas mas e aura farming rek woilah absolute rizzmastah"),
              ],
            ),
          ),
        ));
  }
}
