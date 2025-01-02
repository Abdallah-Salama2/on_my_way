import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/app_routes.dart';
import 'package:on_my_way/features/go_food/providers/categories/categories_provider.dart';

import '../../../../core/styles/app_colors.dart';

class CategoriesListWidget extends ConsumerWidget {
  final String filterQuery;

  const CategoriesListWidget({super.key, required this.filterQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);
    final categoriesNotifier = ref.read(categoriesProvider.notifier);
    return categoriesState.when(
      skipError: true,
      skipLoadingOnReload: true,
      data: (categories) {
        final filteredList =
            categories.categoriesEntity.categories.where((category) {
          return category.name
              .toLowerCase()
              .contains(filterQuery.toLowerCase());
        }).toList();
        if (filteredList.isEmpty) {
          return const SliverToBoxAdapter(
            child: Text('No matches in categories.'),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: 160,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: filteredList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final category = filteredList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        categoriesNotifier.showCategoryItems(category.id);
                        Navigator.of(context)
                            .pushNamed(AppRoutes.categoryItemsScreen);
                      },
                      child: Container(
                        width: 125,
                        height: 125,
                        margin: const EdgeInsets.only(bottom: 7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: const [
                            AppColors.boxShadowBlack26,
                          ],
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.cadetGrey,
                          ),
                          // child: Image.network(
                          //   category.imageUrl,
                          //   fit: BoxFit.contain,
                          // ),
                        ),
                      ),
                    ),
                    Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
      error: (error, stackTrace) => const SliverToBoxAdapter(
        child: SizedBox(height: 160, child: Text("Error loading categories")),
      ),
      loading: () => const SliverToBoxAdapter(
        child: SizedBox(
            height: 160, child: Center(child: LinearProgressIndicator())),
      ),
    );
  }
}
