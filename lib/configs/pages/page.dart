import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/features/forgot_password/bindings/forgot_password_binding.dart';
import 'package:venturo_core/features/forgot_password/bindings/otp_binding.dart';
import 'package:venturo_core/features/forgot_password/view/ui/forgot_password_screen.dart';
import 'package:venturo_core/features/forgot_password/view/ui/otp_view.dart';
import 'package:venturo_core/features/initial/views/ui/get_location_screen.dart';
import 'package:venturo_core/features/sign_in/sub_features/no_connection/view/ui/no_connection_screen.dart';
import 'package:venturo_core/features/sign_in/view/ui/sign_in_screen.dart';
import 'package:venturo_core/features/splash/bindings/splash_binding.dart';
import 'package:venturo_core/features/sign_in/bindings/sign_in_binding.dart';
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
      name: MainRoute.profile,
      page: () =>  ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: MainRoute.privacyPolicy,
      page: () =>const  PrivacyPolicyView(),
    ),
      GetPage(
      name: MainRoute.noConnection,
      page: () =>  NoConnectionScreen(),
    ),
    GetPage(
      name: MainRoute.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
  GetPage(
      name: MainRoute.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
  GetPage(
      name: MainRoute.otp,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
  GetPage(
      name: MainRoute.location,
      page: () => const GetLocationScreen(),
    ),


  ];
}
