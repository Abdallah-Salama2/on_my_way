import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/widgets/dynamic_form_field.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';
import 'package:on_my_way/features/cart/ui/widgets/cart_button_widget.dart';

import 'package:on_my_way/features/go_food/providers/categories/categories_provider.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';
import 'package:on_my_way/features/go_food/ui/widgets/categories_list_widget.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';

import 'widgets/restaurants_list_widget.dart';

/// [GoFoodBody] is not called a screen because it's not a scaffold
/// and is a part of [HomeScreen]'s navigation and doesn't have it's own route
///
/// Check `features/home/ui/home_screen.dart` for more details
class GoFoodBody extends ConsumerStatefulWidget {
  const GoFoodBody({super.key});

  @override
  ConsumerState<GoFoodBody> createState() => _GoFoodBodyState();
}

class _GoFoodBodyState extends ConsumerState<GoFoodBody> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const verticalSpace = SliverToBoxAdapter(child: SizedBox(height: 12));

    final userData = ref.read(authStateProvider).authEntity?.data.user;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          searchController.clear();
          setState(() {});

          ref.invalidate(categoriesProvider);
          ref.invalidate(storesProvider);
          await Future.wait([
            ref.read(categoriesProvider.future),
            ref.read(storesProvider.future),
          ]);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 22,
          ),
          child: CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      shape: const StadiumBorder(),
                      onPressed: () {},
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.antiFlashWhite,
                            child: Icon(
                              Icons.menu_open_rounded,
                              color: AppColors.onyx,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DELIVER TO',
                                style: TextStyle(
                                  color: AppColors.pumpkinOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(userData?.address ?? "Address")
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 5),
                    const CartButtonWidget(),
                  ],
                ),
              ),
              verticalSpace,
              SliverToBoxAdapter(
                child: Text.rich(
                  TextSpan(
                    text: 'Hey ${userData?.name ?? "Name"}, ',
                    style: textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Good Afternoon!',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace,

              // Search Bar
              SliverToBoxAdapter(
                child: DynamicFormField(
                  controller: searchController,
                  hintText: 'What are you looking for?',
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
              verticalSpace,

              SliverToBoxAdapter(
                child: Text(
                  searchController.text.isEmpty
                      ? 'All Categories'
                      : "Categories",
                  style: textTheme.titleLarge,
                ),
              ),
              verticalSpace,
              CategoriesListWidget(filterQuery: searchController.text),
              verticalSpace,
              SliverToBoxAdapter(
                child: Text(
                    ref.read(homeStateProvider).selectedServiceType!.isGoFood
                        ? 'Open Restaurants'
                        : "Open Stores",
                    style: textTheme.titleLarge),
              ),
              verticalSpace,
              RestaurantsListWidget(filterQuery: searchController.text),
            ],
          ),
        ),
      ),
    );
  }
}
