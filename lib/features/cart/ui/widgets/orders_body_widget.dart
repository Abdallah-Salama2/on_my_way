import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/core/utils/enums.dart';

import 'package:on_my_way/features/cart/providers/orders_provider.dart';
import 'package:on_my_way/features/cart/ui/widgets/order_history_widget.dart';
import 'package:on_my_way/features/cart/ui/widgets/ride_history_widget.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';

import '../../../../core/shared/widgets/back_button.dart';
import '../../../../core/styles/app_colors.dart';

class OrdersBodyWidget extends ConsumerStatefulWidget {
  const OrdersBodyWidget({super.key});

  @override
  ConsumerState<OrdersBodyWidget> createState() => _OrdersBodyWidgetState();
}

class _OrdersBodyWidgetState extends ConsumerState<OrdersBodyWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    const verticalSpace = SizedBox(height: 12);

    final ordersState = ref.watch(ordersProvider);
    final homeState = ref.watch(homeStateProvider);
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          title: const Text(
            'My Orders',
            style: TextStyle(color: AppColors.darkGunMetal),
          ),
          automaticallyImplyLeading: false,
          leadingWidth: 60,
          leading: ModalRoute.of(context)?.settings.name == AppRoutes.homeScreen
              ? null
              : const Row(
                  children: [
                    SizedBox(width: 15),
                    BackButtonWidget(
                      color: AppColors.brightGray,
                      iconColor: AppColors.darkGunMetal,
                    ),
                  ],
                ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        verticalSpace,
        TabBar(
          labelColor: AppColors.pumpkinOrange,
          indicatorColor: AppColors.pumpkinOrange,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'History'),
          ],
        ),
        ordersState.when(
          data: (data) {
            final isFood = homeState.selectedServiceType!.isEcommerce;
            final ongoingFoodList = data.items.where(
              (element) {
                return element.status.toLowerCase() == 'pending';
              },
            ).toList();

            final historyFoodList = data.items.where(
              (element) {
                return element.status.toLowerCase() != 'pending';
              },
            ).toList();

            final ongoingRidesList = data.rides.where(
              (element) {
                return element.status.toLowerCase() == 'pending';
              },
            ).toList();

            final historyRidesList = data.rides.where(
              (element) {
                return element.status.toLowerCase() != 'pending';
              },
            ).toList();

            return Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(ordersProvider);
                    },
                    child: ListView(children: [
                      ...List.generate(
                        isFood
                            ? ongoingFoodList.length
                            : ongoingRidesList.length,
                        (index) {
                          if (!isFood) {
                            return RidesHistoryWidget(
                              orderModel: historyRidesList[index],
                              isOngoing: true,
                            );
                          }
                          return OrderHistoryWidget(
                            orderModel: ongoingFoodList[index],
                            isOngoing: true,
                          );
                        },
                      ),
                      const SizedBox(height: 200),
                    ]),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(ordersProvider);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        ...List.generate(
                          isFood
                              ? historyFoodList.length
                              : historyRidesList.length,
                          (index) {
                            if (!isFood) {
                              return RidesHistoryWidget(
                                orderModel: historyRidesList[index],
                                isOngoing: false,
                              );
                            }
                            return OrderHistoryWidget(
                              orderModel: historyFoodList[index],
                              isOngoing: false,
                            );
                          },
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Column(
                children: [
                  const Text('An error occured'),
                  OutlinedButton(
                    onPressed: () {
                      ref.invalidate(ordersProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: LinearProgressIndicator(),
          ),
        )
      ],
    );
  }
}
