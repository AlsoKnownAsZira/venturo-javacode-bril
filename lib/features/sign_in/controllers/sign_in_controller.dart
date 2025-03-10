import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/api_constant.dart';
import 'package:venturo_core/shared/controllers/global_controllers/initial_controller.dart';
import 'package:venturo_core/shared/styles/google_text_style.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();

  /// Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Dio _dio = Dio();
  final Logger logger = Logger();

  /// Form Variable Setting
  var formKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();
  var emailValue = "".obs;
  var passwordCtrl = TextEditingController();
  var passwordValue = "".obs;
  var isPassword = true.obs;
  var isRememberMe = false.obs;

  /// Form Password Show
  void showPassword() {
    if (isPassword.value == true) {
      isPassword.value = false;
    } else {
      isPassword.value = true;
    }
  }

  /// Form Validate & Submited
  void validateForm(context) async {
    await GlobalController.to.checkConnection();

    var isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (isValid && GlobalController.to.isConnect.value == true) {
      EasyLoading.show(
        status: 'Sedang Diproses...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );

      formKey.currentState!.save();
      await _signInWithApi(context);
    } else if (GlobalController.to.isConnect.value == false) {
      Get.toNamed(MainRoute.noConnection);
    }
  }

Future<void> _signInWithApi(BuildContext context) async {
  final url = 'https://trainee.landa.id/javacode/auth/login';
  try {
    logger.d('Sending login request to $url with email: ${emailCtrl.text}');
    final response = await _dio.post(
      url,
      data: {
        'email': emailCtrl.text,
        'password': passwordCtrl.text,
      },
    );

    EasyLoading.dismiss();

    logger.d('Received response: ${response.data}');

    if (response.statusCode == 200 && response.data['status_code'] == 200) {
      final responseData = response.data['data'];
      logger.d('Login successful, userId: ${responseData['user']['id_user']}');
      _saveSession(responseData['user']['id_user'],responseData['user']['pin']); 
      Get.toNamed(MainRoute.checkloc);
    } else {
      logger.w('Login failed, response: ${response.data}');
      PanaraInfoDialog.show(
        context,
        title: "Warning",
        message: "Email & Password Salah",
        buttonText: "Coba lagi",
        onTapDismiss: () {
          Get.back();
        },
        panaraDialogType: PanaraDialogType.warning,
        barrierDismissible: false,
      );
    }
  } catch (e) {
    EasyLoading.dismiss();
    logger.e('Login request failed: $e');
    PanaraInfoDialog.show(
      context,
      title: "Error",
      message: "Failed to sign in. Please try again.",
      buttonText: "Coba lagi",
      onTapDismiss: () {
        Get.back();
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
    );
  }
}

  /// Flavor setting
  void flavorSeting() async {
    Get.bottomSheet(
      Obx(
        () => Wrap(
          children: [
            Container(
              width: double.infinity.w,
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: MainColor.white,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      GlobalController.to.isStaging.value = false;
                      GlobalController.to.baseUrl = ApiConstant.production;
                    },
                    title: Text(
                      "Production",
                      style: GoogleTextStyle.fw400.copyWith(
                        color: GlobalController.to.isStaging.value == true
                            ? MainColor.black
                            : MainColor.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: GlobalController.to.isStaging.value == true
                        ? null
                        : Icon(
                            Icons.check,
                            color: MainColor.primary,
                            size: 14.sp,
                          ),
                  ),
                  Divider(
                    height: 1.h,
                  ),
                  ListTile(
                    onTap: () {
                      GlobalController.to.isStaging.value = true;
                      GlobalController.to.baseUrl = ApiConstant.staging;
                    },
                    title: Text(
                      "Staging",
                      style: GoogleTextStyle.fw400.copyWith(
                        color: GlobalController.to.isStaging.value == true
                            ? MainColor.primary
                            : MainColor.black,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: GlobalController.to.isStaging.value == true
                        ? Icon(
                            Icons.check,
                            color: MainColor.primary,
                            size: 14.sp,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      EasyLoading.show(status: 'Signing in with Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        EasyLoading.dismiss();
        return; // User canceled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _saveSession(googleUser.id.hashCode, '11111'); // Use a unique identifier for the user and provide a default pin

      Get.toNamed(MainRoute.checkloc);

      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      Get.snackbar("Login Failed", error.toString());
    }
  }

  /// Save session status
  void _saveSession(int userId, String pin) {
    var box = Hive.box('venturo');
    box.put('isLoggedIn', true);
    box.put('email', emailCtrl.text);
    box.put('userId', userId);
    logger.d('Email stored in Hive box: ${emailCtrl.text}');
    box.put('pin', pin);
    logger.d('User ID stored in Hive box: $userId');
    logger.d('PIN stored in Hive box: $pin');
  }
}