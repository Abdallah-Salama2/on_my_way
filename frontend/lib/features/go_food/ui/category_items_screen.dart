import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/widgets/back_button.dart';
import '../../../core/shared/widgets/dynamic_form_field.dart';
import '../../../core/styles/app_colors.dart';
import '../../cart/ui/widgets/cart_button_widget.dart';
import '../providers/categories/categories_provider.dart';
import 'widgets/item_card.dart';

class CategoryItemsScreen extends ConsumerStatefulWidget {
  const CategoryItemsScreen({super.key});

  @override
  ConsumerState<CategoryItemsScreen> createState() =>
      _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends ConsumerState<CategoryItemsScreen> {
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

    final categoriesState = ref.watch(categoriesProvider);
    return Scaffold(
      body: categoriesState.when(
        data: (data) {
          final filterQuery = searchController.text;
          final filteredList =
              data.categoryItemsEntity.products.where((category) {
            return category.name
                .toLowerCase()
                .contains(filterQuery.toLowerCase());
          }).toList();
          return CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: false,
                snap: false,
                backgroundColor: AppColors.cadetGrey,
                surfaceTintColor: Colors.transparent,
                title: Text(data.categoryItemsEntity.name),
                clipBehavior: Clip.antiAlias,
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
                shape: const RoundedRectangleBorder(
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
                        ? 'All ${data.categoryItemsEntity.name}'
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
        error: (error, stackTrace) =>const Center(child:  Text("Error loading items")),
        loading: () => const Center(child: LinearProgressIndicator()),
      ),
    );
  }
}
