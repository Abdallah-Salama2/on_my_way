import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/enums.dart';

import 'package:on_my_way/features/go_food/data/repos/store_repo.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';

import '../../../../core/errors/exceptions.dart';

import '../../data/repos/favorites_repo.dart';
import 'restaurants_state.dart';

final storesProvider =
    AsyncNotifierProvider<RestaurantsProvider, RestaurantsState>(
  () => RestaurantsProvider(),
  name: "Stores Provider",
);

class RestaurantsProvider extends AsyncNotifier<RestaurantsState> {
  @override
  Future<RestaurantsState> build() async {
    return initStores();
  }

  Future<RestaurantsState> initStores() async {
    final int type =
        ref.read(homeStateProvider).selectedServiceType!.isGoFood ? 1 : 2;
    final storesRepo = ref.read(storeRepoProvider);

    final result = await storesRepo.getStores(type: type);
    return result.fold(
      (l) {
        throw ServerException(message: l.message);
      },
      (r) {
        return RestaurantsState(restaurantsEntity: r);
      },
    );
  }

  Future<void> showRestaurantItems(int id) async {
    final storesRepo = ref.read(storeRepoProvider);

    if (id == state.value?.restaurantItemsEntity.restaurant.id) {
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final result = await storesRepo.showSingleStore(id: id);
        return result.fold(
          (l) {
            throw Exception(l);
          },
          (r) {
            final x = state.valueOrNull!.copyWith(restaurantItemsEntity: r);
            return x;
          },
        );
      },
    );
  }

  void toggleRestaurantFavoriteStats() async {
    final favoritesRepo = ref.read(favoritesRepoProvider);

    final id = state.value!.restaurantItemsEntity.restaurant.id;

    final result = await favoritesRepo.toggleFavorites(
      id: id.toString(),
      isProduct: false,
    );

    result.fold(
      (l) {
        log(l.message);

        return;
      },
      (r) async {
        state = await AsyncValue.guard(
          () async {
            final stateValue = state.valueOrNull;
            return stateValue!.copyWith(
              restaurantItemsEntity: stateValue.restaurantItemsEntity.copyWith(
                restaurant:
                    stateValue.restaurantItemsEntity.restaurant.copyWith(
                  favoriteStats: r,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void toggleFavoriteStatsIfExists(int id) async {
    final index = state.value?.restaurantItemsEntity.products.indexWhere(
      (element) {
        return element.id == id;
      },
    );

    if (index != -1 && index != null) {
      final updatedList =
          state.value!.restaurantItemsEntity.products.map((item) {
        if (item.id == id) {
          return item.copyWith(favoriteStats: !item.favoriteStats);
        } else {
          return item;
        }
      }).toList();

      state = await AsyncValue.guard(
        () async {
          final stateValue = state.valueOrNull;
          return stateValue!.copyWith(
              restaurantItemsEntity: stateValue.restaurantItemsEntity.copyWith(
            items: updatedList,
          ));
        },
      );
    }
  }
}
