import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:venturo_core/configs/routes/route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:venturo_core/features/sign_in/bindings/sign_in_binding.dart';
import 'package:venturo_core/shared/controllers/global_controllers/initial_controller.dart';
import 'package:venturo_core/shared/models/cart_item.dart';
import 'package:venturo_core/shared/models/menu.dart';
import 'package:venturo_core/shared/models/rating.dart';
import 'configs/pages/page.dart';
import 'configs/themes/theme.dart';
import 'utils/services/sentry_services.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());

  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(KategoriAdapter());
   Hive.registerAdapter(RatingModelAdapter()); 

  await Hive.openBox("venturo");
  await Hive.openBox<CartItem>('cartBox');
  await Hive.openBox<RatingModel>('ratingsBox');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.lazyPut(() => GlobalController());

  /// Change your options.dns with your project !!!!
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://30fca41e405dfa6b23883af045e4658e@o4505883092975616.ingest.sentry.io/4506539099095040';
      options.tracesSampleRate = 1.0;
      options.beforeSend = filterSentryErrorBeforeSend;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    /// Screen Util Init berdasarkan ukuran iphone xr
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'Venturo Core',
          debugShowCheckedModeBanner: false,
          locale: const Locale('id'),
          fallbackLocale: const Locale('id'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('id'),
          ],
          initialBinding: SignInBinding(),
          initialRoute: MainRoute.initial,
          theme: themeLight,
          defaultTransition: Transition.native,
          getPages: MainPages.pages,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
