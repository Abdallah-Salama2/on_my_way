import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/go_food/providers/categories/categories_provider.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';

import 'package:on_my_way/features/home/data/models/home_state.dart';

final homeStateProvider = NotifierProvider<HomeStateProvider, HomeState>(
  HomeStateProvider.new,
  name: "HomeStateProvider",
);

class HomeStateProvider extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState();
  }

  void updateServiceType(ServiceType serviceType) {
    if (serviceType == state.selectedServiceType) {
      return;
    }
    if (serviceType.isEcommerce) {
      ref.invalidate(categoriesProvider);
      ref.invalidate(storesProvider);
    }
    state = state.copyWith(selectedServiceType: serviceType);
  }
}
