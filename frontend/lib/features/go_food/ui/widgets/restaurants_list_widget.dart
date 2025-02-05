import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';

import 'restaurant_card.dart';

class RestaurantsListWidget extends ConsumerWidget {
  final String filterQuery;

  const RestaurantsListWidget({super.key, required this.filterQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsState = ref.watch(storesProvider);
    return restaurantsState.when(
      // skipError: true,
      // skipLoadingOnReload: true, // For state updates from .watch()
      skipLoadingOnRefresh: false, // For .refresh() and .invalidate()
      data: (data) {
        final filteredList = data.restaurantsEntity.data.where((category) {
          return category.name
              .toLowerCase()
              .contains(filterQuery.toLowerCase());
        }).toList();
        if (filteredList.isEmpty) {
          return const SliverToBoxAdapter(
            child: Text('No matches in restaurants.'),
          );
        }
        return SliverList.separated(
          itemCount: data.restaurantsEntity.data.length,
          itemBuilder: (context, index) {
            return RestaurantCard(
                restaurant: data.restaurantsEntity.data[index]);
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
        );
      },
      error: (error, stackTrace) => const SliverToBoxAdapter(
        child: SizedBox(height: 160, child: Text("Error loading restaurants")),
      ),
      loading: () => const SliverToBoxAdapter(
        child: SizedBox(
          height: 160,
          child: Center(child: LinearProgressIndicator()),
        ),
      ),
    );
  }
}
