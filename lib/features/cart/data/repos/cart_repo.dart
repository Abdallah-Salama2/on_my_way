import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/errors/failure.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';
import 'package:on_my_way/features/cart/data/models/cart_entity.dart';

import '../../../../core/shared/helpers/dio_helper.dart';
import '../../../../core/utils/api_constants.dart';

final cartRepoProvider = Provider<CartRepo>(CartRepo.new, name: "Cart Repo");

class CartRepo {
  final Ref ref;
  late final token = ref.read(authStateProvider).authEntity?.data.token;

  CartRepo(this.ref);

  Future<Either<Failure, CartEntity>> getCart() async {
    final response = await DioHelper.getData(
      path: ApiConstants.getCart,
      token: token,
    );
    if (response.data['success'] == true) {
      return Right(CartEntity.fromJson(response.data));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, String>> updateCart({
    required int itemId,
    required int quantity,
    required bool isAdding,
  }) async {
    final response = await DioHelper.putData(
      path: ApiConstants.updateCart,
      token: token,
      queryParameters: {
        "itemId": itemId,
        "quantity": quantity,
        "operator": isAdding ? "add" : "subtract"
      },
    );
    if (response.data['success'] == true) {
      return Right(response.data['message']);
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, String>> deleteCartItem({
    required int itemId,
  }) async {
    final response = await DioHelper.deleteData(
      path: ApiConstants.deleteCartItem(itemId),
      token: token,
    );
    if (response.data['success'] == true) {
      return Right(response.data['message']);
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }
}
