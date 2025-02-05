import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/features/cart/data/models/food_order.dart';
import 'package:on_my_way/features/cart/providers/orders_provider.dart';

class OrderHistoryWidget extends ConsumerWidget {
  final FoodOrderModel orderModel;
  final bool isOngoing;

  const OrderHistoryWidget({
    super.key,
    required this.orderModel,
    required this.isOngoing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final ordersNotifier = ref.read(ordersProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.cadetGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  orderModel.items.first.imageUrl!,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Order#${orderModel.id.toString()}",
                          style: textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          "#${orderModel.id.toString()}",
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.pumpkinOrange,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.pumpkinOrange,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${orderModel.orderAmount} EGP",
                          style: textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            color: AppColors.antiFlashWhite,
                            thickness: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${orderModel.items.length} Items",
                          style: const TextStyle(
                            color: AppColors.pumpkinOrange,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          if (isOngoing)
            ElevatedButton(
              onPressed: () {
                ordersNotifier.deleteOrder(orderModel.id);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(41),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancel'),
            )
          else
            ElevatedButton(
              onPressed: () {
                ordersNotifier.reorder(orderModel.id);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(41),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Re-order'),
            ),
          const Divider(),
        ],
      ),
    );
  }
}
