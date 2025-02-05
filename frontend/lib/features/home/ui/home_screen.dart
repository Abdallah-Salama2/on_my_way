import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/cart/ui/widgets/orders_body_widget.dart';
import 'package:on_my_way/features/go_food/ui/go_food_body.dart';
import 'package:on_my_way/features/go_ride/providers/go_ride_state.dart';
import 'package:on_my_way/features/home/data/models/home_state.dart';
import 'package:on_my_way/features/go_ride/providers/go_ride_provider.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';
import 'package:on_my_way/features/home/ui/choose_service_screen.dart';
import 'package:on_my_way/features/go_ride/ui/go_ride_body.dart';
import 'package:on_my_way/features/settings/ui/settings_body.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;
  final selectedColor = AppColors.pumpkinOrange;
  final unselectedColor = AppColors.cadetGrey;

  bool isSelected(int index) {
    return index == selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final navBarTextTheme = Theme.of(context).textTheme.bodyMedium;
    final homeState = ref.read(homeStateProvider);
    final goRideState = ref.watch(goRideStateProvider);
    return Scaffold(
      extendBody: true,
      body: [
        switch (homeState.selectedServiceType) {
          ServiceType.goCar || ServiceType.goRide => const GoRideBody(),
          ServiceType.goFood => const GoFoodBody(),
          ServiceType.goMart => const GoFoodBody(),
          null => const Center(child: Text('Choose a service')),
        },
        const ChooseServiceScreen(),
        const OrdersBodyWidget(),
        const SettingsBody(),
      ][selectedIndex],
      bottomNavigationBar: (goRideState.rideState != RideState.choosingFrom &&
              goRideState.rideState != RideState.choosingWhereTo)
          ? null
          : Container(
              height: 80.0,
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  AppColors.boxShadowBlack26,
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    minWidth: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected(0) ? Icons.home_filled : Icons.home_filled,
                          color:
                              isSelected(0) ? selectedColor : unselectedColor,
                        ),
                        Text(
                          'Home',
                          style: navBarTextTheme?.copyWith(
                            color:
                                isSelected(0) ? selectedColor : unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(AppRoutes.chooseServiceScreen),
                      );
                      // setState(() {
                      //   selectedIndex = 1;
                      // });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.apps,
                          color:
                              isSelected(1) ? selectedColor : unselectedColor,
                        ),
                        Text(
                          'Services',
                          style: navBarTextTheme?.copyWith(
                            color:
                                isSelected(1) ? selectedColor : unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected(2)
                              ? Icons.bookmark
                              : Icons.bookmark_border_rounded,
                          color:
                              isSelected(2) ? selectedColor : unselectedColor,
                        ),
                        Text(
                          'Activity',
                          style: navBarTextTheme?.copyWith(
                            color:
                                isSelected(2) ? selectedColor : unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected(3)
                              ? CupertinoIcons.gear_solid
                              : CupertinoIcons.gear,
                          color:
                              isSelected(3) ? selectedColor : unselectedColor,
                        ),
                        Text(
                          'Settings',
                          style: navBarTextTheme?.copyWith(
                            color:
                                isSelected(3) ? selectedColor : unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
