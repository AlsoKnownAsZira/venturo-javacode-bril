import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/features/splash/bindings/splash_binding.dart';
import 'package:venturo_core/features/profile/bindings/profile_binding.dart';
import 'package:venturo_core/features/splash/view/components/privacy_policy_view.dart';
import 'package:venturo_core/features/profile/view/ui/profile_screen.dart';
import 'package:venturo_core/features/splash/view/ui/splash_screen.dart';

abstract class MainPages {
  static final pages = [
    GetPage(
      name: MainRoute.splashRoute,
      page: () => SplashScreen(),
      binding: SplashBinding()
    ),
    GetPage(
      name: MainRoute.profileView,
      page: () =>  ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: MainRoute.privacyPolicy,
      page: () =>const  PrivacyPolicyView(),
    ),

  ];
}
