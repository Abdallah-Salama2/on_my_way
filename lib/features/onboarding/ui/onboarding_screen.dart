import 'package:flutter/material.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/onboarding/ui/widgets/onboarding1.dart';
import 'package:on_my_way/features/onboarding/ui/widgets/onboarding2.dart';
import 'package:on_my_way/features/onboarding/ui/widgets/onboarding3.dart';
import 'package:on_my_way/features/onboarding/ui/widgets/onboarding4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController pageController;
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: PageView(
                controller: pageController,
                children: const [
                  Onboarding1(),
                  Onboarding2(),
                  Onboarding3(),
                  Onboarding4(),
                ],
                onPageChanged: (value) {
                  setState(() {
                    pageIndex = value;
                  });
                },
              ),
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: 4,
              effect: const SwapEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: AppColors.pumpkinOrange,
                dotColor: AppColors.lightOrangeRed,
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: pageIndex == 3
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.loginScreen);
                          },
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style
                              ?.copyWith(
                                  minimumSize: const WidgetStatePropertyAll(
                                      Size.fromHeight(62))),
                          child: const Text('Get Started'),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              pageController.nextPage(
                                duration: Durations.medium1,
                                curve: Curves.bounceIn,
                              );
                            },
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style
                                ?.copyWith(
                                    minimumSize: const WidgetStatePropertyAll(
                                        Size.fromHeight(62))),
                            child: const Text('Next'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.loginScreen);
                            },
                            child: const Text('Skip'),
                          )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
