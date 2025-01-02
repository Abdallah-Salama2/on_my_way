import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/features/go_food/data/repos/favorites_repo.dart';
import 'package:on_my_way/features/go_food/providers/categories/categories_provider.dart';

import 'package:on_my_way/features/go_food/providers/favorites/favorites_state.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';

final favoritesProvider =
    AsyncNotifierProvider<FavoritesProvider, FavoritesState>(
  () => FavoritesProvider(),
  name: "Favorites Provider",
);

class FavoritesProvider extends AsyncNotifier<FavoritesState> {
  @override
  FutureOr<FavoritesState> build() {
    return FavoritesState();
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
        return r;
      },
    );
  }
}
