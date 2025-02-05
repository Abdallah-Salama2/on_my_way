import 'package:equatable/equatable.dart';
import 'package:on_my_way/features/go_food/data/entities/restaurant_items_entity.dart';
import 'package:on_my_way/features/go_food/data/entities/restaurants_entity.dart';

import '../../data/models/restaurant.dart';

class RestaurantsState extends Equatable {
  final RestaurantsEntity restaurantsEntity;
  final RestaurantItemsEntity restaurantItemsEntity;

  const RestaurantsState({
    this.restaurantsEntity = const RestaurantsEntity(
      success: true,
      message: '',
      data: [],
    ),
    this.restaurantItemsEntity = const RestaurantItemsEntity(
      success: true,
      message: '',
      products: [],
      restaurant: Restaurant(
        id: -1,
        imageUrl: '',
        typeId: -1,
        locationId: -1,
        name: 'name',
        openingHours: 'openingHours',
        phone: '',
        rating: -1,
        favoriteStats: false,
      ),
    ),
  });

  RestaurantsState copyWith({
    RestaurantsEntity? restaurantsEntity,
    RestaurantItemsEntity? restaurantItemsEntity,
  }) {
    return RestaurantsState(
      restaurantsEntity: restaurantsEntity ?? this.restaurantsEntity,
      restaurantItemsEntity:
          restaurantItemsEntity ?? this.restaurantItemsEntity,
    );
  }

  @override
  List<Object?> get props => [restaurantsEntity, restaurantItemsEntity];
}
