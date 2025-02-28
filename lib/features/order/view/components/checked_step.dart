import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venturo_core/configs/themes/main_color.dart';

class CheckedStep extends StatelessWidget {
  const CheckedStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: MainColor.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: -1,
            color: Colors.black54,
          ),
        ],
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 30.r,
      ),
    );
  }
}
