import 'package:flutter/material.dart';
import 'package:on_my_way/core/styles/app_colors.dart';

class BackButtonWidget extends StatelessWidget {
  final double? height;

  final Color? color;
  final Color? iconColor;
  final void Function()? onTap;

  const BackButtonWidget({
    super.key,
    this.height,
    this.color,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        height: height ?? 44.0,
        width: height ?? 44.0,
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: InkWell(
          onTap: onTap ?? () => Navigator.pop(context),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              color: iconColor ?? AppColors.onyx,
            ),
          ),
        ),
      ),
    );
  }
}
