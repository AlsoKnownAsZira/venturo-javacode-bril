import 'package:flutter/material.dart';

class PrimaryButtonWithTitle extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;
  final bool isLoading;
  final VisualDensity? visualDensity;
  final bool isCompact;
  final double? width;
  final double? height;

  const PrimaryButtonWithTitle({
    super.key,
    this.onPressed,
    required this.title,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.visualDensity,
  }) : isCompact = false;

  const PrimaryButtonWithTitle.compact({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.onPressed,
    this.width,
    this.height,
    this.isLoading = false,
  })  : visualDensity = VisualDensity.compact,
        isCompact = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: titleColor ?? Colors.white, backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          visualDensity: visualDensity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  titleColor ?? Colors.white,
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Colors.white,
                  fontSize: isCompact ? 14.0 : 16.0,
                ),
              ),
      ),
    );
  }
}