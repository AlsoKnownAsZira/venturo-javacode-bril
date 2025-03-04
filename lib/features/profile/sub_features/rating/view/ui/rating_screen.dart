import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/profile/sub_features/rating/view/components/rating_card.dart';
import 'package:venturo_core/features/profile/sub_features/rating/view/ui/add_new_rating.dart';
import 'package:venturo_core/shared/models/rating.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  late Box<RatingModel> ratingBox;

  @override
  void initState() {
    super.initState();
    ratingBox = Hive.box<RatingModel>('ratingsBox');
  }

  void addRating(RatingModel rating) {
    ratingBox.add(rating);
    setState(() {}); // Refresh UI
  }

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
        "dafar_penilaian".tr,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MainColor.black,
            fontSize: 35.sp,
            decoration: TextDecoration.underline,
            decorationColor: MainColor.primary),
      ),
    ),
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            ImageConstant.loading,
            fit: BoxFit.cover,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: ratingBox.listenable(),
          builder: (context, Box<RatingModel> box, _) {
            if (box.isEmpty) {
              return Center(child: Text('nilai_kosong'.tr));
            }
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final rating = box.getAt(index)!;
                return RatingCard(
                  category: rating.category,
                  rating: rating.rating,
                  description: rating.description,
                );
              },
            );
          },
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      backgroundColor: MainColor.primary,
      onPressed: () async {
        final newRating = await Get.to(() => AddNewRating());
        if (newRating != null) {
          addRating(newRating);
        }
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    ),
  );
}
}
