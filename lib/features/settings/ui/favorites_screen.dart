import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/features/go_food/providers/favorites/favorites_provider.dart';

import '../../../core/shared/widgets/back_button.dart';
import '../../../core/shared/widgets/dynamic_form_field.dart';
import '../../../core/styles/app_colors.dart';
import '../../cart/ui/widgets/cart_button_widget.dart';
import '../../go_food/ui/widgets/item_card.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() =>
      _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends ConsumerState<FavoritesScreen> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const sliverVerticalSpace = SliverToBoxAdapter(child: SizedBox(height: 12));

    final favoritesState = ref.watch(favoritesProvider);
    return Scaffold(
      body: favoritesState.when(
        data: (data) {
          final filterQuery = searchController.text;
          final filteredList = data.favoritesEntity.items.where((category) {
            return category.name
                .toLowerCase()
                .contains(filterQuery.toLowerCase());
          }).toList();
          return CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              const SliverAppBar(
                floating: false,
                pinned: false,
                snap: false,
                backgroundColor: AppColors.cadetGrey,
                surfaceTintColor: Colors.transparent,
                title: Text('Favorites'),
                clipBehavior: Clip.antiAlias,
                leading: Row(
                  children: [
                    SizedBox(width: 8),
                    BackButtonWidget(),
                  ],
                ),
                actions: [
                  CartButtonWidget(invertColors: true),
                  SizedBox(width: 8),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),

              sliverVerticalSpace,

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DynamicFormField(
                    hintText: 'Search',
                    controller: searchController,
                    onChange: (value) {
                      setState(() {});
                    },
                    maxLines: 1,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.pumpkinOrange,
                    ),
                    suffix: searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                            ),
                          ),
                  ),
                ),
              ),
              sliverVerticalSpace,

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    searchController.text.isEmpty
                        ? 'All Favorites'
                        : "Search results",
                    style: textTheme.titleLarge,
                  ),
                ),
              ),

              sliverVerticalSpace,
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ItemCard(filteredList[index]);
                    },
                    childCount: filteredList.length,
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
        error: (error, stackTrace) =>const Center(child:  Text("Error loading favorites")),
        loading: () => const Center(child: LinearProgressIndicator()),
      ),
    );
  }
}
