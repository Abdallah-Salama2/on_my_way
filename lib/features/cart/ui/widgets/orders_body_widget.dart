import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/cart/providers/orders_provider.dart';
import 'package:on_my_way/features/cart/ui/widgets/order_history_widget.dart';

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
            final ongoingList = data.items.where(
              (element) {
                return element.status.toLowerCase() == 'pending';
              },
            ).toList();

            final historyList = data.items.where(
              (element) {
                return element.status.toLowerCase() != 'pending';
              },
            ).toList();
            return Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: List.generate(
                      ongoingList.length,
                      (index) {
                        return OrderHistoryWidget(
                          orderModel: ongoingList[index],
                        );
                      },
                    ),
                  ),
                  Column(
                    children: List.generate(
                      historyList.length,
                      (index) {
                        return OrderHistoryWidget(
                          orderModel: historyList[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return const Center(
              child: Text('An error occured'),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
