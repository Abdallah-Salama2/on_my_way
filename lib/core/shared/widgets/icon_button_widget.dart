import 'package:flutter/material.dart';
import 'package:on_my_way/core/styles/app_colors.dart';

class IconButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final double? diameter;
  final void Function() onTap;
  final Icon icon;

  const IconButtonWidget({
    super.key,
    this.backgroundColor,
    this.diameter,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        height: diameter ?? 30,
        width: diameter ?? 30,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}
