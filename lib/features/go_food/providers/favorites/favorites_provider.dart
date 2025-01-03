import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/enums.dart';

import 'package:on_my_way/features/go_food/data/repos/favorites_repo.dart';
import 'package:on_my_way/features/go_food/providers/categories/categories_provider.dart';

import 'package:on_my_way/features/go_food/providers/favorites/favorites_state.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';

import '../../../../core/errors/exceptions.dart';

final favoritesProvider =
    AsyncNotifierProvider<FavoritesProvider, FavoritesState>(
  () => FavoritesProvider(),
  name: "Favorites Provider",
);

class FavoritesProvider extends AsyncNotifier<FavoritesState> {
  @override
  FutureOr<FavoritesState> build() {
    return getFavorites();
  }

  Future<bool?> toggleFavorites(int id) async {
    final favoritesRepo = ref.read(favoritesRepoProvider);

    final result = await favoritesRepo.toggleFavorites(
      id: id.toString(),
      isProduct: true,
    );

    return result.fold(
      (l) {
        log(l.message);
        return null;
      },
      (r) {
        log(r.toString());
        ref.read(categoriesProvider.notifier).toggleFavoriteStatsIfExists(id);
        ref.read(storesProvider.notifier).toggleFavoriteStatsIfExists(id);
        ref.invalidateSelf();
        return r;
      },
    );
  }

  Future<FavoritesState> getFavorites() async {
    final favoritesRepo = ref.read(favoritesRepoProvider);
    final mainType = ref.read(homeStateProvider).selectedServiceType!.isGoFood
        ? "restaurant"
        : "supermarket";

    final result = await favoritesRepo.getFavorites(mainType: mainType);

    return result.fold(
      (l) async {
        log(l.message);
        throw ServerException(message: l.message);
      },
      (r) async {
        log(r.toString());

        return FavoritesState(favoritesEntity: r);
      },
    );
  }
}
