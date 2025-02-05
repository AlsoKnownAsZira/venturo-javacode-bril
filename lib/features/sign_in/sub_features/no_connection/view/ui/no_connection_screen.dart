  import 'package:flutter/material.dart';
import 'package:venturo_core/features/sign_in/constants/sign_in_assets_constant.dart';
  class NoConnectionScreen extends StatelessWidget {
    NoConnectionScreen({Key? key}):super(key: key);

    final assetsConstant = SignInAssetsConstant();
    @override
    Widget build(BuildContext context) {
      return const Scaffold(
        body: Center(
          child: Text("No Connection"),
        ),
      );
    }
  }
    