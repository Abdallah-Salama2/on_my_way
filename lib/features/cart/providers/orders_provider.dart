import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/errors/exceptions.dart';
import 'package:on_my_way/core/shared/helpers/ftoast_helper.dart';
import 'package:on_my_way/features/cart/data/models/orders_entity.dart';

import '../data/repos/orders_repo.dart';

final ordersProvider = AsyncNotifierProvider<OrdersProvider, OrdersEntity>(
  () => OrdersProvider(),
  name: "Orders Provider",
);

class OrdersProvider extends AsyncNotifier<OrdersEntity> {
  @override
  Future<OrdersEntity> build() {
    return getOrders();
  }

  Future<OrdersEntity> getOrders() async {
    final ordersRepo = ref.read(ordersRepoProvider);

    final result = await ordersRepo.getOrders();

    return result.fold(
      (l) {
        throw ServerException(message: l.message);
      },
      (r) {
        return r;
      },
    );
  }

  Future<void> reorder(int id) async {
    final ordersRepo = ref.read(ordersRepoProvider);

    final result = await ordersRepo.reorder(id);

    result.fold(
      (l) {},
      (r) {
        ref.invalidateSelf();
        FtoastHelper.showSuccessToast(r);
      },
    );
  }

  Future<void> deleteOrder(int id) async {
    final ordersRepo = ref.read(ordersRepoProvider);

    final result = await ordersRepo.deleteOrder(id);

    result.fold(
      (l) {},
      (r) {
        ref.invalidateSelf();
        FtoastHelper.showSuccessToast(r);
      },
    );
  }
}
