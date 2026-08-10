import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'AllColors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.padding,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? getHeight(50),
      child: InkWell(
        onTap: (isDisabled || isLoading) ? null : onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 50),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 50),
            color: isDisabled
                ? AppColors.primaryColor.withOpacity(0.5)
                : backgroundColor ?? AppColors.primaryColor,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: getHeight(22),
                    width: getWidth(22),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        SizedBox(width: getWidth(8)),
                      ],
                      Text(
                        title,
                        style: textStyle ??
                            AppColors().customTextStyleBold16(
                              color: textColor ?? AppColors.textColor,
                            ),
                      ),
                      if (suffixIcon != null) ...[
                        SizedBox(width: getWidth(8)),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}