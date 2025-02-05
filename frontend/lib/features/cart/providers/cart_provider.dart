import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/features/cart/data/models/cart_entity.dart';
import 'package:on_my_way/features/cart/data/repos/cart_repo.dart';
import 'package:on_my_way/features/cart/data/repos/orders_repo.dart';

import '../../../core/errors/exceptions.dart';

final cartProvider = AsyncNotifierProvider<CartProvider, CartEntity>(
  () => CartProvider(),
  name: "Cart Provider",
);

class CartProvider extends AsyncNotifier<CartEntity> {
  @override
  Future<CartEntity> build() async {
    return initCart();
  }

  Future<CartEntity> initCart() async {
    final cartRepo = ref.read(cartRepoProvider);

    final result = await cartRepo.getCart();
    return result.fold(
      (l) {
        throw ServerException(message: l.message);
      },
      (r) {
        return r;
      },
    );
  }

  Future<void> updateCart({
    required int itemId,
    required int quantity,
    required bool isAdding,
  }) async {
    final cartRepo = ref.read(cartRepoProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await cartRepo.updateCart(
        itemId: itemId,
        quantity: quantity,
        isAdding: isAdding,
      );

      return initCart();
    });
  }

  Future<void> deleteCartItem({
    required int itemId,
  }) async {
    final cartRepo = ref.read(cartRepoProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await cartRepo.deleteCartItem(
        itemId: itemId,
      );

      return initCart();
    });
  }

  Future<void> createOrder() async {
    final ordersRepo = ref.read(ordersRepoProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ordersRepo.createOrder();
      return initCart();
    });
  }
}
