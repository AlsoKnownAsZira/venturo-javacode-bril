import 'package:flutter/material.dart';
import 'package:venturo_core/features/profile/constants/profile_assets_constant.dart';
import 'package:venturo_core/features/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/profile/view/components/dialog_webview.dart';
import 'package:venturo_core/shared/widgets/tile_option.dart';
import 'package:venturo_core/utils/functions/helpers.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key}) {
    Helpers.logFirebaseAnalytics("Profile Screen", "ProfileScreen");
  }
  final assetsConstant = ProfileAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            const DialogWebview(),
          );
        },
        child: const Icon(Icons.open_in_new),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Profile Screen"),
            const Divider(),
            TileOption(
              title: 'Privacy Policy',
              message: 'Here',
              onTap: () => Get.find<ProfileController>().privacyPolicyWebView(),
            ),
          ],
        ),
      ),
    );
  }
}
