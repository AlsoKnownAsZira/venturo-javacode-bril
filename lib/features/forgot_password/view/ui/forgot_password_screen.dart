import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/features/forgot_password/controllers/forgot_password_controller.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:venturo_core/shared/customs/text_form_field_custom.dart';
import 'package:venturo_core/shared/styles/elevated_button_style.dart';
import 'package:venturo_core/shared/styles/google_text_style.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    /// Google analytics untuk tracking user di setiap halaman
    if (Platform.isAndroid) {
      /// Tracking bawah dia masuk screen lupa password di device android
      analytics.logScreenView(
        screenName: 'Forgot Password Screen',
        screenClass: 'Android',
      );
    } else if (Platform.isIOS) {
      /// Tracking bawah dia masuk screen lupa password di device ios
      analytics.logScreenView(
        screenName: 'Forgot Password Screen',
        screenClass: 'IOS',
      );
    } else if (Platform.isMacOS) {
      /// Tracking bawah dia masuk screen lupa password di device macos
      analytics.logScreenView(
        screenName: 'Forgot Password Screen',
        screenClass: 'MacOS',
      );
    }

   if (kIsWeb) {
      /// Tracking bawah dia masuk screen lupa password di device web
      analytics.logScreenView(
        screenName: 'Forgot Password Screen',
        screenClass: 'Web',
      );
    }

    return Scaffold(
      appBar: null,
      extendBody: false,
      backgroundColor: MainColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 121.h),
              GestureDetector(
                child: Image.asset(
                  ImageConstant.logo,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 121.h),
              Text(
                'Masukkan alamat email untuk mengubah password anda',
                style: GoogleTextStyle.fw600.copyWith(
                  fontSize: 22.sp,
                  color: MainColor.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Form(
                key: ForgotPasswordController.to.formKey,
                child: TextFormFieldCustoms(
                  controller: ForgotPasswordController.to.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  initialValue: ForgotPasswordController.to.emailValue.value,
                  label: "Email Address",
                  hint: "Input Email Address",
                  isRequired: true,
                  requiredText: "Email address cannot be empty",
                ),
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                style: EvelatedButtonStyle.mainRounded,
                onPressed: () {
                  // Navigate to the OTP screen
                  Get.toNamed('/otp'); 
                },
                child: Text(
                  "Ubah Password",
                  style: GoogleTextStyle.fw800.copyWith(
                    fontSize: 14.sp,
                    color: MainColor.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}