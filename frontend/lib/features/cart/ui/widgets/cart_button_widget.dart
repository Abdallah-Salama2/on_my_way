import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/cart/providers/cart_provider.dart';

import '../../../../core/styles/app_colors.dart';

class CartButtonWidget extends ConsumerStatefulWidget {
  final bool invertColors;

  const CartButtonWidget({
    super.key,
    this.invertColors = false,
  });

  @override
  ConsumerState<CartButtonWidget> createState() => _CartButtonWidgetState();
}

class _CartButtonWidgetState extends ConsumerState<CartButtonWidget> {
  bool isLabelVisible = false;

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);

    return Badge(
      backgroundColor: AppColors.pumpkinOrange,
      isLabelVisible: isLabelVisible,
      alignment: const Alignment(0.5, -0.7),
      label: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: AppColors.pumpkinOrange,
          shape: BoxShape.circle,
        ),
        child: cartData.when(
          skipError: true,
          skipLoadingOnReload: true,
          data: (data) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isLabelVisible = true;
              });
            });
            return Text(
              data.items.length.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          },
          error: (error, stackTrace) {
            return;
          },
          loading: () {
            return;
          },
        ),
      ),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: Ink(
          height: 44.0,
          width: 44.0,
          decoration: BoxDecoration(
            color:
                widget.invertColors ? AppColors.white : AppColors.darkGunMetal,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.cartScreen);
            },
            child: Center(
              child: Icon(
                Icons.shopping_cart_outlined,
                color:
                    widget.invertColors ? AppColors.darkGunMetal : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
