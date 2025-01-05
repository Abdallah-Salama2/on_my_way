import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/widgets/dynamic_form_field.dart';
import 'package:on_my_way/core/shared/widgets/icon_button_widget.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/core/utils/extensions.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';
import 'package:on_my_way/features/cart/providers/cart_provider.dart';

import '../../../core/shared/widgets/back_button.dart';
import '../../../core/styles/app_colors.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final cartAsyncData = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      body: cartAsyncData.when(
        skipLoadingOnReload: true,
        skipError: true,
        data: (cartData) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(cartProvider);
            },
            child: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  floating: false,
                  pinned: false,
                  snap: false,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  title: Text(
                    'Cart',
                    style: TextStyle(color: AppColors.pumpkinOrange),
                  ),
                  leadingWidth: 60,
                  leading: Row(
                    children: [
                      SizedBox(width: 15),
                      BackButtonWidget(
                        color: AppColors.eggShell,
                        iconColor: AppColors.pumpkinOrange,
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                for (final cartItem in cartData.items)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 117,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 117,
                            width: 136,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppColors.macaroniAndCheese,
                              boxShadow: const [AppColors.boxShadowBlack26],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Image.network(
                              cartItem.product.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cartItem.product.name,
                                        maxLines: 2,
                                        style: textTheme.titleMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButtonWidget(
                                      backgroundColor: AppColors.pumpkinOrange,
                                      onTap: () {
                                        cartNotifier.deleteCartItem(
                                          itemId: cartItem.product.id,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${cartItem.totalPrice} EGP',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: AppColors.pumpkinOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButtonWidget(
                                      backgroundColor: AppColors.pumpkinOrange
                                          .withOpacity(0.2),
                                      onTap: () {
                                        cartNotifier.updateCart(
                                          itemId: cartItem.product.id,
                                          quantity: 1,
                                          isAdding: false,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        color: AppColors.pumpkinOrange,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    Text(
                                      cartItem.quantity.toString(),
                                      style: textTheme.titleSmall,
                                    ),
                                    const SizedBox(width: 11),
                                    IconButtonWidget(
                                      backgroundColor: AppColors.pumpkinOrange
                                          .withOpacity(0.2),
                                      onTap: () {
                                        cartNotifier.updateCart(
                                          itemId: cartItem.product.id,
                                          quantity: 1,
                                          isAdding: true,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: AppColors.pumpkinOrange,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bottom Place Order
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Text('DELIVER ADDRESS'),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'EDIT',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.pumpkinOrange,
                                      decorationColor: AppColors.pumpkinOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DynamicFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: ref
                                    .read(authStateProvider)
                                    .authEntity
                                    ?.data
                                    .user
                                    .address,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Text(
                                  'TOTAL:',
                                  style: TextStyle(
                                    color: AppColors.cadetGrey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${cartData.totalPrice.roundedToHundredth.toString()}EGP",
                                  style: textTheme.headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: cartData.items.isEmpty
                                  ? null
                                  : () {
                                      Navigator.of(context)
                                          .pushNamed(AppRoutes.paymentScreen);
                                    },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size.fromHeight(62),
                              ),
                              child: const Text('PLACE ORDER'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('An error occured'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
