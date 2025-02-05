import 'package:dartz/dartz.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/helpers/dio_helper.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../models/favorites_entity.dart';

final favoritesRepoProvider = Provider.autoDispose(
  (ref) => FavoritesRepo(ref),
  name: "Categories Repo Provider",
);

class FavoritesRepo {
  final Ref ref;
  late final token = ref.watch(authStateProvider).authEntity?.data.token;

  FavoritesRepo(this.ref);

  Future<Either<Failure, bool>> toggleFavorites({
    required String id,
    required bool isProduct,
  }) async {
    final response = await DioHelper.postData(
        path: ApiConstants.addToFavorites(id.toString()),
        token: token,
        body: {
          "type": isProduct ? "item" : "store",
        });
    if (response.data['success'] == true) {
      final newFavoriteStats =
          response.data['message'].toString().contains("Added");

      return Right(newFavoriteStats);
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }

  Future<Either<Failure, FavoritesEntity>> getFavorites({
    required String mainType,
  }) async {
    final response = await DioHelper.getData(
      path: ApiConstants.getFavorites,
      token: token,
      body: {
        "type": "item",
        "main_type": mainType,
      },
    );
    if (response.data['success'] == true) {
      return Right(FavoritesEntity.fromJson(response.data));
    } else {
      return Left(ServerFailure(response.data['message']));
    }
  }
}
