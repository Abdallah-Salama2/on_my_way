import 'package:flutter/material.dart';
import 'package:on_my_way/core/styles/app_colors.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: constraints.maxHeight*0.65,
            width: constraints.maxWidth*0.7,
            decoration: BoxDecoration(
              color: AppColors.cadetGrey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Column(
            children: [
              Text(
                'Order from chosen chef',
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.onyx,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: constraints.maxWidth*0.85,
                child: Text(
                  'Get all your loved foods in one place, you just place the order and we do the rest.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.darkElectricBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
