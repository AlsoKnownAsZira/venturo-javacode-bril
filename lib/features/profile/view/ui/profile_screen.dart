import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/profile/constants/profile_assets_constant.dart';
import 'package:venturo_core/features/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:venturo_core/shared/widgets/custom_navbar.dart';
import 'package:venturo_core/utils/functions/helpers.dart';

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
        title: Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MainColor.primary,
            fontSize: 35.sp,
            decoration: TextDecoration.underline,
          ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                if (profileController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final userProfile = profileController.userProfile;
                  return Column(
                    children: [
                      SizedBox(height: 40.h),
                      CircleAvatar(
                        radius: 100.h,
                        backgroundImage: userProfile['foto'] != null
                            ? NetworkImage(userProfile['foto'])
                            : ImageConstant.logo as ImageProvider<Object>?,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card,
                              color: MainColor.primary, size: 20.sp),
                          Text(
                            "Segera Verifikasi KTP mu S=sekarang!",
                            style: TextStyle(
                                color: MainColor.primary, fontSize: 20.sp),
                          )
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Text(
                            "Info Akun",
                            style: TextStyle(
                                color: MainColor.primary,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: Get.width,
                        height: Get.height * 0.325,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 0, 0, 0),
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Nama',
                                    style: TextStyle(
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${userProfile['nama'] ?? 'Unknown'}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(20.w))),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Tanggal Lahir',
                                    style: TextStyle(
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${userProfile['tgl_lahir'] ?? 'Unknown'}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(20.w))),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Telepon',
                                    style: TextStyle(
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${userProfile['telepon'] ?? 'Unknown'}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(20.w))),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${userProfile['email'] ?? 'Unknown'}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(20.w))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Text(
                            "Info Lainnya",
                            style: TextStyle(
                                color: MainColor.primary,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: Get.width,
                        height: Get.height * 0.175,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 0, 0, 0),
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Device Model',
                                    style: TextStyle(
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                      'Device Model: ${ProfileController.to.deviceModel.value}'),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(20.w))),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Android Version',
                                    style: TextStyle(
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                      ProfileController.to.deviceVersion.value),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      style: ButtonStyle(
                                          iconSize:
                                              MaterialStateProperty.all(20.w))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
