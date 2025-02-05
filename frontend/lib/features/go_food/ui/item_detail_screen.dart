import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:on_my_way/features/go_food/data/models/product.dart';
import 'package:on_my_way/features/go_food/providers/favorites/favorites_provider.dart';

import '../../../core/shared/helpers/ftoast_helper.dart';
import '../../../core/shared/widgets/back_button.dart';
import '../../../core/styles/app_colors.dart';
import '../../cart/providers/cart_provider.dart';
import '../../cart/ui/widgets/cart_button_widget.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ItemDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  int quantity = 1;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.favoriteStats;
  }

  @override
  Widget build(BuildContext context) {
    const verticalSpace = SliverToBoxAdapter(child: SizedBox(height: 12));
    final textTheme = Theme.of(context).textTheme;

    final favoritesProv = ref.read(favoritesProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: AppColors.cadetGrey,
            clipBehavior: Clip.antiAlias,
            expandedHeight: 200,
            leading: const Row(
              children: [
                SizedBox(width: 8),
                BackButtonWidget(),
              ],
            ),
            actions: const [
              CartButtonWidget(invertColors: true),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: AppColors.cadetGrey,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          verticalSpace,
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //
                      const Icon(
                        Icons.star_border_rounded,
                        color: AppColors.pumpkinOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),

                      //
                      const Icon(
                        Icons.delivery_dining_outlined,
                        color: AppColors.pumpkinOrange,
                      ),
                      const SizedBox(width: 4),
                      const Text("Free"),
                      const Spacer(),

                      //
                      const Icon(Icons.access_time,
                          color: AppColors.pumpkinOrange),
                      const SizedBox(width: 4),
                      const Text("20 min"),
                      const Spacer(),

                      IconButton.outlined(
                        onPressed: () {
                          favoritesProv.toggleFavorites(widget.product.id).then(
                            (value) {
                              if (value is bool) {
                                isFavorite = value;
                                setState(() {});
                              }
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFavorite
                              ? AppColors.pumpkinOrange
                              : Colors.white,
                          side: BorderSide(
                            color: isFavorite
                                ? AppColors.pumpkinOrange
                                : AppColors.cadetGrey,
                          ),
                        ),
                        icon: Icon(
                          CupertinoIcons.heart_fill,
                          color:
                              isFavorite ? Colors.white : AppColors.cadetGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.name,
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  ),
                ],
              ),
            ),
          ),
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
                    color: AppColors.aliceBlue,
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
                          Text(
                            "${((widget.product.price * quantity) * 100).round() / 100} EGP",
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.darkGunMetal,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        quantity--;
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.outerSpace,
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  quantity.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.outerSpace,
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {
                          cartNotifier
                              .updateCart(
                            itemId: widget.product.id,
                            quantity: quantity,
                            isAdding: true,
                          )
                              .then(
                            (value) {
                              FtoastHelper.showSuccessToast('Added to cart.');
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(62),
                        ),
                        child: const Text('ADD TO CART'),
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
  }
}
