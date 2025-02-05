import 'package:flutter/material.dart';
import 'package:venturo_core/configs/themes/main_color.dart';

class EvelatedButtonStyle {
  static final ButtonStyle mainRounded = ElevatedButton.styleFrom(
    backgroundColor: MainColor.primary,
    foregroundColor: MainColor.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );
}