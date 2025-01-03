import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/errors/exceptions.dart';
import 'package:on_my_way/features/cart/data/models/orders_entity.dart';

import '../data/repos/orders_repo.dart';

final ordersProvider = FutureProvider<OrdersEntity>(
  (ref) async {
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
  },
);
