import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/widgets/back_button.dart';
import 'package:on_my_way/features/cart/ui/widgets/cart_button_widget.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';
import 'package:on_my_way/features/go_food/ui/widgets/item_card.dart';

import '../../../core/styles/app_colors.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const verticalSpace = SliverToBoxAdapter(child: SizedBox(height: 12));
    final textTheme = Theme.of(context).textTheme;

    final restaurant = ref.watch(storesProvider);
    final restaurantNotifier = ref.read(storesProvider.notifier);
    return Scaffold(
      body: restaurant.when(
        data: (data) {
          final restaurantData = data.restaurantItemsEntity;
          return CustomScrollView(
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
                    // clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: AppColors.cadetGrey,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: Image.network(
                      data.restaurantItemsEntity.restaurant.imageUrl,
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
                            restaurantData.restaurant.rating.toString(),
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
                              restaurantNotifier
                                  .toggleRestaurantFavoriteStats();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  restaurantData.restaurant.favoriteStats
                                      ? AppColors.pumpkinOrange
                                      : Colors.white,
                              side: BorderSide(
                                color: restaurantData.restaurant.favoriteStats
                                    ? AppColors.pumpkinOrange
                                    : AppColors.cadetGrey,
                              ),
                            ),
                            icon: Icon(
                              CupertinoIcons.heart_fill,
                              color: restaurantData.restaurant.favoriteStats
                                  ? Colors.white
                                  : AppColors.cadetGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        restaurantData.restaurant.name,
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
              verticalSpace,
              verticalSpace,
              // Products text
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Products',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              verticalSpace,
              // The Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ItemCard(
                          data.restaurantItemsEntity.products[index]);
                    },
                    childCount: restaurantData.products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 213,
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('An error occured'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
