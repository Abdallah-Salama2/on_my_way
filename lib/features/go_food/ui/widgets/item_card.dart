import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/helpers/ftoast_helper.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/features/cart/providers/cart_provider.dart';

import 'package:on_my_way/features/go_food/data/models/product.dart';
import 'package:on_my_way/features/go_food/ui/item_detail_screen.dart';

class ItemCard extends ConsumerWidget {
  final Product product;

  const ItemCard(this.product, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ItemDetailScreen(product: product);
          },
        ));
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            AppColors.boxShadowBlack26.copyWith(),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.darkElectricBlue),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${product.price.toString()} EGP",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: IconButton(
                          onPressed: () {
                            cartNotifier
                                .updateCart(
                              itemId: product.id,
                              quantity: 1,
                              isAdding: true,
                            )
                                .then(
                              (value) {
                                FtoastHelper.showSuccessToast('Added to cart.');
                              },
                            );
                          },
                          padding: EdgeInsets.zero,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: AppColors.pumpkinOrange,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
