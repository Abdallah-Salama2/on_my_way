import 'package:flutter/material.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/features/cart/data/models/order.dart';

class OrderHistoryWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderHistoryWidget({
    super.key,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                decoration: BoxDecoration(
                  color: AppColors.cadetGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Order${orderModel.id.toString()}",
                          style: textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          orderModel.id.toString(),
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
                        SizedBox(width: 4),
                        SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            color: AppColors.antiFlashWhite,
                            thickness: 1,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${orderModel.items.length} Items",
                          style: TextStyle(
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
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('Track Order'),
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.pumpkinOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: AppColors.pumpkinOrange,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text('Cancel'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
