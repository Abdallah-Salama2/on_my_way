import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/errors/failure.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';

import 'package:on_my_way/features/cart/data/models/food_order.dart';
import 'package:on_my_way/features/cart/data/models/orders_entity.dart';
import 'package:on_my_way/features/cart/providers/orders_provider.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';

import '../../../../core/shared/helpers/dio_helper.dart';
import '../../../../core/utils/api_constants.dart';

final ordersRepoProvider =
    Provider<OrdersRepo>(OrdersRepo.new, name: "Orders Repo");

class OrdersRepo {
  final Ref ref;
  late final token = ref.watch(authStateProvider).authEntity?.data.token;

  OrdersRepo(this.ref);

  Future<Either<Failure, OrdersEntity>> getOrders() async {
    final isFood = ref.read(homeStateProvider).selectedServiceType!.isEcommerce;

    final type = isFood ? "food" : "rides";

    final response = await DioHelper.getData(
      path: ApiConstants.getOrders,
      token: token,
      queryParameters: {
        "type": type,
      },
    );
    if (response.data['success'] == true) {
      return Right(OrdersEntity.fromJson(response.data, isFood));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, FoodOrderModel>> createOrder() async {
    final response = await DioHelper.postData(
      path: ApiConstants.createOrder,
      token: token,
    );
    if (response.data['success'] == true) {
      ref.invalidate(ordersProvider);
      return Right(FoodOrderModel.fromJson(response.data['data']));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, String>> reorder(int id) async {
    final response = await DioHelper.postData(
      path: ApiConstants.reorder(id),
      token: token,
    );
    if (response.data['success'] == true) {
      return Right(response.data['message']);
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, String>> deleteOrder(int id) async {
    final response = await DioHelper.deleteData(
      path: ApiConstants.deleteOrder(id),
      token: token,
    );
    if (response.data['success'] == true) {
      return Right(response.data['message']);
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }
}
