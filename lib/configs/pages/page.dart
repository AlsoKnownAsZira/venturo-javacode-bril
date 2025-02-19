import 'package:get/get.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:venturo_core/features/detail_order/bindings/detail_order_binding.dart';
import 'package:venturo_core/features/forgot_password/bindings/forgot_password_binding.dart';
import 'package:venturo_core/features/forgot_password/bindings/otp_binding.dart';
import 'package:venturo_core/features/forgot_password/view/ui/forgot_password_screen.dart';
import 'package:venturo_core/features/forgot_password/view/ui/otp_view.dart';
import 'package:venturo_core/features/initial/views/ui/check_location_screen.dart';
import 'package:venturo_core/features/initial/views/ui/get_location_screen.dart';
import 'package:venturo_core/features/list/bindings/list_binding.dart';
import 'package:venturo_core/features/list/sub_features/checkout/view/ui/checkout_screen.dart';
import 'package:venturo_core/features/list/sub_features/checkout_voucher/view/ui/checkout_voucher_detail.dart';
import 'package:venturo_core/features/list/sub_features/checkout_voucher/view/ui/checkout_voucher_screen.dart';
import 'package:venturo_core/features/list/sub_features/detail_menu/view/ui/detail_menu_screen.dart';
import 'package:venturo_core/features/list/sub_features/promo/view/ui/promo_screen.dart';
import 'package:venturo_core/features/list/view/ui/list_screen.dart';
import 'package:venturo_core/features/order/bindings/order_binding.dart';
import 'package:venturo_core/features/detail_order/view/ui/detail_order_view.dart';
import 'package:venturo_core/features/order/view/ui/order_screen.dart';
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
  GetPage(
      name: MainRoute.checkloc,
      page: () => const CheckLocationScreen(),
    ),
  GetPage(
      name: MainRoute.list,
      page: () => ListScreen(),
      binding: ListBinding(),
    ),
  GetPage(
      name: MainRoute.listDetail,
      page: () => DetailMenuScreen(),
      binding: ListBinding(), 
    ),
  GetPage(
      name: MainRoute.listCheckout,
      page: () => CheckoutScreen(),
      binding: ListBinding(), 
    ),
  GetPage(
      name: MainRoute.order,
      page: () =>const  OrderScreen(),
      binding: OrderBinding(), 
    ),
  GetPage(
      name: MainRoute.orderDetail,
      page: () =>const  DetailOrderView(),
      binding: DetailOrderBinding(), 
    ),
  GetPage(
      name: MainRoute.promo,
      page: () => PromoScreen(),
      binding: ListBinding(), 
    ),
  GetPage(
      name: MainRoute.checkoutVoucher,
      page: () => CheckoutVoucherScreen(),
      binding: ListBinding(), 
    ),
  GetPage(
      name: MainRoute.checkoutVoucherDetail,
      page: () => CheckoutVoucherDetail(),
      binding: ListBinding(), 
    ),


  ];
}
