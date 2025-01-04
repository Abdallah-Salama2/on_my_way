import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/go_food/data/models/restaurant.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';

class RestaurantCard extends ConsumerWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final restaurantNotifier = ref.read(storesProvider.notifier);
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        restaurantNotifier.showRestaurantItems(restaurant.id);
        Navigator.of(context).pushNamed(AppRoutes.restaurantScreen);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.cadetGrey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.network(
              restaurant.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Placeholder();
              },
            ),
          ),
          const SizedBox(height: 7),
          Text(
            restaurant.name,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          Text(
            'Burger - Chiken - Riche - Wings ',
            style:
                textTheme.bodyLarge?.copyWith(color: AppColors.pumpkinOrange),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              //
              const Icon(
                Icons.star_border_rounded,
                color: AppColors.pumpkinOrange,
              ),
              const SizedBox(width: 4),
              Text(
                restaurant.rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),

              //
              const Icon(
                Icons.delivery_dining_outlined,
                color: AppColors.pumpkinOrange,
              ),
              const SizedBox(width: 4),
              Text("Free"),
              const SizedBox(width: 12),

              //
              const Icon(Icons.access_time, color: AppColors.pumpkinOrange),
              const SizedBox(width: 4),
              Text("20 min")
            ],
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
}
