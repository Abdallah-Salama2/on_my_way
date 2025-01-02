import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';

class ServiceChoiceButton extends StatelessWidget {
  const ServiceChoiceButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.assetPath,
  });
  final void Function()? onPressed;
  final String text;
  final String assetPath;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: onPressed,
            elevation: 1,
            color: AppColors.lightOrangeRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Image.asset(assetPath),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.orangeRed,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
