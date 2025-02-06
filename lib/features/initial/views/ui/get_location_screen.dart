import 'package:flutter/material.dart';
import 'package:venturo_core/constants/image_constant.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/shared/controllers/global_controllers/initial_controller.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:app_settings/app_settings.dart';

class GetLocationScreen extends StatelessWidget {
  const GetLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.loading),
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Searching location...'.tr,
                style: Get.textTheme.titleLarge!
                    .copyWith(color: MainColor.kDarkColor.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
              50.verticalSpacingRadius,
              Stack(
                children: [
                  Image.asset(
                    ImageConstant.map,
                    width: 190.r,
                  ),
                  Padding(
                    padding: EdgeInsets.all(70.r),
                    child: Icon(
                      Icons.location_pin,
                      size: 50.r,
                    ),
                  ),
                ],
              ),
              50.verticalSpacingRadius,
              Obx(
                () => ConditionalSwitch.single<String>(
                  context: context,
                  valueBuilder: (context) =>
                      GlobalController.to.statusLocation.value,
                  caseBuilders: {
                    'error': (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              GlobalController.to.messageLocation.value,
                              style: Get.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            24.verticalSpacingRadius,
                             
                            ElevatedButton(
                              onPressed: () =>
                                  AppSettings.openAppSettings(type: AppSettingsType.location),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 2,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),
                           
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.settings,
                                    color: MainColor.kDarkColor,
                                  ),
                                  16.horizontalSpaceRadius,
                                  Text(
                                    'Open settings'.tr,
                                    style: Get.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    'success': (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              GlobalController.to.address.value!,
                              style: Get.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            24.verticalSpacingRadius,
                           
                          ],
                        ),
                    'far': (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              GlobalController.to.address.value!,
                              style: Get.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            24.verticalSpacingRadius,
                          const  Text("Lokasi anda terlalu jauh dari javacode!")
                          ],
                        ),
                  },
                  fallbackBuilder: (context) => const CircularProgressIndicator(
                    color: MainColor.kBlueColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async => false,
      ),
    );
  }
}