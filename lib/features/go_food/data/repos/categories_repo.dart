import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/errors/failure.dart';
import 'package:on_my_way/core/shared/helpers/dio_helper.dart';
import 'package:on_my_way/core/utils/api_constants.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';
import 'package:on_my_way/features/go_food/data/entities/categories_entity.dart';
import 'package:on_my_way/features/go_food/data/entities/items_entity.dart';

final categoriesRepoProvider = Provider.autoDispose(
    (ref) => CategoriesRepo(ref),
    name: "Categories Repo Provider");

class CategoriesRepo {
  final Ref ref;
  late final token = ref.read(authStateProvider).authEntity?.data.token;
  CategoriesRepo(this.ref);

  Future<Either<Failure, CategoriesEntity>> getCategories({
    required int type,
  }) async {
    final response = await DioHelper.getData(
      path: ApiConstants.getCategories,
      token: token,
      queryParameters: {"type": type},
    );
    if (response.data['success'] == true) {
      return Right(CategoriesEntity.fromJson(response.data));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, CategoryItemsEntity>> showSingleCategory({
    required int id,
  }) async {
    final response = await DioHelper.getData(
      path: ApiConstants.showSingleCategories(id.toString()),
      token: token,
    );
    if (response.data['success'] == true) {
      return Right(CategoryItemsEntity.fromJson(response.data));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }
}
