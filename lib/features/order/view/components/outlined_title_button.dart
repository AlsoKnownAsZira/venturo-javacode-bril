import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlinedTitleButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final VisualDensity? visualDensity;
  final bool isCompact;

  const OutlinedTitleButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.visualDensity,
  })  : isCompact = false,
        super(key: key);

  const OutlinedTitleButton.compact({
    Key? key,
    required this.text,
    this.onPressed,
  })  : visualDensity = VisualDensity.compact,
        isCompact = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        visualDensity: visualDensity,
        backgroundColor: Colors.white,
        maximumSize: Size(1.sw, 56.h),
        elevation: 3,
        textStyle: GoogleFonts.montserrat(
          fontSize: isCompact ? 10.sp : 14.sp,
          fontWeight: FontWeight.w800,
          height: 1.219,
        ),
        tapTargetSize: isCompact ? MaterialTapTargetSize.shrinkWrap : null,
        minimumSize: isCompact ? Size(100.w, 30.h) : Size(1.sw, 56.h),
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 18.w : 24.w,
          vertical: isCompact ? 0.h : 14.h,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColorDark, width: 1),
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
      child:
          Text(text, style: TextStyle(color: Theme.of(context).primaryColor)),
    );
  }
}