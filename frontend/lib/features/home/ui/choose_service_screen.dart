import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/home/data/models/home_state.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';
import 'package:on_my_way/features/home/ui/widgets/service_choice_button.dart';

import '../../../core/styles/app_colors.dart';

class ChooseServiceScreen extends ConsumerWidget {
  const ChooseServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Scaffold(
        backgroundColor: AppColors.antiFlashWhite,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose Service",
                      style: textTheme.displaySmall?.copyWith(
                        color: AppColors.pumpkinOrange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(text: "Hey Halal, ", children: [
                        TextSpan(
                          text: "Good Afternoon!",
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.cadetGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.cadetGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: GridView(
                      padding: const EdgeInsets.symmetric(vertical: 33),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 22,
                              crossAxisSpacing: 22),
                      children: [
                        ServiceChoiceButton(
                          text: 'GoCar',
                          assetPath: 'assets/gocar-icon.png',
                          onPressed: () {
                            ref
                                .read(homeStateProvider.notifier)
                                .updateServiceType(ServiceType.goCar);
                            Navigator.of(context)
                                .pushNamed(AppRoutes.homeScreen);
                          },
                        ),
                        ServiceChoiceButton(
                          text: 'GoRide',
                          assetPath: 'assets/goride-icon.png',
                          onPressed: () {
                            ref
                                .read(homeStateProvider.notifier)
                                .updateServiceType(ServiceType.goRide);
                            Navigator.of(context)
                                .pushNamed(AppRoutes.homeScreen);
                          },
                        ),
                        ServiceChoiceButton(
                          text: 'GoFood',
                          assetPath: 'assets/gofood-icon.png',
                          onPressed: () {
                            ref
                                .read(homeStateProvider.notifier)
                                .updateServiceType(ServiceType.goFood);
                            Navigator.of(context)
                                .pushNamed(AppRoutes.homeScreen);
                          },
                        ),
                        ServiceChoiceButton(
                          text: 'GoMart',
                          assetPath: 'assets/gomart-icon.png',
                          onPressed: () {
                            ref
                                .read(homeStateProvider.notifier)
                                .updateServiceType(ServiceType.goMart);
                            Navigator.of(context)
                                .pushNamed(AppRoutes.homeScreen);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
