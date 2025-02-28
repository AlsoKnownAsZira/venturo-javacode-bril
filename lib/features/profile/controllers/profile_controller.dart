import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/profile/repositories/profile_repository.dart';
import 'package:venturo_core/features/sign_in/controllers/sign_in_controller.dart';
import 'package:venturo_core/shared/widgets/image_picker_dialog.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  final Rx<File?> _imageFile = Rx<File?>(null);
  File? get imageFile => _imageFile.value;

  void privacyPolicyWebView() {
    Get.toNamed(MainRoute.privacyPolicy);
  }

  var userProfile = {}.obs;
  var isLoading = true.obs;
  final RxString deviceModel = ''.obs;
  final RxString deviceVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initDeviceInfo();
    loadUserProfile();
  }

  Future<void> _initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel.value = androidInfo.model;
        deviceVersion.value = androidInfo.version.release;
      } else if (GetPlatform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel.value = iosInfo.utsname.machine;
        deviceVersion.value = iosInfo.systemVersion;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get device info: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      var box = Hive.box('venturo');

      await box.clear();

      SignInController.to.emailCtrl.clear();
      SignInController.to.passwordCtrl.clear();

      userProfile.value = {};
      isLoading.value = true;

      Get.offAllNamed(MainRoute.signIn);
    } catch (e) {
      Get.snackbar("Error", "Failed to sign out: $e");
    }
  }

  void fetchUserProfile() async {
    try {
      isLoading(true);
      var profile = await ProfileRepository().fetchUserProfile();
      userProfile.value = profile;
      saveUserProfile(profile); // Save profile locally
    } finally {
      isLoading(false);
    }
  }

  void saveUserProfile(Map<String, dynamic> profile) async {
    var box = Hive.box('venturo');
    await box.put('userProfile', profile);
  }

// kalau tidak null maka load profile, jika null maka fetch profile dari API
  void loadUserProfile() async {
    var box = Hive.box('venturo');
    var profile = box.get('userProfile');
    if (profile != null) {
      userProfile.value = profile;
      isLoading.value = false;
    } else {
      fetchUserProfile();
    }
  }

  void updateUserProfile(Map<String, dynamic> updatedProfile) async {
    userProfile.value = updatedProfile;
    saveUserProfile(updatedProfile);
  }

  /// Pilih image untuk update photo
  Future<void> pickImage() async {
    ImageSource? imageSource = await Get.defaultDialog(
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      content: const ImagePickerDialog(),
    );

    if (imageSource == null) return;

    final pickedFile = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: 300,
      maxHeight: 300,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      _imageFile.value = File(pickedFile.path);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile.value!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: MainColor.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
        ],
      );

      if (croppedFile != null) {
        _imageFile.value = File(croppedFile.path);

        // Simpan path gambar ke Hive
        var box = Hive.box('venturo');
        var updatedProfile = Map<String, dynamic>.from(userProfile);
        updatedProfile['foto'] = _imageFile.value!.path;
        box.put('userProfile', updatedProfile);

        // Perbarui profil yang ditampilkan
        userProfile.value = updatedProfile;
      }
    }
  }
}
