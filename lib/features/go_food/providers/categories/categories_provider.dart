import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/errors/exceptions.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/go_food/data/entities/items_entity.dart';

import 'package:on_my_way/features/go_food/data/repos/categories_repo.dart';
import 'package:on_my_way/features/go_food/providers/categories/categories_state.dart';

import '../../../home/providers/home_state_provider.dart';

final categoriesProvider =
    AsyncNotifierProvider<CategoriesProvider, CategoriesState>(
  () => CategoriesProvider(),
  name: "Categories Provider",
);

class CategoriesProvider extends AsyncNotifier<CategoriesState> {
  @override
  Future<CategoriesState> build() async {
    return initCategories();
  }

  Future<CategoriesState> initCategories() async {
    final int type =
        ref.read(homeStateProvider).selectedServiceType!.isGoFood ? 1 : 2;
    final categoriesRepo = ref.read(categoriesRepoProvider);

    final result = await categoriesRepo.getCategories(type: type);
    return result.fold(
      (l) {
        throw ServerException(message: l.message);
      },
      (r) {
        return CategoriesState(categoriesEntity: r);
      },
    );
  }

  Future<void> showCategoryItems(int id) async {
    final categoriesRepo = ref.read(categoriesRepoProvider);

    if (id ==
        state.value?.categoryItemsEntity.products.firstOrNull?.categoryId) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final result = await categoriesRepo.showSingleCategory(id: id);
        return result.fold(
          (l) {
            throw Exception(l);
          },
          (r) {
            final x = state.valueOrNull!.copyWith(categoryItemsEntity: r);
            return x;
          },
        );
      },
    );
  }

  void clearItems() async {
    state = await AsyncValue.guard(
      () async {
        return state.valueOrNull!.copyWith(
          categoryItemsEntity: const CategoryItemsEntity(
            success: true,
            message: '',
            products: [],
            description: '',
            id: -1,
            name: '',
          ),
        );
      },
    );
  }

  void toggleFavoriteStatsIfExists(int id) async {
    final index = state.value?.categoryItemsEntity.products.indexWhere(
      (element) {
        return element.id == id;
      },
    );

    if (index != -1 && index != null) {
      final updatedProductsList =
          state.value!.categoryItemsEntity.products.map((item) {
        if (item.id == id) {
          return item.copyWith(favoriteStats: !item.favoriteStats);
        } else {
          return item;
        }
      }).toList();

      state = await AsyncValue.guard(
        () async {
          final stateValue = state.valueOrNull!;
          return stateValue.copyWith(
            categoryItemsEntity: stateValue.categoryItemsEntity.copyWith(
              products: updatedProductsList,
            ),
          );
        },
      );
    }
  }
}
