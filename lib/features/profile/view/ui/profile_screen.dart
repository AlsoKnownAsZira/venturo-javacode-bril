import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/features/profile/constants/profile_assets_constant.dart';
import 'package:venturo_core/features/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:venturo_core/shared/widgets/custom_navbar.dart';
import 'package:venturo_core/utils/functions/helpers.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key}) {
    Helpers.logFirebaseAnalytics("Profile Screen", "ProfileScreen");
  }

  final assetsConstant = ProfileAssetsConstant();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavbar(),
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
          "profile".tr,
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
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final userProfile = profileController.userProfile;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        CircleAvatar(
                          radius: 100.h,
                          backgroundImage: profileController.imageFile != null
                              ? FileImage(profileController.imageFile!)
                                  as ImageProvider
                              : (userProfile['foto'] != null &&
                                      userProfile['foto'] is String
                                  ? FileImage(File(userProfile['foto']))
                                  : AssetImage(ImageConstant.logo)
                                      as ImageProvider),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () => profileController.pickImage(),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.camera_alt,
                                    color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.credit_card,
                                color: MainColor.primary, size: 20.sp),
                            Text(
                              "ktp_verif".tr,
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
                              "info_akun".tr,
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
                          height: Get.height * 0.48,
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
                                _buildProfileRow(
                                  context,
                                  'nama'.tr,
                                  userProfile['nama'] ?? 'Unknown',
                                  () => _showEditBottomSheet(
                                    context,
                                    'Nama',
                                    userProfile['nama'] ?? 'Unknown',
                                    (value) =>
                                        profileController.updateUserProfile({
                                      ...userProfile,
                                      'nama': value,
                                    }),
                                  ),
                                ),
                                const Divider(),
                                _buildProfileRow(
                                  context,
                                  'lahir'.tr,
                                  userProfile['tgl_lahir'] ?? 'Unknown',
                                  () => _showDatePicker(
                                    context,
                                    userProfile['tgl_lahir'] ?? 'Unknown',
                                    (value) =>
                                        profileController.updateUserProfile({
                                      ...userProfile,
                                      'tgl_lahir': value,
                                    }),
                                  ),
                                ),
                                const Divider(),
                                _buildProfileRow(
                                  context,
                                  'Telepon',
                                  userProfile['telepon'] ?? 'Unknown',
                                  () => _showEditBottomSheet(
                                    context,
                                    'telepon'.tr,
                                    userProfile['telepon'] ?? 'Unknown',
                                    (value) =>
                                        profileController.updateUserProfile({
                                      ...userProfile,
                                      'telepon': value,
                                    }),
                                  ),
                                ),
                                const Divider(),
                                _buildProfileRow(
                                  context,
                                  'email'.tr,
                                  userProfile['email'] ?? 'Unknown',
                                  () => _showEditBottomSheet(
                                    context,
                                    'Email',
                                    userProfile['email'] ?? 'Unknown',
                                    (value) =>
                                        profileController.updateUserProfile({
                                      ...userProfile,
                                      'email': value,
                                    }),
                                  ),
                                ),
                                const Divider(),
                                _buildProfileRow(
                                  context,
                                  'pin'.tr,
                                  userProfile['pin'] != null
                                      ? obscurePin(userProfile['pin'])
                                      : 'Unknown',
                                  () => _showEditBottomSheet(
                                    context,
                                    'PIN',
                                    userProfile['pin'] ?? 'Unknown',
                                    (value) =>
                                        profileController.updateUserProfile({
                                      ...userProfile,
                                      'pin': value,
                                    }),
                                  ),
                                ),
                                const Divider(),
                                _buildProfileRow(
                                  context,
                                  'bahasa'.tr,
                                  'ganti_bahasa'.tr,
                                  () => _showLanguageBottomSheet(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: Get.width,
                          height: Get.height * 0.095,
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
                                    Icon(Icons.reviews,
                                        color: MainColor.primary, size: 20.sp),
                                    Text(
                                      'nilai'.tr,
                                      style: TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: MainColor.primary,
                                          side: const BorderSide(
                                              color: MainColor.white, width: 2),
                                        ),
                                        onPressed: () {
                                          Get.toNamed(MainRoute.rating);
                                        },
                                        child:  Text(
                                          'nilai_sekarang'.tr,
                                          style:const TextStyle(color: Colors.white),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Text(
                              "info_lain".tr,
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
                                      'device'.tr,
                                      style: TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                        ProfileController.to.deviceModel.value),
                                    IconButton(
                                        onPressed: () {},
                                        icon:
                                            const Icon(Icons.arrow_forward_ios),
                                        style: ButtonStyle(
                                            iconSize: MaterialStateProperty.all(
                                                20.w))),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Text(
                                      'android'.tr,
                                      style: TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(ProfileController
                                        .to.deviceVersion.value),
                                    IconButton(
                                        onPressed: () {},
                                        icon:
                                            const Icon(Icons.arrow_forward_ios),
                                        style: ButtonStyle(
                                            iconSize: MaterialStateProperty.all(
                                                20.w))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            // Add your sign-out logic here
                            profileController.signOut();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.w, vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'sign_out'.tr,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(
      BuildContext context, String title, String value, VoidCallback onEdit) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.arrow_forward_ios),
          style: ButtonStyle(
            iconSize: MaterialStateProperty.all(20.w),
          ),
        ),
      ],
    );
  }

  void _showEditBottomSheet(BuildContext context, String field,
      String currentValue, Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit $field'.tr,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: field,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  onSave(controller.text);
                  Navigator.pop(context);
                },
                child:  Text('save'.tr),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(
      BuildContext context, String currentDate, Function(String) onSave) {
    DateTime initialDate = DateTime.tryParse(currentDate) ?? DateTime.now();
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate != null) {
        onSave(selectedDate.toIso8601String().split('T').first);
      }
    });
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ganti_bahasa'.tr,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.updateLocale(Locale('en', 'US'));
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 32.h, horizontal: 48.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.asset(ImageConstant.eng,
                              width: 24.w, height: 24.h),
                          SizedBox(width: 8.w),
                          Text('english'.tr, style: TextStyle(fontSize: 18.sp)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.updateLocale(Locale('id', 'ID'));
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 32.h, horizontal: 48.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.asset(ImageConstant.indo,
                              width: 24.w, height: 24.h),
                          SizedBox(width: 8.w),
                          Text('indonesia'.tr,
                              style: TextStyle(fontSize: 18.sp)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String obscurePin(String pin) {
    return '*' * pin.length;
  }
}
