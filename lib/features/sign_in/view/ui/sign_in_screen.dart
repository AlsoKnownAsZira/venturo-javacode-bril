import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/sign_in/controllers/sign_in_controller.dart';
import 'package:venturo_core/features/sign_in/view/components/form_sign_in_component.dart';
import 'package:venturo_core/shared/styles/google_text_style.dart';
import 'package:venturo_core/shared/styles/elevated_button_style.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:get/get.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    /// Google analytics untuk tracking user di setiap halaman
      if (Platform.isAndroid) {
      /// Tracking bawah dia masuk screen sign in di device android
      analytics.logScreenView(
        screenName: 'Sign in Screen',
        screenClass: 'Android',
      );
    } else if (Platform.isIOS) {
      /// Tracking bawah dia masuk screen otp di device ios
      analytics.logScreenView(
        screenName: 'sign in Screen',
        screenClass: 'IOS',
      );
    } else if (Platform.isMacOS) {
      /// Tracking bawah dia masuk screen sign in di device macos
      analytics.logScreenView(
        screenName: 'sign in Screen',
        screenClass: 'MacOS',
      );
    }

    if (kIsWeb) {
      /// Tracking bahwa dia masuk screen sign in di device web
      analytics.logScreenView(
        screenName: 'sign in Screen',
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
                onDoubleTap: () => SignInController.to.flavorSeting(),
                child: Image.asset(
                  ImageConstant.logo,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 121.h),
              Text(
                'Masuk untuk melanjutkan!',
                style: GoogleTextStyle.fw600.copyWith(
                  fontSize: 22.sp,
                  color: MainColor.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              const FormSignInCompoent(),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(
                      '/forgot_password'), // Adjust the route name as needed
                  child: Text(
                    'Forgot Password?',
                    style: GoogleTextStyle.fw600.copyWith(
                      fontSize: 14.sp,
                      color: MainColor.primary,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: EvelatedButtonStyle.mainRounded,
                onPressed: () => SignInController.to.validateForm(context),
                child: Text(
                  "Masuk",
                  style: GoogleTextStyle.fw800.copyWith(
                    fontSize: 14.sp,
                    color: MainColor.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => SignInController.to.signInWithGoogle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImageConstant.google,
                        height: 24), 
                   const SizedBox(width: 10),
                  const  Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
