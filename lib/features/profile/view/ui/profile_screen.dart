import 'package:flutter/material.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/profile/constants/profile_assets_constant.dart';
import 'package:venturo_core/features/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/profile/view/components/dialog_webview.dart';
import 'package:venturo_core/shared/widgets/tile_option.dart';
import 'package:venturo_core/utils/functions/helpers.dart';
import 'package:venturo_core/shared/widgets/custom_navbar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key}) {
    Helpers.logFirebaseAnalytics("Profile Screen", "ProfileScreen");
  }

  final assetsConstant = ProfileAssetsConstant();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomNavbar(currentIndex: 2),
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
          title: const Text(
            "Profil",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.loading),
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
            ),
          ),
        ));
  }
}
