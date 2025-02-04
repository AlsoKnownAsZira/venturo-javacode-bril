import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venturo_core/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => AnimatedOpacity(
          opacity: splashController.opacity.value,
          duration: const Duration(seconds: 2),
          child: Image.asset('assets/images/ic_javacode.png'),
        )),
      ),
    );
  }
}