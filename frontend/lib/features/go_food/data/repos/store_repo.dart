import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/features/go_food/data/entities/restaurant_items_entity.dart';
import 'package:on_my_way/features/go_food/data/entities/restaurants_entity.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/helpers/dio_helper.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../authentication/providers/auth_provider.dart';

final storeRepoProvider = Provider.autoDispose(
  (ref) => StoreRepo(ref),
  name: "Store Repo Provider",
);

class StoreRepo {
  final Ref ref;

  StoreRepo(this.ref);

  Future<Either<Failure, RestaurantsEntity>> getStores({
    required int type,
  }) async {
    final token = ref.read(authStateProvider).authEntity?.data.token;
    final response = await DioHelper.getData(
      path: ApiConstants.getStores,
      token: token,
      queryParameters: {"type": type},
    );
    if (response.data['success'] == true) {
      return Right(RestaurantsEntity.fromJson(response.data));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, RestaurantItemsEntity>> showSingleStore({
    required int id,
  }) async {
    final token = ref.read(authStateProvider).authEntity?.data.token;
    final response = await DioHelper.getData(
      path: ApiConstants.showSingleStores(id.toString()),
      token: token,
    );
    if (response.data['success'] == true) {
      return Right(RestaurantItemsEntity.fromJson(response.data));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }
}
